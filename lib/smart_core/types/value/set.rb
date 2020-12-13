# frozen_string_literal: true

require 'set'

# @api public
# @since 0.x.0
SmartCore::Types::Value.define_type(:Set) do |type|
  type.define_checker do |value|
    value.is_a?(::Set)
  end

  type.define_caster do |value|
    ::Set.new(::Kernel.Array(value))
  end
end
