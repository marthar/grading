class Evaluation < ActiveRecord::Base
  attr_accessor :full_evaluation

  def self.match(evaluation, first_name)
    evaluation_text = strip_evaluation(evaluation,first_name)

    evaluation_text << "." unless evaluation_text.last == "."

    all_sentences = sentences(evaluation_text)

    last_sentence = all_sentences.last
    last_sentence_text= self.connection.quote(last_sentence)
    evaluations = Evaluation.where("similarity(evaluation,#{last_sentence_text}) > 0.03")
               .order("similarity(evaluation,#{last_sentence_text}) desc").limit(10)

    evaluations.each do |evaluation|
      if first_name.present?
        evaluation.evaluation = unstrip_evaluation(evaluation.evaluation,first_name)
        evaluation.full_evaluation =  unstrip_evaluation(((all_sentences[0..-2]||[]) + [ evaluation.evaluation ]).join(" "), first_name)
      end
    end
    evaluations
  end

  def self.sentences(str)
    NlpPure::Segmenting::DefaultSentence.parse(str)
  end

  def self.strip_evaluation(evaluation,first_name)
    return evaluation unless first_name.present?
    evaluation.gsub(/\b#{Regexp.quote(first_name)}\b/,"STUDENT_NAME")
  end

  def self.unstrip_evaluation(evaluation,first_name)
    evaluation.gsub("STUDENT_NAME",first_name)
  end

  def self.generate_evaluation(evaluation, first_name)
    sentences(strip_evaluation(evaluation,first_name)).each do |sentence|
      Evaluation.where(evaluation: sentence).first_or_create
    end
  end

end
