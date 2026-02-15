# frozen_string_literal: true

module Carbon
  class BaseComponent < ViewComponent::Base
    class_attribute :interactivity_mode, default: :stimulus

    private

    def class_names(*args)
      args.flatten.compact.join(' ')
    end

    def carbon_class(block, element = nil, modifier = nil)
      base = "cds--#{block}"
      base = "#{base}__#{element}" if element
      base = "#{base}--#{modifier}" if modifier
      base
    end

    def render_mode
      self.class.interactivity_mode
    end
  end
end
