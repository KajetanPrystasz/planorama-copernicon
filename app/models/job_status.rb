# == Schema Information
#
# Table name: job_statuses
#
#  id           :uuid             not null, primary key
#  lock_version :integer          default(0)
#  status       :string
#  submit_time  :datetime
#  type         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class JobStatus < ApplicationRecord
  validates_inclusion_of :status, in: %w[inprogress completed]
end
