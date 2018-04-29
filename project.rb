require "./component"

class Project < ActiveRecord::Base

  has_many :project_students

  validates :course, presence: true
  validates :name, presence: true

  before_save :create_components
  after_save :create_students

  attr_accessor :student_emails

  def component_objects
    return @component_objects if @component_objects
    index = Component.where(id: self.components).index_by(&:id)
    @component_objects = components.map { |id| index[id] }.compact
  end

  def component_names
    @component_names || component_objects.map(&:name).join("\n")
  end

  def component_names=(val)
    @component_names = val
  end

  def create_components
    return unless @component_names
    self.components ||= []
    self.components += @component_names.split("\n").map(&:strip).map do |component_name|
      Component.create(name: component_name).id
    end
  end

  def create_students 
    return unless student_emails

    student_emails.split("\n").map(&:downcase).map(&:strip).each do |email|
      student = Student.where(email: email).first_or_create
      ProjectStudent.create(student: student, project: self)
    end
  end

end

