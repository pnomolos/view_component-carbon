# Carbon ViewComponents

## Active Plan

There is an active implementation plan at `PLAN.md` in the project root. This file describes the full phased build-out of the `carbon_view_components` gem — a Rails Engine implementing IBM's Carbon Design System as ViewComponents.

**Current status: Phase 0 — not yet started.**

As each phase is completed, update this CLAUDE.md to reflect:
- The current phase in progress
- Conventions and patterns established by completed phases
- Any decisions made at human checkpoints that refine the plan

## Project Overview

- **Gem name**: `carbon_view_components`
- **Purpose**: ViewComponent implementations of IBM's Carbon Design System for Rails
- **Interactivity**: Dual-mode — Stimulus controllers (primary) or WebComponents (optional)
- **Styles**: `@carbon/styles` via `dartsass-rails` + Propshaft
- **Testing**: Minitest + Capybara matchers, Playwright MCP for a11y
- **Previews**: Lookbook

## Key References

- Implementation plan: `PLAN.md`
- Carbon Design System: https://carbondesignsystem.com
- Carbon React (API reference): https://react.carbondesignsystem.com
- ViewComponent docs: https://viewcomponent.org
