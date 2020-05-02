# frozen_string_literal: true

require 'date'

# @api public
# @since 0.1.0
SmartCore::Types::Value.define_type(:Date) do |type|
  type.define_checker do |value|
    value.is_a?(::Date)
  end

  type.define_caster do |value|
    begin
      ::Date.parse(value)
    rescue ::Date::Error, ::TypeError
      raise(SmartCore::Types::TypeCastingError, 'Non-castable to Date')
    end
  end
end
