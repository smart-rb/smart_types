# frozen_string_literal: true

# @api public
# @since 0.3.0
SmartCore::Types::Varied.define_type(:Variant) do |type|
  type.define_checker do |value, *types|
    types.any? { |x| x.valid?(value) }
  end
end
