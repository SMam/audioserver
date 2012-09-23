# coding: utf-8

require './dbconverter'

describe DBConverter do
  before do
    @dbfile = "./test_db.sqlite3"
    File::delete(@dbfile) if File::exists?(@dbfile)
    @db = SQLite3::Database.new(@dbfile)
    @db.execute("create table patients(id int, created_at datetime)")
    @db.execute("insert into patients values(1, '2012-09-20 09:00:00.000000');")
    @db.execute("insert into patients values(2, '2012-09-20 09:00:01.000000')")
    @db.execute("create table audiograms(id int, examdate, created_at, updated_at, image_location,\
      ac_rt_125, ac_rt_250, ac_rt_500, ac_rt_1k, ac_rt_2k, ac_rt_4k, ac_rt_8k,\
      ac_lt_125, ac_lt_250, ac_lt_500, ac_lt_1k, ac_lt_2k, ac_lt_4k, ac_lt_8k,\
      bc_rt_250, bc_rt_500, bc_rt_1k, bc_rt_2k, bc_rt_4k, bc_rt_8k,\
      bc_lt_250, bc_lt_500, bc_lt_1k, bc_lt_2k, bc_lt_4k, bc_lt_8k,\
      ac_rt_125_scaleout, ac_rt_250_scaleout, ac_rt_500_scaleout,\
      ac_rt_1k_scaleout, ac_rt_2k_scaleout, ac_rt_4k_scaleout, ac_rt_8k_scaleout,\
      ac_lt_125_scaleout, ac_lt_250_scaleout, ac_lt_500_scaleout,\
      ac_lt_1k_scaleout, ac_lt_2k_scaleout, ac_lt_4k_scaleout, ac_lt_8k_scaleout,\
      bc_rt_250_scaleout, bc_rt_500_scaleout, bc_rt_1k_scaleout,\
      bc_rt_2k_scaleout, bc_rt_4k_scaleout, bc_rt_8k_scaleout,\
      bc_lt_250_scaleout, bc_lt_500_scaleout, bc_lt_1k_scaleout,\
      bc_lt_2k_scaleout, bc_lt_4k_scaleout, bc_lt_8k_scaleout)")
    @db.execute("insert into audiograms values(1, '2012-09-20 09:00:00.000000',\
                '2012-09-20 09:00:10.000000', '2012-09-20 09:00:20.000000', '',\
		10, 10, 10, 10, 10, 10, 10,\
		20, 20, 20, 20, 20, 20, 20,\
		0, 0, 0, 0, 0, 0,\
		0, 0, 0, 0, 0, 0,\
		'f', 'f', 'f', 'f', 'f', 'f', 'f',\
		'f', 'f', 'f', 'f', 'f', 'f', 'f',\
		'f', 'f', 'f', 'f', 'f', 'f',\
		'f', 'f', 'f', 'f', 'f', 'f')")
    @db.execute("insert into audiograms values(2, '2012-09-20 09:10:00.000000',\
                '2012-09-20 09:10:10.000000', '2012-09-20 09:10:20.000000', '',\
		 1,  2,  3,  4,  5,  6,  7,\
		11, 12, 13, 14, 15, 16, 17,\
		21, 22, 23, 24, 25, 26,\
		31, 32, 33, 34, 35, 36,\
		'f', 'f', 'f', 'f', 'f', 'f', 'f',\
		'f', 'f', 'f', 'f', 'f', 'f', 'f',\
		'f', 'f', 'f', 'f', 'f', 'f',\
		'f', 'f', 'f', 'f', 'f', 'f')")
    @db.execute("insert into audiograms values(3, '2012-09-20 09:20:00.000000',\
                '2012-09-20 09:20:10.000000', '2012-09-20 09:20:20.000000', '',\
		40, 50,110,110,110, 90,100,\
		11, 12,100,100,100, 16, 17,\
		21, 22, 23, 24, 25, 26,\
		31, 32, 33, 34, 35, 36,\
		'f', 'f', 'f', 'f', 'f', 'f', 'f',\
		'f', 'f', 't', 't', 'f', 'f', 'f',\
		'f', 'f', 'f', 'f', 'f', 'f',\
		'f', 'f', 'f', 'f', 'f', 'f')")
  end

  describe "DBConverter#adjust_minus9" do
    it "正しく9時間前の時刻を返すことができる" do
      date_str = "2012-09-05 03:45:30.272610"
      DBConverter.new(@db, "test").adjust_minus9(date_str).should match /2012-09-04 18:45:30.272610/
    end
  end

  describe "DBConverter#convert" do
    it 'convert the table PATIENTS' do
      DBConverter.new(@db, "test").convert
      @db.execute("select * from patients") do |r|
        r[1].should match /2012-09-20 00:00:0.+/
      end
    end

    it 'convert the table AUDIOGRAMS' do
      DBConverter.new(@db, "test").convert
      @db.execute("select * from audiograms") do |r|
        r[1].should match /2012-09-20 00:.0:00.+/
        r[2].should match /2012-09-20 00:.0:10.+/
        r[3].should match /2012-09-20 00:.0:20.+/
      end
      @db.execute("select image_location from audiograms") do |r|
        r[0].should match /test\/graphs\/2012\/20120920-09.0.0.+png/
	# pngファイル名はlocal(+0900)なので、20120920-09.0.0となるべき
      end
    end
  end

  describe "DBconverter#remake_audiograms" do
    before do
      @env = "test"
      if File::exists?("#{App_assets_img_location}/#{@env}/graphs")
        Dir::glob("#{App_assets_img_location}/#{@env}/**/*") do |f|
          File::delete(f) if File::ftype(f) == "file"
        end
      end
      @graphfile1 = "#{App_assets_img_location}/#{@env}/graphs/2012/20120920-090000.png"
      @graphfile2 = "#{App_assets_img_location}/#{@env}/graphs/2012/20120920-091000.png"
      @graphfile3 = "#{App_assets_img_location}/#{@env}/graphs/2012/20120920-092000.png"
	# pngファイル名はlocal(+0900)なので、20120920-09.0.0となるべき
      @thumbfile1 = @graphfile1.sub("graphs", "thumbnails")
      @thumbfile2 = @graphfile2.sub("graphs", "thumbnails")
      @thumbfile3 = @graphfile3.sub("graphs", "thumbnails")
      File::exists?(@graphfile1).should_not be_true
      File::exists?(@graphfile2).should_not be_true
      File::exists?(@graphfile3).should_not be_true
      File::exists?(@thumbfile1).should_not be_true
      File::exists?(@thumbfile2).should_not be_true
      File::exists?(@thumbfile3).should_not be_true
    end

    it 'create audiogram files' do
      DBConverter.new(@db, @env).convert
      DBConverter.new(@db, @env).remake_audiograms
      File::exists?(@graphfile1).should be_true
      File::exists?(@graphfile2).should be_true
      File::exists?(@graphfile3).should be_true
      File::exists?(@thumbfile1).should be_true
      File::exists?(@thumbfile2).should be_true
      File::exists?(@thumbfile3).should be_true
    end

    it 'create audiogram files, also by #execute' do
      DBConverter.new(@db, @env).execute
      File::exists?(@graphfile1).should be_true
      File::exists?(@graphfile2).should be_true
      File::exists?(@graphfile3).should be_true
      File::exists?(@thumbfile1).should be_true
      File::exists?(@thumbfile2).should be_true
      File::exists?(@thumbfile3).should be_true
    end
  end

  after do
    File::delete(@dbfile) if File::exists?(@dbfile)
  end
end
