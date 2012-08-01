require "spec_helper"

describe PatientsController do
  describe "routing" do

    it "routes to #index" do
      get("/patients").should route_to("patients#index")
    end

    it "routes to #new" do
      get("/patients/new").should route_to("patients#new")
    end

    it "routes to #show" do
      get("/patients/1").should route_to("patients#show", :id => "1")
    end

    it "routes to #edit" do
      get("/patients/1/edit").should route_to("patients#edit", :id => "1")
    end

    it "routes to #create" do
      post("/patients").should route_to("patients#create")
    end

    it "routes to #update" do
      put("/patients/1").should route_to("patients#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/patients/1").should route_to("patients#destroy", :id => "1")
    end

    it "routes to #direct_create" do
      post("/patients/direct_create").should route_to("patients#direct_create")
    end

    it "routes to #by_hp_id" do
      get("/patients/by_hp_id/1").should route_to("patients#by_hp_id", :hp_id => "1")
    end

    it "routes to #by_hp_id for audiograms/index_of_id/:hp_id" do
      get("/audiograms/index_of_id/1").should route_to("patients#by_hp_id", :hp_id => "1")
    end

  end
end
