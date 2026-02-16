# frozen_string_literal: true

module Carbon
  class FormComponentPreview < ViewComponent::Preview
    def default
      render Carbon::FormComponent.new(action: '/submit', method: 'post') do
        '<div class="cds--form-item">
          <label class="cds--label" for="form-name">Name</label>
          <input type="text" class="cds--text-input" id="form-name" placeholder="Enter name">
        </div>
        <div class="cds--form-item">
          <label class="cds--label" for="form-email">Email</label>
          <input type="email" class="cds--text-input" id="form-email" placeholder="Enter email">
        </div>
        <button type="submit" class="cds--btn cds--btn--primary">Submit</button>'.html_safe
      end
    end

    def with_form_group
      render Carbon::FormComponent.new do
        render_component_group
      end
    end

    private

    def render_component_group
      '<fieldset class="cds--fieldset">
        <legend class="cds--label">Personal Information</legend>
        <div class="cds--form-item">
          <label class="cds--label" for="first-name">First name</label>
          <input type="text" class="cds--text-input" id="first-name">
        </div>
        <div class="cds--form-item">
          <label class="cds--label" for="last-name">Last name</label>
          <input type="text" class="cds--text-input" id="last-name">
        </div>
      </fieldset>'.html_safe
    end
  end
end
