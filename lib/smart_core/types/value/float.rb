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
        # NOTE: for cases like this:
        # => ::Kernel.Float(nil) # => ::TypeError
        # => ::Kernel.Float(nil.to_f) # => 0.0 (with a layer of the core validation mechanism)
        ::Kernel.Float(value.to_f)
      rescue ::NoMethodError, ::TypeError
        raise(SmartCore::Types::TypeCastingError, 'Non-castable to Float')
      end
    end
  end
end
