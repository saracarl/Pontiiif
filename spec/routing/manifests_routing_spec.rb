require "rails_helper"

RSpec.describe ManifestsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/manifests").to route_to("manifests#index")
    end

    it "routes to #new" do
      expect(:get => "/manifests/new").to route_to("manifests#new")
    end

    it "routes to #show" do
      expect(:get => "/manifests/1").to route_to("manifests#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/manifests/1/edit").to route_to("manifests#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/manifests").to route_to("manifests#create")
    end

    it "routes to #update" do
      expect(:put => "/manifests/1").to route_to("manifests#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/manifests/1").to route_to("manifests#destroy", :id => "1")
    end

  end
end
