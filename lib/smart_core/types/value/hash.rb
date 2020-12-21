# frozen_string_literal: true

using SmartCore::Ext::BasicObjectAsObject

# @api public
# @since 0.1.0
# @version 0.3.0
SmartCore::Types::Value.define_type(:Hash) do |type|
  type.define_checker do |value|
    value.is_a?(::Hash)
  end

  type.define_caster do |value|
    begin
      ::Kernel.Hash(value)
    rescue ::TypeError
      begin
        # NOTE:
        # - ::Kernel.Hash does not invoke `#to_h` under the hood (it invokes `#to_hash`)
        # - ::Kernel.Hash is used to validate the returned value from `#to_h`
        ::Kernel.Hash(value.to_h)
      rescue ::TypeError, ::NoMethodError, ::ArgumentError
        raise(SmartCore::Types::TypeCastingError, 'Non-castable to Hash')
      end
    end
  end
end
