require_relative '../../../lib/controller/controller_base'
require_relative '../../../lib/controller/session'
require_relative '../models/dog'

class DogsController < ControllerBase

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
