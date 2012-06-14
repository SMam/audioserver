require "spec_helper"

describe AudiogramsController do
  describe "routing" do

    it "routes to #index" do
      get("/audiograms").should route_to("audiograms#index")
    end

    it "routes to #new" do
      get("/audiograms/new").should route_to("audiograms#new")
    end

    it "routes to #show" do
      get("/audiograms/1").should route_to("audiograms#show", :id => "1")
    end

    it "routes to #edit" do
      get("/audiograms/1/edit").should route_to("audiograms#edit", :id => "1")
    end

    it "routes to #create" do
      post("/audiograms").should route_to("audiograms#create")
    end

    it "routes to #update" do
      put("/audiograms/1").should route_to("audiograms#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/audiograms/1").should route_to("audiograms#destroy", :id => "1")
    end

  end
end
