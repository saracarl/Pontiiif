require 'rails_helper'

RSpec.describe "collections/edit", :type => :view do
  before(:each) do
    @collection = assign(:collection, Collection.create!(
      :collection_id => ""
    ))
  end

  it "renders the edit collection form" do
    render

    assert_select "form[action=?][method=?]", collection_path(@collection), "post" do

      assert_select "input#collection_collection_id[name=?]", "collection[collection_id]"
    end
  end
end
