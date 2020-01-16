# frozen_string_literal: true

# @api public
# @since 0.1.0
SmartCore::Types::Value.define_type(:Hash) do |type|
  type.define_checker do |value|
    value.is_a?(::Hash)
  end

  type.define_caster do |value|
    begin
      ::Kernel.Hash(value)
    rescue ::TypeError
      {}
    end
  end
end
