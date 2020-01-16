# frozen_string_literal: true

# @api public
# @since 0.1.0
class SmartCore::Types::Value < SmartCore::Types::Primitive
  require_relative 'value/string'
  require_relative 'value/symbol'
end
