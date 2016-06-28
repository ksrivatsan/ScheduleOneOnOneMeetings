class ParticipantsController < ApplicationController
  before_action :set_participant, only: [:show, :edit, :update, :destroy]

  # GET /participants
  def index
    @participants = Participant.all
  end

  # GET /participants/1
  def show
  end

  # GET /participants/new
  def new
    @participant = Participant.new
  end

  # GET /participants/1/edit
  def edit
  end

  # POST /participants
  def create
    @participant = Participant.new(participant_params)

    if @participant.save
      redirect_to @participant, notice: "Participant was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /participants/1
  def update
    if @participant.update(participant_params)
      redirect_to @participant, notice: "Participant was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /participants/1
  def destroy
    @participant.destroy
    redirect_to participants_url, notice: "Participant was successfully destroyed."
  end

  def scheduled_meeting
    # @participants = Participant.all
    @meetings = Participant.schedule_one_to_one
  end

  def add_more
    participants_array = []
    params[:names].split(",").each do |participant_name|
      if Participant.where(name:participant_name)
        participants_array << participant_name
      else
        participant = Participant.create(name:participant_name)
      end
    end
    @flash_message = participants_array.empty? ? "Congrats! Participant have been added to the schedule." : "Participants #{participants_array.join(" ")} are already present in the system!"
    redirect_to scheduled_meeting_participants_url, notice: @flash_message
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_participant
    @participant = Participant.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def participant_params
    params.require(:participant).permit(:name)
  end
end
