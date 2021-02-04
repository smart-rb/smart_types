# frozen_string_literal: true

using SmartCore::Ext::BasicObjectAsObject

# @api public
# @since 0.5.0
SmartCore::Types::Variadic.define_type(:Enum) do |type|
  type.runtime_attributes_checker(&:any?)

  type.define_checker { |value, enum| enum.include?(value) }
end
