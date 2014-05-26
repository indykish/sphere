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

describe OrganisationClientsController do

  # This should return the minimal set of attributes required to create a valid
  # OrganisationClient. As you add validations to OrganisationClient, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "first_name" => "" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # OrganisationClientsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all organisation_clients as @organisation_clients" do
      organisation_client = OrganisationClient.create! valid_attributes
      get :index, {}, valid_session
      assigns(:organisation_clients).should eq([organisation_client])
    end
  end

  describe "GET show" do
    it "assigns the requested organisation_client as @organisation_client" do
      organisation_client = OrganisationClient.create! valid_attributes
      get :show, {id: organisation_client.to_param}, valid_session
      assigns(:organisation_client).should eq(organisation_client)
    end
  end

  describe "GET new" do
    it "assigns a new organisation_client as @organisation_client" do
      get :new, {}, valid_session
      assigns(:organisation_client).should be_a_new(OrganisationClient)
    end
  end

  describe "GET edit" do
    it "assigns the requested organisation_client as @organisation_client" do
      organisation_client = OrganisationClient.create! valid_attributes
      get :edit, {id: organisation_client.to_param}, valid_session
      assigns(:organisation_client).should eq(organisation_client)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new OrganisationClient" do
        expect {
          post :create, {organisation_client: valid_attributes}, valid_session
        }.to change(OrganisationClient, :count).by(1)
      end

      it "assigns a newly created organisation_client as @organisation_client" do
        post :create, {organisation_client: valid_attributes}, valid_session
        assigns(:organisation_client).should be_a(OrganisationClient)
        assigns(:organisation_client).should be_persisted
      end

      it "redirects to the created organisation_client" do
        post :create, {organisation_client: valid_attributes}, valid_session
        response.should redirect_to(OrganisationClient.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved organisation_client as @organisation_client" do
        # Trigger the behavior that occurs when invalid params are submitted
        OrganisationClient.any_instance.stub(:save).and_return(false)
        post :create, {organisation_client: { "first_name" => "invalid value" }}, valid_session
        assigns(:organisation_client).should be_a_new(OrganisationClient)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        OrganisationClient.any_instance.stub(:save).and_return(false)
        post :create, {organisation_client: { "first_name" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested organisation_client" do
        organisation_client = OrganisationClient.create! valid_attributes
        # Assuming there are no other organisation_clients in the database, this
        # specifies that the OrganisationClient created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        OrganisationClient.any_instance.should_receive(:update).with({ "first_name" => "" })
        put :update, {id: organisation_client.to_param, organisation_client: { "first_name" => "" }}, valid_session
      end

      it "assigns the requested organisation_client as @organisation_client" do
        organisation_client = OrganisationClient.create! valid_attributes
        put :update, {id: organisation_client.to_param, organisation_client: valid_attributes}, valid_session
        assigns(:organisation_client).should eq(organisation_client)
      end

      it "redirects to the organisation_client" do
        organisation_client = OrganisationClient.create! valid_attributes
        put :update, {id: organisation_client.to_param, organisation_client: valid_attributes}, valid_session
        response.should redirect_to(organisation_client)
      end
    end

    describe "with invalid params" do
      it "assigns the organisation_client as @organisation_client" do
        organisation_client = OrganisationClient.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        OrganisationClient.any_instance.stub(:save).and_return(false)
        put :update, {id: organisation_client.to_param, organisation_client: { "first_name" => "invalid value" }}, valid_session
        assigns(:organisation_client).should eq(organisation_client)
      end

      it "re-renders the 'edit' template" do
        organisation_client = OrganisationClient.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        OrganisationClient.any_instance.stub(:save).and_return(false)
        put :update, {id: organisation_client.to_param, organisation_client: { "first_name" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested organisation_client" do
      organisation_client = OrganisationClient.create! valid_attributes
      expect {
        delete :destroy, {id: organisation_client.to_param}, valid_session
      }.to change(OrganisationClient, :count).by(-1)
    end

    it "redirects to the organisation_clients list" do
      organisation_client = OrganisationClient.create! valid_attributes
      delete :destroy, {id: organisation_client.to_param}, valid_session
      response.should redirect_to(organisation_clients_url)
    end
  end

end
