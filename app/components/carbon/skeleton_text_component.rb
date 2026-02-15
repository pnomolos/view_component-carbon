# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Skeleton Text placeholder.
  #
  # @example Basic usage
  #   render Carbon::SkeletonTextComponent.new(lines: 3)
  #
  # @see https://carbondesignsystem.com/components/skeleton/usage/
  class SkeletonTextComponent < BaseComponent
    # @param heading [Boolean] renders as a skeleton heading
    # @param lines [Integer] number of skeleton lines to render
    # @param width [String, nil] custom width for the skeleton
    # @param paragraph [Boolean, nil] whether to render as a paragraph
    # @param system_arguments [Hash] additional HTML attributes
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
