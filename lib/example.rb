require 'rack'
require_relative 'controller/controller_base'
require_relative 'router'
require_relative 'static'
require_relative '../app/controllers/dogs_controller'

router = Router.new
router.draw do
  get Regexp.new("^/dogs$"), DogsController, :index
  get Regexp.new("^/dogs/new$"), DogsController, :new
  delete Regexp.new("^/dogs$"), DogsController, :destroy
  post Regexp.new("^/dogs$"), DogsController, :create
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
