# spec/system/admin/users_spec.rb
require 'rails_helper'

RSpec.describe "Admin::UsersController", type: :system do
# let!(:admin_user) { create(:user, email: "admin@example.com", name: "admin", yob: 1989, password: 12345, confirm_password: 12345,  role: 1) }
let!(:admin_user) { create(:user, role: :admin, password: "password123", email: "admin@example.com", status: :approved) }

before do
    sign_in admin_user
end

  describe "Invite a new trader" do
    it "successfully invites a new trader" do
      visit root_path

      click_link "Go to admin dashboard"

      expect(page).to have_current_path(admin_dashboard_path)

      click_button "Add new trader"

      expect(page).to have_current_path(new_admin_user_path)
      # visit new_admin_user_path
      fill_in "Email", with: "newtrader@example.com"
      fill_in "Name", with: "New Trader"
      click_button "Invite Trader"
            
      expect(page).to have_content("Trader was successfully invited.")
      end

    # it "Approve the invited user/trader" do
    #     visit admin_dashboard_path

    #     expect(page).to have_content("Pending user.")

    #     click_button "Activate"
    # end
  end
end
