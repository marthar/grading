require "./component"

class Project < ActiveRecord::Base
  attr_accessor :student_emails

  has_many :project_students

  validates :course, presence: true
  validates :name, presence: true

  before_create :create_components
  after_create :create_students

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
    self.components = @component_names.split("\n").map(&:strip).map do |component_name|
      Component.where(name: component_name).first_or_create.id
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

