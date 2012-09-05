class AudiogramsController < ApplicationController

  USERNAME = "audioadmin"
  PASSWORD = "audioadmin"
  http_basic_authenticate_with :name => USERNAME, :password => PASSWORD,\
    :only => ["edit", "destroy"]

  # GET /patients/:patient_id/audiograms
  # GET /audiograms.json
  def index
    @patient = Patient.find(params[:patient_id])
    @audiograms = @patient.audiograms.order('examdate DESC').all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @audiograms }
    end
  end

  # GET /patients/:patient_id/audiograms/1
  # GET /audiograms/1.json
  def show
    @patient = Patient.find(params[:patient_id])
    @audiogram = @patient.audiograms.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @audiogram }
    end
  end

  # GET /patients/:patient_id/audiograms/new
  # GET /audiograms/new.json
  def new
    @patient = Patient.find(params[:patient_id])
    @audiogram = Audiogram.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @audiogram }
    end
  end

  # GET /patients/:patient_id/audiograms/1/edit
  def edit
    @patient = Patient.find(params[:patient_id])
    @audiogram = @patient.audiograms.find(params[:id])
  end

  # POST /patients/:patients_id/audiograms
  # POST /audiograms.json
  def create
    @patient = Patient.find(params[:patient_id])
    @audiogram = @patient.audiograms.create(params[:audiogram])

    respond_to do |format|
      if @audiogram.save
        format.html { redirect_to [@patient, @audiogram], notice: 'Audiogram was successfully created.' }
        format.json { render json: @audiogram, status: :created, location: @audiogram }
      else
        format.html { render action: "new" } # ----------------- ???
        format.json { render json: @audiogram.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /patients/:patient_id/audiograms/1
  # PUT /audiograms/1.json
  def update
    @patient = Patient.find(params[:patient_id])
    @audiogram = @patient.audiograms.find(params[:id])

    respond_to do |format|
      if @audiogram.update_attributes(params[:audiogram])
        format.html { redirect_to [@patient, @audiogram], notice: 'Audiogram was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" } # -------------------- ???
        format.json { render json: @audiogram.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /patients/:patient_id/audiograms/1
  # DELETE /audiograms/1.json
  def destroy
    @patient = Patient.find(params[:patient_id])
    @audiogram = @patient.audiograms.find(params[:id])
    @audiogram.destroy

    respond_to do |format|
      format.html { redirect_to patient_audiograms_url }
      format.json { head :no_content }
    end
  end

  # PUT /patients/:patient_id/audiograms/1/edit_comment
  def edit_comment
    @patient = Patient.find(params[:patient_id])
    @audiogram = @patient.audiograms.find(params[:id])
    @audiogram.comment = params[:comment]
    @audiogram.save

    respond_to do |format|
      format.html { redirect_to [@patient, @audiogram] }
      format.json { render json: @audiogram, status: :created, location: @audiogram }
    end
  end
end
