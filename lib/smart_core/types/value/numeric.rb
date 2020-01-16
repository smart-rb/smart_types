# frozen_string_literal: true

# @api public
# @since 0.1.0
SmartCore::Types::Value.define_type(:Numeric) do |type|
  type.define_checker do |value|
    value.is_a?(::Numeric)
  end

  type.define_caster do |value|
    begin
      Float(value)
    rescue ::TypeError, ::ArgumentError
      value.to_f
    end
  end
end
