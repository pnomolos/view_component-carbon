# frozen_string_literal: true

module Carbon
  module Concerns
    module Popoverable
      extend ActiveSupport::Concern

      POPOVER_ALIGNS = %i[
        top top-start top-end
        bottom bottom-start bottom-end
        left left-start left-end
        right right-start right-end
      ].freeze

      DEFAULT_POPOVER_ALIGN = :bottom

      private

      def validate_popover_align(value)
        value = value.to_sym if value.is_a?(String)
        return value if POPOVER_ALIGNS.include?(value)

        raise ArgumentError,
              "Invalid align: #{value.inspect}. Must be one of: #{POPOVER_ALIGNS.map(&:inspect).join(', ')}"
      end

      def popover_container_classes(base_class:, align:, caret: true, drop_shadow: true,
                                    high_contrast: false, open: false, extra_classes: [])
        classes = ['cds--popover-container']
        classes << 'cds--popover--caret' if caret
        classes << 'cds--popover--drop-shadow' if drop_shadow
        classes << 'cds--popover--high-contrast' if high_contrast
        classes << 'cds--popover--open' if open
        classes << "cds--popover--#{align}"
        classes << base_class
        classes.concat(Array(extra_classes))
        classes
      end
    end
  end
end
