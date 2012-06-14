class AudiogramsController < ApplicationController
  # GET /audiograms
  # GET /audiograms.json
  def index
    @audiograms = Audiogram.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @audiograms }
    end
  end

  # GET /audiograms/1
  # GET /audiograms/1.json
  def show
    @audiogram = Audiogram.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @audiogram }
    end
  end

  # GET /audiograms/new
  # GET /audiograms/new.json
  def new
    @audiogram = Audiogram.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @audiogram }
    end
  end

  # GET /audiograms/1/edit
  def edit
    @audiogram = Audiogram.find(params[:id])
  end

  # POST /audiograms
  # POST /audiograms.json
  def create
    @audiogram = Audiogram.new(params[:audiogram])

    respond_to do |format|
      if @audiogram.save
        format.html { redirect_to @audiogram, notice: 'Audiogram was successfully created.' }
        format.json { render json: @audiogram, status: :created, location: @audiogram }
      else
        format.html { render action: "new" }
        format.json { render json: @audiogram.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /audiograms/1
  # PUT /audiograms/1.json
  def update
    @audiogram = Audiogram.find(params[:id])

    respond_to do |format|
      if @audiogram.update_attributes(params[:audiogram])
        format.html { redirect_to @audiogram, notice: 'Audiogram was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @audiogram.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /audiograms/1
  # DELETE /audiograms/1.json
  def destroy
    @audiogram = Audiogram.find(params[:id])
    @audiogram.destroy

    respond_to do |format|
      format.html { redirect_to audiograms_url }
      format.json { head :no_content }
    end
  end
end
