# frozen_string_literal: true

# @api public
# @since 0.1.0
SmartCore::Types::Value.define_type(:Float) do |type|
  type.define_checker do |value|
    value.is_a?(::Float)
  end

  type.define_caster do |value|
    begin
      ::Kernel.Float(value)
    rescue ::TypeError, ::ArgumentError
      begin
        ::Kernel.Float(value.to_f)
      rescue ::NoMethodError, ::TypeError, ::ArgumentError
        raise(SmartCore::Types::TypeCastingError, 'Non-castable to Float')
      end
    end
  end
end
