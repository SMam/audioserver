require 'spec_helper'

describe "audiograms/new" do
  before(:each) do
    @patient = FactoryGirl.create(:patient)
    assign(:audiogram, stub_model(Audiogram,
      :patient => nil,
      :examiner => nil,
      :comment => "MyString",
      :image_location => "MyString",
      :ac_rt_125 => 1.5,
      :ac_rt_250 => 1.5,
      :ac_rt_500 => 1.5,
      :ac_rt_1k => 1.5,
      :ac_rt_2k => 1.5,
      :ac_rt_4k => 1.5,
      :ac_rt_8k => 1.5,
      :ac_lt_125 => 1.5,
      :ac_lt_250 => 1.5,
      :ac_lt_500 => 1.5,
      :ac_lt_1k => 1.5,
      :ac_lt_2k => 1.5,
      :ac_lt_4k => 1.5,
      :ac_lt_8k => 1.5,
      :bc_rt_250 => 1.5,
      :bc_rt_500 => 1.5,
      :bc_rt_1k => 1.5,
      :bc_rt_2k => 1.5,
      :bc_rt_4k => 1.5,
      :bc_rt_8k => 1.5,
      :bc_lt_250 => 1.5,
      :bc_lt_500 => 1.5,
      :bc_lt_1k => 1.5,
      :bc_lt_2k => 1.5,
      :bc_lt_4k => 1.5,
      :bc_lt_8k => 1.5,
      :ac_rt_125_scaleout => false,
      :ac_rt_250_scaleout => false,
      :ac_rt_500_scaleout => false,
      :ac_rt_1k_scaleout => false,
      :ac_rt_2k_scaleout => false,
      :ac_rt_4k_scaleout => false,
      :ac_rt_8k_scaleout => false,
      :ac_lt_125_scaleout => false,
      :ac_lt_250_scaleout => false,
      :ac_lt_500_scaleout => false,
      :ac_lt_1k_scaleout => false,
      :ac_lt_2k_scaleout => false,
      :ac_lt_4k_scaleout => false,
      :ac_lt_8k_scaleout => false,
      :bc_rt_250_scaleout => false,
      :bc_rt_500_scaleout => false,
      :bc_rt_1k_scaleout => false,
      :bc_rt_2k_scaleout => false,
      :bc_rt_4k_scaleout => false,
      :bc_rt_8k_scaleout => false,
      :bc_lt_250_scaleout => false,
      :bc_lt_500_scaleout => false,
      :bc_lt_1k_scaleout => false,
      :bc_lt_2k_scaleout => false,
      :bc_lt_4k_scaleout => false,
      :bc_lt_8k_scaleout => false,
      :mask_ac_rt_125 => 1.5,
      :mask_ac_rt_250 => 1.5,
      :mask_ac_rt_500 => 1.5,
      :mask_ac_rt_1k => 1.5,
      :mask_ac_rt_2k => 1.5,
      :mask_ac_rt_4k => 1.5,
      :mask_ac_rt_8k => 1.5,
      :mask_ac_lt_125 => 1.5,
      :mask_ac_lt_250 => 1.5,
      :mask_ac_lt_500 => 1.5,
      :mask_ac_lt_1k => 1.5,
      :mask_ac_lt_2k => 1.5,
      :mask_ac_lt_4k => 1.5,
      :mask_ac_lt_8k => 1.5,
      :mask_bc_rt_250 => 1.5,
      :mask_bc_rt_500 => 1.5,
      :mask_bc_rt_1k => 1.5,
      :mask_bc_rt_2k => 1.5,
      :mask_bc_rt_4k => 1.5,
      :mask_bc_rt_8k => 1.5,
      :mask_bc_lt_250 => 1.5,
      :mask_bc_lt_500 => 1.5,
      :mask_bc_lt_1k => 1.5,
      :mask_bc_lt_2k => 1.5,
      :mask_bc_lt_4k => 1.5,
      :mask_bc_lt_8k => 1.5,
      :mask_ac_rt_125_type => "MyString",
      :mask_ac_rt_250_type => "MyString",
      :mask_ac_rt_500_type => "MyString",
      :mask_ac_rt_1k_type => "MyString",
      :mask_ac_rt_2k_type => "MyString",
      :mask_ac_rt_4k_type => "MyString",
      :mask_ac_rt_8k_type => "MyString",
      :mask_ac_lt_125_type => "MyString",
      :mask_ac_lt_250_type => "MyString",
      :mask_ac_lt_500_type => "MyString",
      :mask_ac_lt_1k_type => "MyString",
      :mask_ac_lt_2k_type => "MyString",
      :mask_ac_lt_4k_type => "MyString",
      :mask_ac_lt_8k_type => "MyString",
      :mask_bc_rt_250_type => "MyString",
      :mask_bc_rt_500_type => "MyString",
      :mask_bc_rt_1k_type => "MyString",
      :mask_bc_rt_2k_type => "MyString",
      :mask_bc_rt_4k_type => "MyString",
      :mask_bc_rt_8k_type => "MyString",
      :mask_bc_lt_250_type => "MyString",
      :mask_bc_lt_500_type => "MyString",
      :mask_bc_lt_1k_type => "MyString",
      :mask_bc_lt_2k_type => "MyString",
      :mask_bc_lt_4k_type => "MyString",
      :mask_bc_lt_8k_type => "MyString",
      :manual_input => false,
      :audiometer => "MyString",
      :hospital => "MyString"
    ).as_new_record)
  end

  it "renders new audiogram form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
