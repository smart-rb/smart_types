# frozen_string_literal: true

# @api public
# @since 0.3.0
SmartCore::Types::Protocol.define_type(:Instance) do |type|
  type.define_checker do |value, klass|
    value.is_a?(klass)
  end
end
