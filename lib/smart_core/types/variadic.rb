# frozen_string_literal: true

# @api public
# @since 0.3.0
# @version 0.6.0
class SmartCore::Types::Variadic < SmartCore::Types::Primitive
  require_relative 'variadic/array_of'
  require_relative 'variadic/enum'
  require_relative 'variadic/tuple'
end
