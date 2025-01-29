# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user
  belongs_to :project, optional: true

  has_many :task_taggings, dependent: :destroy
  has_many :tags, through: :task_taggings

  validates :title, presence: true
  validates :description, presence: true
  validates :is_done, inclusion: { in: [true, false] }
  validate :validate_attachment

  has_one_attached :attachment

  scope :done, -> { where(is_done: true) }
  scope :not_done, -> { where(is_done: false) }
  scope :search_by_title, ->(q) { where('tasks.title ILIKE ?', "%#{sanitize_sql_like(q)}%") if q.present? }
  scope :with_tags, lambda { |tag_ids|
    return Task.none if tag_ids.blank?

    joins(:task_taggings)
      .where(task_taggings: { tag_id: tag_ids })
      .group('tasks.id')
      .having('COUNT(task_taggings.tag_id) = ?', tag_ids.size)
  }

  private

  def validate_attachment
    return unless attachment.attached? && attachment.blob.present?

    if attachment.blob.byte_size > 1.megabyte
      errors.add(:attachment, I18n.t('activerecord.errors.messages.file_too_large', size: '1MB'))
    end

    allowed_types = %w[
      image/jpeg image/png image/gif image/webp
      application/pdf text/plain
      application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
      video/mp4 video/mpeg video/quicktime
    ]
    return if allowed_types.include?(attachment.blob.content_type)

    errors.add(:attachment, I18n.t('activerecord.errors.messages.file_type_invalid'))
  end
end