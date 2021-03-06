require 'json'

class SubmissionsController < ApplicationController
  respond_to :json

  def update
    @submission = Submission.find(params[:id])
    @submission.update(correct: params[:submission][:correct], responded_to: params[:submission][:responded_to] )
    $redis.publish('update', 'something has changed')
    respond_with @submission, location: nil
  end

  def create
    @team = Team.find(params[:team_id])
    if Submission.create(attachment: params[:attachment], team_id: params[:team_id], location_id: params[:location_id])
      $redis.publish('update', 'something has changed')
      redirect_to team_path(@team)
    else
      flash[:errors] = "Something went terribly wrong."
      redirect_to team_path(@team)
    end
  end

  def index
    respond_with Submission.where(responded_to: false)
  end

  def latest_submission
    team = Team.find(params[:team_id][:team_id])
    respond_with team.submissions.where(correct: true).last
  end

  def update_accept
    accept = Team.find_by!(slug: params[:slug]).submissions.last.update(accepted: true)
    $redis.publish('update', 'something has changed')
    respond_with accept
  end
  
  private

  def submission_params
    params.require(:submission).permit(:team_id,
                                       :location_id,
                                       :attachment)
  end
end
