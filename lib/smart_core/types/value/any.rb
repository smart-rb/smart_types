# frozen_string_literal: true

# @api public
# @since 0.1.0
SmartCore::Types::Value.define_type(:Any) do |type|
  type.define_checker do |value|
    true
  end

  type.define_caster do |value|
    value
  end
end
