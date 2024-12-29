# frozen_string_literal: true

class PatchMailer < ApplicationMailer
  def reviewd_by_manager(engineer, patch)
    @engineer = engineer
    @patch = patch
    mail(to: @engineer.email, subject: 'Your patch has been reviewd by Manager')
  end
end
