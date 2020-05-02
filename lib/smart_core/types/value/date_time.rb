# frozen_string_literal: true

require 'date'

# @api public
# @since 0.1.0
SmartCore::Types::Value.define_type(:DateTime) do |type|
  type.define_checker do |value|
    value.is_a?(::DateTime)
  end

  type.define_caster do |value|
    begin
      ::DateTime.parse(value)
    rescue ::Date::Error, ::TypeError
      raise(SmartCore::Types::TypeCastingError, 'Invalid date')
    end
  end
end
