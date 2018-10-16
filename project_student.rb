require "cgi"

class ProjectStudent < ActiveRecord::Base
  belongs_to :project
  belongs_to :student

  after_save :save_evaluation

  before_create :set_token

  scope :recent, -> { order("evaluated_at DESC") }

  delegate :name, :email, to: :student

  validate :evaluation_student

  def display_name
    self.student.first_name.present? ?
      self.student.name : self.student.email
  end

  def initial_evaluation
    if self.student.first_name.present?
      "#{self.student.first_name}, "
    end
  end

  def grade?(grade, component)
    self.grades[component.id.to_s] == grade
  end

  def grades
    read_attribute(:grades) || {}
  end

  def all_grades
    [ "A+","A","A-","B+","B","B-","C+","C","D","F" ]
  end

  def save_evaluation
    if self.evaluation.present?
      Evaluation.generate_evaluation(self.evaluation,self.student.first_name)
    end
  end
  
 def evaluated_at
   Time.zone = "Eastern Time (US & Canada)"
   atr = read_attribute(:evaluated_at)
   atr.presence && atr.localtime(Time.zone.utc_offset)
  end

 def generate_mailto
   subject = CGI.escape("Your grade on #{self.project.name}").gsub("+","%20")

   body = <<-EOF
   Hi #{student.first_name},

   You can see your grade for #{self.project.name} here:

   #{grade_link}

   -Martha
   EOF


   body = CGI.escape(body).gsub("+","%20")
   "#{self.email}?subject=#{subject}&body=#{body}"
 end

 def grade_link
   "#{ENV['URL_BASE']}/grades/#{self.token}"
 end


 def set_token
   self.token =  SecureRandom.urlsafe_base64(64).gsub(/\-/,"")[0..16].downcase
 end

 def evaluation_student
   if evaluation.present? && evaluation.include?("STUDENT_NAME")
     self.errors.add(:evaluation,"is missing student name")
   end

   if !self.new_record? && grades.keys.length < project.components.length
     self.errors.add(:grades,"are missing")
   end
 end

end
