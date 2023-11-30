# == Schema Information
#
# Table name: survey_responses
#
#  id               :uuid             not null, primary key
#  lock_version     :integer          default(0)
#  response         :jsonb
#  response_as_text :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  question_id      :uuid             not null
#  submission_id    :uuid             not null
#
# Indexes
#
#  index_survey_responses_on_submission_id  (submission_id)
#  survey_resp_question_idx                 (question_id)
#
# Foreign Keys
#
#  fk_rails_...  (submission_id => survey_submissions.id)
#
class Survey::Response < ApplicationRecord
  belongs_to :question,
             class_name: 'Survey::Question',
             foreign_key: 'question_id'

  belongs_to :submission,
             class_name: 'Survey::Submission',
             foreign_key: 'submission_id',
             inverse_of: :responses

  before_save :set_response_text
  after_save :update_linked

  attr_accessor :check_update_linked

  #
  # Deal with linked_field from question
  #
  def update_linked
    if question.linked_field && submission.person && response
      # we can set the linked field on the person
      details = question.linked_field.split('.',2)

      # TODO: if yesnomaybe we need to set the exception attr as well ...
      if details[0] == 'Person'
        exception_val = nil
        val = case question.question_type
              when :textfield
                response['text']
              when :textbox
                response['text']
              when :email
                response['email']
              when :socialmedia
                response['socialmedia']
              when :boolean
                response['answers'].first.to_s.downcase == "true"
              when :yesnomaybe
                response['answers'].first
              when :attendance_type
                response['answers'].first
              else
                nil
              end

        submission.person.reload
        Rails.logger.debug("submission.person #{submission.person.id} #{submission.person.lock_version}")
        if question.question_type == :yesnomaybe
          # Yes not maybe and attendance should only have one answer
          exception_val = response['text']

          if exception_val
            if check_update_linked
              existing = submission.person.send("#{details[1]}_exceptions")
              return if !existing.blank?
            end
            submission.person.send("#{details[1]}_exceptions=", exception_val)
          end
        end

        # Rails.logger.debug "***** GOING TO SET person linked field #{details[1]} with #{val}"
        if val
          if question.question_type == :socialmedia
            submission.person.twitter = val['twitter']
            submission.person.facebook = val['facebook']
            submission.person.linkedin = val['linkedin']
            submission.person.twitch = val['twitch']
            submission.person.youtube = val['youtube']
            submission.person.instagram = val['instagram']
            submission.person.tiktok = val['tiktok']
            submission.person.othersocialmedia = val['other']
            submission.person.website = val['website']
          else
            if check_update_linked
              existing = submission.person.send("#{details[1]}")
              return if !existing.blank?
            end
            submission.person.send("#{details[1]}=", val)
          end
          submission.person.save!
        end
      end
    end
  end

  # TODO: this may not be needed
  # def get_linked
  #   if question.linked_field && submission.person
  #     # TODO
  #     # we can get the linked field on the person and set the value accordingly
  #   end
  # end

  def self.create_response(question:, submission:, value:, check_update_linked: false)
    # TODO: some conditional check in here???
    json_val = empty_json
    case question.question_type
         when :textfield
           json_val[:text] = value
         when :textbox
           json_val[:text] = value
         when :singlechoice
           json_val[:answers] = value
         when :multiplechoice
           json_val[:answers] = value
         when :dropdown
           json_val[:answers] = value
         when :socialmedia
           json_val[:socialmedia] = value
         when :boolean
           json_val[:answers] = value
         when :yesnomaybe
           json_val[:answers] = value[:value]
           json_val[:text] = value[:text]
         when :email
           json_val[:answers] = value
         # when :textonly, :hr are not actual questions
         when :attendance_type
           json_val[:answers] = value
         else
           json_val = nil
         end

    if json_val
      # p "****** SET RES #{json_val}"
      Survey::Response.create!(
        question: question,
        submission: submission,
        response: json_val,
        check_update_linked: check_update_linked
      )
    end
  end

  #
  # Extract the values from all the entries and save a plain text
  # version that can be used for searchin the responses in a "report"
  #
  def set_response_text
    if response
      flattened_response = flatten_response(response)

      strip_uuid = [:singlechoice, :multiplechoice].include?(question.question_type)
      if strip_uuid
        self.response_as_text = flattened_response.values.flatten.collect{|v| v[37..-1]}.reject { |e| e.to_s.empty? }.join('; ').strip
      else
        self.response_as_text = flattened_response.values.join(' ').strip
      end
    end
  end

  #
  def flatten_response(hash)
    hash.each_with_object({}) do |(k, v), h|
      if v.is_a? Hash
        flatten_response(v).map do |h_k, h_v|
          if k == 'socialmedia'
            h["#{k}.#{h_k}".to_sym] = "#{h_k}:#{h_v}" unless h_v.blank?
          else
            h["#{k}.#{h_k}".to_sym] = h_v unless h_v.blank?
          end
        end
      else
        h[k] = v
      end
    end
  end

  private

  def self.empty_json
    {
      text: "",
      answers: [],
      socialmedia: {
        twitter: nil, facebook: nil, linkedin: nil, twitch: nil, youtube: nil, instagram: nil, tiktok: nil, other: nil, website: nil
      }
    }
  end
end
