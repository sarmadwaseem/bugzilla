# frozen_string_literal: true

class DashboardController < ApplicationController
  def index; end

  def all_managers
    @managers = Manager.all
  end
end
