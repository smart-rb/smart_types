# frozen_string_literal: true

# TODO: revrite to type sum

# @api public
# @since 0.1.0
SmartCore::Types::Value.define_type(:TimeLike) do |type|
  type.define_checker do |value|
    value.is_a?(::Time) || value.is_a?(::DateTime) || value.is_a?(::Date)
  end

  type.define_caster do |value|
    begin
      ::Time.parse(value)
    rescue
      ::DateTime.parse(value)
    rescue
      ::Date.parse(value)
    end # THIS IS INCORRECT!!
    # TODO #1: use original type casters
    # TODO #2: use pipelined type cast
  end
end
