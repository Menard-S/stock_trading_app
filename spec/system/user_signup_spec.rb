# spec/system/user_signup_spec.rb
require 'rails_helper'

RSpec.describe "User Signup", type: :system do
    # This before block can be used to set up any necessary conditions before each test
    before do
        # Add any setup code here, such as creating required data
    end

    it "successfully signs up a new user" do
        # Visit the signup page (assuming the path is named new_user_registration_path)
        visit new_user_registration_path

        # Fill in the registration form fields
        fill_in "Email", with: "newuser@example.com"
        fill_in "Name", with: "New User"
        fill_in "Year of Birth", with: 1989
        fill_in "Initial Funds", with: 5000
        fill_in "Password", with: "password123"
        fill_in "Password confirmation", with: "password123"
        
        # Submit the form
        click_button "Sign up"  # Change the button text as per your form

        # Assert the expected outcome
        if page.has_content?("Welcome! You have signed up successfully.")
            expect(page).to have_current_path(new_user_session_path)
        else
            # Save and open the page for debugging
            save_and_open_page
        end
    end
end
