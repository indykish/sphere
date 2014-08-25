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

describe IntroSectionsController do

  # This should return the minimal set of attributes required to create a valid
  # IntroSection. As you add validations to IntroSection, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "title" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # IntroSectionsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all intro_sections as @intro_sections" do
      intro_section = IntroSection.create! valid_attributes
      get :index, {}, valid_session
      assigns(:intro_sections).should eq([intro_section])
    end
  end

  describe "GET show" do
    it "assigns the requested intro_section as @intro_section" do
      intro_section = IntroSection.create! valid_attributes
      get :show, {:id => intro_section.to_param}, valid_session
      assigns(:intro_section).should eq(intro_section)
    end
  end

  describe "GET new" do
    it "assigns a new intro_section as @intro_section" do
      get :new, {}, valid_session
      assigns(:intro_section).should be_a_new(IntroSection)
    end
  end

  describe "GET edit" do
    it "assigns the requested intro_section as @intro_section" do
      intro_section = IntroSection.create! valid_attributes
      get :edit, {:id => intro_section.to_param}, valid_session
      assigns(:intro_section).should eq(intro_section)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new IntroSection" do
        expect {
          post :create, {:intro_section => valid_attributes}, valid_session
        }.to change(IntroSection, :count).by(1)
      end

      it "assigns a newly created intro_section as @intro_section" do
        post :create, {:intro_section => valid_attributes}, valid_session
        assigns(:intro_section).should be_a(IntroSection)
        assigns(:intro_section).should be_persisted
      end

      it "redirects to the created intro_section" do
        post :create, {:intro_section => valid_attributes}, valid_session
        response.should redirect_to(IntroSection.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved intro_section as @intro_section" do
        # Trigger the behavior that occurs when invalid params are submitted
        IntroSection.any_instance.stub(:save).and_return(false)
        post :create, {:intro_section => { "title" => "invalid value" }}, valid_session
        assigns(:intro_section).should be_a_new(IntroSection)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        IntroSection.any_instance.stub(:save).and_return(false)
        post :create, {:intro_section => { "title" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested intro_section" do
        intro_section = IntroSection.create! valid_attributes
        # Assuming there are no other intro_sections in the database, this
        # specifies that the IntroSection created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        IntroSection.any_instance.should_receive(:update).with({ "title" => "MyString" })
        put :update, {:id => intro_section.to_param, :intro_section => { "title" => "MyString" }}, valid_session
      end

      it "assigns the requested intro_section as @intro_section" do
        intro_section = IntroSection.create! valid_attributes
        put :update, {:id => intro_section.to_param, :intro_section => valid_attributes}, valid_session
        assigns(:intro_section).should eq(intro_section)
      end

      it "redirects to the intro_section" do
        intro_section = IntroSection.create! valid_attributes
        put :update, {:id => intro_section.to_param, :intro_section => valid_attributes}, valid_session
        response.should redirect_to(intro_section)
      end
    end

    describe "with invalid params" do
      it "assigns the intro_section as @intro_section" do
        intro_section = IntroSection.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        IntroSection.any_instance.stub(:save).and_return(false)
        put :update, {:id => intro_section.to_param, :intro_section => { "title" => "invalid value" }}, valid_session
        assigns(:intro_section).should eq(intro_section)
      end

      it "re-renders the 'edit' template" do
        intro_section = IntroSection.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        IntroSection.any_instance.stub(:save).and_return(false)
        put :update, {:id => intro_section.to_param, :intro_section => { "title" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested intro_section" do
      intro_section = IntroSection.create! valid_attributes
      expect {
        delete :destroy, {:id => intro_section.to_param}, valid_session
      }.to change(IntroSection, :count).by(-1)
    end

    it "redirects to the intro_sections list" do
      intro_section = IntroSection.create! valid_attributes
      delete :destroy, {:id => intro_section.to_param}, valid_session
      response.should redirect_to(intro_sections_url)
    end
  end

end