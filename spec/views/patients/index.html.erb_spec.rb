require 'spec_helper'

describe "patients/index" do
  before(:each) do
    assign(:patients, [
      stub_model(Patient,
        :hp_id => "Hp"
      ),
      stub_model(Patient,
        :hp_id => "Hp"
      )
    ])
  end

  it "renders a list of patients" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Hp".to_s, :count => 2
  end
end
