require 'rack'
require_relative 'controller/controller_base'
require_relative 'router'
require_relative 'static'

class TestController < ControllerBase
  def go
    render_content("this is a test", "text/plain")
  end
end

router = Router.new
router.draw do
  get Regexp.new("^/$"), TestController, :go
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

app = Rack::Builder.new do
  use Static
  run app
end.to_app

Rack::Server.start(
  app: app,
  Port: 8080
)
