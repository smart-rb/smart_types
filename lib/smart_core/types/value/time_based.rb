# frozen_string_literal: true

# @api public
# @since 0.1.0
SmartCore::Types::Value::TimeBased = SmartCore::Types::System.type_sum(
  SmartCore::Types::Value::Time,
  SmartCore::Types::Value::DateTime,
  SmartCore::Types::Value::Date
) do |type|
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
          raise(SmartCore::Types::TypeCastingError, 'Non-castable to time-based type')
        end
      end
    end
  end
end
