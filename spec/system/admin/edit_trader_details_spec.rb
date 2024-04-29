
require 'rails_helper'

RSpec.describe "Admin::UsersController", type: :system do
# let!(:admin_user) { create(:user, email: "admin@example.com", name: "admin", yob: 1989, password: 12345, confirm_password: 12345,  role: 1) }
let!(:admin_user) { create(:user, role: :admin, password: "password123", email: "admin@example.com", status: :approved) }

before do
    sign_in admin_user
end

  describe "Editing a trader" do
    let!(:trader) { create(:user, email: "newtrader@example.com", name: "New Trader", yob: 1898, role: 0) }

    it "successfully updates a trader's name" do
      visit edit_admin_user_path(trader)
      fill_in "Name", with: "Updated Trader"
      click_button "Update User"
            
      expect(page).to have_content("Trader was successfully updated.")
      expect(trader.reload.name).to eq("Updated Trader")
    end
  end
end
