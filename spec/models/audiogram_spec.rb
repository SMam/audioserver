# coding: utf-8
require 'spec_helper'

describe Audiogram do
  context "valid data の場合" do
    it "保存できること" do
      audiogram = FactoryGirl.build(:audiogram)
      audiogram.save.should be_true
    end
  end

  context "examdate がない場合" do
    it "保存できないこと" do
      audiogram = FactoryGirl.build(:audiogram, :examdate => nil)
      audiogram.save.should_not be_true
    end
  end

  context "audiometer がない場合" do
    it "保存できないこと" do
      audiogram = FactoryGirl.build(:audiogram, :audiometer => nil)
      audiogram.save.should_not be_true
    end
  end
end
