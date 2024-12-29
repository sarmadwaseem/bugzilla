# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :engineer, optional: true
  belongs_to :manager, optional: true
  belongs_to :ticket

  def creator_name
    if engineer
      engineer.name
    elsif manager
      manager.name
    else
      'Unknown'
    end
  end
end
