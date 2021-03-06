module SearchesHelper

  def result_link(result)
    if result.class == User
      result.email
    elsif result.class == Question
      result.title
    elsif result.class == Answer
      result.question.title
    elsif result.class == Comment
      if result.commentable_type == 'Question'
        Question.find(result.commentable_id).title
      elsif result.commentable_type == 'Answer'
        answer = Answer.find(result.commentable_id)
        answer.question.title
      end
    end
  end


  def result_path(result)
    if result.class == User || result.class == Question
      result
    elsif result.class == Answer
      result.question
    elsif result.class == Comment
      if result.commentable_type == 'Question'
        Question.find(result.commentable_id)
      elsif result.commentable_type == 'Answer'
        answer = Answer.find(result.commentable_id)
        answer.question
      end
    end
  end


end
