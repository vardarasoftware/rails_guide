module ApplicationHelper
    def text_field_with_label(form, attribute)
        form.label(attribute) + form.text_field(attribute)
    end
end
