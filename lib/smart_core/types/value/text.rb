# frozen_string_literal: true

# @api public
# @since 0.1.0
SmartCore::Types::Value::Text = SmartCore::Types::System.type_sum(
  SmartCore::Types::Value::String, SmartCore::Types::Value::Symbol
) { |type| type.define_caster(&:to_s) }
