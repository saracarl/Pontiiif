require 'rails_helper'

RSpec.describe "manifests/edit", :type => :view do
  before(:each) do
    @manifest = assign(:manifest, Manifest.create!(
      :manifest_id => "",
      :label => "",
      :description => "",
      :license => "",
      :navDate => ""
    ))
  end

  it "renders the edit manifest form" do
    render

    assert_select "form[action=?][method=?]", manifest_path(@manifest), "post" do

      assert_select "input#manifest_manifest_id[name=?]", "manifest[manifest_id]"

      assert_select "input#manifest_label[name=?]", "manifest[label]"

      assert_select "input#manifest_description[name=?]", "manifest[description]"

      assert_select "input#manifest_license[name=?]", "manifest[license]"

      assert_select "input#manifest_nav_date[name=?]", "manifest[nav_date]"
    end
  end
end
