# frozen_string_literal: true

class ProjectEngineer < ApplicationRecord
  self.table_name = 'projects_engineers'

  belongs_to :engineer
  belongs_to :project
end
