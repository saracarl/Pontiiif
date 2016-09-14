require 'rails_helper'

RSpec.describe "manifests/index", :type => :view do
  before(:each) do
    assign(:manifests, [
      Manifest.create!(
        :manifest_id => "",
        :label => "",
        :description => "",
        :license => "",
        :navDate => ""
      ),
      Manifest.create!(
        :manifest_id => "",
        :label => "",
        :description => "",
        :license => "",
        :navDate => ""
      )
    ])
  end

  it "renders a list of manifests" do
    render
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
