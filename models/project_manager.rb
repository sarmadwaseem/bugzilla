# frozen_string_literal: true

class ProjectManager < ApplicationRecord
  self.table_name = 'projects_managers'

  belongs_to :manager
  belongs_to :project
end
