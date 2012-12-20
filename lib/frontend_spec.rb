# coding: utf-8

require './frontend'
require 'strscan'

data = Hash.new
File.open('./rawdata_sample.dat','r') do |f|
  buf = f.read
  ss = StringScanner.new(buf)
  until ss.eos? do
    case
    when ss.scan(/(.+?)::"(.+?)"/m)
      data[ss[1].gsub("\n", "")] = ss[2]
    else
      break
    end
  end
end
Raw_audiosample = [data["audiogram_data"]]
#  125 250 500  1k  2k  4k  8k
#R   0  10  20  30  40  50  60
#L  30  35  40  45  50  55  60
Raw_impedance_sample = [data["tympano_data_R"], data["tympano_data_L"],\
                        data["reflex_data0"], data["reflex_data1"], data["reflex_data2"], data["reflex_data3"],\
			data["reflex_data4"], data["reflex_data5"], data["reflex_data6"], data["reflex_data7"] ] 

describe ImpedanceExam do
  before do
    @impedanceexam = ImpedanceExam.new('test')
    @hp_id = 19
    @examdate = Time.now.strftime("%Y:%m:%d-%H:%M:%S")
    @audiometer = "RS-22"
    @comment = "a_comment"
    @raw_impedancesample = Raw_impedance_sample
    @output_t_file = "./result_t.png"
    @output_r_file = "./result_r.png"
    @bg_t_file = "./assets/background_tympanogram.png"
    @bg_r_file = "./assets/background_reflex.png"
  end

  it "test mode/flight modeを使い分けられること" do
    @impedanceexam.mode.should == 'test'
    @impedanceexam.mode.should_not == 'flight'
    ImpedanceExam.new.mode.should == 'flight'
    ImpedanceExam.new.mode.should_not == 'test'
    ImpedanceExam.new('wrong mode').mode.should_not == 'test'
  end

  context 'ID、検査値などが正しく与えられた時' do
    before do
      @impedanceexam.set_data(@hp_id, @examdate, @comment, @raw_impedancesample)
    end

    it 'ID、検査値などがセットできること' do
      @impedanceexam.data[:hp_id].should == @hp_id
      @impedanceexam.data[:examdate].should == @examdate
      @impedanceexam.data[:audiometer].should == @audiometer
      @impedanceexam.data[:comment].should == @comment
      @impedanceexam.data[:datatype].should == "impedance"
      @impedanceexam.data[:data].should == @raw_impedancesample
    end

    it 'tympanogramが生成されること' do
      File::delete(@output_t_file) if File::exists?(@output_t_file)
      @impedanceexam.output
      File::exists?(@output_t_file).should be_true
    end

    it '生成されたtympanogramが白紙ではない = 背景と異なっていること' do
      require 'digest/md5'
      File::delete(@output_t_file) if File::exists?(@output_t_file)
      @impedanceexam.output
      Digest::MD5.hexdigest(File.open(@output_t_file, 'rb').read).should_not ==\
        Digest::MD5.hexdigest(File.open(@bg_t_file, 'rb').read)
    end

    it 'reflex-gramが生成されること' do
      File::delete(@output_r_file) if File::exists?(@output_r_file)
      @impedanceexam.output
      File::exists?(@output_r_file).should be_true
    end

    it '生成されたreflex-gramが白紙ではない = 背景と異なっていること' do
      require 'digest/md5'
      File::delete(@output_r_file) if File::exists?(@output_r_file)
      @impedanceexam.output
      Digest::MD5.hexdigest(File.open(@output_r_file, 'rb').read).should_not ==\
        Digest::MD5.hexdigest(File.open(@bg_r_file, 'rb').read)
    end
  end

  it 'POST#direct_createの際のリクエスト用文字列を作れること' do
    @impedanceexam.set_data(@hp_id, @examdate, @comment, @raw_impedancesample)
    message = @impedanceexam.request_body
    boundary = 'image_boundary'
    r = Regexp.new(".+#{boundary}.+form-data.+#{@hp_id}.+#{boundary}.+#{@examdate}.+#{boundary}.+#{@audiometer}.+#{boundary}.+#{@comment}.+#{boundary}.+impedance.+#{boundary}", Regexp::MULTILINE)
    message.should match r
    Raw_impedance_sample.each do |s|
      if /(.+\/\/.+,\/).+/ =~ s
        ss = $1.gsub('+', '\\!!!').gsub('!!!', '+')
        message.should match Regexp.new(ss)
      end
    end
    message.should match Regexp.new("name=\"data_size\";\r\n\r\n#{Raw_impedance_sample.size.to_s}\r\n")
    message.should match Regexp.new("data#{Raw_impedance_sample.size-1}")
  end
end

