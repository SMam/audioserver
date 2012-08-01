# coding: utf-8
require 'spec_helper'

describe "audiograms/show" do
  before do
    @patient = FactoryGirl.create(:patient)
    @audiogram = assign(:audiogram, stub_model(Audiogram,
      :patient => @patient,
      :examiner => nil,
      :examdate => Time.now,
      :comment => "Comment",
      :image_location => "Image Location",

      :ac_rt_125 => 0, :ac_rt_250 => 10, :ac_rt_500 => 20, :ac_rt_1k => 30,
      :ac_rt_2k => 40, :ac_rt_4k => 50, :ac_rt_8k => 60,
      :ac_lt_125 => 0, :ac_lt_250 => 20, :ac_lt_500 => 40, :ac_lt_1k => 60,
      :ac_lt_2k => 80, :ac_lt_4k => 60, :ac_lt_8k => 40,
      :bc_rt_250 => 5, :bc_rt_500 => 15, :bc_rt_1k => 25,
      :bc_rt_2k => 35, :bc_rt_4k => 45, :bc_rt_8k => 55, 
      :bc_lt_250 => 5, :bc_lt_500 => 25, :bc_lt_1k => 45,
      :bc_lt_2k => 65, :bc_lt_4k => 45, :bc_lt_8k => 25,
      :ac_rt_125_scaleout => false, :ac_rt_250_scaleout => false,
      :ac_rt_500_scaleout => false, :ac_rt_1k_scaleout => false,
      :ac_rt_2k_scaleout => false, :ac_rt_4k_scaleout => false,
      :ac_rt_8k_scaleout => false,
      :ac_lt_125_scaleout => false, :ac_lt_250_scaleout => false,
      :ac_lt_500_scaleout => false, :ac_lt_1k_scaleout => false,
      :ac_lt_2k_scaleout => false, :ac_lt_4k_scaleout => false,
      :ac_lt_8k_scaleout => false,
      :bc_rt_250_scaleout => false, :bc_rt_500_scaleout => false,
      :bc_rt_1k_scaleout => false, :bc_rt_2k_scaleout => false,
      :bc_rt_4k_scaleout => false, :bc_rt_8k_scaleout => false,
      :bc_lt_250_scaleout => false, :bc_lt_500_scaleout => false,
      :bc_lt_1k_scaleout => false, :bc_lt_2k_scaleout => false,
      :bc_lt_4k_scaleout => false, :bc_lt_8k_scaleout => false,
      :mask_ac_rt_125 => 1, :mask_ac_rt_250 => 11, :mask_ac_rt_500 => 21, :mask_ac_rt_1k => 31,
      :mask_ac_rt_2k => 41, :mask_ac_rt_4k => 51, :mask_ac_rt_8k => 61,
      :mask_ac_lt_125 => 2, :mask_ac_lt_250 => 12, :mask_ac_lt_500 => 22, :mask_ac_lt_1k => 32,
      :mask_ac_lt_2k => 42, :mask_ac_lt_4k => 52, :mask_ac_lt_8k => 62,
      :mask_bc_rt_250 => 3, :mask_bc_rt_500 => 13, :mask_bc_rt_1k => 23,
      :mask_bc_rt_2k => 33, :mask_bc_rt_4k => 43, :mask_bc_rt_8k => 53,
      :mask_bc_lt_250 => 4, :mask_bc_lt_500 => 14, :mask_bc_lt_1k => 24,
      :mask_bc_lt_2k => 34, :mask_bc_lt_4k => 44, :mask_bc_lt_8k => 54,
      :mask_ac_rt_125_type => "Mask", :mask_ac_rt_250_type => "Mask",
      :mask_ac_rt_500_type => "Mask", :mask_ac_rt_1k_type => "Mask",
      :mask_ac_rt_2k_type => "Mask", :mask_ac_rt_4k_type => "Mask",
      :mask_ac_rt_8k_type => "Mask",
      :mask_ac_lt_125_type => "Mask", :mask_ac_lt_250_type => "Mask",
      :mask_ac_lt_500_type => "Mask", :mask_ac_lt_1k_type => "Mask",
      :mask_ac_lt_2k_type => "Mask", :mask_ac_lt_4k_type => "Mask",
      :mask_ac_lt_8k_type => "Mask",
      :mask_bc_rt_250_type => "Mask", :mask_bc_rt_500_type => "Mask",
      :mask_bc_rt_1k_type => "Mask", :mask_bc_rt_2k_type => "Mask",
      :mask_bc_rt_4k_type => "Mask", :mask_bc_rt_8k_type => "Mask",
      :mask_bc_lt_250_type => "Mask", :mask_bc_lt_500_type => "Mask",
      :mask_bc_lt_1k_type => "Mask", :mask_bc_lt_2k_type => "Mask",
      :mask_bc_lt_4k_type => "Mask", :mask_bc_lt_8k_type => "Mask",
      :manual_input => false,
      :audiometer => "Audiometer",
      :hospital => "Hospital"
    ))
  end

  context "scaleoutのない場合" do
    it "renders attributes in <p>" do
      render
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      rendered.should match(Regexp.new(reg_id(@patient.hp_id)))
                                                  # hp_idがxxx-xxxx-xx-xで表示されること
      rendered.should match(/\+0900/)             # 検査時刻がJSTで表示されること
      rendered.should match(/Comment/)
      rendered.should match(Regexp.new(mean("3", @audiogram)[:R].to_s)) # 3分法が表示される
      rendered.should match(Regexp.new(mean("3", @audiogram)[:L].to_s))
      rendered.should match(Regexp.new(mean("4", @audiogram)[:R].to_s)) # 4分法
      rendered.should match(Regexp.new(mean("4", @audiogram)[:L].to_s))
      rendered.should match(Regexp.new(mean("6", @audiogram)[:R].to_s)) # 6分法
      rendered.should match(Regexp.new(mean("6", @audiogram)[:L].to_s))
      rendered.should_not match(/cut off/)        # cut off値表示がない
      rendered.should match(/1/)                  # マスキングの条件が表示される
      rendered.should match(/11/)
      rendered.should match(/21/)
      rendered.should match(/31/)
      rendered.should match(/41/)
      rendered.should match(/51/)
      rendered.should match(/61/)
      rendered.should match(/2/)
      rendered.should match(/12/)
      rendered.should match(/22/)
      rendered.should match(/32/)
      rendered.should match(/42/)
      rendered.should match(/52/)
      rendered.should match(/62/)
      rendered.should match(/3/)
      rendered.should match(/13/)
      rendered.should match(/23/)
      rendered.should match(/33/)
      rendered.should match(/43/)
      rendered.should match(/53/)
      rendered.should match(/4/)
      rendered.should match(/14/)
      rendered.should match(/24/)
      rendered.should match(/34/)
      rendered.should match(/44/)
      rendered.should match(/54/)
      rendered.should match(/Audiometer/)
      rendered.should match(/Hospital/)
    end
  end

  context "scaleoutのある場合" do
    before(:each) do
      @audiogram.ac_rt_1k = 110.0           # AC Rt 1kHzが > 110dB
      @audiogram.ac_rt_1k_scaleout = true
    end

    it "renders attributes in <p>" do
      render
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      rendered.should match(Regexp.new(reg_id(@patient.hp_id)))
                                                  # hp_idがxxx-xxxx-xx-xで表示されること
      rendered.should match(/\+0900/)             # 検査時刻がJSTで表示されること
      rendered.should match(/Comment/)
      rendered.should match(Regexp.new(mean("3", @audiogram)[:R].to_s)) # 3分法が表示される
      rendered.should match(Regexp.new(mean("3", @audiogram)[:L].to_s))
      rendered.should match(Regexp.new(mean("4", @audiogram)[:R].to_s)) # 4分法
      rendered.should match(Regexp.new(mean("4", @audiogram)[:L].to_s))
      rendered.should match(Regexp.new(mean("4R",@audiogram)[:R].to_s)) # 4分法(cut offあり)
      rendered.should match(Regexp.new(mean("4R",@audiogram)[:L].to_s))
      rendered.should match(Regexp.new(mean("6", @audiogram)[:R].to_s)) # 6分法
      rendered.should match(Regexp.new(mean("6", @audiogram)[:L].to_s))
      rendered.should match(/cut off/)            # cut off値表示がある
      rendered.should match(/1/)                  # マスキングの条件が表示される
      rendered.should match(/11/)
      rendered.should match(/21/)
      rendered.should match(/31/)
      rendered.should match(/41/)
      rendered.should match(/51/)
      rendered.should match(/61/)
      rendered.should match(/2/)
      rendered.should match(/12/)
      rendered.should match(/22/)
      rendered.should match(/32/)
      rendered.should match(/42/)
      rendered.should match(/52/)
      rendered.should match(/62/)
      rendered.should match(/3/)
      rendered.should match(/13/)
      rendered.should match(/23/)
      rendered.should match(/33/)
      rendered.should match(/43/)
      rendered.should match(/53/)
      rendered.should match(/4/)
      rendered.should match(/14/)
      rendered.should match(/24/)
      rendered.should match(/34/)
      rendered.should match(/44/)
      rendered.should match(/54/)
      rendered.should match(/Audiometer/)
      rendered.should match(/Hospital/)
    end
  end

  context "scaleoutではないが、>100dBの結果がある場合" do
    before(:each) do
      @audiogram.ac_rt_1k = 110.0           # AC Rt 1kHzが 110dB
      @audiogram.ac_rt_1k_scaleout = false
    end

    it "renders attributes in <p>" do
      render
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      rendered.should match(Regexp.new(reg_id(@patient.hp_id)))
                                                  # hp_idがxxx-xxxx-xx-xで表示されること
      rendered.should match(/\+0900/)             # 検査時刻がJSTで表示されること
      rendered.should match(Regexp.new(mean("3", @audiogram)[:R].to_s)) # 3分法が表示される
      rendered.should match(Regexp.new(mean("3", @audiogram)[:L].to_s))
      rendered.should match(Regexp.new(mean("4", @audiogram)[:R].to_s)) # 4分法
      rendered.should match(Regexp.new(mean("4", @audiogram)[:L].to_s))
      rendered.should match(Regexp.new(mean("4R",@audiogram)[:R].to_s)) # 4分法(cut offあり)
      rendered.should match(Regexp.new(mean("4R",@audiogram)[:L].to_s))
      rendered.should match(Regexp.new(mean("6", @audiogram)[:R].to_s)) # 6分法
      rendered.should match(Regexp.new(mean("6", @audiogram)[:L].to_s))
      rendered.should match(/cut off/)            # cut off値表示がある
    end
  end

  context "1kHzと4kHzの気導のみデータがある場合" do
    before(:each) do
      @audiogram.ac_rt_125 = @audiogram.ac_rt_250 = @audiogram.ac_rt_500 =\
      @audiogram.ac_rt_2k  = @audiogram.ac_rt_8k  = nil
      @audiogram.ac_lt_125 = @audiogram.ac_lt_250 = @audiogram.ac_lt_500 =\
      @audiogram.ac_lt_2k  = @audiogram.ac_lt_8k  = nil
      @audiogram.bc_rt_250 = @audiogram.bc_rt_500 = @audiogram.bc_rt_1k  =\
      @audiogram.bc_rt_2k  = @audiogram.bc_rt_4k  = @audiogram.bc_rt_8k  = nil
      @audiogram.bc_lt_250 = @audiogram.bc_lt_500 = @audiogram.bc_lt_1k  =\
      @audiogram.bc_lt_2k  = @audiogram.bc_lt_4k  = @audiogram.bc_lt_8k  = nil
      @audiogram.mask_ac_rt_125 = @audiogram.mask_ac_rt_250 = @audiogram.mask_ac_rt_500 =\
      @audiogram.mask_ac_rt_2k  = @audiogram.mask_ac_rt_8k  = nil
      @audiogram.mask_ac_lt_125 = @audiogram.mask_ac_lt_250 = @audiogram.mask_ac_lt_500 =\
      @audiogram.mask_ac_lt_2k  = @audiogram.mask_ac_lt_8k  = nil
      @audiogram.mask_bc_rt_250 = @audiogram.mask_bc_rt_500 = @audiogram.mask_bc_rt_1k  =\
      @audiogram.mask_bc_rt_2k  = @audiogram.mask_bc_rt_4k  = @audiogram.mask_bc_rt_8k  = nil
      @audiogram.mask_bc_lt_250 = @audiogram.mask_bc_lt_500 = @audiogram.mask_bc_lt_1k  =\
      @audiogram.mask_bc_lt_2k  = @audiogram.mask_bc_lt_4k  = @audiogram.mask_bc_lt_8k  = nil
    end

    it "renders attributes in <p>" do
      render
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      rendered.should match(Regexp.new(reg_id(@patient.hp_id)))
                                                  # hp_idがxxx-xxxx-xx-xで表示されること
      rendered.should match(/\+0900/)             # 検査時刻がJSTで表示されること
      rendered.should match(Regexp.new(mean("3", @audiogram)[:R].to_s)) # 3分法が表示される
      rendered.should match(Regexp.new(mean("3", @audiogram)[:L].to_s))
      rendered.should match(Regexp.new(mean("4", @audiogram)[:R].to_s)) # 4分法
      rendered.should match(Regexp.new(mean("4", @audiogram)[:L].to_s))
      rendered.should match(Regexp.new(mean("4R",@audiogram)[:R].to_s)) # 4分法(cut offあり)
      rendered.should match(Regexp.new(mean("4R",@audiogram)[:L].to_s))
      rendered.should match(Regexp.new(mean("6", @audiogram)[:R].to_s)) # 6分法
      rendered.should match(Regexp.new(mean("6", @audiogram)[:L].to_s))
      rendered.should_not match(/cut off/)            # cut off値表示がある
    end
  end
end
