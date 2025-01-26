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

  scope :done, -> { where(is_done: true) }
  scope :not_done, -> { where(is_done: false) }
  scope :search_by_title, ->(q) {
    where("tasks.title ILIKE ?", "%#{q}%") if q.present?
  }
  scope :with_tags, ->(tag_ids) {
    joins(:task_taggings)
      .where(task_taggings: { tag_id: tag_ids })
      .group('tasks.id')
      .having('COUNT(task_taggings.tag_id) = ?', tag_ids.size) if tag_ids.present?
  }
end