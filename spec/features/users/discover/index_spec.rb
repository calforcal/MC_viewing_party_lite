# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/users/:id/discover', type: :feature do
  describe 'discover page' do
    let!(:user1) { User.create!(name: 'Michael', email: 'mcalla123@gmail.com', password: "test123", password_confirmation: "test123") }
    let!(:user2) { User.create!(name: 'Garrett', email: 'garrett123@gmail.com', password: "test123", password_confirmation: "test123") }

    before(:each) do
      visit discover_index_path
    end

    it 'has a button to discover top rated movies', :vcr do
      within '.top-movies' do
        click_button('Find Top Rated Movies')
        expect(current_path).to eq(movies_path)
      end
    end

    it 'has a text field to enter keyworkd(s) to search by movie title' do
      within '.search-movies' do
        fill_in('Search:', with: 'Fight Club')
      end
    end

    it 'has a button to search by movie title', :vcr do
      within '.search-movies' do
        fill_in('Search:', with: 'Fight Club')
        click_button('Find Movies')
        expect(current_path).to eq(movies_path)
      end
    end
  end
end
