# frozen_string_literal: true

# @api public
# @since 0.1.0
SmartCore::Types::Value.define_type(:String) do |type|
  type.define_checker { |value| value.is_a?(::String) }
  type.define_caster  { |value| value.to_s }
end
