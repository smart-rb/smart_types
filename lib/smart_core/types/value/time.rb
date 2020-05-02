# frozen_string_literal: true

# @api public
# @since 0.1.0
SmartCore::Types::Value.define_type(:Time) do |type|
  type.define_checker do |value|
    value.is_a?(::Time)
  end

  type.define_caster do |value|
    ::Time.parse(value)
  end
end
