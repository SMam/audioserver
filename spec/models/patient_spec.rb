# coding: utf-8
require 'spec_helper'

describe Patient do
  context "hp_id が valid の場合" do
    it "保存できること" do
      patient = FactoryGirl.build(:patient) # hp_id: 19(valid)
      patient.save.should be_true
    end
  end

  context "hp_id が invalid の場合" do
    it "保存できないこと" do
      patient = FactoryGirl.build(:patient, :hp_id => '123')
                                            # hp_id: 123(invalid)
      patient.save.should_not be_true
    end
  end

end
