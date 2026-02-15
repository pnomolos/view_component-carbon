# frozen_string_literal: true

module Carbon
  class ClickableTileComponent < Carbon::BaseComponent
    attr_reader :href, :disabled, :target, :rel

    def initialize(href: nil, disabled: false, target: nil, rel: nil, **system_arguments)
      @href = href
      @disabled = disabled
      @target = target
      @rel = rel
      @system_arguments = system_arguments
    end

    def link?
      @href.present?
    end

    private

    def css_classes
      classes = %w[cds--tile cds--tile--clickable]
      classes << 'cds--tile--disabled' if @disabled
      classes << @system_arguments[:class] if @system_arguments[:class]
      class_names(classes)
    end

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs[:tabindex] = @disabled ? '-1' : '0'
      attrs['aria-disabled'] = 'true' if @disabled

      if link?
        attrs[:href] = @href
        attrs[:target] = @target if @target
        attrs[:rel] = @rel if @rel
      else
        attrs[:role] = 'button'
      end

      attrs
    end

    def tag_name
      link? ? :a : :div
    end
  end
end
