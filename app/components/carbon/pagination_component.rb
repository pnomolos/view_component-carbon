# frozen_string_literal: true

module Carbon
  # Renders a Carbon Design System Pagination control.
  #
  # @example Basic usage
  #   render Carbon::PaginationComponent.new(total_items: 100, page: 1)
  #
  # @see https://carbondesignsystem.com/components/pagination/usage/
  class PaginationComponent < BaseComponent
    SIZES = %i[sm md lg].freeze

    DEFAULT_SIZE = :md

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
    # @return [Symbol] component size
    attr_reader :size
    # @return [String] items per page label text
    attr_reader :items_per_page_text
    # @return [Proc, nil] custom page text formatter
    attr_reader :page_text
    # @return [Proc, nil] custom item range text formatter
    attr_reader :item_range_text
    # @return [String] unique select element ID
    attr_reader :select_id
    # @return [String] unique label element ID
    attr_reader :label_id

    # @param total_items [Integer] total number of items
    # @param page [Integer] current page number
    # @param page_size [Integer] items per page
    # @param page_sizes [Array<Integer>] available page size options
    # @param disabled [Boolean] disables the pagination controls
    # @param size [Symbol] component size (:sm, :md, :lg)
    # @param items_per_page_text [String] label for items per page
    # @param page_text [Proc, nil] custom page text formatter
    # @param item_range_text [Proc, nil] custom item range text formatter
    # @param system_arguments [Hash] additional HTML attributes
    def initialize(total_items:, page: 1, page_size: 10, page_sizes: [10, 20, 30, 40, 50],
                   disabled: false, size: DEFAULT_SIZE, items_per_page_text: 'Items per page:',
                   page_text: nil, item_range_text: nil, **system_arguments)
      @total_items = total_items
      @page = page
      @page_size = page_size
      @page_sizes = page_sizes
      @disabled = disabled
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @items_per_page_text = items_per_page_text
      @page_text = page_text
      @item_range_text = item_range_text
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
      classes << "cds--pagination--#{@size}" unless @size == :md
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

    private

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError, "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end
  end
end
