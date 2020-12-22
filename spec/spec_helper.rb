# frozen_string_literal: true

require_relative './setup_simplecov'

SimpleCov.start

require 'bundler/setup'
require 'pry'
require 'smart_core/types'

RSpec.configure do |config|
  Kernel.srand config.seed
  config.disable_monkey_patching!
  config.filter_run_when_matching :focus
  config.order = :random
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.expect_with(:rspec) { |c| c.syntax = :expect }
  Thread.abort_on_exception = true
end
