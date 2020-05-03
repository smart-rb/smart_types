# frozen_string_literal: true

# @api public
# @since 0.1.0
SmartCore::Types::Value.define_type(:Numeric) do |type|
  type.define_checker do |value|
    value.is_a?(::Numeric)
  end

  type.define_caster do |value|
    # TODO: think about dryification
    next value if value.is_a?(::Numeric)

    SmartCore::Engine::RescueExt.inline_rescue_pipe(
      -> { SmartCore::Types::Value::Float.cast(value) },
      -> { SmartCore::Types::Value::Integer.cast(value) },
      -> { SmartCore::Types::Value::BigDecimal.cast(value) }
    ) do |error|
      raise(error) unless error.is_a?(SmartCore::Types::TypeCastingError)
      raise(SmartCore::Types::TypeCastingError, 'Non-castable to Numeric')
    end
  end
end
