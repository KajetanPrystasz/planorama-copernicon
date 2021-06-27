class Survey::SubmissionsController < ResourceController
  MODEL_CLASS = 'Survey::Submission'.freeze
  POLICY_CLASS = 'SubmissionsPolicy'.freeze

  # TODO: create and update

  # TODO: need the survey id etc as a parameter to the collection/index method
  def belong_to_class
    Survey
  end

  def belongs_to_relationship
    'survey_submissions'
  end
end