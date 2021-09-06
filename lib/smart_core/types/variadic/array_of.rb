# frozen_string_literal: true

using SmartCore::Ext::BasicObjectAsObject

# @api public
# @since 0.6.0
SmartCore::Types::Variadic.define_type(:ArrayOf) do |type|
  type.define_caster { |value| SmartCore::Types::Value::Array.cast(value) }

  type.runtime_attributes_checker do |runtime_attrs|
    runtime_attrs.any? && runtime_attrs.all? do |runtime_attr|
      runtime_attr.is_a?(::Class)
    end
  end

  type.define_checker do |value, expected_types|
    next false unless SmartCore::Types::Value::Array.valid?(value)

    value.all? do |elem|
      expected_types.any? { |expected_type| elem.is_a?(expected_type) }
    end
  end
end
