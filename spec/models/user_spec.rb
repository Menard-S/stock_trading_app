require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  # context 'scope tests' do
  #   before(:each) do
  #     User.create(name: 'MJ', email: 'example1@example.com', yob: 1989, asset: 5000, password: 'password123')
  #   end
  #   it'user count is 1' do
  #     expect(User.count).to eq(1)
  #   end
  # end

  # Test validations
  describe 'validations' do
    it 'validates presence of email' do
      user = User.new(name: 'Test User', yob: 1990)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    # it 'validates presence of name' do
    #   user = User.new(email: 'test@example.com', yob: 1990)
    #   expect(user).not_to be_valid
    #   expect(user.errors[:name]).to include("can't be blank")
    # end

    it 'validates presence of yob' do
      user = User.new(email: 'test@example.com', name: 'Test User')
      expect(user).not_to be_valid
      expect(user.errors[:yob]).to include("can't be blank")
    end

    it 'validates yob is an integer' do
      user = User.new(email: 'test@example.com', name: 'Test User', yob: 'nineteen ninety')
      expect(user).not_to be_valid
      expect(user.errors[:yob]).to include("is not a number")
    end

    it 'validates user is at least 18 years old' do
      user = User.new(email: 'test@example.com', name: 'Test User', yob: Date.today.year - 17)
      expect(user).not_to be_valid
      expect(user.errors[:yob]).to include('You must be at least 18 years old to sign up.')
    end
  end

  # Test custom methods
  # describe '#deactivate!' do
  #   let(:user) { create(:user, status: :approved) }

  #   it 'deactivates the user by updating the status to rejected' do
  #     user.deactivate!
  #     expect(user.status).to eq('rejected')
  #   end
  # end

  # describe '#active_for_authentication?' do
  #   let(:approved_user) { create(:user, status: :approved) }
  #   let(:pending_user) { create(:user, status: :pending) }

  #   it 'returns true if the user is approved' do
  #     expect(approved_user.active_for_authentication?).to be_truthy
  #   end

  #   it 'returns false if the user is not approved' do
  #     expect(pending_user.active_for_authentication?).to be_falsey
  #   end
  # end

  # describe 'after_create_commit callback' do
  #   context 'when user is invited' do
  #     it 'sends new user invitation notice to admin' do
  #       invited_user = create(:user, invited_by_admin: true)
  #       expect(AdminMailer).to receive(:new_user_invitation_notice).with(invited_user)
  #       invited_user.run_callbacks(:commit)
  #     end
  #   end

  #   context 'when user is not invited' do
  #     it 'sends admin mail and pending approval email' do
  #       user = create(:user, invited_by_admin: false)
  #       expect(user).to receive(:send_admin_mail)
  #       expect(user).to receive(:send_pending_approval_email)
  #       user.run_callbacks(:commit)
  #     end
  #   end
  # end
end
