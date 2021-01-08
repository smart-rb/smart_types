# frozen_string_literal: true

require 'simplecov'
require 'simplecov-lcov'

SimpleCov::Formatter::LcovFormatter.config do |config|
  config.report_with_single_file = true
  config.output_directory = 'coverage'
  config.lcov_file_name = 'lcov.info'
end

SimpleCov.configure do
  enable_coverage :line
  enable_coverage :branch

  minimum_coverage 95

  formatter SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::LcovFormatter
  ])

  add_group 'Engine', '/lib/smart_core/types/primitive'
  add_group 'Type Definitions', %w[
    /lib/smart_core/types/protocol
    /lib/smart_core/types/struct
    /lib/smart_core/types/value
    /lib/smart_core/types/variadic
  ]

  add_filter '/spec/'
end
