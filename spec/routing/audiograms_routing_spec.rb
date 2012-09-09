require "spec_helper"

describe AudiogramsController do
  describe "routing" do
    it "routes to #index" do
#      get("/audiograms").should route_to("audiograms#index")
      get("/patients/1/audiograms").should route_to("audiograms#index", :patient_id => "1")
    end

    it "routes to #new" do
#      get("/audiograms/new").should route_to("audiograms#new")
      get("/patients/1/audiograms/new").should route_to("audiograms#new", :patient_id => "1")
    end

    it "routes to #show" do
      get("/patients/1/audiograms/2").should route_to("audiograms#show", :patient_id => "1", :id => "2")
    end

    it "routes to #edit" do
      get("/patients/1//audiograms/2/edit").should route_to("audiograms#edit", :patient_id => "1", :id => "2")
    end

    it "routes to #create" do
      post("/patients/1/audiograms").should route_to("audiograms#create", :patient_id => "1")
    end

    it "routes to #update" do
      put("/patients/1/audiograms/2").should route_to("audiograms#update", :patient_id => "1", :id => "2")
    end

    it "routes to #destroy" do
      delete("/patients/1/audiograms/2").should route_to("audiograms#destroy", :patient_id => "1", :id => "2")
    end

    it "routes to #direct_create" do
      post("/audiograms/direct_create").should route_to("audiograms#direct_create")
    end

  end
end
