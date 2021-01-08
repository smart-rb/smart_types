# frozen_string_literal: true

require 'date'

using SmartCore::Ext::BasicObjectAsObject

# @api public
# @since 0.1.0
# @version 0.5.0
SmartCore::Types::Value.define_type(:Date) do |type|
  type.define_checker do |value|
    value.is_a?(::Date) || value == ::Date::Infinity
  end

  type.define_caster do |value|
    next value if value.is_a?(::Date) || value == ::Date::Infinity

    begin
      ::Date.parse(value)
    rescue ::ArgumentError, ::TypeError
      raise(SmartCore::Types::TypeCastingError, 'Non-castable to Date')
    end
  end
end
