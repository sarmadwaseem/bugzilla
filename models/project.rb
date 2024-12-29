# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :admin

  has_many :tickets, dependent: :destroy
  has_many :project_managers, dependent: :destroy
  has_many :managers, through: :project_managers
  has_many :project_engineers, dependent: :destroy
  has_many :engineers, through: :project_engineers

  accepts_nested_attributes_for :project_managers
  accepts_nested_attributes_for :project_engineers

  validates :name, presence: true
  validates :description, presence: true

  def self.search_by_name(search_term)
    where('name LIKE ?', "%#{search_term}%")
  end
end
