# frozen_string_literal: true

# Engineer_Model
class Engineer < ApplicationRecord
  include Discard::Model
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :invited_by, class_name: 'Admin', optional: true

  has_many :tickets, dependent: :destroy
  has_many :project_engineers, dependent: :destroy
  has_many :projects, through: :project_engineers
  has_many :patches, dependent: :destroy
  has_many :comments, dependent: :destroy

  def active_for_authentication?
    super && !discarded?
  end

  scope :active_engineers, -> { where(active: true) }
  scope :inactive_engineers, -> { where(active: false) }
end
