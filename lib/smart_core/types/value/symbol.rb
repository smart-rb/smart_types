# frozen_string_literal: true

# @api public
# @since 0.1.0
SmartCore::Types::Value.define_type(:Symbol) do |type|
  type.define_checker do |value|
    value.is_a?(::Symbol)
  end

  type.define_caster do |value|
    begin
      value.to_sym
    rescue ::NoMethodError, ::ArgumentError
      raise(SmartCore::Types::TypeCastingError, 'Non-castable to Symbol')
    end
  end
end
