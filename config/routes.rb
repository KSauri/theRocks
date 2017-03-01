ROUTER = Router.new

ROUTER.draw do
  get Regexp.new("^/dogs$"), DogsController, :index
  get Regexp.new("^/dogs/new$"), DogsController, :new
  delete Regexp.new("^/dogs$"), DogsController, :destroy
  post Regexp.new("^/dogs$"), DogsController, :create
end
