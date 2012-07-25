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
    @audiogram_stub = stub_model(Audiogram,
      :examdate => @examdate,
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

  context "Audiogramがある場合" do
    before do
      @patient.audiograms << @audiogram_stub
      @patient.audiograms << @audiogram_stub
      @patient.audiograms << @audiogram_stub
      assign(:patient, @patient)
    end

    it "renders attributes in <p>" do
      render
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      rendered.should match(Regexp.new(reg_id(@patient.hp_id)))
                                                      # hp_idがxxx-xxxx-xx-xで表示されること
      rendered.should_not match(/No Otolaryngological data/)
      rendered.should match(/Audiograms/)
      # 3回分のAudiogramを表示
      assert_select "tr>td", :text => Regexp.new("#{@examdate.strftime("%Y/%m/%d")}"),\
        :count => 3
      assert_select "tr>td", :text => Regexp.new("R:.+#{mean("4R", @audiogram_stub)[:R]}"),\
        :count => 3
      assert_select "tr>td", :text => Regexp.new("L:.+#{mean("4R", @audiogram_stub)[:L]}"),\
        :count => 3
      assert_select "tr>td>a>img", :count => 3
      thumb_location = "assets/#{@audiogram_stub.image_location.sub("graphs", "thumbnails")}"
      rendered.should =~ Regexp.new("#{thumb_location}.+#{thumb_location}", Regexp::MULTILINE)
    end
  end
end
