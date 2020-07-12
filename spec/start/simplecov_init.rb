require 'simplecov'
SimpleCov.start 'rails' do
  add_filter '/test/'
  add_filter '/config/'
  add_filter '/vendor/'
  add_filter '/spec/'

  # This have default files i have no idea for now how to test and why
  add_filter '/app/channels'
  add_filter '/app/jobs'
  add_filter '/app/mailers'

  # This directory has almost not changed devise controllers
  add_filter '/app/controllers/users/'

  # Thid directory have policies which tested in integration tests.
  add_filter '/app/policies'
end