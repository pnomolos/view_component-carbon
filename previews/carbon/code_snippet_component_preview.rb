# frozen_string_literal: true

module Carbon
  class CodeSnippetComponentPreview < ViewComponent::Preview
    # @param type select { choices: [single, multi, inline] }
    # @param code text
    # @param hide_copy_button toggle
    def default(type: :single, code: 'npm install carbon-components', hide_copy_button: false)
      render Carbon::CodeSnippetComponent.new(
        type: type.to_sym,
        code: code,
        hide_copy_button: hide_copy_button
      )
    end

    # @!group All Types

    def single
      render Carbon::CodeSnippetComponent.new(
        type: :single,
        code: 'npm install @carbon/react'
      )
    end

    def multi
      code = <<~CODE
        import { Button } from '@carbon/react';

        function MyComponent() {
          return (
            <div>
              <Button kind="primary">Click me</Button>
              <Button kind="secondary">Cancel</Button>
            </div>
          );
        }

        export default MyComponent;
      CODE

      render Carbon::CodeSnippetComponent.new(
        type: :multi,
        code: code.strip
      )
    end

    def inline
      render Carbon::CodeSnippetComponent.new(
        type: :inline,
        code: 'npm install'
      )
    end

    # @!endgroup

    def without_copy_button
      render Carbon::CodeSnippetComponent.new(
        code: 'npm start',
        hide_copy_button: true
      )
    end

    def multi_with_many_lines
      code = (1..30).map { |i| "Line #{i}: some code here" }.join("\n")

      render Carbon::CodeSnippetComponent.new(
        type: :multi,
        code: code
      )
    end

    def using_block_content
      render Carbon::CodeSnippetComponent.new do
        'git clone https://github.com/example/repo.git'
      end
    end

    def custom_expand_text
      code = <<~CODE
        const greeting = 'Hello, World!';
        console.log(greeting);

        function add(a, b) {
          return a + b;
        }

        const result = add(2, 3);
        console.log(result);
      CODE

      render Carbon::CodeSnippetComponent.new(
        type: :multi,
        code: code.strip,
        show_more_text: 'Expand code',
        show_less_text: 'Collapse code'
      )
    end
  end
end
