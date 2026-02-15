# frozen_string_literal: true

module Carbon
  class SkeletonTextComponent < BaseComponent
    def initialize(heading: false, lines: 3, width: nil, paragraph: nil, **system_arguments)
      @heading = heading
      @lines = lines
      @width = width
      @paragraph = paragraph.nil? ? (lines > 1) : paragraph
      @system_arguments = system_arguments
    end

    private

    attr_reader :heading, :lines, :width, :paragraph, :system_arguments

    def css_classes(element_type = nil)
      element_type ||= (heading ? 'heading' : 'text')
      classes = [carbon_class('skeleton', element_type)]
      classes << system_arguments[:class] if system_arguments[:class]
      class_names(classes)
    end

    def html_attributes_for_element
      attrs = system_arguments.dup
      attrs[:class] = css_classes
      attrs
    end

    def line_widths
      # Alternate between full width and shorter widths for natural appearance
      widths = []
      lines.times do |i|
        widths << (i.even? ? '100%' : '75%')
      end
      widths
    end
  end
end
