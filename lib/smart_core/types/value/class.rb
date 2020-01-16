# frozen_string_literal: true

# @api public
# @since 0.1.0
SmartCore::Types::Value.define_type(:Class) do |type|
  type.define_checker do |value|
    value.is_a?(::Class)
  end
end
