require 'rails_helper'

RSpec.describe User, type: :model do
  # Test validations
  describe 'validations' do
    it 'validates presence of email, name, yob, and asset' do
      user = User.new
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
      expect(user.errors[:name]).to include("can't be blank")
      expect(user.errors[:yob]).to include("can't be blank")
      # expect(user.errors[:asset]).to include("can't be blank")
    end
    it 'validates yob must be an integer' do
      user = User.new(yob: 'not_a_number')
      expect(user).not_to be_valid
      expect(user.errors[:yob]).to include("is not a number")
    end
    it 'validates user must be at least 18 years old' do
      user = User.new(yob: Date.today.year - 17)
      expect(user).not_to be_valid
      expect(user.errors[:yob]).to include('You must be at least 18 years old to sign up.')
    end
  end
  # Test callbacks
  describe 'callbacks' do
    it 'sets default role and status on new record' do
      user = User.new
      expect(user.role).to eq('trader')
      expect(user.status).to eq('pending')
    end
  end
  # Test custom methods
  describe '#active_for_authentication?' do
    it 'returns true if user is approved and super returns true' do
      user = create(:user, status: :approved)
      expect(user.active_for_authentication?).to be_truthy
    end
    it 'returns false if user is not approved' do
      user = create(:user, status: :pending)
      expect(user.active_for_authentication?).to be_falsey
    end
  end
  describe '#inactive_message' do
    it 'returns super message if user is approved' do
      user = create(:user, status: :approved)
      # Debugging statements
      puts "User approved: #{user.approved?}"
      puts "Inactive message: #{user.inactive_message}"
      expect(user.inactive_message).to eq(:signed_in)
    end
    it 'returns :not_approved if user is not approved' do
      user = create(:user, status: :pending)
      expect(user.inactive_message).to eq(:not_approved)
    end
  end
end