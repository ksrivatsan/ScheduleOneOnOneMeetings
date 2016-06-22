require "rails_helper"

RSpec.describe Participant, type: :model do
  it "has a valid factory" do
    # Using the shortened version of FactoryGirl syntax.
    # Add:  "config.include FactoryGirl::Syntax::Methods" (no quotes) to your spec_helper.rb
    expect(build(:participant)).to be_valid
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
end
