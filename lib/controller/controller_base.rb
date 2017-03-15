require 'active_support'
require 'active_support/inflector'
require 'active_support/core_ext'
require 'erb'
require_relative './flash'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res, route_params)
    @req = req
    @res = res
    @params = route_params.merge(@req.params)
  end

  def already_built_response?
    @already_built_response
  end

  def redirect_to(url)
    @res.set_header('location', url)
    @res.status = 302
    session.store_session(@res)

    raise "double render error" if already_built_response?
    @already_built_response = true
  end

  def render_content(content, content_type)
    @res['Content-Type'] = content_type
    @res.write content
    raise "double render error" if already_built_response?
    @already_built_response = true
    session.store_session(@res)
  end

  def render(template_name)
    path = "./app/views/#{self.class.to_s.underscore}/#{template_name}.html.erb"
    content = File.read(path)
    content = ERB.new(content).result(binding)
    render_content(content, 'text/html')
  end

  def session
    @session ||= Session.new(@req)
  end

  def invoke_action(name)
    self.send(name)
    render(name) unless already_built_response?
  end
end
