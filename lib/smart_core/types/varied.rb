# frozen_string_literal: true

# @api public
# @since 0.3.0
class SmartCore::Types::Varied < SmartCore::Types::Primitive
  require_relative 'varied/enum'
  require_relative 'varied/variant'
end
