# frozen_string_literal: true

using SmartCore::Ext::BasicObjectAsObject

# @api public
# @since 0.4.0
SmartCore::Types::Struct.define_type(:StrictHash) do |type|
  type.runtime_attributes_checker do |runtime_attrs|
    schema = runtime_attrs.first

    next false unless runtime_attrs.size == 1
    next false unless schema.is_a?(::Hash)

    schema.all? { |_key, value| value.is_a?(SmartCore::Types::Primitive) }
  end

  type.define_checker do |value, schema_values|
    schema = schema_values.first

    next false unless SmartCore::Types::Value::Hash.valid?(value)
    next false unless value.keys == schema.keys

    value.all? { |k, v| schema[k].valid?(v) }
  end
end
