require 'rails_helper'

RSpec.describe "collections/show", :type => :view do
  before(:each) do
    @collection = assign(:collection, Collection.create!(
      :collection_id => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
  end
end
