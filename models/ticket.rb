# frozen_string_literal: true

class Ticket < ApplicationRecord
  belongs_to :manager
  belongs_to :project
  belongs_to :engineer, optional: true

  has_many :patches, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :name, presence: true

  enum status: { in_review: 'in review', solved: 'solved', working: 'in Progress' }

  before_create :set_initial_status

  private

  def set_initial_status
    self.status ||= :in_review
  end
end
