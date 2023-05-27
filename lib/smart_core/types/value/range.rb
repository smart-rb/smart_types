# frozen_string_literal: true

using SmartCore::Ext::BasicObjectAsObject

# @api public
# @since 0.9.0
SmartCore::Types::Value.define_type(:Range) do |type|
  type.define_checker do |value|
    value.is_a?(::Range)
  end
end
