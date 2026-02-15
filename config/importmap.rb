# frozen_string_literal: true

# Pin Stimulus controllers from component sidecar directories.
# Each controller JS file (e.g. carbon/tabs_component/tabs_controller.js)
# is pinned as "controllers/carbon/<name>_controller" so Stimulus auto-discovers
# it for the "carbon--<name>" controller identifier.
Dir[File.expand_path('../app/components/carbon/**/*_controller.js', __dir__)].each do |path|
  controller_name = File.basename(path, '.js')
  relative_path = path.sub(%r{.*/app/components/}, '')
  pin "controllers/carbon/#{controller_name}", to: relative_path
end
