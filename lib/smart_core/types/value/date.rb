# frozen_string_literal: true

SmartCore::Types::Value.define_type(:Date) do |type|
  type.define_checker do |value|
    value.is_a?(::Date)
  end

  type.define_caster do |value|
    ::Date.parse(value)
  end
end
