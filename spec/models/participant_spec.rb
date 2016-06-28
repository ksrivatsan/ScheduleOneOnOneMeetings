require "rails_helper"
require 'pry'

RSpec.describe Participant, type: :model do
  it "has a valid factory" do
    # Using the shortened version of FactoryGirl syntax.
    # Add:  "config.include FactoryGirl::Syntax::Methods" (no quotes) to your spec_helper.rb
    expect(build(:participant)).to be_valid
    expect(build(:participant, name: 'a')).to_not be_valid
  end

  # Lazily loaded to ensure it's only used when it's needed
  # RSpec tip: Try to avoid @instance_variables if possible. They're slow.
  let(:participant) { build(:participant) }

  describe "ActiveModel validations" do
    # http://guides.rubyonrails.org/active_record_validations.html
    # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/frames
    # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/Shoulda/Matchers/ActiveModel

    # Basic validations
    it { expect(participant).to validate_presence_of(:name) }


    # Format validations
    it { expect(participant).to allow_value("JSON Vorhees").for(:name) }
  end

  describe "ActiveRecord associations" do
    # http://guides.rubyonrails.org/association_basics.html
    # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/frames
    # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/Shoulda/Matchers/ActiveRecord

    # Database columns/indexes
    # http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/Shoulda/Matchers/ActiveRecord/HaveDbColumnMatcher
    it { expect(participant).to have_db_column(:name).of_type(:string).with_options(null: false) }
  end

  describe "Should validate meetings" do
    before(:all) do
      Participant.create(name:"Trevor")
      Participant.create(name:"Joe")
      Participant.create(name:"Gillman")
      Participant.create(name:"Peter")
      Participant.create(name:"Smith")
    end

    it "Should check if a person has just only one meeting scheduled per week" do
      p "Should check if a person has just only one meeting scheduled per week"
      actual_output = Participant.schedule_one_to_one
      no_of_participants = Participant.count
      count_presence_of_participant = 0
      actual_output.each do |week|
        count = week.flatten.count("Trevor")
        expect(count).to be_between(0, 1).inclusive
      end
    end

    it "Should have one meeting less than total number of participants" do
      p "Should have one meeting less than total number of participants"
      actual_output = Participant.schedule_one_to_one
      no_of_participants = Participant.count-1
      participant_count = actual_output.flatten(2).count("Trevor")
      expect(participant_count).to eq(no_of_participants)
    end
    
    it "Should find correct meeting for week one" do
      p "Should find correct meeting for week one"
      all_scheduled_meetings = []
      remaining_participants =[
                                ["Trevor", "Joe"],
                                ["Trevor", " Gillman"],
                                ["Trevor", "Peter"],
                                ["Trevor", "Smith"],
                                ["Joe", " Gillman"],
                                ["Joe", "Peter"],
                                ["Joe", "Smith"],
                                [" Gillman", "Peter"],
                                [" Gillman", "Smith"],
                                ["Peter", "Smith"]
                              ]
      current_weeks_meeting = []
      expected_output = [["Trevor", "Joe"], [" Gillman", "Peter"]]
      actual_output = Participant.find_meeting(all_scheduled_meetings, remaining_participants, current_weeks_meeting)
      expect((actual_output - expected_output).blank?).to eq(true)
    end

    it "Should schedule 1 on 1 meeting with everyone" do
      p "Should schedule 1 on 1 meeting with everyone"
      expected_output = [
                          [["Trevor", "Joe"], ["Gillman", "Peter"]],
                          [["Trevor", "Gillman"], ["Joe", "Peter"]],
                          [["Trevor", "Peter"], ["Joe", "Gillman"]],
                          [["Trevor", "Smith"]],
                          [["Joe", "Smith"]],
                          [["Gillman", "Smith"]],
                          [["Peter", "Smith"]]
                        ]
      actual_output = Participant.schedule_one_to_one
      result = (actual_output-expected_output).blank?
      expect(result).to eq(true)
    end

    it "Should check total number of meetings" do
      p "Should check total number of meetings"
      expected_output = [
                          [["Trevor", "Joe"], [" Gillman", "Peter"]],
                          [["Trevor", " Gillman"], ["Joe", "Peter"]],
                          [["Trevor", "Peter"], ["Joe", " Gillman"]],
                          [["Trevor", "Smith"]],
                          [["Joe", "Smith"]],
                          [[" Gillman", "Smith"]],
                          [["Peter", "Smith"]]
                      ]
      actual_output = Participant.schedule_one_to_one
      actual_output_length = actual_output.flatten(1).count
      expected_output_length = expected_output.flatten(1).count

      expect(expected_output_length.equal?(actual_output_length)).to eq(true)
    end
  end
end
