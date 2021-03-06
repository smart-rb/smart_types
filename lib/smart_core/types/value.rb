# frozen_string_literal: true

# @api public
# @since 0.1.0
class SmartCore::Types::Value < SmartCore::Types::Primitive
  require_relative 'value/nil'
  require_relative 'value/string'
  require_relative 'value/string_io'
  require_relative 'value/symbol'
  require_relative 'value/text'
  require_relative 'value/integer'
  require_relative 'value/float'
  require_relative 'value/numeric'
  require_relative 'value/boolean'
  require_relative 'value/array'
  require_relative 'value/hash'
  require_relative 'value/io'
  require_relative 'value/proc'
  require_relative 'value/class'
  require_relative 'value/module'
  require_relative 'value/any'
  require_relative 'value/time'
  require_relative 'value/date'
  require_relative 'value/date_time'
  require_relative 'value/time_based'
  require_relative 'value/enumerable'
  require_relative 'value/enumerator'
  require_relative 'value/enumerator_chain'
  require_relative 'value/comparable'
  require_relative 'value/big_decimal'
  require_relative 'value/range'
  require_relative 'value/method'
  require_relative 'value/unbound_method'
  require_relative 'value/set'
  require_relative 'value/rational'
end
