# frozen_string_literal: true

class User < ApplicationRecord
  has_many :user_parties, dependent: :restrict_with_error
  has_many :viewing_parties, through: :user_parties
end