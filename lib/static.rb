class Static
  attr_reader :app, :root, :content_server

  def initialize(app)
    @app = app
    @root = :public
    @content_server = ContentServer.new(@root)
  end

  def call(env)
    req = Rack::Request.new(env)
    path = req.path
    if servable?(path)
      res = content_server.call(env)
    else
      res = app.call(env)
    end

    res
  end

  private

  def servable?(path)
    path.index("/#{root}")
  end
end


class ContentServer

  MIME_TYPES = {
    '.txt' => 'text/plain',
    '.jpg' => 'image/jpeg',
    '.zip' => 'application/zip',
    '.gif' => 'image/gif',
    '.css' => 'text/css',
    '.js' => 'text/javascript'
  }

  def initialize(root)
    @root = root
  end

  def call(env)
    res = Rack::Response.new
    file_name = req_file_name(env)
    if File.exist?(file_name)
      serve_file(file_name, res)
    else
      res.status = 404
      res.write("Content not found")
    end
    res
  end

  private

  def req_file_name(env)
    req = Rack::Request.new(env)
    path = req.path
    dir = File.dirname(__FILE__)
    File.join(dir, '..', path)
  end

  def serve_file(file_name, res)
    ext = File.extname(file_name)
    content_type = MIME_TYPES[ext]
    file = File.read(file_name)
    res["Content-type"] = content_type
    res.write(file)
  end

end
