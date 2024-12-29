# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'BUGZILLA'
  layout 'mailer'
end
