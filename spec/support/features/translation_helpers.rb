module Features
  module TranslationHelpers
    def field(translation_key)
      t(translation_key, scope: "simple_form.labels")
    end

    def button(translation_key)
      t(translation_key, scope: "helpers.submit")
    end
  end
end
