# frozen_string_literal: true

module Carbon
  class ProgressBarComponentPreview < ViewComponent::Preview
    # @param value number
    # @param max number
    # @param size select { choices: [big, small] }
    # @param status select { choices: [active, finished, error] }
    # @param type select { choices: [default, inline, indeterminate] }
    # @param label text
    # @param helper_text text
    def default(value: 50, max: 100, size: :big, status: :active, type: :default, label: '', helper_text: '')
      options = {
        size: size.to_sym,
        status: status.to_sym,
        type: type.to_sym
      }
      options[:value] = value if type.to_sym == :default
      options[:max] = max
      options[:label] = label if label.present?
      options[:helper_text] = helper_text if helper_text.present?

      render Carbon::ProgressBarComponent.new(**options)
    end

    # @!group Sizes

    def big
      render Carbon::ProgressBarComponent.new(value: 50, size: :big, label: 'Upload progress')
    end

    def small
      render Carbon::ProgressBarComponent.new(value: 50, size: :small, label: 'Upload progress')
    end

    # @!endgroup

    # @!group Statuses

    def active
      render Carbon::ProgressBarComponent.new(value: 30, status: :active, label: 'Uploading...')
    end

    def finished
      render Carbon::ProgressBarComponent.new(value: 100, status: :finished, label: 'Upload complete')
    end

    def error
      render Carbon::ProgressBarComponent.new(
        value: 45,
        status: :error,
        label: 'Upload failed',
        helper_text: 'Connection lost'
      )
    end

    # @!endgroup

    # @!group Types

    def default_type
      render Carbon::ProgressBarComponent.new(value: 60, type: :default, label: 'Progress', helper_text: '60 of 100 MB')
    end

    def inline_type
      render Carbon::ProgressBarComponent.new(value: 75, type: :inline, label: 'Inline progress')
    end

    def indeterminate_type
      render Carbon::ProgressBarComponent.new(type: :indeterminate, label: 'Loading...')
    end

    # @!endgroup

    def with_label_and_value
      render Carbon::ProgressBarComponent.new(value: 30, max: 100, label: 'Upload progress')
    end

    def with_helper_text
      render Carbon::ProgressBarComponent.new(
        value: 45,
        max: 100,
        label: 'Downloading',
        helper_text: '45 of 100 MB downloaded'
      )
    end

    def custom_max
      render Carbon::ProgressBarComponent.new(value: 5, max: 10, label: 'Progress')
    end
  end
end
