require 'json'

class SubmissionsController < ApplicationController
  respond_to :json
  
  def update
    @submission = Submission.find(params[:submission][:submission_id])
    @submission.update(correct: params[:submission][:correct])
    respond_with @submission, location: nil
  end
  
  def create
    respond_with Submission.create(submission_params), location: nil
  end
  
  def index
    respond_with Submission.where(responded_to: false)
  end
  
  def latest_submission
    team = Team.find(params[:team_id][:team_id])
    respond_with team.submissions.where(correct: true).last
  end
  
  private
  
  def submission_params
    params.require(:submission).permit(:team_id, 
                                       :location_id, 
                                       :attachment)
  end
end
