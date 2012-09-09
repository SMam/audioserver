#coding: UTF-8

class PatientsController < ApplicationController
  require 'id_validation.rb'

  # GET /patients
  # GET /patients.json
  def index
    @patients = Patient.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @patients }
    end
  end

  # GET /patients/1
  # GET /patients/1.json
  def show
    @patient = Patient.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @patient }
    end
  end

  # GET /patients/new
  # GET /patients/new.json
  def new
    @patient = Patient.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @patient }
    end
  end

  # GET /patients/1/edit
  def edit
    @patient = Patient.find(params[:id])
  end

  # POST /patients
  # POST /patients.json
  def create
    @patient = Patient.new(params[:patient])

    respond_to do |format|
      if @patient.save
        format.html { redirect_to @patient, notice: 'Patient was successfully created.' }
        format.json { render json: @patient, status: :created, location: @patient }
      else
        format.html { render action: "new" }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /patients/1
  # PUT /patients/1.json
  def update
    @patient = Patient.find(params[:id])

    respond_to do |format|
      if @patient.update_attributes(params[:patient])
        format.html { redirect_to @patient, notice: 'Patient was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /patients/1
  # DELETE /patients/1.json
  def destroy
    @patient = Patient.find(params[:id])
    @patient.destroy

    respond_to do |format|
      format.html { redirect_to patients_url }
      format.json { head :no_content }
    end
  end

=begin
  # POST /direct_create
  # create audiogram directly from http request
  # データなどはmultipart/form-dataの形式で送信する
  def direct_create
    hp_id = valid_id?(params[:hp_id]) || "invalid_id"
    if not @patient = Patient.find_by_hp_id(hp_id)
      @patient = Patient.new
      @patient.hp_id = hp_id
    end

    if @patient.save
      case params[:datatype]
      when "audiogram"
        @audiogram = @patient.audiograms.create
        @audiogram.examdate = Time.local *params[:examdate].split(/:|-/)
        @audiogram.audiometer = params[:audiometer]
        @audiogram.comment = parse_comment(params[:comment])
        @audiogram.manual_input = false
        if params[:data] && set_data(params[:data])
          build_graph
          if @audiogram.save
            render :nothing => true, :status => 204
          else
            render :nothing => true, :status => 400
          end
        else
          render :nothing => true, :status => 400
        end
      else
        render :nothing => true, :status => 400
      end
    else
      render :nothing => true, :status => 400
    end

#    respond_to do |format|
#      format.html { redirect_to patients_url }
#      format.json { head :no_content }
#    end
  end
=end

  # GET /by_hp_id/:hp_id
  # get index by hp_id
  def by_hp_id
    if hp_id = valid_id?(params[:hp_id])
      if @patient = Patient.find_by_hp_id(hp_id)
        respond_to do |format|
          format.html { redirect_to(@patient) }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { render :file => "#{Rails.root}/public/404", :format => :html,\
                               :status => :not_found }
	  format.json  { head :not_found }
        end
      end
    else
      respond_to do |format|
        format.html { render :file => "#{Rails.root}/public/404", :format => :hrml,\
                             :status => :bad_request }
	  format.json  { head :bad_request }
        end
      #render :file => "#{Rails.root}/public/400.html", :status => '400'
    end

  end

end
