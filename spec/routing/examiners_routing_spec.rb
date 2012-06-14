require "spec_helper"

describe ExaminersController do
  describe "routing" do

    it "routes to #index" do
      get("/examiners").should route_to("examiners#index")
    end

    it "routes to #new" do
      get("/examiners/new").should route_to("examiners#new")
    end

    it "routes to #show" do
      get("/examiners/1").should route_to("examiners#show", :id => "1")
    end

    it "routes to #edit" do
      get("/examiners/1/edit").should route_to("examiners#edit", :id => "1")
    end

    it "routes to #create" do
      post("/examiners").should route_to("examiners#create")
    end

    it "routes to #update" do
      put("/examiners/1").should route_to("examiners#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/examiners/1").should route_to("examiners#destroy", :id => "1")
    end

  end
end
