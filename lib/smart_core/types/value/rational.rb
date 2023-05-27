# frozen_string_literal: true

using SmartCore::Ext::BasicObjectAsObject

# @api public
# @since 0.9.0
SmartCore::Types::Value.define_type(:Rational) do |type|
  type.define_checker do |value|
    value.is_a?(::Rational)
  end

  type.define_caster do |value|
    ::Kernel.Rational(value)
  rescue ::TypeError, ::FloatDomainError
    # NOTE: FloatDomainError is raised when you try to type cast Float::INFINITY or Float::NAN
    raise(SmartCore::Types::TypeCastingError, 'Non-castable to Rational')
  end
end
