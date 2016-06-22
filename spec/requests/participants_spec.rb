require "rails_helper"

RSpec.describe "Participants", type: :request do
  # This should return the minimal set of attributes required to create a valid
  # Participant. As you add validations to Participant, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    attributes_for(:participant)
  end

  let(:invalid_attributes) do
    {
      name: "q"
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ParticipantsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it do
      participant = Participant.create! valid_attributes
      get participants_path, {}, valid_session
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #show" do
    it do
      participant = Participant.create! valid_attributes
      get participants_path(participant.to_param), valid_session
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #new" do
    it do
      get new_participant_path, {}, valid_session
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #edit" do
    it do
      participant = Participant.create! valid_attributes
      get edit_participant_path(participant.to_param), valid_session
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Participant" do
        expect do
          post participants_path, { participant: valid_attributes }, valid_session
        end.to change(Participant, :count).by(1)
        expect(response).to have_http_status(302)
      end

      it "redirects to the created participant" do
        post participants_path, { participant: valid_attributes }, valid_session
        expect(response).to redirect_to(Participant.last)
      end
    end

    context "with invalid params" do
      it "does not create a new Participant" do
        expect do
          post participants_path, { participant: invalid_attributes }, valid_session
        end.not_to change(Participant, :count)
        expect(response).to have_http_status(422)
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) do
        attributes_for(:participant)
      end

      it "updates the requested participant" do
        participant = Participant.create! valid_attributes
        expect do
          put participant_path(participant.to_param), { participant: new_attributes }, valid_session
          participant.reload
        end.to change { participant.name }
      end

      it "redirects to the participant" do
        participant = Participant.create! valid_attributes
        put participant_path(participant.to_param), { participant: valid_attributes }, valid_session
        expect(response).to redirect_to(participant)
      end
    end

    context "with invalid params" do
      it "assigns the participant as @participant" do
        participant = Participant.create! valid_attributes
        put participant_path(participant.to_param), { participant: invalid_attributes }, valid_session
        expect(assigns(:participant)).to eq(participant)
      end

      it "re-renders the 'edit' template" do
        participant = Participant.create! valid_attributes
        put participant_path(participant.to_param), { participant: invalid_attributes }, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested participant" do
      participant = Participant.create! valid_attributes
      expect do
        delete participant_path(participant.to_param), valid_session
      end.to change(Participant, :count).by(-1)
    end

    it "redirects to the participants list" do
      participant = Participant.create! valid_attributes
      delete participant_path(participant.to_param), { id: participant.to_param }, valid_session
      expect(response).to redirect_to(participants_url)
    end
  end
end
