# frozen_string_literal: true

# @api public
# @since 0.1.0
SmartCore::Types::Value.define_type(:Integer) do |type|
  type.define_checker do |value|
    value.is_a?(::Integer)
  end

  type.define_caster do |value|
    begin
      ::Kernel.Integer(value)
    rescue ::TypeError, ::ArgumentError
      # NOTE: for cases like this:
      # => ::Kernel.Float(nil) # => ::TypeError
      # => ::Kernel.Float(nil.to_f) # => 0.0 (with a layer of the core validation mechanism)
      begin
        ::Kernel.Integer(value.to_i)
      rescue ::TypeError, ::NoMethodError
        raise(SmartCore::Types::TypeCastingError, 'Non-castable to Integer')
      end
    end
  end
end
