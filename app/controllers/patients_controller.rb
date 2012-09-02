#coding: UTF-8

class PatientsController < ApplicationController
  #skip_before_filter :verify_authenticity_token, :only => [:direct_create]
  require 'audio_class.rb'
  require 'id_validation.rb'
  require 'strscan'

  Thumbnail_size = "160x160"
  #Number_of_selection = 2 #Overdraw_times   # for overdrawing of audiograms

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

  ##
  private

  def set_data(data)
    begin
      d = Audiodata.new("raw", data)
      @audiogram = convert_to_audiogram(d, @audiogram)
    rescue
      return false
    else
      return @audiogram
    end
  end

  def convert_to_audiogram(audiodata, audiogram)
    d = audiodata.extract
    a = audiogram

    ra_data = d[:ra][:data]  # Array of floats
    a.ac_rt_125, a.ac_rt_250, a.ac_rt_500, a.ac_rt_1k, a.ac_rt_2k, a.ac_rt_4k, a.ac_rt_8k = \
      ra_data[0], ra_data[1], ra_data[2], ra_data[3], ra_data[4], ra_data[5], ra_data[6]
    la_data = d[:la][:data]
    a.ac_lt_125, a.ac_lt_250, a.ac_lt_500, a.ac_lt_1k, a.ac_lt_2k, a.ac_lt_4k, a.ac_lt_8k = \
      la_data[0], la_data[1], la_data[2], la_data[3], la_data[4], la_data[5], la_data[6]

    rb_data = d[:rb][:data]
    a.bc_rt_250, a.bc_rt_500, a.bc_rt_1k, a.bc_rt_2k, a.bc_rt_4k, a.bc_rt_8k = \
      rb_data[1], rb_data[2], rb_data[3], rb_data[4], rb_data[5], rb_data[6]
    lb_data = d[:lb][:data]
    a.bc_lt_250, a.bc_lt_500, a.bc_lt_1k, a.bc_lt_2k, a.bc_lt_4k, a.bc_lt_8k = \
      lb_data[1], lb_data[2], lb_data[3], lb_data[4], lb_data[5], lb_data[6]

    ra_so = d[:ra][:scaleout]  # Array of booleans
    a.ac_rt_125_scaleout, a.ac_rt_250_scaleout, a.ac_rt_500_scaleout, \
    a.ac_rt_1k_scaleout, a.ac_rt_2k_scaleout, a.ac_rt_4k_scaleout, a.ac_rt_8k_scaleout = \
      ra_so[0], ra_so[1], ra_so[2], ra_so[3], ra_so[4], ra_so[5], ra_so[6]
    la_so = d[:la][:scaleout]
    a.ac_lt_125_scaleout, a.ac_lt_250_scaleout, a.ac_lt_500_scaleout, \
    a.ac_lt_1k_scaleout, a.ac_lt_2k_scaleout, a.ac_lt_4k_scaleout, a.ac_lt_8k_scaleout = \
      la_so[0], la_so[1], la_so[2], la_so[3], la_so[4], la_so[5], la_so[6]

    rb_so = d[:rb][:scaleout]
    a.bc_rt_250_scaleout, a.bc_rt_500_scaleout, a.bc_rt_1k_scaleout, \
    a.bc_rt_2k_scaleout, a.bc_rt_4k_scaleout, a.bc_rt_8k_scaleout = \
      rb_so[1], rb_so[2], rb_so[3], rb_so[4], rb_so[5], rb_so[6]
    lb_so = d[:lb][:scaleout]
    a.bc_lt_250_scaleout, a.bc_lt_500_scaleout, a.bc_lt_1k_scaleout, \
    a.bc_lt_2k_scaleout, a.bc_lt_4k_scaleout, a.bc_lt_8k_scaleout = \
      lb_so[1], lb_so[2], lb_so[3], lb_so[4], lb_so[5], lb_so[6]

    #  Air-Rt, data type of :mask is Array, data-order: mask_type, mask_level
    a.mask_ac_rt_125 = d[:ra][:mask][0][1].prec_f rescue nil    # Air-rt
    a.mask_ac_rt_125_type = d[:ra][:mask][0][0] rescue nil
    a.mask_ac_rt_250 = d[:ra][:mask][1][1].prec_f rescue nil
    a.mask_ac_rt_250_type = d[:ra][:mask][1][0] rescue nil
    a.mask_ac_rt_500 = d[:ra][:mask][2][1].prec_f rescue nil
    a.mask_ac_rt_500_type = d[:ra][:mask][2][0] rescue nil
    a.mask_ac_rt_1k = d[:ra][:mask][3][1].prec_f rescue nil
    a.mask_ac_rt_1k_type = d[:ra][:mask][3][0] rescue nil
    a.mask_ac_rt_2k = d[:ra][:mask][4][1].prec_f rescue nil
    a.mask_ac_rt_2k_type = d[:ra][:mask][4][0] rescue nil
    a.mask_ac_rt_4k = d[:ra][:mask][5][1].prec_f rescue nil
    a.mask_ac_rt_4k_type = d[:ra][:mask][5][0] rescue nil
    a.mask_ac_rt_8k = d[:ra][:mask][6][1].prec_f rescue nil
    a.mask_ac_rt_8k_type = d[:ra][:mask][6][0] rescue nil

    a.mask_ac_lt_125 = d[:la][:mask][0][1].prec_f rescue nil    #  Air-Lt
    a.mask_ac_lt_125_type = d[:la][:mask][0][0] rescue nil
    a.mask_ac_lt_250 = d[:la][:mask][1][1].prec_f rescue nil
    a.mask_ac_lt_250_type = d[:la][:mask][1][0] rescue nil
    a.mask_ac_lt_500 = d[:la][:mask][2][1].prec_f rescue nil
    a.mask_ac_lt_500_type = d[:la][:mask][2][0] rescue nil
    a.mask_ac_lt_1k = d[:la][:mask][3][1].prec_f rescue nil
    a.mask_ac_lt_1k_type = d[:la][:mask][3][0] rescue nil
    a.mask_ac_lt_2k = d[:la][:mask][4][1].prec_f rescue nil
    a.mask_ac_lt_2k_type = d[:la][:mask][4][0] rescue nil
    a.mask_ac_lt_4k = d[:la][:mask][5][1].prec_f rescue nil
    a.mask_ac_lt_4k_type = d[:la][:mask][5][0] rescue nil
    a.mask_ac_lt_8k = d[:la][:mask][6][1].prec_f rescue nil
    a.mask_ac_lt_8k_type = d[:la][:mask][6][0] rescue nil

    a.mask_bc_rt_250 = d[:rb][:mask][1][1].prec_f rescue nil    #  Bone-Rt
    a.mask_bc_rt_250_type = d[:rb][:mask][1][0] rescue nil
    a.mask_bc_rt_500 = d[:rb][:mask][2][1].prec_f rescue nil
    a.mask_bc_rt_500_type = d[:rb][:mask][2][0] rescue nil
    a.mask_bc_rt_1k = d[:rb][:mask][3][1].prec_f rescue nil
    a.mask_bc_rt_1k_type = d[:rb][:mask][3][0] rescue nil
    a.mask_bc_rt_2k = d[:rb][:mask][4][1].prec_f rescue nil
    a.mask_bc_rt_2k_type = d[:rb][:mask][4][0] rescue nil
    a.mask_bc_rt_4k = d[:rb][:mask][5][1].prec_f rescue nil
    a.mask_bc_rt_4k_type = d[:rb][:mask][5][0] rescue nil
    a.mask_bc_rt_8k = d[:rb][:mask][6][1].prec_f rescue nil
    a.mask_bc_rt_8k_type = d[:rb][:mask][6][0] rescue nil

    a.mask_bc_lt_250 = d[:lb][:mask][1][1].prec_f rescue nil    #  Bone-Lt
    a.mask_bc_lt_250_type = d[:lb][:mask][1][0] rescue nil
    a.mask_bc_lt_500 = d[:lb][:mask][2][1].prec_f rescue nil
    a.mask_bc_lt_500_type = d[:lb][:mask][2][0] rescue nil
    a.mask_bc_lt_1k = d[:lb][:mask][3][1].prec_f rescue nil
    a.mask_bc_lt_1k_type = d[:lb][:mask][3][0] rescue nil
    a.mask_bc_lt_2k = d[:lb][:mask][4][1].prec_f rescue nil
    a.mask_bc_lt_2k_type = d[:lb][:mask][4][0] rescue nil
    a.mask_bc_lt_4k = d[:lb][:mask][5][1].prec_f rescue nil
    a.mask_bc_lt_4k_type = d[:lb][:mask][5][0] rescue nil
    a.mask_bc_lt_8k = d[:lb][:mask][6][1].prec_f rescue nil
    a.mask_bc_lt_8k_type = d[:lb][:mask][6][0] rescue nil

    return a
  end

  def create_dir_if_not_exist(dir)
    Dir::mkdir(dir) if not File.exists?(dir)
  end

  def convert_to_audiodata(audiogram)
    ra_data = [{:data => audiogram.ac_rt_125, :scaleout => audiogram.ac_rt_125_scaleout},
               {:data => audiogram.ac_rt_250, :scaleout => audiogram.ac_rt_250_scaleout},
               {:data => audiogram.ac_rt_500, :scaleout => audiogram.ac_rt_500_scaleout},
               {:data => audiogram.ac_rt_1k,  :scaleout => audiogram.ac_rt_1k_scaleout} ,
               {:data => audiogram.ac_rt_2k,  :scaleout => audiogram.ac_rt_2k_scaleout} ,
               {:data => audiogram.ac_rt_4k,  :scaleout => audiogram.ac_rt_4k_scaleout} ,
               {:data => audiogram.ac_rt_8k,  :scaleout => audiogram.ac_rt_8k_scaleout} ]
    la_data = [{:data => audiogram.ac_lt_125, :scaleout => audiogram.ac_lt_125_scaleout},
               {:data => audiogram.ac_lt_250, :scaleout => audiogram.ac_lt_250_scaleout},
               {:data => audiogram.ac_lt_500, :scaleout => audiogram.ac_lt_500_scaleout},
               {:data => audiogram.ac_lt_1k,  :scaleout => audiogram.ac_lt_1k_scaleout} ,
               {:data => audiogram.ac_lt_2k,  :scaleout => audiogram.ac_lt_2k_scaleout} ,
               {:data => audiogram.ac_lt_4k,  :scaleout => audiogram.ac_lt_4k_scaleout} ,
               {:data => audiogram.ac_lt_8k,  :scaleout => audiogram.ac_lt_8k_scaleout} ]
    rb_data = [{:data => nil, :scaleout => nil},           # nil is better than "" ?
               {:data => audiogram.bc_rt_250, :scaleout => audiogram.bc_rt_250_scaleout},
               {:data => audiogram.bc_rt_500, :scaleout => audiogram.bc_rt_500_scaleout},
               {:data => audiogram.bc_rt_1k,  :scaleout => audiogram.bc_rt_1k_scaleout} ,
               {:data => audiogram.bc_rt_2k,  :scaleout => audiogram.bc_rt_2k_scaleout} ,
               {:data => audiogram.bc_rt_4k,  :scaleout => audiogram.bc_rt_4k_scaleout} ,
               {:data => audiogram.bc_rt_8k,  :scaleout => audiogram.bc_rt_8k_scaleout} ]
    lb_data = [{:data => nil, :scaleout => nil},           # nil is better than "" ?
               {:data => audiogram.bc_lt_250, :scaleout => audiogram.bc_lt_250_scaleout},
               {:data => audiogram.bc_lt_500, :scaleout => audiogram.bc_lt_500_scaleout},
               {:data => audiogram.bc_lt_1k,  :scaleout => audiogram.bc_lt_1k_scaleout} ,
               {:data => audiogram.bc_lt_2k,  :scaleout => audiogram.bc_lt_2k_scaleout} ,
               {:data => audiogram.bc_lt_4k,  :scaleout => audiogram.bc_lt_4k_scaleout} ,
               {:data => audiogram.bc_lt_8k,  :scaleout => audiogram.bc_lt_8k_scaleout} ]
    ra_mask = [{:type => audiogram.mask_ac_rt_125_type, :level => audiogram.mask_ac_rt_125},
               {:type => audiogram.mask_ac_rt_250_type, :level => audiogram.mask_ac_rt_250},
               {:type => audiogram.mask_ac_rt_500_type, :level => audiogram.mask_ac_rt_500},
               {:type => audiogram.mask_ac_rt_1k_type,  :level => audiogram.mask_ac_rt_1k} ,
               {:type => audiogram.mask_ac_rt_2k_type,  :level => audiogram.mask_ac_rt_2k} ,
               {:type => audiogram.mask_ac_rt_4k_type,  :level => audiogram.mask_ac_rt_4k} ,
               {:type => audiogram.mask_ac_rt_8k_type,  :level => audiogram.mask_ac_rt_8k} ]
    la_mask = [{:type => audiogram.mask_ac_lt_125_type, :level => audiogram.mask_ac_lt_125},
               {:type => audiogram.mask_ac_lt_250_type, :level => audiogram.mask_ac_lt_250},
               {:type => audiogram.mask_ac_lt_500_type, :level => audiogram.mask_ac_lt_500},
               {:type => audiogram.mask_ac_lt_1k_type,  :level => audiogram.mask_ac_lt_1k} ,
               {:type => audiogram.mask_ac_lt_2k_type,  :level => audiogram.mask_ac_lt_2k} ,
               {:type => audiogram.mask_ac_lt_4k_type,  :level => audiogram.mask_ac_lt_4k} ,
               {:type => audiogram.mask_ac_lt_8k_type,  :level => audiogram.mask_ac_lt_8k} ]
    rb_mask = [{:type => nil, :level => nil},
               {:type => audiogram.mask_bc_rt_250_type, :level => audiogram.mask_bc_rt_250},
               {:type => audiogram.mask_bc_rt_500_type, :level => audiogram.mask_bc_rt_500},
               {:type => audiogram.mask_bc_rt_1k_type,  :level => audiogram.mask_bc_rt_1k} ,
               {:type => audiogram.mask_bc_rt_2k_type,  :level => audiogram.mask_bc_rt_2k} ,
               {:type => audiogram.mask_bc_rt_4k_type,  :level => audiogram.mask_bc_rt_4k} ,
               {:type => audiogram.mask_bc_rt_8k_type,  :level => audiogram.mask_bc_rt_8k} ]
    lb_mask = [{:type => nil, :level => nil},
               {:type => audiogram.mask_bc_lt_250_type, :level => audiogram.mask_bc_lt_250},
               {:type => audiogram.mask_bc_lt_500_type, :level => audiogram.mask_bc_lt_500},
               {:type => audiogram.mask_bc_lt_1k_type,  :level => audiogram.mask_bc_lt_1k} ,
               {:type => audiogram.mask_bc_lt_2k_type,  :level => audiogram.mask_bc_lt_2k} ,
               {:type => audiogram.mask_bc_lt_4k_type,  :level => audiogram.mask_bc_lt_4k} ,
               {:type => audiogram.mask_bc_lt_8k_type,  :level => audiogram.mask_bc_lt_8k} ]
    return Audiodata.new("cooked", ra_data, la_data, rb_data, lb_data, \
                                   ra_mask, la_mask, rb_mask, lb_mask)
  end

