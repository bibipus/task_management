# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :title, presence: true
  validates :position, presence: true

  scope :search_by_title, lambda { |query|
    where('title ILIKE ?', "%#{query}%") if query.present?
  }
end