require 'rails_helper'

RSpec.describe "collections/new", :type => :view do
  before(:each) do
    assign(:collection, Collection.new(
      :collection_id => ""
    ))
  end

  it "renders new collection form" do
    render

    assert_select "form[action=?][method=?]", collections_path, "post" do

      assert_select "input#collection_collection_id[name=?]", "collection[collection_id]"
    end
  end
end
