# frozen_string_literal: true

require 'time'

using SmartCore::Ext::BasicObjectAsObject

# @api public
# @since 0.1.0
# @version 0.3.0
SmartCore::Types::Value.define_type(:Time) do |type|
  type.define_checker do |value|
    value.is_a?(::Time)
  end

  type.define_caster do |value|
    next value if value.is_a?(::Time)

    begin
      SmartCore::Types::Value::Integer.valid?(value) ? ::Time.at(value) : ::Time.parse(value)
    rescue ::TypeError, ::ArgumentError
      raise(SmartCore::Types::TypeCastingError, 'Non-castable to Time')
    end
  end
end