describe AudioExam do
  before do
    @audioexam = AudioExam.new('test')
    @hp_id = 19
    @examdate = Time.now.strftime("%Y:%m:%d-%H:%M:%S")
    @audiometer = "AA-79S"
    @comment = "a_comment"
    @raw_audiosample = Raw_audiosample
    @output_file = "./result.png"
    @bg_file = "./assets/background.png"
  end

  it "test mode/flight modeを使い分けられること" do
    @audioexam.mode.should == 'test'
    @audioexam.mode.should_not == 'flight'
    AudioExam.new.mode.should == 'flight'
    AudioExam.new.mode.should_not == 'test'
    AudioExam.new('wrong mode').mode.should_not == 'test'
  end

  context 'ID、検査値などが正しく与えられた時' do
    before do
      @audioexam.set_data(@hp_id, @examdate, @comment, @raw_audiosample)
    end

    it 'ID、検査値などがセットできること' do
      @audioexam.data[:hp_id].should == @hp_id
      @audioexam.data[:examdate].should == @examdate
      @audioexam.data[:audiometer].should == @audiometer
      @audioexam.data[:comment].should == @comment
      @audioexam.data[:datatype].should == "audiogram"
      @audioexam.data[:data].should == @raw_audiosample[0]
    end

    it 'Audiogramが生成されること' do
      File::delete(@output_file) if File::exists?(@output_file)
      @audioexam.output
      File::exists?(@output_file).should be_true
    end

    it '生成されたAudiogramが白紙ではない=背景と異なっていること' do
      require 'digest/md5'
      File::delete(@output_file) if File::exists?(@output_file)
      @audioexam.output
      Digest::MD5.hexdigest(File.open(@output_file, 'rb').read).should_not ==\
        Digest::MD5.hexdigest(File.open(@bg_file, 'rb').read)
    end
  end

  it 'POST#direct_createの際のリクエスト用文字列を作れること' do
    @audioexam.set_data(@hp_id, @examdate, @comment, @raw_audiosample)
    message = @audioexam.request_body
    boundary = 'image_boundary'
    r = Regexp.new(".+#{boundary}.+form-data.+#{@hp_id}.+#{boundary}.+#{@examdate}.+#{boundary}.+#{@audiometer}.+#{boundary}.+#{@comment}.+#{boundary}.+audiogram.+#{boundary}.+#{@raw_audiosample[0]}.+#{boundary}", Regexp::MULTILINE)
    message.should match r
  end
end

describe Markup_msg do
  before do
    @m = Markup_msg.new
  end

  it "状態に応じてそれぞれmarkupされたメッセージを用意できること" do
    @m.show("scan").should match /black/
    @m.show("scan").should_not match /red/
    @m.show("receive").should match /black/
    @m.show("receive").should_not match /red/
    @m.show("transmit").should match /black/
    @m.show("transmit").should_not match /red/
    @m.show("timeout").should match /red/
    @m.show("timeout").should_not match /black/
    @m.show("invalid_id").should match /red/
    @m.show("invalid_id").should_not match /black/
    @m.show("no_data").should match /red/
    @m.show("no_data").should_not match /black/
    @m.show("no_data").should_not == @m.show("scan")
    @m.show("invalid_arg").should be_nil
  end
end

