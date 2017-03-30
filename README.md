theRocks
=====

theRocks is a lightweight and agile framework that allows you
to route HTTP requests and generate HTTP responses easily.  theRocks was
inspired by Rails (Ruby on theRocks) and has a simple to use
interface so your app can get off the ground and onto theRocks!

How To See theRocks in Action!
-------

1. Clone this repo
2. Run 'ruby lib/example'
3. Navigate to `http://localhost:8080/dogs`
4. Interact with and create new Dog GIFs!

Key Features
--------

## theRocks Controller

### Controller methods

All controllers that inherit from ControllerBase have access to:

 - `render(template_name)` Finds and renders a template located in the
  `app/views/< controller_name >` folder
 - `render_content(content, content_type)` gives users access to rendering
  of content with a specified 'content_type'
 - `redirect_to(url)` allows users to redirect to the given URL
 - `session` allows getter and setter methods to the session cookie
 - `flash` and `flash.now` allow users to render errors during the
  current HTTP lifecycle that can persist for an additional HTTP
  lifecycle

### Creating a new Controller

Open the 'controllers' folder located in 'app', and use the
snake_case naming convention to create a new controller.  An example
would be 'dogs_controller.rb' - theRocks will rely on naming conventions
to find the proper views so please be consistent!

You will need to `require_relative '../../lib/controller/controller_base'`
in each of your controllers so you have access to all the functionality
of the controller.  

As an example, say you have an index of 'todos' that you want to render.
Much like Rails, you will first fetch that list from a database,
or for a lightweight prototype, use the session for persistence.
Then, give the fetched todos a ruby instance variable name, like
`@todos` and designate the view you want to render - `render :index`.

For views requiring the `params` object, theRocks provides
access to the same object in every controller.  

theRocks does much of the work of routing and inferring which router
you want to use.

### Example Usage

```ruby
require_relative '../../lib/controller/controller_base'
require_relative '../../lib/controller/session'

class DogsController < ControllerBase

  DOGS = ["http://stories.barkpost.com/wp-content/uploads/2013/02/tumblr_mbl5larwCV1qdoqhwo1_500.gif",
    "http://stories.barkpost.com/wp-content/uploads/2013/02/tumblr_mahffvX0He1r2gqh6o1_500.gif",
    "http://s3.amazonaws.com/barkpost-assets/50+GIFs/37.gif",
    "http://www.doggifpage.com/gifs/143.gif"]

  def index # For lightweight persistence, the session cookie is used
    @dogs = session["dogs"] ? DOGS + (session["dogs"]) : DOGS  
    render :index
  end

  def new
    render :new
  end

  def create
    if session["dogs"]
      session["dogs"].push(params["dog"]["url"])
    else
      session["dogs"] = [params["dog"]["url"]]
    end
    redirect_to "/dogs"
  end

  def destroy
    session["dogs"].delete(params["dog"]["url"])
    redirect_to "/dogs"
  end
end
```

### Creating a new View

Once in the view, you will have access to any instance variables you
declared in your controller.  theRocks integrates Ruby's ERB,
so you can use `<% %>` and `<%= %>` methods in your views.

## theRocks Router

### Route Mapping

theRocks' `router` allows users to designate their routes using
Regex:

```ruby
ROUTER = Router.new

ROUTER.draw do
  get Regexp.new("^/dogs$"), DogsController, :index
  get Regexp.new("^/dogs/new$"), DogsController, :new
  delete Regexp.new("^/dogs$"), DogsController, :destroy
  post Regexp.new("^/dogs$"), DogsController, :create
end
```

### Additional Middleware

 - `Static` allows for rendering of static assets in the /public folder.
  Currently, theRocks is compatible with .jpg, .png, and .png

## Future Features

 - Attach an ORM for easy database interaction
 - Package theRocks as a gem
