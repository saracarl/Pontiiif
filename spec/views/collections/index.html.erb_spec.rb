require 'rails_helper'

RSpec.describe "collections/index", :type => :view do
  before(:each) do
    assign(:collections, [
      Collection.create!(
        :collection_id => ""
      ),
      Collection.create!(
        :collection_id => ""
      )
    ])
  end

  it "renders a list of collections" do
    render
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
