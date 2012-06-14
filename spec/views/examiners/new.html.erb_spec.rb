require 'spec_helper'

describe "examiners/new" do
  before(:each) do
    assign(:examiner, stub_model(Examiner,
      :worker_id => "MyString"
    ).as_new_record)
  end

  it "renders new examiner form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => examiners_path, :method => "post" do
      assert_select "input#examiner_worker_id", :name => "examiner[worker_id]"
    end
  end
end
