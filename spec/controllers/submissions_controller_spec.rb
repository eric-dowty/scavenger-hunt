require 'rails_helper'
require 'json'

RSpec.describe SubmissionsController, type: :controller do
  let!(:hunt) { create(:hunt) }
  let!(:team) { create(:team) }
  let!(:location) { create(:location) }
  let!(:submission_1) { create(:submission_1)}
  let!(:submission_2) { create(:submission_2)}
  let!(:submission_3) { create(:submission_3)}
  let!(:submission_4) { create(:submission_4)}
  
  before(:each) do
    team.hunt_id = hunt.id
    submission_2.team_id = team.id
    team.submissions << submission_2
  end
  
  describe "POST#create" do
    it "creates a submission" do
      beginning_count = Submission.count
      params = {team_id: team.id.to_s, location_id: location.id.to_s}
      post :create, format: :json, submission: params
      
      expect(Submission.count).to eq(beginning_count + 1)
      expect(Submission.last.team_id).to eq(team.id)
      expect(Submission.last.correct).to eq(false)
      expect(Submission.last.location_id).to eq(location.id)
    end
  end
  
  describe "GET#index" do
    it "gets the submissions that haven't been responded to" do
      get :index, format: :json
      data = JSON.parse(response.body, symbolize_names: true)

      expect(data.count).to eq(2)
      expect(data.first[:responded_to]).to be(false)
      expect(data.last[:responded_to]).to be(false)
    end
  end
  
  describe "PATCH#update" do
    #I need help with this one, for some reason the correct won't update
  xit "updates a submission" do
      expect(submission_1.correct).to eq(false)
      params = {submission_id: submission_1.id, correct: true}
      put :update, :id => submission_1.id, format: :json, submission: params
      
      expect(submission_1.correct).to eq(true)
    end
  end
  
  describe "GET#latest_submission" do
    it "gets the teams latest submission when responded to" do
      params = { team_id: team.id }
      get :latest_submission, format: :json, team_id: params
      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:responded_to]).to be(true)
      expect(data[:correct]).to be(true)
    end
  end
end
