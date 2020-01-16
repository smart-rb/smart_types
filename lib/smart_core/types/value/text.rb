# frozen_string_literal: true

# @api public
# @since 0.1.0
SmartCore::Types::Value.define_type(:Text) do |type|
  type.define_checker { |value| value.is_a?(::String) || value.is_a?(::Symbol) }
  type.define_caster  { |value| value.to_s }
end
