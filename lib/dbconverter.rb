# coding: utf-8
# Audioserver: production.sqlite3 移行ツール
#   ruby/rails 1.8/3.0 => 1.9/3.2
#   audiogram も作り直し	

require 'sqlite3'
require 'fileutils'
require './audio_class.rb'
App_assets_img_location = "../app/assets/images"   # Rails.root/libから辿る形 

class DBConverter
  def initialize(db, env) # dbはSQLite3::Databaseのインスタンス
    @db = db
    @env = env
  end

  def execute
    convert
    remake_audiograms
  end

  def convert
    adj_examd = ""
    @db.execute( "select id, created_at from patients" ) do |row|
      id = row[0]
      adj_cr_at = adjust_minus9(row[1])
      @db.execute( "UPDATE patients SET created_at = '#{adj_cr_at}'\
                   WHERE id = '#{id}'")
    end
    @db.execute( "select id, examdate, created_at, updated_at \
                  from audiograms" ) do |row|
      id = row[0]
      adj_examd = adjust_minus9(row[1])
      adj_cr_at = adjust_minus9(row[2])
      adj_up_at = adjust_minus9(row[3])
      @db.execute( "UPDATE audiograms SET examdate = '#{adj_examd}',\
                    created_at = '#{adj_cr_at}', updated_at = '#{adj_up_at}',\
		    image_location = '#{make_img_loc(adj_examd)}' WHERE id = '#{id}'")
    end
  end

  def remake_audiograms
    n=0
    nn = @db.execute( "SELECT COUNT(id) FROM audiograms" )
    @db.execute( "select #{audiogram_items} from audiograms" ) do |r|
      ra = Array.new; la = Array.new; rb = Array.new; lb = Array.new
      for i in 5..11 do
        ra << {:data => r[i], :scaleout => (r[i+26] =~ /^t|^T/? true: false)}
      end 
      for i in 12..18 do
        la << {:data => r[i], :scaleout => (r[i+26] =~ /^t|^T/? true: false)}
      end 
      rb << {:data =>  nil, :scaleout => nil}
      for i in 19..24 do
        rb << {:data => r[i], :scaleout => (r[i+26] =~ /^t|^T/? true: false)}
      end 
      lb << {:data =>  nil, :scaleout => nil}
      for i in 25..30 do
        lb << {:data => r[i], :scaleout => (r[i+26] =~ /^t|^T/? true: false)}
      end 
      audiogram = Audio.new(Audiodata.new("cooked", ra,la,rb,lb))
      output_file = "#{App_assets_img_location}/#{r[4]}"
      output_dir = File::dirname(output_file)
      FileUtils.mkdir_p(output_dir) if not File.exists?(output_dir)
      thumb_dir = output_dir.sub("graphs","thumbnails")
      FileUtils.mkdir_p(thumb_dir) if not File.exists?(thumb_dir)
      audiogram.draw(output_file)
      thumb_size = "160x160"
      system("convert -geometry #{thumb_size} #{output_file} #{output_file.sub("graphs", "thumbnails")}")

      n+=1
      puts "#{n}/#{nn}"
    end
  end

  private
  def adjust_minus9(date_str) # style: e.g. "2012-09-05 03:45:30.272610"
    if /(\d+)-(\d+)-(\d+) (\d+):(\d+):(\d+).(\d+)/ =~ date_str
      t = Time.utc($1,$2,$3,$4,$5,$6,$7)
      at = t - 9*3600
      return "#{at.strftime("%Y-%m-%d %H:%M:%S")}.#{at.tv_usec}"
    else
      puts date_str
    end 
  end

  def make_img_loc(date_str) # "2012-09-20 00:00:00.0" => "app/20120920-000000.png"
    t = Time.new
    if /(\d+)-(\d+)-(\d+) (\d+):(\d+):(\d+).(\d+)/ =~ date_str
      t = Time.utc($1,$2,$3,$4,$5,$6,$7)
    end 
    exam_year = t.strftime("%Y")
    base_dir = "#{@env}/graphs/#{exam_year}/"
    return make_filename(base_dir, t.strftime("%Y%m%d-%H%M%S"))
  end

  def make_filename(base_dir, base_name)
    # assume make_filename(base_dir, @audiogram.examdate.strftime("%Y%m%d-%H%M%S"))
    # as actual argument
    ver = 0
    Dir.glob("#{App_assets_img_location}/#{base_dir}#{base_name}*").each do |f|
      if /#{base_name}.png\Z/ =~ f
        ver = 1 if ver == 0
      end
      if /#{base_name}-(\d*).png\Z/ =~ f
        ver = ($1.to_i + 1) if $1.to_i >= ver
      end
    end
    if ver == 0
      return "#{base_dir}#{base_name}.png"
    else
      if ver < 100
        ver_str = "%02d" % ver
      else
        ver_str = ver.to_s
      end
      return "#{base_dir}#{base_name}-#{ver_str}.png"
    end
  end

  def audiogram_items
    items = <<SQL
      id, examdate, created_at, updated_at, image_location,\
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
      bc_lt_2k_scaleout, bc_lt_4k_scaleout, bc_lt_8k_scaleout
SQL
  end

end

#----------------------------------------#
if ($0 == __FILE__)
  if ARGV.shift == "production"
    env = "production"
  else
    env = "development"
  end
  db_file = "../db/#{env}.sqlite3"
  dest = "#{db_file}.converted"
  FileUtils.cp(db_file, dest)

  db = SQLite3::Database.new(dest)
  DBConverter.new(db, env).execute
end
