# frozen_string_literal: true

require 'bigdecimal'
require 'bigdecimal/util'

using SmartCore::Ext::BasicObjectAsObject

# @api public
# @since 0.1.0
# @version 0.3.0
SmartCore::Types::Value.define_type(:BigDecimal) do |type|
  type.define_checker do |value|
    value.is_a?(::BigDecimal)
  end

  type.define_caster do |value|
    if SmartCore::Types::Value::Numeric.valid?(value)
      value = SmartCore::Types::Value::String.cast(value)
    end

    begin
      ::Kernel.BigDecimal(value)
    rescue ::ArgumentError, ::TypeError
      begin
        ::Kernel.BigDecimal(value.to_d)
      rescue ::ArgumentError, ::TypeError, ::NoMethodError
        raise(SmartCore::Types::TypeCastingError, "#{value.inspect} non-castable to BigDecimal")
      end
    end
  end
end
