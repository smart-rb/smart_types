# frozen_string_literal: true

# @api public
# @since 0.1.0
SmartCore::Types::Value::Text = SmartCore::Types::System.type_sum(
  SmartCore::Types::Value::String,
  SmartCore::Types::Value::Symbol
) do |type|
  type.define_caster do |value|
    next value if SmartCore::Types::Value::String.valid?(value)
    next value if SmartCore::Types::Value::Symbol.valid?(value)

    begin
      SmartCore::Types::Value::String.cast(value)
    rescue SmartCore::Types::TypeCastingError
      begin
        SmartCore::Types::Value::Symbol.cast(value)
      rescue SmartCore::Types::TypeCastingError
        raise(SmartCore::Types::TypeCastingError, 'Non-castable to text')
      end
    end
  end
end
