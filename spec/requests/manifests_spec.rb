require 'rails_helper'

RSpec.describe "Manifests", :type => :request do
  describe "GET /manifests" do
    it "works! (now write some real specs)" do
      get manifests_path
      expect(response.status).to be(200)
    end
  end
end
