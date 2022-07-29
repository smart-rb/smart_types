# frozen_string_literal: true

using SmartCore::Ext::BasicObjectAsObject

# @api public
# @since 0.1.0
# @version 0.3.0
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
        raise(SmartCore::Types::TypeCastingError, "#{value.inspect} non-castable to Float")
      end
    end
  end
end
