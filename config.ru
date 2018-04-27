require "./server.rb"
require 'rack-proxy'
require 'sass/plugin/rack'

Sass::Plugin.options[:style] = :compressed
use Sass::Plugin::Rack

class AppProxy < Rack::Proxy
  def rewrite_env(env)
    env["HTTP_HOST"] = "localhost:8080"
    env
  end
end

run Rack::URLMap.new(
  '/' => Sinatra::Application,
  '/assets' => AppProxy.new
)
