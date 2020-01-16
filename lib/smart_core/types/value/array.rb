# frozen_string_literal: true

# @api public
# @since 0.1.0
SmartCore::Types::Value.define_type(:Array) do |type|
  type.define_checker do |value|
    value.is_a?(::Array)
  end

  type.define_caster do |value|
    begin
      ::Kernel.Array(value)
    rescue ::TypeError
      [value]
    end
  end
end
