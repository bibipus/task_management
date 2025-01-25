# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user
  belongs_to :project, optional: true

  has_many :task_taggings, dependent: :destroy
  has_many :tags, through: :task_taggings

  validates :title, presence: true
  validates :description, presence: true
  validates :is_done, inclusion: { in: [true, false] }

  has_one_attached :attachment
end