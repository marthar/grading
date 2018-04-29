class Student < ActiveRecord::Base
  
  def name
    "#{first_name} #{last_name}".strip
  end

  def name=(val)
    names = val.to_s.split(" ")
    self.first_name = names[0]
    self.last_name = (names[1..-1]||[]).join(" ")
  end
end

