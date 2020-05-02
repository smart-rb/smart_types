# frozen_string_literal: true

SmartCore::Types::Value.define_type(:Nil) do |type|
  type.define_checker do |value|
    # rubocop:disable Style/NilComparison
    value == nil # NOTE: #nil? is not used cuz BasicObject hasn't #nil? method
    # rubocop:enable Style/NilComparison
  end
end
