# frozen_string_literal: true

using SmartCore::Ext::BasicObjectAsObject

# @api public
# @since 0.1.0
# @version 0.3.0
SmartCore::Types::Value.define_type(:Symbol) do |type|
  type.define_checker do |value|
    value.is_a?(::Symbol)
  end

  type.define_caster do |value|
    begin
      value.to_sym
    rescue ::NoMethodError, ::ArgumentError
      raise(SmartCore::Types::TypeCastingError, "#{value.inspect} non-castable to Symbol")
    end
  end
end
