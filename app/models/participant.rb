class Participant < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 2 }

  def self.find_meeting(all_scheduled_meetings, remaining_participants, current_weeks_meeting)
    first_set_of_participants = remaining_participants[0]
    unless first_set_of_participants.count.zero?
      current_weeks_meeting << first_set_of_participants 
    end
    new_remaining_participants = (remaining_participants - [first_set_of_participants]).select{|k| (k & first_set_of_participants).blank?}
    if !new_remaining_participants.empty?
      result = find_meeting(all_scheduled_meetings << first_set_of_participants, new_remaining_participants, current_weeks_meeting)
      unless result.count.zero?
        current_weeks_meeting = result
      end
    end
    return current_weeks_meeting
  end

  def self.schedule_one_to_one
    participant_names =  Participant.pluck(:name)
    participant_names =  participant_names.combination(2).to_a
    copy_of_participant_names = participant_names
    all_weeks_schedule = []
    remaining_array = []
    while ( !copy_of_participant_names.empty? )
      current_weeks_meeting = []
      meeting_participants = find_meeting(all_weeks_schedule.flatten(1), copy_of_participant_names, current_weeks_meeting)
      all_weeks_schedule << meeting_participants
      copy_of_participant_names = copy_of_participant_names - meeting_participants
    end
    return all_weeks_schedule
  end
end

