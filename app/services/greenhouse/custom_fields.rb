module Greenhouse
  class CustomFields
    SUPPORTED_TYPES = ["single_select", "short_text", "long_text", "number"]

    def self.match(payload, namely_fields)
      new(payload, namely_fields).to_h
    end

    def initialize(payload, namely_fields)
      namely_field_by_label = Hash[namely_fields.map { |f| [f.label, f.name] }]
      supported = payload.select do |_, field|
        SUPPORTED_TYPES.include? field.fetch("type")
      end
      @fields = Hash[supported.map do |_, field|
        if field_name = namely_field_by_label[field["name"]]
          [field_name.to_sym, convert(field)]
        end
      end.compact]
    end

    def to_h
      @fields
    end

    private

    def convert(field)
      field.fetch("value", nil)
    end
  end
end
