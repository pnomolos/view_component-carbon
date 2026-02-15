# frozen_string_literal: true

module Carbon
  class FileUploaderComponentPreview < ViewComponent::Preview
    # @param label_title text
    # @param label_description text
    # @param button_label text
    # @param size select { choices: [sm, md, lg] }
    # @param kind select { choices: [primary, tertiary] }
    # @param disabled toggle
    # @param multiple toggle
    def default(label_title: 'Upload files', label_description: 'Max file size is 500mb. Supported types: .jpg, .png',
                button_label: 'Add file', size: :md, kind: :primary, disabled: false, multiple: false)
      render Carbon::FileUploaderComponent.new(
        label_title: label_title,
        label_description: label_description,
        button_label: button_label,
        size: size.to_sym,
        kind: kind.to_sym,
        disabled: disabled,
        multiple: multiple,
        accept: ['.jpg', '.png']
      )
    end

    def with_multiple_files
      render Carbon::FileUploaderComponent.new(
        label_title: 'Upload documents',
        label_description: 'Only .pdf and .doc files are accepted',
        button_label: 'Add files',
        multiple: true,
        accept: ['.pdf', '.doc', '.docx']
      )
    end

    def drop_container
      render Carbon::FileUploaderComponent.new(
        label_title: 'Upload files',
        label_description: 'Drag and drop files here or click to upload',
        button_label: 'Drag and drop files here or click to upload',
        drop_container: true,
        multiple: true,
        accept: ['.jpg', '.png', '.gif']
      )
    end

    def tertiary_button
      render Carbon::FileUploaderComponent.new(
        label_title: 'Upload files',
        label_description: 'Max file size is 500mb.',
        button_label: 'Add file',
        kind: :tertiary
      )
    end

    def disabled
      render Carbon::FileUploaderComponent.new(
        label_title: 'Upload files',
        label_description: 'File upload is currently disabled',
        button_label: 'Add file',
        disabled: true
      )
    end

    def small_size
      render Carbon::FileUploaderComponent.new(
        label_title: 'Upload files',
        button_label: 'Add file',
        size: :sm
      )
    end
  end
end
