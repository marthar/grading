require "dotenv/load"
require "haml"
require 'sinatra'
require "pg"
require "sinatra/activerecord"
require 'active_support/all'
require "sinatra/json"
require 'nlp_pure/segmenting/default_sentence'
require "sinatra/reloader" if development?

require "./component"
require "./project"
require "./student"
require "./project_student"
require "./evaluation"

Time.zone = "Eastern Time (US & Canada)"


class Admin < Sinatra::Base

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

  post "/projects/:id" do
    @project = Project.find(params[:id])

    if params[:component]
      params[:component].each do |key,pieces|
        Component.find(key).update(pieces)
      end
    end 

    @project.update(params[:project])
    redirect "/admin/project/#{params[:id]}"
  end

  get '/project/:id/:student_id' do
    @project = Project.find(params[:id])
    @student = ProjectStudent.find(params[:student_id])
    haml :student
  end

  post '/project/:id/:student_id' do
    @project = Project.find(params[:id])
    @student = ProjectStudent.find(params[:student_id])
    @student.student.update(params[:student])

    @student.attributes = params[:project_student]
    @student.evaluated_at ||= Time.now

    if  @student.save
      redirect "/admin/project/#{params[:id]}"
    else

      haml :student
    end
  end

  post '/evaluations' do
    @student = Student.find(params[:student_id])
    @evaluations = Evaluation.match(params[:evaluation], @student.first_name)
    haml :evaluations, layout: false
  end

  get '/projects/new' do
    @project = Project.new
    haml :new_project
  end


  post '/projects' do
    @project = Project.new(params[:project])
    if @project.save
      redirect "/admin/project/#{@project.id}"
    else
      haml :new_project
    end
  end



end

class Grades < Sinatra::Base

  get '/grades/:token' do
    @student = ProjectStudent.where(token: params[:token].to_s).first
    @project = @student.project if @student
    haml :grades
  end

end

