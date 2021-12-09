# frozen_string_literal: true

using SmartCore::Ext::BasicObjectAsObject

# @api public
# @since 0.1.0
# @version 0.3.0
SmartCore::Types::Value.define_type(:Numeric) do |type|
  type.define_checker do |value|
    value.is_a?(::Numeric)
  end

  type.define_caster do |value|
    next value if value.is_a?(::Numeric)

    begin
      SmartCore::Types::Value::Float.cast(value)
    rescue SmartCore::Types::TypeCastingError
      begin
        SmartCore::Types::Value::Integer.cast(value)
      rescue SmartCore::Types::TypeCastingError
        begin
          SmartCore::Types::Value::BigDecimal.cast(value)
        rescue SmartCore::Types::TypeCastingError
          raise(SmartCore::Types::TypeCastingError, "#{value.inspect} non-castable to Numeric")
        end
      end
    end
  end
end
