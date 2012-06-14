class ExaminersController < ApplicationController
  # GET /examiners
  # GET /examiners.json
  def index
    @examiners = Examiner.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @examiners }
    end
  end

  # GET /examiners/1
  # GET /examiners/1.json
  def show
    @examiner = Examiner.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @examiner }
    end
  end

  # GET /examiners/new
  # GET /examiners/new.json
  def new
    @examiner = Examiner.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @examiner }
    end
  end

  # GET /examiners/1/edit
  def edit
    @examiner = Examiner.find(params[:id])
  end

  # POST /examiners
  # POST /examiners.json
  def create
    @examiner = Examiner.new(params[:examiner])

    respond_to do |format|
      if @examiner.save
        format.html { redirect_to @examiner, notice: 'Examiner was successfully created.' }
        format.json { render json: @examiner, status: :created, location: @examiner }
      else
        format.html { render action: "new" }
        format.json { render json: @examiner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /examiners/1
  # PUT /examiners/1.json
  def update
    @examiner = Examiner.find(params[:id])

    respond_to do |format|
      if @examiner.update_attributes(params[:examiner])
        format.html { redirect_to @examiner, notice: 'Examiner was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @examiner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /examiners/1
  # DELETE /examiners/1.json
  def destroy
    @examiner = Examiner.find(params[:id])
    @examiner.destroy

    respond_to do |format|
      format.html { redirect_to examiners_url }
      format.json { head :no_content }
    end
  end
end
