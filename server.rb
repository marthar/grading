require "dotenv/load"
require "haml"
require 'sinatra'
require "pg"
require "sinatra/activerecord"
require "sinatra/json"
require "sinatra/reloader" if development?

require "./project"

#set :database, { "adapater" "database.yml"

use Rack::Auth::Basic, "Restricted Area" do |username, password|
  username == 'martha' and password == ENV['PASSWORD']
end

get '/' do
  haml :index
end

get '/project/:id' do

end

get '/project/:id/:student' do

end


get '/projects/new' do
  @project = Project.new
  haml :new_project
end


post '/projects' do
  
end


get '/:token' do

end

