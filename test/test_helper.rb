# frozen_string_literal: true

ENV['RAILS_ENV'] = 'test'

require_relative '../test/dummy/config/environment'

require 'rails/test_help'
require 'view_component/test_helpers'
require 'view_component/test_case'
require 'capybara/minitest'

module CarbonViewComponents
  class TestCase < ViewComponent::TestCase
    include ViewComponent::TestHelpers
    include Capybara::Minitest::Assertions
  end
end
