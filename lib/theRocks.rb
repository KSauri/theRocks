require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'cgi'
require 'erb'
require 'json'
require 'pg'
require 'rack'
require 'uri'

require 'router'
require 'controller/controller_base'

module theRocks

  def self.app


    app = Proc.new do |env|
      req = Rack::Request.new(env)
      res = Rack::Response.new
      theRocks::Router.run(req, res)
      res.finish
    end

    Rack::Builder.new do
      use Static
      run app
    end
  end

  def self.root=(root)
    const_set(:ROOT, root)
  end

end
