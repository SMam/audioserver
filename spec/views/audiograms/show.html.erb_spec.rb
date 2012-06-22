require 'spec_helper'

describe "audiograms/show" do
  before(:each) do
    @patient = FactoryGirl.create(:patient)
    @audiogram = assign(:audiogram, stub_model(Audiogram,
      :patient => nil,
      :examiner => nil,
      :comment => "Comment",
      :image_location => "Image Location",
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
      :mask_ac_rt_125_type => "Mask Ac Rt 125 Type",
      :mask_ac_rt_250_type => "Mask Ac Rt 250 Type",
      :mask_ac_rt_500_type => "Mask Ac Rt 500 Type",
      :mask_ac_rt_1k_type => "Mask Ac Rt 1k Type",
      :mask_ac_rt_2k_type => "Mask Ac Rt 2k Type",
      :mask_ac_rt_4k_type => "Mask Ac Rt 4k Type",
      :mask_ac_rt_8k_type => "Mask Ac Rt 8k Type",
      :mask_ac_lt_125_type => "Mask Ac Lt 125 Type",
      :mask_ac_lt_250_type => "Mask Ac Lt 250 Type",
      :mask_ac_lt_500_type => "Mask Ac Lt 500 Type",
      :mask_ac_lt_1k_type => "Mask Ac Lt 1k Type",
      :mask_ac_lt_2k_type => "Mask Ac Lt 2k Type",
      :mask_ac_lt_4k_type => "Mask Ac Lt 4k Type",
      :mask_ac_lt_8k_type => "Mask Ac Lt 8k Type",
      :mask_bc_rt_250_type => "Mask Bc Rt 250 Type",
      :mask_bc_rt_500_type => "Mask Bc Rt 500 Type",
      :mask_bc_rt_1k_type => "Mask Bc Rt 1k Type",
      :mask_bc_rt_2k_type => "Mask Bc Rt 2k Type",
      :mask_bc_rt_4k_type => "Mask Bc Rt 4k Type",
      :mask_bc_rt_8k_type => "Mask Bc Rt 8k Type",
      :mask_bc_lt_250_type => "Mask Bc Lt 250 Type",
      :mask_bc_lt_500_type => "Mask Bc Lt 500 Type",
      :mask_bc_lt_1k_type => "Mask Bc Lt 1k Type",
      :mask_bc_lt_2k_type => "Mask Bc Lt 2k Type",
      :mask_bc_lt_4k_type => "Mask Bc Lt 4k Type",
      :mask_bc_lt_8k_type => "Mask Bc Lt 8k Type",
      :manual_input => false,
      :audiometer => "Audiometer",
      :hospital => "Hospital"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(/Comment/)
    rendered.should match(/Image Location/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/Mask Ac Rt 125 Type/)
    rendered.should match(/Mask Ac Rt 250 Type/)
    rendered.should match(/Mask Ac Rt 500 Type/)
    rendered.should match(/Mask Ac Rt 1k Type/)
    rendered.should match(/Mask Ac Rt 2k Type/)
    rendered.should match(/Mask Ac Rt 4k Type/)
    rendered.should match(/Mask Ac Rt 8k Type/)
    rendered.should match(/Mask Ac Lt 125 Type/)
    rendered.should match(/Mask Ac Lt 250 Type/)
    rendered.should match(/Mask Ac Lt 500 Type/)
    rendered.should match(/Mask Ac Lt 1k Type/)
    rendered.should match(/Mask Ac Lt 2k Type/)
    rendered.should match(/Mask Ac Lt 4k Type/)
    rendered.should match(/Mask Ac Lt 8k Type/)
    rendered.should match(/Mask Bc Rt 250 Type/)
    rendered.should match(/Mask Bc Rt 500 Type/)
    rendered.should match(/Mask Bc Rt 1k Type/)
    rendered.should match(/Mask Bc Rt 2k Type/)
    rendered.should match(/Mask Bc Rt 4k Type/)
    rendered.should match(/Mask Bc Rt 8k Type/)
    rendered.should match(/Mask Bc Lt 250 Type/)
    rendered.should match(/Mask Bc Lt 500 Type/)
    rendered.should match(/Mask Bc Lt 1k Type/)
    rendered.should match(/Mask Bc Lt 2k Type/)
    rendered.should match(/Mask Bc Lt 4k Type/)
    rendered.should match(/Mask Bc Lt 8k Type/)
    rendered.should match(/false/)
    rendered.should match(/Audiometer/)
    rendered.should match(/Hospital/)
  end
end
