require 'rails_helper'

RSpec.describe "manifests/new", :type => :view do
  before(:each) do
    assign(:manifest, Manifest.new(
      :manifest_id => "",
      :label => "",
      :description => "",
      :license => "",
      :navDate => ""
    ))
  end

  it "renders new manifest form" do
    render

    assert_select "form[action=?][method=?]", manifests_path, "post" do

      assert_select "input#manifest_manifest_id[name=?]", "manifest[manifest_id]"

      assert_select "input#manifest_label[name=?]", "manifest[label]"

      assert_select "input#manifest_description[name=?]", "manifest[description]"

      assert_select "input#manifest_license[name=?]", "manifest[license]"

      assert_select "input#manifest_navDate[name=?]", "manifest[navDate]"
    end
  end
end
