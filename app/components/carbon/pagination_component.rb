# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Pagination control.
  #
  # @example Basic usage
  #   render Carbon::PaginationComponent.new(total_items: 100, page: 1)
  #
  # @see https://carbondesignsystem.com/components/pagination/usage/
  class PaginationComponent < BaseComponent
    # @return [Integer] total number of items
    attr_reader :total_items
    # @return [Integer] current page number
    attr_reader :page
    # @return [Integer] items per page
    attr_reader :page_size
    # @return [Array<Integer>] available page size options
    attr_reader :page_sizes
    # @return [Boolean] whether disabled
    attr_reader :disabled
    # @return [String] unique select element ID
    attr_reader :select_id
    # @return [String] unique label element ID
    attr_reader :label_id

    # @param total_items [Integer] total number of items
    # @param page [Integer] current page number
    # @param page_size [Integer] items per page
    # @param page_sizes [Array<Integer>] available page size options
    # @param disabled [Boolean] disables the pagination controls
    # @param system_arguments [Hash] additional HTML attributes
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

    # @return [Integer] total number of pages
    def total_pages
      (@total_items.to_f / @page_size).ceil
    end

    # @return [Integer] 1-based index of the first item on the current page
    def start_item
      return 0 if @total_items.zero?

      ((@page - 1) * @page_size) + 1
    end

    # @return [Integer] 1-based index of the last item on the current page
    def end_item
      ending = @page * @page_size
      [ending, @total_items].min
    end

    # @return [String] CSS class string
    def css_classes
      classes = ['cds--pagination']
      classes << @system_arguments.delete(:class) if @system_arguments[:class]
      class_names(*classes)
    end

    # @return [Hash] HTML attributes for the pagination element
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
