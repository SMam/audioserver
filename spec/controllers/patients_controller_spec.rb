# coding: utf-8
require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe PatientsController do

  # This should return the minimal set of attributes required to create a valid
  # Patient. As you add validations to Patient, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
#    {:hp_id => '19'}
    {:hp_id => valid_id?('19')}
  end
  
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PatientsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all patients as @patients" do
      patient = Patient.create! valid_attributes
      get :index, {}, valid_session
      assigns(:patients).should eq([patient])
    end
  end

  describe "GET show" do
    it "assigns the requested patient as @patient" do
      patient = Patient.create! valid_attributes
      get :show, {:id => patient.to_param}, valid_session
      assigns(:patient).should eq(patient)
    end
  end

  describe "GET new" do
    it "assigns a new patient as @patient" do
      get :new, {}, valid_session
      assigns(:patient).should be_a_new(Patient)
    end
  end

  describe "GET edit" do
    it "assigns the requested patient as @patient" do
      patient = Patient.create! valid_attributes
      get :edit, {:id => patient.to_param}, valid_session
      assigns(:patient).should eq(patient)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Patient" do
        expect {
          post :create, {:patient => valid_attributes}, valid_session
        }.to change(Patient, :count).by(1)
      end

      it "assigns a newly created patient as @patient" do
        post :create, {:patient => valid_attributes}, valid_session
        assigns(:patient).should be_a(Patient)
        assigns(:patient).should be_persisted
      end

      it "redirects to the created patient" do
        post :create, {:patient => valid_attributes}, valid_session
        response.should redirect_to(Patient.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved patient as @patient" do
        # Trigger the behavior that occurs when invalid params are submitted
        Patient.any_instance.stub(:save).and_return(false)
        post :create, {:patient => {}}, valid_session
        assigns(:patient).should be_a_new(Patient)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Patient.any_instance.stub(:save).and_return(false)
        post :create, {:patient => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested patient" do
        patient = Patient.create! valid_attributes
        # Assuming there are no other patients in the database, this
        # specifies that the Patient created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Patient.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => patient.to_param, :patient => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested patient as @patient" do
        patient = Patient.create! valid_attributes
        put :update, {:id => patient.to_param, :patient => valid_attributes}, valid_session
        assigns(:patient).should eq(patient)
      end

      it "redirects to the patient" do
        patient = Patient.create! valid_attributes
        put :update, {:id => patient.to_param, :patient => valid_attributes}, valid_session
        response.should redirect_to(patient)
      end
    end

    describe "with invalid params" do
      it "assigns the patient as @patient" do
        patient = Patient.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Patient.any_instance.stub(:save).and_return(false)
        put :update, {:id => patient.to_param, :patient => {}}, valid_session
        assigns(:patient).should eq(patient)
      end

      it "re-renders the 'edit' template" do
        patient = Patient.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Patient.any_instance.stub(:save).and_return(false)
        put :update, {:id => patient.to_param, :patient => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested patient" do
      patient = Patient.create! valid_attributes
      expect {
        delete :destroy, {:id => patient.to_param}, valid_session
      }.to change(Patient, :count).by(-1)
    end

    it "redirects to the patients list" do
      patient = Patient.create! valid_attributes
      delete :destroy, {:id => patient.to_param}, valid_session
      response.should redirect_to(patients_url)
    end
  end

  describe "POST direct_create" do
    # datatype は今のところ audiogram, impedance, images
    # params は params[:hp_id][:datatype][:examdate][:comment][:data]

    context "datatypeがaudiogramの場合" do
      before do
        @valid_hp_id = 19
        @invalid_hp_id = 18
	@examdate = Time.now.strftime("%Y:%m:%d-%H:%M:%S")
	@audiometer = "audiometer"
	@datatype = "audiogram"
	@comment = "comment"
        @raw_audiosample = "7@/          /  080604  //   0   30 ,  10   35 ,  20   40 ,          ,  30   45 ,          ,  40   50 ,          ,  50   55 ,          ,  60   60 ,          , -10   55 ,  -5   55 ,          ,   0   55 ,          ,   5   55 ,          ,  10   55 ,          ,  15   55 ,  4>  4<,  4>  4<,  4>  4<,        ,  4>  4<,        ,  4>  4<,        ,  4>  4<,        ,  4>  4<,        ,  4>  4<,  4>  4<,        ,  4>  4<,        ,  4>  4<,        ,  4>  4<,        ,  4>  4<,/P"
 #  125 250 500  1k  2k  4k  8k
 #R   0  10  20  30  40  50  60
 #L  30  35  40  45  50  55  60
      end

      it "正しいパラメータの場合、Audiogramのアイテム数が1増えること" do
        expect {
          post :direct_create, {:hp_id => @valid_hp_id, :examdate => @examdate, \
                                :audiometer => @audiometer, :datatype => @datatype, \
                                :comment => @comment, :data => @raw_audiosample}
         }.to change(Audiogram, :count).by(1)
      end

      it "正しいパラメータの場合、HTTP status code 204を返すこと" do
        post :direct_create, {:hp_id => @valid_hp_id, :examdate => @examdate, \
                              :audiometer => @audiometer, :datatype => @datatype, \
                              :comment => @comment, :data => @raw_audiosample}
        response.status.should  be(204)
      end

      it "正しいパラメータの場合、所定の位置にグラフとサムネイルが作られること" do
        post :direct_create, {:hp_id => @valid_hp_id, :examdate => @examdate, \
                              :audiometer => @audiometer, :datatype => @datatype, \
                              :comment => @comment, :data => @raw_audiosample}
	img_loc = "app/assets/images/#{assigns(:audiogram).image_location}"
	thumb_loc = img_loc.sub("graphs", "thumbnails")
	File::exists?(img_loc).should be_true
	File::exists?(thumb_loc).should be_true
	# assigns(:audiogram)を有効にするには、controller側でインスタンス変数@audiogramが
	# 作成したAudiogramを示すことが必要
      end

      it "不正なhp_idの場合、HTTP status code 400を返すこと" do
        post :direct_create, {:hp_id => @invalid_hp_id, :examdate => @examdate, \
                              :audiometer => @audiometer, :datatype => @datatype, \
                              :comment => @comment, :data => @raw_audiosample}
        response.status.should  be(400)
      end

      it "audiometerの入力がない場合、HTTP status code 400を返すこと" do
        post :direct_create, {:hp_id => @valid_hp_id, :examdate => @examdate, \
                              :datatype => @datatype, \
                              :comment => @comment, :data => @raw_audiosample}
        response.status.should  be(400)
      end

      it "dataがない場合、HTTP status code 400を返すこと" do
        post :direct_create, {:hp_id => @valid_hp_id, :examdate => @examdate, \
                              :audiometer => @audiometer, :datatype => @datatype, \
                              :comment => @comment}
        response.status.should  be(400)
      end

      it "data形式が不正の場合、HTTP status code 400を返すこと" do
        post :direct_create, {:hp_id => @valid_hp_id, :examdate => @examdate, \
                              :audiometer => @audiometer, :datatype => @datatype, \
                              :comment => @comment, :data => "no valid data"}
        response.status.should  be(400)
      end

      it "hp_idが存在しないものの場合、Patientのアイテム数が1増えること" do
        if patient_to_delete = Patient.find_by_hp_id(@valid_hp_id)
	  patient_to_delete.destroy
        end
        expect {
          post :direct_create, {:hp_id => @valid_hp_id, :examdate => @examdate, \
                                :audiometer => @audiometer, :datatype => @datatype, \
                                :comment => @comment, :data => @raw_audiosample}
         }.to change(Patient, :count).by(1)
      end

      it "hp_idが存在しないものの場合、Audiogramのアイテム数が1増えること" do
        if patient_to_delete = Patient.find_by_hp_id(@valid_hp_id)
	  patient_to_delete.destroy
        end
        expect {
          post :direct_create, {:hp_id => @valid_hp_id, :examdate => @examdate, \
                                :audiometer => @audiometer, :datatype => @datatype, \
                                :comment => @comment, :data => @raw_audiosample}
         }.to change(Audiogram, :count).by(1)
      end

      it "examdateが設定されていない場合..." do
        pending "どうしたものかまだ思案中"
      end

    end
  end

  describe "GET by_hp_id" do
    context "validな hp_idで requestした場合" do
      before do
        @patient = Patient.create! valid_attributes
        @hp_id = @patient.hp_id
        get :by_hp_id, {:hp_id => @hp_id}, valid_session
      end

      it "正しく @patientとしてassignされること" do
        assigns(:patient).should eq(@patient)
      end

      it "redirects to the patient" do
        response.should redirect_to(@patient)
      end
    end

    it "存在しない、validな hp_idで requestした場合、HTTP status code 404を返すこと" do
      patient = Patient.create! valid_attributes
      hp_id = patient.hp_id
      patient.delete
      get :by_hp_id, {:hp_id => hp_id}, valid_session
      response.status.should  be(404)
    end

    it "invalidな hp_idで requestした場合、HTTP status code 400を返すこと" do
      @invalid_hp_id = 18
      get :by_hp_id, {:hp_id => @invalid_hp_id}, valid_session
      response.status.should  be(400)
    end
  end
end
