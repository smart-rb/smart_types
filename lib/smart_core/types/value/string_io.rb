# frozen_string_literal: true

require 'stringio'

# @api public
# @since 0.x.0
SmartCore::Types::Value.define_type(:StringIO) do |type|
  type.define_checker do |value|
    # TODO: realize
  end

  type.define_caster do |value|
    # TODO: realize
  end
end
