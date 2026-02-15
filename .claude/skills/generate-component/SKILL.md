# Generate Component

Generate a complete Carbon Design System ViewComponent implementation.

## Usage

`/generate-component <ComponentName>`

Example: `/generate-component Accordion`

## Instructions

Given a Carbon component name, generate the full implementation by following these steps:

### 1. Research the Carbon component

Fetch the Carbon Design System documentation for the component:
- Usage: `https://carbondesignsystem.com/components/<name>/usage/`
- Accessibility: `https://carbondesignsystem.com/components/<name>/accessibility/`
- React API (for props reference): `https://react.carbondesignsystem.com/?path=/docs/components-<name>--overview`

Extract:
- All variants/kinds and their CSS classes
- Size options
- Required ARIA attributes and keyboard interactions
- Slot/child content patterns
- Props that map to HTML attributes

### 2. Read the reference component

Read `app/components/carbon/button_component.rb` and its sidecar files as the reference pattern. Follow the same structure exactly.

### 3. Create the Ruby component class

Create `app/components/carbon/<name>_component.rb`:
- Class: `Carbon::<Name>Component < Carbon::BaseComponent`
- Use keyword arguments in `initialize` for all props
- Validate enum values (kind, size, variant) against allowed constants
- Define ViewComponent slots for nested content where needed
- Accept `**system_arguments` for HTML attribute passthrough
- Use `carbon_class` helper for CSS class generation

### 4. Create the ERB template

Create `app/components/carbon/<name>_component/<name>_component.html.erb`:
- Use correct `cds--` prefixed CSS classes from `@carbon/styles`
- Include all required ARIA attributes
- Use `content` or named slots for child content
- Support both Stimulus and WebComponent render modes if applicable

### 5. Create a Stimulus controller (if interactive)

Create `app/components/carbon/<name>_component/<name>_controller.js`:
- Import from `@hotwired/stimulus`
- Implement keyboard navigation per Carbon accessibility docs
- Manage ARIA state changes
- Follow idiomatic Stimulus patterns (targets, values, actions)

### 6. Create tests

Create `test/components/carbon/<name>_component_test.rb`:
- Extend `CarbonViewComponents::TestCase`
- Test default rendering
- Test each variant/kind
- Test each size
- Test disabled state
- Test ARIA attributes
- Test slot content
- Test system_arguments passthrough

### 7. Create Lookbook preview

Create `previews/carbon/<name>_component_preview.rb`:
- Class: `Carbon::<Name>ComponentPreview < ViewComponent::Preview`
- Create a `default` preview method
- Create preview methods for each major variant
- Use Lookbook `@param` annotations for interactive controls

### 8. Verify

Run `bundle exec ruby -Itest test/components/carbon/<name>_component_test.rb` to verify all tests pass.
