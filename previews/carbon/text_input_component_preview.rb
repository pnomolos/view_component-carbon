# frozen_string_literal: true

module Carbon
  class TextInputComponentPreview < ViewComponent::Preview
    # @param label_text text
    # @param placeholder text
    # @param size select { choices: [sm, md, lg] }
    # @param disabled toggle
    # @param readonly toggle
    def default(label_text: 'Username', placeholder: 'Enter username', size: :md, disabled: false,
                readonly: false)
      render Carbon::TextInputComponent.new(
        label_text: label_text,
        placeholder: placeholder,
        size: size.to_sym,
        disabled: disabled,
        readonly: readonly,
        name: 'username'
      )
    end

    def with_helper_text
      render Carbon::TextInputComponent.new(
        label_text: 'Email address',
        name: 'email',
        type: :email,
        helper_text: 'We will never share your email with anyone',
        placeholder: 'you@example.com'
      )
    end

    def invalid
      render Carbon::TextInputComponent.new(
        label_text: 'Password',
        name: 'password',
        type: :password,
        invalid: true,
        invalid_text: 'Password must be at least 8 characters',
        value: 'short'
      )
    end

    def warning
      render Carbon::TextInputComponent.new(
        label_text: 'Website URL',
        name: 'url',
        type: :url,
        warn: true,
        warn_text: 'This URL does not use HTTPS',
        value: 'http://example.com'
      )
    end

    def with_character_counter
      render Carbon::TextInputComponent.new(
        label_text: 'Tweet',
        name: 'tweet',
        placeholder: 'What\'s happening?',
        max_count: 280,
        helper_text: 'Share your thoughts'
      )
    end

    def small_size
      render Carbon::TextInputComponent.new(
        label_text: 'Small input',
        size: :sm,
        placeholder: 'Small'
      )
    end

    def large_size
      render Carbon::TextInputComponent.new(
        label_text: 'Large input',
        size: :lg,
        placeholder: 'Large'
      )
    end

    def password_type
      render Carbon::TextInputComponent.new(
        label_text: 'Password',
        name: 'password',
        type: :password,
        placeholder: 'Enter password'
      )
    end

    def disabled
      render Carbon::TextInputComponent.new(
        label_text: 'Disabled input',
        disabled: true,
        value: 'Cannot edit this'
      )
    end

    def readonly
      render Carbon::TextInputComponent.new(
        label_text: 'Read-only input',
        readonly: true,
        value: 'This is read-only'
      )
    end
  end
end
