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
      begin
        # NOTE: for cases like this:
        # => ::Kernel.Integer(nil) # => ::TypeError
        # => ::Kernel.Integer(nil.to_i) # => 0 (::Kernel.Integer used as validation layer)
        ::Kernel.Integer(value.to_i)
      rescue ::TypeError, ::NoMethodError, ::ArgumentError
        raise(SmartCore::Types::TypeCastingError, 'Non-castable to Integer')
      end
    end
  end
end
