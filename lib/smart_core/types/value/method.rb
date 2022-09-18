# frozen_string_literal: true

using SmartCore::Ext::BasicObjectAsObject

# @api public
# @since 0.8.0
SmartCore::Types::Value.define_type(:Method) do |type|
  type.define_checker do |value|
    value.is_a?(::Method)
  end
end
