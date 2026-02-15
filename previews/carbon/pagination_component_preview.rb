# frozen_string_literal: true

module Carbon
  class PaginationComponentPreview < ViewComponent::Preview
    # Default pagination
    # -----------------
    # Pagination with 100 items, page 1, 10 items per page
    def default
      render(Carbon::PaginationComponent.new(total_items: 100))
    end

    # On page five
    # ------------
    # Pagination on page 5 of 10
    def on_page_five
      render(Carbon::PaginationComponent.new(total_items: 100, page: 5, page_size: 10))
    end

    # Large page size
    # --------------
    # Pagination with 50 items per page
    def large_page_size
      render(Carbon::PaginationComponent.new(total_items: 500, page: 1, page_size: 50))
    end

    # Custom page sizes
    # ----------------
    # Pagination with custom page size options
    def custom_page_sizes
      render(Carbon::PaginationComponent.new(
               total_items: 250,
               page: 1,
               page_size: 25,
               page_sizes: [5, 25, 50, 100]
             ))
    end

    # Small dataset
    # ------------
    # Pagination with small number of items
    def small_dataset
      render(Carbon::PaginationComponent.new(total_items: 23, page: 1, page_size: 10))
    end

    # Disabled
    # -------
    # Disabled pagination controls
    def disabled
      render(Carbon::PaginationComponent.new(total_items: 100, disabled: true))
    end

    # Last page
    # --------
    # Pagination on the last page
    def last_page
      render(Carbon::PaginationComponent.new(total_items: 100, page: 10, page_size: 10))
    end
  end
end
