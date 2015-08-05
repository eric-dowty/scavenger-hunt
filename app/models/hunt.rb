class Hunt < ActiveRecord::Base
  has_many :huntlocations
  has_many :locations, through: :huntlocations
  has_many :teams
  validates :name, presence: true, length: { maximum: 30, minimum: 2}
  validates :number_of_teams, presence: true

  def self.end_game(id)
    Hunt.find(id).update(active: false)
  end

  def self.current_hunt_data
    current_hunt = Hunt.includes(:teams).last
    submission_data = Hunt.last.teams.map {|team| team.submissions.select {|submission| submission.responded_to == false}}.flatten
    { id: current_hunt.id, name: current_hunt.name,
      active: current_hunt.active,
      number_of_teams: current_hunt.number_of_teams,
      teams: current_hunt.teams,
      submissions: submission_data }.to_json
  end

end
