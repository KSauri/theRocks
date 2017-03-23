

class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    if req.params["_method"]
      return true if req.params["_method"].downcase.to_sym == @http_method
    end
    req.path =~ @pattern && req.request_method.downcase.to_sym == @http_method
  end

  def run(req, res)
    params = @pattern.match(req.path)
    route_params = {}
    params.names.each do |key|
      route_params[key] = params[key]
    end
    controller = @controller_class.new(req, res, route_params)
    controller.invoke_action(action_name)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
    self.instance_eval(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def match(req)
    @routes.each do |route|
      return route if route.matches?(req)
    end
    nil
  end

  def run(req, res)
    route = match(req)
    if route.nil?
      return res.status = 404
    end
    route.run(req, res)
  end
end
