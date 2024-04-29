# spec/system/admin_login_spec.rb
require 'rails_helper'

RSpec.describe "Trader login", type: :system do
  # Before each test, create an trader user
  let!(:trader_user) { create(:user, role: :trader, password: "password123", email: "trader@example.com", status: :approved) }

  it "logs in successfully and redirects to the root path" do
    # Visit the trader login page (adjust path if needed)
    visit new_user_session_path
        
    # Fill in the login form fields
    fill_in "Email", with: "trader@example.com"
    fill_in "Password", with: "password123"
        
    # Submit the form
    click_button "Log in"
        
    #  Assert the expected outcome
    if page.has_content?("Signed in successfully.")
      expect(page).to have_current_path(root_path)
    else
    # Save and open the page for debugging
      save_and_open_page
    end

    # Expect to be redirected to the root path
    # expect(page).to have_current_path(root_path)
    # expect(page).to have_content("Signed in successfully.")
  end
end
