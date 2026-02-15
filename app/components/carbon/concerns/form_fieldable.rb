# frozen_string_literal: true

module Carbon
  module Concerns
    module FormFieldable
      extend ActiveSupport::Concern

      private

      def initialize_form_field(invalid: false, invalid_text: nil, warn: false, warn_text: nil, helper_text: nil)
        @invalid = invalid
        @invalid_text = invalid_text
        @warn = warn && !invalid
        @warn_text = warn_text
        @helper_text = helper_text
        @helper_text_id = "helper-#{SecureRandom.hex(4)}"
      end

      def validation_state
        return :invalid if @invalid
        return :warn if @warn

        nil
      end

      def data_invalid_attrs
        return { 'data-invalid' => '' } if @invalid

        {}
      end

      def aria_describedby_id
        return @helper_text_id if @helper_text || @invalid_text || @warn_text

        nil
      end

      def form_field_wrapper_classes(base)
        classes = [base]
        classes << "#{base}--invalid" if @invalid
        classes << "#{base}--warn" if @warn
        classes
      end

      def warning_icon_svg
        if @invalid
          '<svg focusable="false" preserveAspectRatio="xMidYMid meet" xmlns="http://www.w3.org/2000/svg" ' \
            'fill="currentColor" width="16" height="16" viewBox="0 0 16 16" aria-hidden="true" ' \
            'class="cds--text-input__invalid-icon">' \
            '<path d="M8,1C4.2,1,1,4.2,1,8s3.2,7,7,7s7-3.1,7-7S11.9,1,8,1z M7.5,4h1v5h-1C7.5,9,7.5,4,7.5,4z ' \
            'M8,12.2c-0.4,0-0.8-0.4-0.8-0.8s0.3-0.8,0.8-0.8c0.4,0,0.8,0.4,0.8,0.8S8.4,12.2,8,12.2z"></path>' \
            '</svg>'
        elsif @warn
          '<svg focusable="false" preserveAspectRatio="xMidYMid meet" xmlns="http://www.w3.org/2000/svg" ' \
            'fill="currentColor" width="16" height="16" viewBox="0 0 32 32" aria-hidden="true" ' \
            'class="cds--text-input__invalid-icon cds--text-input__invalid-icon--warning">' \
            '<path fill="none" d="M16,26a1.5,1.5,0,1,1,1.5-1.5A1.5,1.5,0,0,1,16,26Zm-1.125-5h2.25V12h-2.25Z"></path>' \
            '<path d="M16.002,6.171h-.004L4.648,27.997,4.646,28H27.354l0,0ZM14.875,12h2.25v9h-2.25ZM16,26a1.5,1.5,0,' \
            '1,1,1.5-1.5A1.5,1.5,0,0,1,16,26Z"></path>' \
            '</svg>'
        end
      end
    end
  end
end
