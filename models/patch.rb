# frozen_string_literal: true

class Patch < ApplicationRecord
  belongs_to :ticket
  belongs_to :engineer

  has_one_attached :patch_file

  validates :name, presence: true
  validates :comment, presence: true
  validates :ticket_id, presence: true

  enum status: { in_review: 'in review', approved: 'approved', rejected: 'rejected' }

  before_create :set_initial_status

  private

  def set_initial_status
    self.status ||= :in_review
  end
end
