require 'spec_helper'

describe "audiograms/index" do
  before(:each) do
    @patient = FactoryGirl.create(:patient)
    assign(:audiograms, [
      stub_model(Audiogram,
        :patient => @patient,
        #:examiner => nil,
        :comment => "Comment",
        :ac_rt_125 => 1.5,
        :ac_rt_250 => 2.5,
        :audiometer => "Audiometer",
        :hospital => "Hospital"
      ),
      stub_model(Audiogram,
        :patient => @patient,
        #:examiner => nil,
        :comment => "Comment",
        :ac_rt_125 => 1.5,
        :ac_rt_250 => 2.5,
        :audiometer => "Audiometer",
        :hospital => "Hospital"
      )
    ])
  end

  it "renders a list of audiograms" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    #assert_select "tr>td", :text => nil.to_s, :count => 2
    #assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Comment".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => "Audiometer".to_s, :count => 2
    assert_select "tr>td", :text => "Hospital".to_s, :count => 2
  end
end
