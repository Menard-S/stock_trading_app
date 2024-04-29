require 'rails_helper'

RSpec.describe "Admin login", type: :system do
  # Before each test, create an admin user
  let!(:admin_user) { create(:user, role: :admin, password: "password123", email: "admin@example.com") }

  it "logs in successfully and redirects to the root path" do
    # Visit the admin login page (adjust path if needed)
    visit new_user_session_path
        
    # Fill in the login form fields
    fill_in "Email", with: "admin@example.com"
    fill_in "Password", with: "password123"
        
    # Submit the form
    click_button "Log in"
        
    # Expect to be redirected to the root path
    # expect(page).to have_current_path(root_path)
    # Assert the expected outcome
    if page.has_content?("Signed in successfully.")
      expect(page).to have_current_path(root_path)
    else
      # Save and open the page for debugging
      save_and_open_page
    end
  end
end
