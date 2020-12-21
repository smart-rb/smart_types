# frozen_string_literal: true

using SmartCore::Ext::BasicObjectAsObject

# @api public
# @since 0.1.0
# @version 0.3.0
SmartCore::Types::Value.define_type(:Proc) do |type|
  type.define_checker do |value|
    value.is_a?(::Proc)
  end

  type.define_caster do |value|
    begin
      value.to_proc.tap do |result|
        unless result.is_a?(::Proc)
          raise(SmartCore::Types::TypeCastingError, 'Non-castable to Proc')
        end
      end
    rescue ::NoMethodError
      raise(SmartCore::Types::TypeCastingError, 'Non-castable to Proc')
    end
  end
end
