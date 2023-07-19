# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/register', type: :feature do
  describe 'registration page' do
    let!(:user1) { User.create!(name: 'Michael', email: 'mcalla123@gmail.com', password: "test123", password_confirmation: "test123") }
    let!(:user2) { User.create!(name: 'Garrett', email: 'garrett123@gmail.com', password: "test123", password_confirmation: "test123") }
    password = "test"
    password_confirmation = "test"

    before(:each) do
      visit register_path
    end

    context 'happy path' do
      it 'registers a new user with unique email and name' do
        fill_in('Name:', with: 'Shannon')
        fill_in('Email:', with: 'shannon123@gmail.com')
        fill_in :user_password, with: password
        fill_in :user_password_confirmation, with: password_confirmation
        click_button 'Create New User'

        expect(current_path).to eq(dashboard_path(User.last))
      end

      it 'registers a new user with unique email but duplicate name' do
        User.create!(name: 'Shannon', email: 'shannon123@gmail.com', password: "test123", password_confirmation: "test123")
        fill_in('Name:', with: 'Shannon')
        fill_in('Email:', with: 'shannon345@gmail.com')
        fill_in :user_password, with: password
        fill_in :user_password_confirmation, with: password_confirmation
        click_button 'Create New User'

        expect(current_path).to eq(dashboard_path(User.last))
      end
    end

    context 'sad path' do
      it 'will display an error if email is not unique' do
        fill_in('Name:', with: 'Michael')
        fill_in('Email:', with: 'mcalla123@gmail.com')
        fill_in :user_password, with: password
        fill_in :user_password_confirmation, with: password_confirmation
        click_button 'Create New User'

        expect(page).to have_content(User.last.errors.full_messages.to_sentence.to_s)

        expect(current_path).to eq('/register')
      end

      it 'will display an error if all fields are not filled out' do
        fill_in('Email:', with: 'bustarhymes@gmail.com')
        click_button 'Create New User'

        expect(page).to have_content(User.last.errors.full_messages.to_sentence.to_s)
        expect(current_path).to eq('/register')

        fill_in('Name:', with: 'Busta Rhymes')
        fill_in :user_password, with: password
        fill_in :user_password_confirmation, with: password_confirmation
        click_button 'Create New User'

        expect(page).to have_content(User.last.errors.full_messages.to_sentence.to_s)
        expect(current_path).to eq('/register')
      end

      it 'will generate an error if passwords dont match' do
        fill_in('Name:', with: 'Michael')
        fill_in('Email:', with: 'michaelbichael@gmail.com')
        fill_in :user_password, with: password
        fill_in :user_password_confirmation, with: 'WRONG'
        click_button 'Create New User'

        expect(current_path).to eq(register_path)
        expect(page).to have_content("Error: Passwords don't match")
      end

      it 'will generate an error if passwords are not sent' do
        fill_in('Name:', with: 'Michael')
        fill_in('Email:', with: 'michaelbichael@gmail.com')
        fill_in :user_password, with: ""
        fill_in :user_password_confirmation, with: ""
        click_button 'Create New User'

        expect(current_path).to eq(register_path)
        expect(page).to have_content("Error: Password can't be blank")
      end
    end
  end
end
