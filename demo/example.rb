require 'rack'
require_relative '../lib/controller/controller_base'
require_relative '../lib/router'
require_relative '../lib/static'
require_relative './app/controllers/dogs_controller'
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
