require 'rails_helper'

RSpec.describe "Admin::UsersController", type: :system do
# let!(:admin_user) { create(:user, email: "admin@example.com", name: "admin", yob: 1989, password: 12345, confirm_password: 12345,  role: 1) }
let!(:admin_user) { create(:user, role: :admin, password: "password123", email: "admin@example.com", status: :approved) }

before do
    sign_in admin_user
end

  describe "Viewing user details" do
    let!(:trader) { create(:user, name: "Trader", role: 0) }

    it "displays the user's transactions" do
      visit admin_user_path(trader)
      expect(page).to have_content("User Details")
    end
  end
end
