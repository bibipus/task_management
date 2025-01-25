# frozen_string_literal: true

class Tag < ApplicationRecord
  belongs_to :user

  has_many :task_taggings, dependent: :destroy
  has_many :tasks, through: :task_taggings

  validates :title, presence: true
end