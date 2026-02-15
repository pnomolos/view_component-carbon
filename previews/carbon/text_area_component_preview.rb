# frozen_string_literal: true

module Carbon
  class TextAreaComponentPreview < ViewComponent::Preview
    # @param label_text text
    # @param placeholder text
    # @param rows number
    # @param disabled toggle
    # @param readonly toggle
    def default(label_text: 'Comments', placeholder: 'Enter your comments', rows: 4, disabled: false,
                readonly: false)
      render Carbon::TextAreaComponent.new(
        label_text: label_text,
        placeholder: placeholder,
        rows: rows,
        disabled: disabled,
        readonly: readonly,
        name: 'comments'
      )
    end

    def with_helper_text
      render Carbon::TextAreaComponent.new(
        label_text: 'Feedback',
        name: 'feedback',
        helper_text: 'Please provide detailed feedback about your experience',
        placeholder: 'Your feedback...'
      )
    end

    def with_value
      render Carbon::TextAreaComponent.new(
        label_text: 'Description',
        name: 'description',
        value: 'This is a pre-filled text area with some content already in it.',
        rows: 6
      )
    end

    def invalid
      render Carbon::TextAreaComponent.new(
        label_text: 'Message',
        name: 'message',
        invalid: true,
        invalid_text: 'Message must be at least 10 characters',
        value: 'Short'
      )
    end

    def with_character_counter
      render Carbon::TextAreaComponent.new(
        label_text: 'Bio',
        name: 'bio',
        placeholder: 'Tell us about yourself...',
        max_count: 200,
        rows: 5,
        helper_text: 'Maximum 200 characters'
      )
    end

    def large_text_area
      render Carbon::TextAreaComponent.new(
        label_text: 'Article content',
        name: 'content',
        rows: 15,
        cols: 80,
        placeholder: 'Write your article here...'
      )
    end

    def disabled
      render Carbon::TextAreaComponent.new(
        label_text: 'Disabled textarea',
        disabled: true,
        value: 'This content cannot be edited'
      )
    end

    def readonly
      render Carbon::TextAreaComponent.new(
        label_text: 'Read-only textarea',
        readonly: true,
        value: 'This content is read-only',
        rows: 3
      )
    end

    def with_cols
      render Carbon::TextAreaComponent.new(
        label_text: 'Fixed width',
        cols: 50,
        rows: 8,
        placeholder: 'This textarea has a fixed column width'
      )
    end
  end
end
