require 'spec_helper'

describe "examiners/edit" do
  before(:each) do
    @examiner = assign(:examiner, stub_model(Examiner,
      :worker_id => "MyString"
    ))
  end

  it "renders the edit examiner form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => examiners_path(@examiner), :method => "post" do
      assert_select "input#examiner_worker_id", :name => "examiner[worker_id]"
    end
  end
end
