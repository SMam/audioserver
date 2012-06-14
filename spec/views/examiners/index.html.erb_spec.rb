require 'spec_helper'

describe "examiners/index" do
  before(:each) do
    assign(:examiners, [
      stub_model(Examiner,
        :worker_id => "Worker"
      ),
      stub_model(Examiner,
        :worker_id => "Worker"
      )
    ])
  end

  it "renders a list of examiners" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Worker".to_s, :count => 2
  end
end
