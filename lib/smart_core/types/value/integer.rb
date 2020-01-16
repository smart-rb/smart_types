# frozen_string_literal: true

# @api public
# @since 0.1.0
SmartCore::Types::Value.define_type(:Integer) do |type|
  type.define_checker do |value|
    value.is_a?(::Integer)
  end

  type.define_caster do |value|
    begin
      Integer(value)
    rescue ::TypeError
      value.to_i
    end
  end
end
