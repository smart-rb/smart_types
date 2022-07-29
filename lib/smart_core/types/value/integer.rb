# frozen_string_literal: true

using SmartCore::Ext::BasicObjectAsObject

# @api public
# @since 0.1.0
# @version 0.3.0
SmartCore::Types::Value.define_type(:Integer) do |type|
  type.define_checker do |value|
    value.is_a?(::Integer)
  end

  type.define_caster do |value|
    begin
      ::Kernel.Integer(value)
    rescue ::TypeError, ::ArgumentError, ::FloatDomainError
      begin
        # NOTE: for cases like this:
        # => ::Kernel.Integer(nil) # => ::TypeError
        # => ::Kernel.Integer(nil.to_i) # => 0 (::Kernel.Integer used as validation layer)
        ::Kernel.Integer(value.to_i)
      rescue ::TypeError, ::NoMethodError, ::ArgumentError, ::FloatDomainError
        raise(SmartCore::Types::TypeCastingError, "#{value.inspect} non-castable to Integer")
      end
    end
  end
end
