# frozen_string_literal: true

require 'test_helper'
require 'generators/carbon_view_components/install_generator'

class InstallGeneratorTest < Rails::Generators::TestCase
  tests CarbonViewComponents::Generators::InstallGenerator
  destination File.expand_path('../tmp/generator_test', __dir__)

  setup do
    prepare_destination
    FileUtils.mkdir_p(File.join(destination_root, 'config'))
    File.write(File.join(destination_root, 'config/importmap.rb'), "# importmap\n")
  end

  test 'creates stylesheet if missing' do
    run_generator

    assert_file 'app/assets/stylesheets/application.scss', %r{@use '@carbon/styles'}
  end

  test 'appends importmap configuration' do
    run_generator

    assert_file 'config/importmap.rb', /Carbon ViewComponents Stimulus controllers/
  end
end
