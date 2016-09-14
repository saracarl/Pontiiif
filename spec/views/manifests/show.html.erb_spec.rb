require 'rails_helper'

RSpec.describe "manifests/show", :type => :view do
  before(:each) do
    @manifest = assign(:manifest, Manifest.create!(
      :manifest_id => "",
      :label => "",
      :description => "",
      :license => "",
      :navDate => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
