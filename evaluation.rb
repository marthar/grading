class Evaluation < ActiveRecord::Base

  def self.match(evaluation)
    name, evaluation_text = strip_evaluation(evaluation)
    evaluation_text = self.connection.quote(evaluation_text)
    evaluations = Evaluation.where("similarity(evaluation,#{evaluation_text}) > 0.03")
               .order("similarity(evaluation,#{evaluation_text}) desc").limit(6)

    evaluations.each do |evaluation|
      if name 
        evaluation.evaluation = "#{name} #{evaluation.evaluation.strip}"
      end
    end
    evaluations
  end

  def self.strip_evaluation(evaluation)
    if evaluation =~ /^([A-Za-z]+,)(.*)/
      return [ $1, $2 ]
    else
      return [ nil, evaluation ]
    end
  end

  def self.generate_evaluation(evaluation)
    name, evaluation_text = strip_evaluation(evaluation)
    evaluation_text = evaluation_text.strip
    Evaluation.where(evaluation: evaluation_text).first_or_create
  end

end
