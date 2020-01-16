# frozen_string_literal: true

# @api public
# @since 0.1.0
SmartCore::Types::Value.define_type(:Proc) do |type|
  type.define_checker do |value|
    value.is_a?(::Proc)
  end

  type.define_caster do |value|
    value.to_proc
  end
end
