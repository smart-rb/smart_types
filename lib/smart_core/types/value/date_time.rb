# frozen_string_literal: true

require 'date'

SmartCore::Types::Value.define_type(:DateTime) do |type|
  type.define_checker do |value|
    value.is_a?(::DateTime)
  end

  type.define_caster do |value|
    ::DateTime.parse(value)
  end
end
