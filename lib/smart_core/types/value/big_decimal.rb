# frozen_string_literal: true

require 'bigdecimal'
require 'bigdecimal/util'

SmartCore::Types::Value.define_type(:BigDecimal) do |type|
  type.define_checker do |value|
    value.is_a?(::BigDecimal)
  end

  type.define_caster do |value|
    begin
      ::Kernel.BigDecimal(value)
    rescue ::ArgumentError, ::TypeError
      begin
        ::Kernel.BigDecimal(value.to_d)
      rescue ::ArgumentError, ::TypeError, ::NoMethodError
        raise(SmartCore::Types::TypeCastingError, 'Non-castable to BigDecimal')
      end
    end
  end
end