#    assert_select "form", :action => audiograms_path, :method => "post" do
    assert_select "form", :action => @patient_audiograms_path, :method => "post" do
      assert_select "input#audiogram_patient", :name => "audiogram[patient]"
      assert_select "input#audiogram_examiner", :name => "audiogram[examiner]"
      assert_select "input#audiogram_comment", :name => "audiogram[comment]"
      assert_select "input#audiogram_image_location", :name => "audiogram[image_location]"
      assert_select "input#audiogram_ac_rt_125", :name => "audiogram[ac_rt_125]"
      assert_select "input#audiogram_ac_rt_250", :name => "audiogram[ac_rt_250]"
      assert_select "input#audiogram_ac_rt_500", :name => "audiogram[ac_rt_500]"
      assert_select "input#audiogram_ac_rt_1k", :name => "audiogram[ac_rt_1k]"
      assert_select "input#audiogram_ac_rt_2k", :name => "audiogram[ac_rt_2k]"
      assert_select "input#audiogram_ac_rt_4k", :name => "audiogram[ac_rt_4k]"
      assert_select "input#audiogram_ac_rt_8k", :name => "audiogram[ac_rt_8k]"
      assert_select "input#audiogram_ac_lt_125", :name => "audiogram[ac_lt_125]"
      assert_select "input#audiogram_ac_lt_250", :name => "audiogram[ac_lt_250]"
      assert_select "input#audiogram_ac_lt_500", :name => "audiogram[ac_lt_500]"
      assert_select "input#audiogram_ac_lt_1k", :name => "audiogram[ac_lt_1k]"
      assert_select "input#audiogram_ac_lt_2k", :name => "audiogram[ac_lt_2k]"
      assert_select "input#audiogram_ac_lt_4k", :name => "audiogram[ac_lt_4k]"
      assert_select "input#audiogram_ac_lt_8k", :name => "audiogram[ac_lt_8k]"
      assert_select "input#audiogram_bc_rt_250", :name => "audiogram[bc_rt_250]"
      assert_select "input#audiogram_bc_rt_500", :name => "audiogram[bc_rt_500]"
      assert_select "input#audiogram_bc_rt_1k", :name => "audiogram[bc_rt_1k]"
      assert_select "input#audiogram_bc_rt_2k", :name => "audiogram[bc_rt_2k]"
      assert_select "input#audiogram_bc_rt_4k", :name => "audiogram[bc_rt_4k]"
      assert_select "input#audiogram_bc_rt_8k", :name => "audiogram[bc_rt_8k]"
      assert_select "input#audiogram_bc_lt_250", :name => "audiogram[bc_lt_250]"
      assert_select "input#audiogram_bc_lt_500", :name => "audiogram[bc_lt_500]"
      assert_select "input#audiogram_bc_lt_1k", :name => "audiogram[bc_lt_1k]"
      assert_select "input#audiogram_bc_lt_2k", :name => "audiogram[bc_lt_2k]"
      assert_select "input#audiogram_bc_lt_4k", :name => "audiogram[bc_lt_4k]"
      assert_select "input#audiogram_bc_lt_8k", :name => "audiogram[bc_lt_8k]"
      assert_select "input#audiogram_ac_rt_125_scaleout", :name => "audiogram[ac_rt_125_scaleout]"
      assert_select "input#audiogram_ac_rt_250_scaleout", :name => "audiogram[ac_rt_250_scaleout]"
      assert_select "input#audiogram_ac_rt_500_scaleout", :name => "audiogram[ac_rt_500_scaleout]"
      assert_select "input#audiogram_ac_rt_1k_scaleout", :name => "audiogram[ac_rt_1k_scaleout]"
      assert_select "input#audiogram_ac_rt_2k_scaleout", :name => "audiogram[ac_rt_2k_scaleout]"
      assert_select "input#audiogram_ac_rt_4k_scaleout", :name => "audiogram[ac_rt_4k_scaleout]"
      assert_select "input#audiogram_ac_rt_8k_scaleout", :name => "audiogram[ac_rt_8k_scaleout]"
      assert_select "input#audiogram_ac_lt_125_scaleout", :name => "audiogram[ac_lt_125_scaleout]"
      assert_select "input#audiogram_ac_lt_250_scaleout", :name => "audiogram[ac_lt_250_scaleout]"
      assert_select "input#audiogram_ac_lt_500_scaleout", :name => "audiogram[ac_lt_500_scaleout]"
      assert_select "input#audiogram_ac_lt_1k_scaleout", :name => "audiogram[ac_lt_1k_scaleout]"
      assert_select "input#audiogram_ac_lt_2k_scaleout", :name => "audiogram[ac_lt_2k_scaleout]"
      assert_select "input#audiogram_ac_lt_4k_scaleout", :name => "audiogram[ac_lt_4k_scaleout]"
      assert_select "input#audiogram_ac_lt_8k_scaleout", :name => "audiogram[ac_lt_8k_scaleout]"
      assert_select "input#audiogram_bc_rt_250_scaleout", :name => "audiogram[bc_rt_250_scaleout]"
      assert_select "input#audiogram_bc_rt_500_scaleout", :name => "audiogram[bc_rt_500_scaleout]"
      assert_select "input#audiogram_bc_rt_1k_scaleout", :name => "audiogram[bc_rt_1k_scaleout]"
      assert_select "input#audiogram_bc_rt_2k_scaleout", :name => "audiogram[bc_rt_2k_scaleout]"
      assert_select "input#audiogram_bc_rt_4k_scaleout", :name => "audiogram[bc_rt_4k_scaleout]"
      assert_select "input#audiogram_bc_rt_8k_scaleout", :name => "audiogram[bc_rt_8k_scaleout]"
      assert_select "input#audiogram_bc_lt_250_scaleout", :name => "audiogram[bc_lt_250_scaleout]"
      assert_select "input#audiogram_bc_lt_500_scaleout", :name => "audiogram[bc_lt_500_scaleout]"
      assert_select "input#audiogram_bc_lt_1k_scaleout", :name => "audiogram[bc_lt_1k_scaleout]"
      assert_select "input#audiogram_bc_lt_2k_scaleout", :name => "audiogram[bc_lt_2k_scaleout]"
      assert_select "input#audiogram_bc_lt_4k_scaleout", :name => "audiogram[bc_lt_4k_scaleout]"
      assert_select "input#audiogram_bc_lt_8k_scaleout", :name => "audiogram[bc_lt_8k_scaleout]"
      assert_select "input#audiogram_mask_ac_rt_125", :name => "audiogram[mask_ac_rt_125]"
      assert_select "input#audiogram_mask_ac_rt_250", :name => "audiogram[mask_ac_rt_250]"
      assert_select "input#audiogram_mask_ac_rt_500", :name => "audiogram[mask_ac_rt_500]"
      assert_select "input#audiogram_mask_ac_rt_1k", :name => "audiogram[mask_ac_rt_1k]"
      assert_select "input#audiogram_mask_ac_rt_2k", :name => "audiogram[mask_ac_rt_2k]"
      assert_select "input#audiogram_mask_ac_rt_4k", :name => "audiogram[mask_ac_rt_4k]"
      assert_select "input#audiogram_mask_ac_rt_8k", :name => "audiogram[mask_ac_rt_8k]"
      assert_select "input#audiogram_mask_ac_lt_125", :name => "audiogram[mask_ac_lt_125]"
      assert_select "input#audiogram_mask_ac_lt_250", :name => "audiogram[mask_ac_lt_250]"
      assert_select "input#audiogram_mask_ac_lt_500", :name => "audiogram[mask_ac_lt_500]"
      assert_select "input#audiogram_mask_ac_lt_1k", :name => "audiogram[mask_ac_lt_1k]"
      assert_select "input#audiogram_mask_ac_lt_2k", :name => "audiogram[mask_ac_lt_2k]"
      assert_select "input#audiogram_mask_ac_lt_4k", :name => "audiogram[mask_ac_lt_4k]"
      assert_select "input#audiogram_mask_ac_lt_8k", :name => "audiogram[mask_ac_lt_8k]"
      assert_select "input#audiogram_mask_bc_rt_250", :name => "audiogram[mask_bc_rt_250]"
      assert_select "input#audiogram_mask_bc_rt_500", :name => "audiogram[mask_bc_rt_500]"
      assert_select "input#audiogram_mask_bc_rt_1k", :name => "audiogram[mask_bc_rt_1k]"
      assert_select "input#audiogram_mask_bc_rt_2k", :name => "audiogram[mask_bc_rt_2k]"
      assert_select "input#audiogram_mask_bc_rt_4k", :name => "audiogram[mask_bc_rt_4k]"
      assert_select "input#audiogram_mask_bc_rt_8k", :name => "audiogram[mask_bc_rt_8k]"
      assert_select "input#audiogram_mask_bc_lt_250", :name => "audiogram[mask_bc_lt_250]"
      assert_select "input#audiogram_mask_bc_lt_500", :name => "audiogram[mask_bc_lt_500]"
      assert_select "input#audiogram_mask_bc_lt_1k", :name => "audiogram[mask_bc_lt_1k]"
      assert_select "input#audiogram_mask_bc_lt_2k", :name => "audiogram[mask_bc_lt_2k]"
      assert_select "input#audiogram_mask_bc_lt_4k", :name => "audiogram[mask_bc_lt_4k]"
      assert_select "input#audiogram_mask_bc_lt_8k", :name => "audiogram[mask_bc_lt_8k]"
      assert_select "input#audiogram_mask_ac_rt_125_type", :name => "audiogram[mask_ac_rt_125_type]"
      assert_select "input#audiogram_mask_ac_rt_250_type", :name => "audiogram[mask_ac_rt_250_type]"
      assert_select "input#audiogram_mask_ac_rt_500_type", :name => "audiogram[mask_ac_rt_500_type]"
      assert_select "input#audiogram_mask_ac_rt_1k_type", :name => "audiogram[mask_ac_rt_1k_type]"
      assert_select "input#audiogram_mask_ac_rt_2k_type", :name => "audiogram[mask_ac_rt_2k_type]"
      assert_select "input#audiogram_mask_ac_rt_4k_type", :name => "audiogram[mask_ac_rt_4k_type]"
      assert_select "input#audiogram_mask_ac_rt_8k_type", :name => "audiogram[mask_ac_rt_8k_type]"
      assert_select "input#audiogram_mask_ac_lt_125_type", :name => "audiogram[mask_ac_lt_125_type]"
      assert_select "input#audiogram_mask_ac_lt_250_type", :name => "audiogram[mask_ac_lt_250_type]"
      assert_select "input#audiogram_mask_ac_lt_500_type", :name => "audiogram[mask_ac_lt_500_type]"
      assert_select "input#audiogram_mask_ac_lt_1k_type", :name => "audiogram[mask_ac_lt_1k_type]"
      assert_select "input#audiogram_mask_ac_lt_2k_type", :name => "audiogram[mask_ac_lt_2k_type]"
      assert_select "input#audiogram_mask_ac_lt_4k_type", :name => "audiogram[mask_ac_lt_4k_type]"
      assert_select "input#audiogram_mask_ac_lt_8k_type", :name => "audiogram[mask_ac_lt_8k_type]"
      assert_select "input#audiogram_mask_bc_rt_250_type", :name => "audiogram[mask_bc_rt_250_type]"
      assert_select "input#audiogram_mask_bc_rt_500_type", :name => "audiogram[mask_bc_rt_500_type]"
      assert_select "input#audiogram_mask_bc_rt_1k_type", :name => "audiogram[mask_bc_rt_1k_type]"
      assert_select "input#audiogram_mask_bc_rt_2k_type", :name => "audiogram[mask_bc_rt_2k_type]"
      assert_select "input#audiogram_mask_bc_rt_4k_type", :name => "audiogram[mask_bc_rt_4k_type]"
      assert_select "input#audiogram_mask_bc_rt_8k_type", :name => "audiogram[mask_bc_rt_8k_type]"
      assert_select "input#audiogram_mask_bc_lt_250_type", :name => "audiogram[mask_bc_lt_250_type]"
      assert_select "input#audiogram_mask_bc_lt_500_type", :name => "audiogram[mask_bc_lt_500_type]"
      assert_select "input#audiogram_mask_bc_lt_1k_type", :name => "audiogram[mask_bc_lt_1k_type]"
      assert_select "input#audiogram_mask_bc_lt_2k_type", :name => "audiogram[mask_bc_lt_2k_type]"
      assert_select "input#audiogram_mask_bc_lt_4k_type", :name => "audiogram[mask_bc_lt_4k_type]"
      assert_select "input#audiogram_mask_bc_lt_8k_type", :name => "audiogram[mask_bc_lt_8k_type]"
      assert_select "input#audiogram_manual_input", :name => "audiogram[manual_input]"
      assert_select "input#audiogram_audiometer", :name => "audiogram[audiometer]"
      assert_select "input#audiogram_hospital", :name => "audiogram[hospital]"
    end
  end
end
