# coding: utf-8
require 'spec_helper'

describe "patients/show" do
  before(:each) do
#    @patient = assign(:patient, stub_model(Patient,
#      :hp_id => "Hp"
#    ))
    @patient = stub_model(Patient,
      :hp_id => "19"
    )
    @examdate = Time.now
    @audiogram_stub0 = stub_model(Audiogram,
      :examdate => @examdate,
      :comment => "Comment",
      :image_location => "graphs_some_directory",
      :ac_rt_500 => 10, :ac_rt_1k => 20, :ac_rt_2k => 30,
      :ac_lt_500 => 15, :ac_lt_1k => 25, :ac_lt_2k => 35,
      :audiometer => "Audiometer",
      :hospital => "Hospital"
      )
    @audiogram_stub1 = stub_model(Audiogram,
      :examdate => @examdate + 3600 * 24,
      :comment => "Comment",
      :image_location => "graphs_some_directory",
      :ac_rt_500 => 10, :ac_rt_1k => 20, :ac_rt_2k => 30,
      :ac_lt_500 => 15, :ac_lt_1k => 25, :ac_lt_2k => 35,
      :audiometer => "Audiometer",
      :hospital => "Hospital"
      )
    @audiogram_stub2 = stub_model(Audiogram,
      :examdate => @examdate - 3600 * 24,
      :comment => "Comment",
      :image_location => "graphs_some_directory",
      :ac_rt_500 => 10, :ac_rt_1k => 20, :ac_rt_2k => 30,
      :ac_lt_500 => 15, :ac_lt_1k => 25, :ac_lt_2k => 35,
      :audiometer => "Audiometer",
      :hospital => "Hospital"
      )
  end

  context "patientに属するAudiogramがない場合" do
    before do
      @patient.audiograms = []
      assign(:patient, @patient)
    end

    it "renders attributes in <p>" do
      render
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      rendered.should match(Regexp.new(reg_id(@patient.hp_id)))
                                                      # hp_idがxxx-xxxx-xx-xで表示されること
      rendered.should match(/No Audiogram/)
      rendered.should_not match(/Audiograms/)
    end
  end

  context "Audiogramが複数ある場合" do
    before do
      @patient.audiograms << @audiogram_stub0
      @patient.audiograms << @audiogram_stub1
      @patient.audiograms << @audiogram_stub2
        #  新しい順に [1],[0],[2]
      assign(:patient, @patient)
    end

    it "renders attributes in <p>" do
      render
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      rendered.should match(Regexp.new(reg_id(@patient.hp_id)))
                                                      # hp_idがxxx-xxxx-xx-xで表示されること
      rendered.should_not match(/No Otolaryngological data/)
      rendered.should match(Regexp.new("Audiograms.+(3.+exams)"))
      # @patientのaudiogramのindexへのlinkが表示されること
      assert_select "h2>a", :href => Regexp.new("patients/#{@patient.to_param}/audiograms")
      # 3回分のAudiogramを表示
      assert_select "tr>td", :text => Regexp.new("R:.+#{mean("4R", @audiogram_stub0)[:R]}"),\
        :count => 3
      assert_select "tr>td", :text => Regexp.new("L:.+#{mean("4R", @audiogram_stub0)[:L]}"),\
        :count => 3
      assert_select "tr>td>a>img", :count => 3
      thumb_location = "assets/#{@audiogram_stub0.image_location.sub("graphs", "thumbnails")}"
      rendered.should =~ Regexp.new("#{thumb_location}.+#{thumb_location}", Regexp::MULTILINE)
      # 最新のAudiogramが最初に表示されること
      assert_select "tr>td#recent0", :text =>\
        Regexp.new("#{(@examdate+3600*24).strftime("%Y/%m/%d")}"), :count => 1
      assert_select "tr>td#recent1", :text =>\
        Regexp.new("#{(@examdate).strftime("%Y/%m/%d")}"), :count => 1
      assert_select "tr>td#recent2", :text =>\
        Regexp.new("#{(@examdate-3600*24).strftime("%Y/%m/%d")}"), :count => 1
      # 個々のAudiogramへのlinkが表示されること
      assert_select "tr>td>a", :href =>\
         Regexp.new("patients/#{@patient.to_param}/audiograms/#{@audiogram_stub1.to_param}")
    end
  end

  context "Audiogramが1つある場合" do
    before do
      @patient.audiograms << @audiogram_stub0
      assign(:patient, @patient)
    end

    it "renders attributes in <p>" do
      render
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      rendered.should_not match(/No Otolaryngological data/)
      rendered.should match(Regexp.new("Audiogram.+(1.+exam)"))
      rendered.should_not match(Regexp.new("Audiograms.+(1.+exams)"))
      # 1回分のAudiogramを表示
      assert_select "tr>td", :text => Regexp.new("R:.+#{mean("4R", @audiogram_stub0)[:R]}"),\
        :count => 1
    end
  end

  context "Audiogramが10ある場合" do
    before do
      9.times do
        @patient.audiograms << @audiogram_stub0
      end
      @patient.audiograms << @audiogram_stub1
      # stub1 がもっとも新しい
      assign(:patient, @patient)
    end

    it "renders attributes in <p>" do
      render
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      rendered.should match(Regexp.new("Audiograms.+(10.+exams)"))
      # 1+4回分のAudiogramを表示(残りは表示されないこと)
      assert_select "tr>td", :text =>\
        Regexp.new("#{(@examdate+3600*24).strftime("%Y/%m/%d")}"), :count => 1   # stub1
      assert_select "tr>td", :text =>\
        Regexp.new("#{(@examdate).strftime("%Y/%m/%d")}"), :count => 4           # stub0
      assert_select "tr>td>a>img", :count => 5
    end
  end
end
