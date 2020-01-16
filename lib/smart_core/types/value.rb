# frozen_string_literal: true

# @api public
# @since 0.1.0
class SmartCore::Types::Value < SmartCore::Types::Primitive
  require_relative 'value/string'
  require_relative 'value/symbol'
  require_relative 'value/text'
  require_relative 'value/integer'
  require_relative 'value/float'
  require_relative 'value/numeric'
ende
