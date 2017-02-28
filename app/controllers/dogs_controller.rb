require_relative '../../lib/controller/controller_base'
require_relative '../../lib/controller/session'

class DogsController < ControllerBase

  DOGS = ["http://stories.barkpost.com/wp-content/uploads/2013/02/tumblr_mbl5larwCV1qdoqhwo1_500.gif",
    "http://stories.barkpost.com/wp-content/uploads/2013/02/tumblr_mahffvX0He1r2gqh6o1_500.gif",
    "http://s3.amazonaws.com/barkpost-assets/50+GIFs/37.gif",
    "http://www.doggifpage.com/gifs/143.gif"]

  def index
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
