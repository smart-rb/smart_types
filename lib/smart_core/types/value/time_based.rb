# frozen_string_literal: true

using SmartCore::Ext::BasicObjectAsObject

# @api public
# @since 0.1.0
# @version 0.3.0
SmartCore::Types::Value.define_type(:TimeBased) do |type|
  type.define_checker do |value|
    SmartCore::Types::Value::Time.valid?(value) ||
      SmartCore::Types::Value::DateTime.valid?(value) ||
      SmartCore::Types::Value::Date.valid?(value)
  end

  type.define_caster do |value|
    next value if SmartCore::Types::Value::Time.valid?(value)
    next value if SmartCore::Types::Value::DateTime.valid?(value)
    next value if SmartCore::Types::Value::Date.valid?(value)

    begin
      SmartCore::Types::Value::Time.cast(value)
    rescue SmartCore::Types::TypeCastingError
      begin
        SmartCore::Types::Value::DateTime.cast(value)
      rescue SmartCore::Types::TypeCastingError
        begin
          SmartCore::Types::Value::Date.cast(value)
        rescue SmartCore::Types::TypeCastingError
          raise(
            SmartCore::Types::TypeCastingError,
            "#{value.inspect} non-castable to time-based type"
          )
        end
      end
    end
  end
end
