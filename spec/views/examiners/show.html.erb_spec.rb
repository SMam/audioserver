require 'spec_helper'

describe "examiners/show" do
  before(:each) do
    @examiner = assign(:examiner, stub_model(Examiner,
      :worker_id => "Worker"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Worker/)
  end
end