############################################### ここまでみた
#  def make_graph_data(audiogram) ###########################見てない
#    a = Audio.new(convert_to_audiodata(audiogram))
#    a.draw                    #######  a.draw(filename)に変更されている
#    return a.to_graph_string  #######  to_graph_string は廃止されている
#  end

  def make_filename(base_dir, base_name)
    # assume make_filename(base_dir, @audiogram.examdate.strftime("%Y%m%d-%H%M%S"))
    # as actual argument
    ver = 0
    Dir.glob("#{base_dir}#{base_name}*").each do |f|
      if /#{base_name}.png\Z/ =~ f
        ver = 1 if ver == 0
      end
      if /#{base_name}-(\d*).png\Z/ =~ f
        ver = ($1.to_i + 1) if $1.to_i >= ver
      end
    end
    if ver == 0
      return "#{base_dir}#{base_name}.png"
    else
      if ver < 100
        ver_str = "%02d" % ver
      else
        ver_str = ver.to_s
      end
      return "#{base_dir}#{base_name}-#{ver_str}.png"
    end
  end

  def parse_comment(comment)
    ss = StringScanner.new(comment)
    result = String.new
    until ss.eos? do
      case
      when ss.scan(/RETRY_/)
        result += "再検査(RETRY)/"
      when ss.scan(/MASK_/)
        result += "マスキング変更(MASK)/"
      when ss.scan(/PATCH_/)
        result += "パッチテスト(PATCH)/"
      when ss.scan(/MED_/)
        result += "薬剤投与後(MED)/"
      when ss.scan(/OTHER:(.*)_/)
        result += "\n"
	result += "・#{ss[1]}"
      else
	break
      end
    end
    return result
  end

  def build_graph
    exam_year = @audiogram.examdate.strftime("%Y")
    image_root = "app/assets/images"
    base_dir = "#{Rails.env}/graphs/#{exam_year}/"
    @audiogram.image_location = make_filename(base_dir, \
                                @audiogram.examdate.strftime("%Y%m%d-%H%M%S"))
    thumbnail_location = @audiogram.image_location.sub("graphs", "thumbnails")
    create_dir_if_not_exist("#{image_root}/#{Rails.env}")
    create_dir_if_not_exist("#{image_root}/#{Rails.env}/graphs")
    create_dir_if_not_exist("#{image_root}/#{Rails.env}/graphs/#{exam_year}")
    create_dir_if_not_exist("#{image_root}/#{Rails.env}/thumbnails")
    create_dir_if_not_exist("#{image_root}/#{Rails.env}/thumbnails/#{exam_year}")

    a = Audio.new(convert_to_audiodata(@audiogram))
    output_file = "#{image_root}/#{@audiogram.image_location}"
    a.draw(output_file) # a.draw(filename)に変更されている
    system("convert -geometry #{Thumbnail_size} #{output_file} \
      #{image_root}/#{thumbnail_location}")  ### convert to 160x160px thumbnail
  end

  def build_overdrawn_graph(audiogram, *pre_audiograms) ###########################みてない
    # recieve undefined(不定長) data with *pre_audiogram
    a = Audio.new(convert_to_audiodata(audiogram))
    p_as = Array.new     # (p)re(_a)udiogram(s) ???? p_as
    pre_audiograms.each do |pre_audiogram|
      p_as << convert_to_audiodata(pre_audiogram)
    end
    a.predraw(p_as)
    a.draw
    buf = a.to_graph_string
    tmp_file = "public/images/#{Rails.env}/graphs/tmp.ppm"
    tmp_file_png = "public/images/#{Rails.env}/graphs/tmp.png"
    File.open(tmp_file, "wb") do |f|                       # write temporally as ppm-file
      f.puts buf
    end
    system("convert #{tmp_file} #{tmp_file_png}")   # convert with ImageMagick
  end

  def select_recent_audiograms(params) # from newer data to older ###############みてない
    audiograms = Array.new
    if params[:selected]
      for id in params[:selected]
        audiograms << Audiogram.find(id.to_i)
      end
      n = audiograms.length
      limit_n = Number_of_selection

      if n > (limit_n-1)
        audiograms.sort! do |s1, s2|
          s2.examdate <=> s1.examdate
        end
        for i in limit_n..(n-1)
          audiograms.delete_at(limit_n)
        end
      end
    end
    return audiograms
  end

end



