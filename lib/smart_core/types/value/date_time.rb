# frozen_string_literal: true

require 'date'

using SmartCore::Ext::BasicObjectAsObject

# @api public
# @since 0.1.0
# @version 0.3.0
SmartCore::Types::Value.define_type(:DateTime) do |type|
  type.define_checker do |value|
    value.is_a?(::DateTime) || value == ::DateTime::Infinity
  end

  type.define_caster do |value|
    next value if value.is_a?(::DateTime) || value == ::DateTime::Infinity

    begin
      ::DateTime.parse(value)
    rescue ::Date::Error, ::TypeError
      raise(SmartCore::Types::TypeCastingError, 'Non-castable to DateTime')
    end
  end
end
