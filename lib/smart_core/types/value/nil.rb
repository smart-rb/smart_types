# frozen_string_literal: true

# @api public
# @since 0.1.0
SmartCore::Types::Value.define_type(:Nil) do |type|
  type.define_checker do |value|
    value == nil # NOTE: #nil? is not used cuz BasicObject hasn't #nil? method
  end
end
