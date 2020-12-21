# frozen_string_literal: true

using SmartCore::Ext::BasicObjectAsObject

# @api public
# @since 0.1.0
# @version 0.3.0
SmartCore::Types::Value.define_type(:String) do |type|
  type.define_checker do |value|
    value.is_a?(::String)
  end

  type.define_caster do |value|
    begin
      ::Kernel.String(value)
    rescue ::TypeError, ::ArgumentError
      raise(SmartCore::Types::TypeCastingError, 'Non-castable to String')
    end
  end
end
