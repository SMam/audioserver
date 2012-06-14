require 'spec_helper'

describe "patients/edit" do
  before(:each) do
    @patient = assign(:patient, stub_model(Patient,
      :hp_id => "MyString"
    ))
  end

  it "renders the edit patient form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => patients_path(@patient), :method => "post" do
      assert_select "input#patient_hp_id", :name => "patient[hp_id]"
    end
  end
end
