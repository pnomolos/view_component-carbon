# Carbon ViewComponents

## Active Plan

There is an active implementation plan at `PLAN.md` in the project root. This file describes the full phased build-out of the `carbon_view_components` gem — a Rails Engine implementing IBM's Carbon Design System as ViewComponents.

**Current status: Phase 1 — complete. Phase 2 next (reference Button component).**

As each phase is completed, update this CLAUDE.md to reflect:
- The current phase in progress
- Conventions and patterns established by completed phases
- Any decisions made at human checkpoints that refine the plan

## Stack

- Ruby gem / Rails Engine (`carbon_view_components`)
- ViewComponent 3.x+, Rails 7.2+
- Styles: `@carbon/styles` via `dartsass-rails` + Propshaft
- Interactivity: Stimulus controllers (primary), `@carbon/web-components` (optional)
- Testing: Minitest + Capybara matchers, Playwright MCP for a11y
- Previews: Lookbook
- Package manager: `pnpm` (not npm or yarn)

## Component Conventions

- All components live in `app/components/carbon/`
- Class names: `Carbon::<Name>Component` (e.g., `Carbon::ButtonComponent`)
- Files: `carbon/<name>_component.rb` + sidecar directory
- Sidecar: `carbon/<name>_component/<name>_component.html.erb`
- Stimulus: `carbon/<name>_component/<name>_controller.js`
- Tests: `test/components/carbon/<name>_component_test.rb`
- Previews: `previews/carbon/<name>_component_preview.rb`

## CSS Class Convention

- Use Carbon's `cds--` prefix: `cds--btn`, `cds--accordion`, etc.
- Use `BaseComponent#carbon_class` helper for consistent class generation
- Never write custom CSS — use `@carbon/styles` classes only

## Component API Pattern

- Use keyword arguments in `initialize` (`kind:`, `size:`, `disabled:`, etc.)
- Use ViewComponent slots for nested content
- All components accept `**system_arguments` for HTML attributes
- Validate `kind`/`size`/`variant` against allowed values
- Include ARIA attributes per Carbon's accessibility docs

## Interactivity

- Default: Stimulus controllers in sidecar JS files
- WebComponent mode: render `<cds-*>` custom elements instead of HTML
- Mode set via `Carbon::BaseComponent.interactivity_mode = :stimulus | :webcomponent`

## Commands

- Run tests: `bundle exec rake test`
- Run single test: `bundle exec ruby -Itest test/components/carbon/<name>_component_test.rb`
- Run rubocop: `bundle exec rubocop`
- Install deps: `bundle install && pnpm install`

## Key References

- Implementation plan: `PLAN.md`
- Carbon Design System: https://carbondesignsystem.com
- Carbon React (API reference): https://react.carbondesignsystem.com
- ViewComponent docs: https://viewcomponent.org

## Reference Docs (fetch when implementing a component)

- Usage: `https://carbondesignsystem.com/components/<name>/usage/`
- Accessibility: `https://carbondesignsystem.com/components/<name>/accessibility/`
- React API: `https://react.carbondesignsystem.com/?path=/docs/components-<name>--overview`
