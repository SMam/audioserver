require 'spec_helper'

describe Patient do
  describe "with valid data" do
    it "can save" do
      patient19 = FactoryGirl.build(:patient) # hp_id: 19(valid)
      patient19.save.should be_true
    end
  end

  describe "with invalid data" do
    it "can not save" do
      patient123 = FactoryGirl.build(:patient_with_invalid_id)
                                              # hp_id: 123(invalid)
      patient123.save.should_not be_true
    end
  end

#  pending "add some examples to (or delete) #{__FILE__}"
end
