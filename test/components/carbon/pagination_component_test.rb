# frozen_string_literal: true

require 'test_helper'

module Carbon
  class PaginationComponentTest < CarbonViewComponents::TestCase
    test 'renders default pagination' do
      render_inline(Carbon::PaginationComponent.new(total_items: 100))

      assert_selector '.cds--pagination'
    end

    test 'renders items per page label' do
      render_inline(Carbon::PaginationComponent.new(total_items: 100))

      assert_selector '.cds--pagination__text', text: 'Items per page:'
    end

    test 'renders page size select' do
      render_inline(Carbon::PaginationComponent.new(total_items: 100))

      assert_selector 'select.cds--select-input'
    end

    test 'renders default page sizes' do
      render_inline(Carbon::PaginationComponent.new(total_items: 100))

      assert_selector 'select option[value="10"]'
      assert_selector 'select option[value="20"]'
      assert_selector 'select option[value="50"]'
    end

    test 'renders custom page sizes' do
      render_inline(Carbon::PaginationComponent.new(total_items: 100, page_sizes: [5, 15, 25]))

      assert_selector 'select option[value="5"]'
      assert_selector 'select option[value="15"]'
      assert_selector 'select option[value="25"]'
    end

    test 'selects current page size' do
      render_inline(Carbon::PaginationComponent.new(total_items: 100, page_size: 20))

      assert_selector 'select option[value="20"][selected]'
    end

    test 'renders item range' do
      render_inline(Carbon::PaginationComponent.new(total_items: 100, page: 1, page_size: 10))

      assert_selector '.cds--pagination__text', text: '1-10 of 100 items'
    end

    test 'calculates correct item range for page 2' do
      render_inline(Carbon::PaginationComponent.new(total_items: 100, page: 2, page_size: 10))

      assert_selector '.cds--pagination__text', text: '11-20 of 100 items'
    end

    test 'calculates correct item range for last partial page' do
      render_inline(Carbon::PaginationComponent.new(total_items: 95, page: 10, page_size: 10))

      assert_selector '.cds--pagination__text', text: '91-95 of 95 items'
    end

    test 'renders page display' do
      render_inline(Carbon::PaginationComponent.new(total_items: 100, page: 1, page_size: 10))

      assert_selector '.cds--pagination__text', text: 'Page 1 of 10'
    end

    test 'calculates total pages correctly' do
      render_inline(Carbon::PaginationComponent.new(total_items: 100, page_size: 10))

      assert_selector '.cds--pagination__text', text: 'Page 1 of 10'
    end

    test 'calculates total pages with partial page' do
      render_inline(Carbon::PaginationComponent.new(total_items: 95, page_size: 10))

      assert_selector '.cds--pagination__text', text: 'Page 1 of 10'
    end

    test 'renders previous page button' do
      render_inline(Carbon::PaginationComponent.new(total_items: 100))

      assert_selector 'button.cds--pagination__button--backward[aria-label="Previous page"]'
    end

    test 'renders next page button' do
      render_inline(Carbon::PaginationComponent.new(total_items: 100))

      assert_selector 'button.cds--pagination__button--forward[aria-label="Next page"]'
    end

    test 'previous button disabled on first page' do
      render_inline(Carbon::PaginationComponent.new(total_items: 100, page: 1))

      assert_selector 'button.cds--pagination__button--backward[disabled]'
    end

    test 'previous button enabled on second page' do
      render_inline(Carbon::PaginationComponent.new(total_items: 100, page: 2))

      assert_no_selector 'button.cds--pagination__button--backward[disabled]'
    end

    test 'next button disabled on last page' do
      render_inline(Carbon::PaginationComponent.new(total_items: 100, page: 10, page_size: 10))

      assert_selector 'button.cds--pagination__button--forward[disabled]'
    end

    test 'next button enabled when not on last page' do
      render_inline(Carbon::PaginationComponent.new(total_items: 100, page: 1, page_size: 10))

      assert_no_selector 'button.cds--pagination__button--forward[disabled]'
    end

    test 'renders disabled pagination' do
      render_inline(Carbon::PaginationComponent.new(total_items: 100, disabled: true))

      assert_selector 'select[disabled]'
      assert_selector 'button.cds--pagination__button--backward[disabled]'
      assert_selector 'button.cds--pagination__button--forward[disabled]'
    end

    test 'has Stimulus controller' do
      render_inline(Carbon::PaginationComponent.new(total_items: 100))

      assert_selector '.cds--pagination[data-controller="carbon--pagination"]'
    end

    test 'has Stimulus values' do
      render_inline(Carbon::PaginationComponent.new(total_items: 100, page: 2, page_size: 20))

      assert_selector '[data-carbon--pagination-total-items-value="100"]'
      assert_selector '[data-carbon--pagination-page-value="2"]'
      assert_selector '[data-carbon--pagination-page-size-value="20"]'
    end

    test 'select has Stimulus action and target' do
      render_inline(Carbon::PaginationComponent.new(total_items: 100))

      assert_selector 'select[data-action="change->carbon--pagination#changePageSize"]'
      assert_selector 'select[data-carbon--pagination-target="pageSizeSelect"]'
    end

    test 'buttons have Stimulus actions' do
      render_inline(Carbon::PaginationComponent.new(total_items: 100))

      assert_selector 'button.cds--pagination__button--backward[data-action="click->carbon--pagination#prevPage"]'
      assert_selector 'button.cds--pagination__button--forward[data-action="click->carbon--pagination#nextPage"]'
    end

    test 'passes through system arguments' do
      render_inline(Carbon::PaginationComponent.new(total_items: 100, id: 'my-pagination'))

      assert_selector '.cds--pagination#my-pagination'
    end

    test 'merges custom class with component classes' do
      render_inline(Carbon::PaginationComponent.new(total_items: 100, class: 'custom-class'))

      assert_selector '.cds--pagination.custom-class'
    end
  end
end
