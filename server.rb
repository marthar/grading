require "dotenv/load"
require "haml"
require 'sinatra'
require "pg"
require "sinatra/activerecord"
require 'active_support/all'
require "sinatra/json"
require "sinatra/reloader" if development?

require "./component"
require "./project"
require "./student"
require "./project_student"
require "./evaluation"

Time.zone = "Eastern Time (US & Canada)"


use Rack::Auth::Basic, "Restricted Area" do |username, password|
  username == 'martha' and password == ENV['PASSWORD']
end

get '/' do
  @projects = Project.order("id DESC")
  haml :index
end

get '/project/:id' do
  @project = Project.find(params[:id])
  haml :project

end

get '/project/:id/:student_id' do
  @project = Project.find(params[:id])
  @student = ProjectStudent.find(params[:student_id])
  haml :student
end

post '/project/:id/:student_id' do
  @student = ProjectStudent.find(params[:student_id])
  @student.student.update(params[:student])

  @student.attributes = params[:project_student]
  @student.evaluated_at ||= Time.now
  @student.save
  
  redirect "/project/#{params[:id]}"
end

post '/evaluations' do
  @evaluations = Evaluation.match(params[:evaluation])
  haml :evaluations, layout: false
end

get '/projects/new' do
  @project = Project.new
  haml :new_project
end


post '/projects' do
  @project = Project.new(params[:project])
  if @project.save
    redirect "/project/#{@project.id}"
  else
    haml :new_project
  end
end


get '/:token' do

end

