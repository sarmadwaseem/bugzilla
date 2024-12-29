# frozen_string_literal: true

class Admin < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseInvitable::Inviter

  has_many :managers, foreign_key: 'invited_by_id', dependent: :destroy, inverse_of: :invited_by
  has_many :engineers, foreign_key: 'invited_by_id', dependent: :destroy, inverse_of: :invited_by
  has_many :projects, dependent: :destroy

  validates :email, presence: true, uniqueness: true
end
