# frozen_string_literal: true

class Manager < ApplicationRecord
  include Discard::Model

  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :invited_by, class_name: 'Admin', optional: true

  has_many :tickets, dependent: :destroy
  has_many :project_managers, dependent: :destroy
  has_many :projects, through: :project_managers
  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :project_managers

  validates :name, presence: true
  validates :email, presence: true

  def active_for_authentication?
    super && !discarded?
  end

  scope :active_managers, -> { where(active: true) }
  scope :inactive_managers, -> { where(active: false) }
end
