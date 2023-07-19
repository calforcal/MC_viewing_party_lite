require "rails_helper"

RSpec.describe "Login Page" do
  let!(:user1) { User.create!(name: 'Michael', email: 'mcalla123@gmail.com', password: "test123", password_confirmation: "test123") }

  describe 'happy paths' do
    it 'has a form to login' do
      visit login_path

      expect(page).to have_field(:email)
      expect(page).to have_field(:password)
    end

    it 'takes a user to their dashboard if credentials are correct' do
      visit login_path

      fill_in :email, with: user1.email 
      fill_in :password, with: user1.password
      click_button "Log In"

      expect(current_path).to eq(dashboard_path(user1))
    end
  end

  describe 'sad paths' do
    it 'displays a wrong credentials error if information is incorrect' do
      visit login_path

      fill_in :email, with: user1.email
      fill_in :password, with: "WRONG"
      click_button "Log In"

      expect(current_path).to eq(login_path)
      expect(page).to have_content("Error: Credentials are incorrect")
    end
  end
end