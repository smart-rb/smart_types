# frozen_string_literal: true

require 'set'

using SmartCore::Ext::BasicObjectAsObject

# @api public
# @since 0.3.0
SmartCore::Types::Value.define_type(:Set) do |type|
  type.define_checker do |value|
    value.is_a?(::Set)
  end

  type.define_caster do |value|
    ::Set.new(SmartCore::Types::Value::Array.cast(value))
  end
end
