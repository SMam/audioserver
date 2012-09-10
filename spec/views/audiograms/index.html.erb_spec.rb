# coding: utf-8
require 'spec_helper'

describe "audiograms/index" do
  before(:each) do
    @patient = FactoryGirl.create(:patient)
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
    @patient.audiograms << @audiogram_stub
    @patient.audiograms << @audiogram_stub
    assign(:audiograms, @patient.audiograms)
  end

  it "renders a list of audiograms" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "h1", :text => "Listing audiograms for #{reg_id(@patient.hp_id)}", :count => 1
    # @patientへのlinkが表示されること
    assert_select "h1>a", :href => Regexp.new("patients/#{@patient.to_param}")
    assert_select "tr>td", :text => Regexp.new("#{@examdate.strftime("%Y/%m/%d")}"), :count => 2
    assert_select "tr>td", :text => Regexp.new("#{@examdate.strftime("%X")}"), :count => 2
    assert_select "tr>td", :text => Regexp.new("R:.+#{mean("4R", @audiogram_stub)[:R]}"),\
      :count => 2
    assert_select "tr>td", :text => Regexp.new("L:.+#{mean("4R", @audiogram_stub)[:L]}"),\
      :count => 2
    assert_select "tr>td>a>img", :count => 2
    thumb_location = "assets/images/#{@audiogram_stub.image_location.sub("graphs", "thumbnails")}"
    rendered.should =~ Regexp.new("#{thumb_location}.+#{thumb_location}", Regexp::MULTILINE)
    assert_select "tr>td", :text => "Comment".to_s, :count => 2
  end
end
