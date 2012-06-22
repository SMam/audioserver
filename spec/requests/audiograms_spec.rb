require 'spec_helper'

describe "Audiograms" do
  describe "GET /audiograms" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      @patient = FactoryGirl.create(:patient)
      get patient_audiograms_path(@patient)
      response.status.should be(200)
    end
  end
end
