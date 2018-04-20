require "dotenv/load"
require 'sinatra'

use Rack::Auth::Basic, "Restricted Area" do |username, password|
  username == 'martha' and password == ENV['PASSWORD']
end

get '/' do
  send_file File.expand_path('index.html', settings.public_folder)
end
