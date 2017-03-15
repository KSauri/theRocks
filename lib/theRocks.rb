require 'rack'
require_relative 'controller/controller_base'
require_relative 'router'
require_relative 'static'
require_relative '../config/routes'

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  ROUTER.run(req, res)
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
