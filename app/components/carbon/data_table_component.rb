# frozen_string_literal: true

module Carbon
  class DataTableComponent < BaseComponent
    SIZES = %i[xs sm md lg xl].freeze
    DEFAULT_SIZE = :lg

    renders_one :toolbar, 'ToolbarComponent'
    renders_one :head, 'HeadComponent'
    renders_many :rows, lambda { |row_id: nil, selected: false, expanded: false, disabled: false, **sys_args|
      RowComponent.new(
        row_id: row_id,
        selected: selected,
        expanded: expanded,
        disabled: disabled,
        selectable: @selectable,
        radio: @radio,
        expandable: @expandable,
        table_id: @table_id,
        **sys_args
      )
    }

    attr_reader :size, :sortable, :selectable, :radio, :expandable, :zebra,
                :sticky_header, :static_width, :title, :description

    def initialize(
      size: DEFAULT_SIZE,
      sortable: false,
      selectable: false,
      radio: false,
      expandable: false,
      zebra: false,
      sticky_header: false,
      static_width: false,
      title: nil,
      description: nil,
      **system_arguments
    )
      @size = validate_argument(:size, size, SIZES, DEFAULT_SIZE)
      @sortable = sortable
      @selectable = selectable
      @radio = radio
      @expandable = expandable
      @zebra = zebra
      @sticky_header = sticky_header
      @static_width = static_width
      @title = title
      @description = description
      @system_arguments = system_arguments
      @table_id = "data-table-#{SecureRandom.hex(8)}"
    end

    private

    def container_css_classes
      classes = ['cds--data-table-container']
      classes << 'cds--data-table-container--static' if @static_width
      classes << @system_arguments[:class] if @system_arguments[:class]
      class_names(classes)
    end

    def container_attributes # rubocop:disable Metrics/AbcSize
      attrs = @system_arguments.dup
      attrs[:class] = container_css_classes
      attrs[:data] ||= {}
      attrs[:data][:controller] = 'carbon--data-table'
      attrs[:data][:'carbon--data-table-selectable-value'] = @selectable.to_s if @selectable
      attrs[:data][:'carbon--data-table-expandable-value'] = @expandable.to_s if @expandable
      attrs[:data][:'carbon--data-table-radio-value'] = @radio.to_s if @radio
      attrs
    end

    def table_css_classes
      classes = ['cds--data-table']
      classes << "cds--data-table--#{@size}"
      classes << 'cds--data-table--sort' if @sortable
      classes << 'cds--data-table--zebra' if @zebra
      classes << 'cds--data-table--static' if @static_width
      classes << 'cds--data-table--sticky-header' if @sticky_header
      class_names(classes)
    end

    def validate_argument(name, value, allowed, _default)
      value = value.to_sym if value.is_a?(String)
      return value if allowed.include?(value)

      raise ArgumentError,
            "Invalid #{name}: #{value.inspect}. Must be one of: #{allowed.map(&:inspect).join(', ')}"
    end

    # -- Sub-components --

    class ToolbarComponent < BaseComponent
      renders_one :batch_actions, 'Carbon::DataTableComponent::BatchActionsComponent'
      renders_one :search, 'Carbon::DataTableComponent::ToolbarSearchComponent'

      def initialize(**system_arguments)
        @system_arguments = system_arguments
      end

      private

      def css_classes
        classes = ['cds--table-toolbar']
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def html_attributes
        attrs = @system_arguments.dup
        attrs[:class] = css_classes
        attrs
      end
    end

    class BatchActionsComponent < BaseComponent
      renders_many :actions, 'Carbon::DataTableComponent::BatchActionButtonComponent'

      attr_reader :active

      def initialize(active: false, **system_arguments)
        @active = active
        @system_arguments = system_arguments
      end

      private

      def css_classes
        classes = ['cds--batch-actions']
        classes << 'cds--batch-actions--active' if @active
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def html_attributes
        attrs = @system_arguments.dup
        attrs[:class] = css_classes
        attrs[:'data-carbon--data-table-target'] = 'batchActions'
        attrs
      end
    end

    class BatchActionButtonComponent < BaseComponent
      attr_reader :label

      def initialize(label:, **system_arguments)
        @label = label
        @system_arguments = system_arguments
      end

      def call
        content_tag(:button, @label, class: 'cds--btn cds--btn--primary', type: 'button', **@system_arguments)
      end
    end

    class ToolbarSearchComponent < BaseComponent
      def initialize(placeholder: 'Filter table', **system_arguments)
        @placeholder = placeholder
        @system_arguments = system_arguments
      end

      private

      def css_classes
        classes = ['cds--toolbar-search-container-expandable']
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def html_attributes
        attrs = @system_arguments.dup
        attrs[:class] = css_classes
        attrs
      end
    end

    class HeadComponent < BaseComponent
      renders_many :cells, 'Carbon::DataTableComponent::HeaderCellComponent'

      def initialize(**system_arguments)
        @system_arguments = system_arguments
      end

      def call
        content_tag(:thead) do
          content_tag(:tr) do
            safe_join(cells)
          end
        end
      end
    end

    class HeaderCellComponent < BaseComponent
      SORT_DIRECTIONS = %i[none ascending descending].freeze

      attr_reader :key, :sortable, :sort_direction

      def initialize(key: nil, sortable: false, sort_direction: :none, **system_arguments)
        @key = key
        @sortable = sortable
        @sort_direction = sort_direction
        @system_arguments = system_arguments
      end

      private

      def css_classes
        classes = []
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def html_attributes
        attrs = @system_arguments.dup
        attrs[:class] = css_classes unless css_classes.empty?
        attrs[:'aria-sort'] = aria_sort_value if @sortable
        attrs
      end

      def sort_button_classes
        classes = ['cds--table-sort']
        classes << 'cds--table-sort--active' if @sort_direction != :none
        classes << 'cds--table-sort--descending' if @sort_direction == :descending
        class_names(classes)
      end

      def aria_sort_value
        case @sort_direction
        when :ascending then 'ascending'
        when :descending then 'descending'
        else 'none'
        end
      end

      def sort_icon_svg
        if @sort_direction == :none
          arrows_vertical_svg
        else
          arrow_down_svg
        end
      end

      def arrows_vertical_svg
        '<svg focusable="false" preserveAspectRatio="xMidYMid meet" ' \
        'xmlns="http://www.w3.org/2000/svg" fill="currentColor" ' \
        'width="16" height="16" viewBox="0 0 32 32" aria-hidden="true" ' \
        'class="cds--table-sort__icon-unsorted">' \
        '<path d="M27.6 20.6L24 24.2 24 4 22 4 22 24.2 18.4 20.6 17 22 23 28 29 22z"></path>' \
        '<path d="M9 4L3 10 4.4 11.4 8 7.8 8 28 10 28 10 7.8 13.6 11.4 15 10z"></path>' \
        '</svg>'.html_safe
      end

      def arrow_down_svg
        '<svg focusable="false" preserveAspectRatio="xMidYMid meet" ' \
        'xmlns="http://www.w3.org/2000/svg" fill="currentColor" ' \
        'width="16" height="16" viewBox="0 0 32 32" aria-hidden="true" ' \
        'class="cds--table-sort__icon">' \
        '<path d="M24 24.2L20.4 20.6 19 22 25 28 31 22 29.6 20.6 26 24.2 26 4 24 4z"></path>' \
        '</svg>'.html_safe
      end
    end

    class RowComponent < BaseComponent
      renders_many :cells, 'Carbon::DataTableComponent::CellComponent'
      renders_one :expanded_content

      attr_reader :row_id, :selected, :expanded, :disabled,
                  :selectable, :radio, :expandable, :table_id

      def initialize(
        row_id: nil,
        selected: false,
        expanded: false,
        disabled: false,
        selectable: false,
        radio: false,
        expandable: false,
        table_id: nil,
        **system_arguments
      )
        @row_id = row_id || "row-#{SecureRandom.hex(8)}"
        @selected = selected
        @expanded = expanded
        @disabled = disabled
        @selectable = selectable
        @radio = radio
        @expandable = expandable
        @table_id = table_id
        @system_arguments = system_arguments
      end

      private

      def css_classes
        classes = []
        classes << 'cds--expandable-row' if @expandable
        classes << 'cds--data-table--selected' if @selected
        classes << @system_arguments[:class] if @system_arguments[:class]
        class_names(classes)
      end

      def html_attributes
        attrs = @system_arguments.dup
        attrs[:class] = css_classes unless css_classes.empty?
        attrs[:'data-carbon--data-table-target'] = 'row'
        attrs[:'aria-selected'] = @selected.to_s if @selectable || @radio
        attrs
      end

      def expanded_row_id
        "#{@row_id}-expanded"
      end

      def expand_button_svg
        '<svg focusable="false" preserveAspectRatio="xMidYMid meet" ' \
        'xmlns="http://www.w3.org/2000/svg" fill="currentColor" ' \
        'width="16" height="16" viewBox="0 0 16 16" aria-hidden="true" ' \
        'class="cds--table-expand__svg">' \
        '<path d="M11 8L6 13 5.3 12.3 9.6 8 5.3 3.7 6 3z"></path>' \
        '</svg>'.html_safe
      end

      def selection_input_type
        @radio ? 'radio' : 'checkbox'
      end

      def selection_input_name
        @radio ? "#{@table_id}-selection" : "#{@row_id}-select"
      end
    end

    class CellComponent < BaseComponent
      def initialize(**system_arguments)
        @system_arguments = system_arguments
      end

      def call
        content_tag(:td, content, **html_attributes)
      end

      private

      def html_attributes
        @system_arguments.dup
      end
    end
  end
end