describe Exam_window do
  before do
    @ew = Exam_window.new
    @ew.test_mode = true
    @hp_id = "19"
    @hyphened_hp_id = "0000-01-9"
    @invalid_hp_id = "18"
    @blank_png = Gdk::Pixbuf.new(Assets_location + "background.png")
  end

  context "button_id_entry を押した時に" do
    context "valid ID、かつ正しい聴力検査データの場合" do
      before do
        @ew.id_entry.text = @hp_id
        @ew.test_data = Raw_audiosample
        @ew.button_id_entry.signal_emit("clicked")
      end

      it "AudioExamのインスタンスが生成されること" do
        @ew.exam.should_not be_nil
      end

      it "image.pixbufがbackground.pngとは異なること" do
        @ew.image.pixbuf.pixels.should_not == @blank_png.pixels
      end

      it "stateがtransmitになること" do
        @ew.state.should == "transmit"
      end
    end

    context "valid ID、かつ dataがTimeoutであった場合" do
      before do
        @ew.id_entry.text = @hp_id
        @ew.test_data = ["Timeout"]
        @ew.button_id_entry.signal_emit("clicked")
      end

      it "Timeoutのメッセージを表示すること" do
        @ew.state.should == "timeout"
      end

      it "image.pixbufがbackground.pngと変わらないこと" do
        @ew.image.pixbuf.pixels.should == @blank_png.pixels
      end
    end

    context "valid ID、かつ聴検dataが不正であった場合" do
      before do
        @ew.id_entry.text = @hp_id
        @ew.test_data = ["invalid data"]
        @ew.button_id_entry.signal_emit("clicked")
      end

      it "No dataのメッセージを表示すること" do
        @ew.state.should == "no_data"
      end

      it "image.pixbufがbackground.pngと変わらないこと" do
        @ew.image.pixbuf.pixels.should == @blank_png.pixels
      end
    end

    context "invalid IDの場合" do
      before do
        @ew.id_entry.text = @invalid_hp_id
        @ew.button_id_entry.signal_emit("clicked")
      end

      it "invalid_idのメッセージを表示すること" do
        @ew.state.should == "invalid_id"
      end

      it "AudioExamのインスタンスが生成されないこと" do
        @ew.exam.should be_nil
      end
    end

    context "ハイフンの入ったIDの場合" do
      it "AudioExamのインスタンスが生成されること" do
        @ew.id_entry.text = @hyphened_hp_id
        @ew.test_data = Raw_audiosample
        @ew.button_id_entry.signal_emit("clicked")
        @ew.exam.should_not be_nil
      end
    end
  end

  context "button_abort を押した時に" do
    context "聴力検査データが得られている場合" do
      before do
        @ew.id_entry.text = @hp_id
        @ew.test_data = Raw_audiosample
        @ew.button_id_entry.signal_emit("clicked")
      end

      it "id_entryが空白になること" do
        @ew.button_abort.signal_emit("clicked")
        @ew.id_entry.text.should == ""
      end

      it "@examが空になること" do
        @ew.exam.data[:data].should_not == ""
        @ew.button_abort.signal_emit("clicked")
        @ew.exam.data[:data].should == ""
      end

      it "stateがtransmitからscanに戻ること" do
        @ew.state.should == "transmit"
        @ew.button_abort.signal_emit("clicked")
        @ew.state.should == "scan"
      end

      it "image.pixbufがbackground.pngとは異なる状態からbackground.pngに戻ること" do
        @ew.image.pixbuf.pixels.should_not == @blank_png.pixels
        @ew.button_abort.signal_emit("clicked")
        @ew.image.pixbuf.pixels.should == @blank_png.pixels
      end

      it "コメント欄が空になること" do
        @ew.comment_retry.active = true
        @ew.comment_other_check.active = true
        @ew.comment_other_entry.text = "some comments"
        @ew.comment_retry.active?.should == true
        @ew.button_abort.signal_emit("clicked")
        @ew.comment_retry.active?.should == false
        @ew.comment_other_check.active?.should == false
        @ew.comment_other_entry.text.should == ""
      end
    end
  end

  context "button_transmit を押した時に" do
    context "聴力検査データが得られている場合" do
      before do
        @ew.id_entry.text = @hp_id
        @ew.test_data = Raw_audiosample
        @ew.button_id_entry.signal_emit("clicked")
        @ew.comment_retry.active = true
        @ew.comment_other_check.active = true
        @ew.comment_other_entry.text = "some comments"
        @ew.button_transmit.signal_emit("clicked")
      end

      it "requestが発行されること" do
        @ew.http_request.should match Regexp.new(Raw_audiosample[0])
      end

      it "requestにID, commentが反映されること" do
        @ew.http_request.should match Regexp.new(@hp_id)
        @ew.http_request.should match Regexp.new('RETRY')
        @ew.http_request.should match Regexp.new('OTHER:some comments')
      end

      it "id_entryが空白になること" do
        @ew.id_entry.text.should == ""
      end

      it "@examが空になること" do
        @ew.exam.data[:data].should == ""
      end

      it "stateがtransmitからscanに戻ること" do
        @ew.state.should == "scan"
      end

      it "image.pixbufがbackground.pngとは異なる状態からbackground.pngに戻ること" do
        @ew.image.pixbuf.pixels.should == @blank_png.pixels
      end

      it "コメント欄が空になること" do
        @ew.comment_retry.active?.should == false
        @ew.comment_other_check.active?.should == false
        @ew.comment_other_entry.text.should == ""
      end
    end

    context "聴力検査データが得られていない場合" do
      it "requestが発行されないこと" do
        @ew.id_entry.text = @hp_id
        @ew.test_data = ['Timeout']
        @ew.button_id_entry.signal_emit("clicked")
        @ew.button_transmit.signal_emit("clicked")
        @ew.http_request.should be_nil
      end
    end
  end

  context "image表示について" do
    before do
      @blank_png = Gdk::Pixbuf.new(Assets_location + "background.png")
    end

    it "初期状態ではbackground.pngが表示されていること" do
      @ew.image.pixbuf.pixels.should == @blank_png.pixels
    end
  end
end
