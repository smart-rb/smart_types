# frozen_string_literal: true

using SmartCore::Ext::BasicObjectAsObject

# @api public
# @since 0.3.0
SmartCore::Types::Protocol.define_type(:InstanceOf) do |type|
  type.runtime_attributes_checker do |runtime_attrs|
    runtime_attrs.any? && runtime_attrs.all? do |runtime_attr|
      runtime_attr.is_a?(::Class)
    end
  end

  type.define_checker do |value, expected_types|
    expected_types.any? && expected_types.any? do |expected_type|
      value.is_a?(expected_type)
    end
  end
end
