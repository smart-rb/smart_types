# frozen_string_literal: true

# @api public
# @since 0.1.0
SmartCore::Types::Value.define_type(:Text) do |type|
  type.define_checker do |value|
    value.is_a?(::String) || value.is_a?(::Symbol)
  end

  type.define_caster do |value|
    value.to_s
  end
end
