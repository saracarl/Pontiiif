require 'rails_helper'

RSpec.describe "Collections", :type => :request do
  describe "GET /collections" do
    it "works! (now write some real specs)" do
      get collections_path
      expect(response.status).to be(200)
    end
  end
end
