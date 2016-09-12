require 'test_helper'

class VestigeTest < Minitest::Test
  def test_passes_rack_linter
    app = Rack::Lint.new(Vestige::Rack.new(fake_app))
    env = Rack::MockRequest.env_for('/hello')
    app.call(env)
  end

  private

  def fake_app
    @app ||= lambda { |env| [200, { 'Content-Type' => 'text/plain' }, env['PATH_INFO']] }
  end
end
