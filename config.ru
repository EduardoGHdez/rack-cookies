require 'rack'


class Application
  ROUTES = {
    '/': -> (_) do
      response = Rack::Response.new "Hello, World 👾", 200, { "Content-Type" => "text/plain; charset=UTF-8" }

      response.set_cookie("foo", {:value => "bar"})
      # response.set_cookie("foo", {:value => "bar", :path => "/"}) # Path
      # response.set_cookie("all-localhosts", { :value => 100, :domain => ".localhost." }) # Http vs Https
      response.set_header("Set-Cookie", "oreo=100; HttpOnly") # Http only
      # response.set_header("Set-Cookie", "pastitas=100; Secure") # Secure
      # Expires / Max-Age
      response.finish
    end,
  }

  def call(env)
    request = Rack::Request.new env
    serve_request(request)
  end

  private

  def serve_request(request)
    path = request.path.to_sym

    if ROUTES.keys.include? path
      ROUTES[path].call(request.params)
    else
      [404, { "Content-Type" => "text/plain; charset=UTF-8" }, ["Not Found 🛸"]]
    end
  end
end


app = Application.new

use Rack::Reloader, 0
#Rack::Handler.default.run(app, port: 3000)

run app
