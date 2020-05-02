# frozen_string_literal: true

# @api public
# @since 0.1.0
SmartCore::Types::Value.define_type(:Float) do |type|
  type.define_checker do |value|
    value.is_a?(::Float)
  end

  type.define_caster do |value|
    begin
      Float(value)
    rescue ::TypeError, ::ArgumentError
      value.to_f
    rescue ::NoMethodError
      raise(SmartCore::Types::TypeCastingError, 'Non-castable value')
    end
  end
end
