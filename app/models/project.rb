# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :title, presence: true
  validates :position, presence: true, uniqueness: { scope: :user_id }

  scope :search_by_title, ->(query) { where('title ILIKE ?', "%#{sanitize_sql_like(query)}%") if query.present? }

  def self.update_positions(projects_order)
    transaction do
      temp_positions = projects_order.map.with_index(1_000_000) do |id, temp|
        [id, temp]
      end

      temp_positions.each { |id, temp| find_by(id: id)&.update_columns(position: temp) }

      projects_order.each_with_index do |id, index|
        find_by(id: id)&.update_columns(position: index + 1)
      end
    end
  end
end