# frozen_string_literal: true

module Carbon
  class PaginationComponent < BaseComponent
    attr_reader :total_items, :page, :page_size, :page_sizes, :disabled, :select_id, :label_id

    def initialize(total_items:, page: 1, page_size: 10, page_sizes: [10, 20, 30, 40, 50],
                   disabled: false, **system_arguments)
      @total_items = total_items
      @page = page
      @page_size = page_size
      @page_sizes = page_sizes
      @disabled = disabled
      @system_arguments = system_arguments
      hex = SecureRandom.hex(4)
      @select_id = "cds-pagination-select-#{hex}"
      @label_id = "cds-pagination-label-#{hex}"
    end

    def total_pages
      (@total_items.to_f / @page_size).ceil
    end

    def start_item
      return 0 if @total_items.zero?

      ((@page - 1) * @page_size) + 1
    end

    def end_item
      ending = @page * @page_size
      [ending, @total_items].min
    end

    def css_classes
      classes = ['cds--pagination']
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    def html_attributes
      attrs = @system_arguments.dup
      attrs[:class] = css_classes
      attrs[:data] ||= {}
      attrs[:data][:controller] = 'carbon--pagination'
      attrs[:data][:'carbon--pagination-total-items-value'] = @total_items
      attrs[:data][:'carbon--pagination-page-value'] = @page
      attrs[:data][:'carbon--pagination-page-size-value'] = @page_size
      attrs
    end
  end
end
