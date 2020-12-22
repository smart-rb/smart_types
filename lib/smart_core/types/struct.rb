# frozen_string_literal: true

# @api public
# @since 0.1.0
# @version 0.4.0
class SmartCore::Types::Struct < SmartCore::Types::Primitive
  require_relative 'struct/strict_hash'
end
