require 'json'
require 'ostruct'

class Team < ActiveRecord::Base
  belongs_to :hunt
  has_many :submissions
  belongs_to :location

  validates :name, presence: true, length: { maximum: 30, minimum: 2 }
  validates :slug, presence: true, uniqueness: true
  validates :phone_number, presence: true, numericality: { only_integer: true }, format: { with: /^[1].*$/,
    message: 'Must start with 1', multiline: true }, length: { is: 11 }

  after_create      :set_locations_found
  after_create      :set_start_location
  before_validation :generate_starting_name
  before_validation :generate_slug

  def to_param
    self.slug
  end

  def set_locations_found
    self.found_locations ||= 0
  end

  def generate_starting_name
    self.name = "Team#{self.phone_number}"  if self.name.nil?
  end

  def generate_slug
    self.slug = self.phone_number
  end

  def set_start_location
    self.update(location_id: Location.first.id)
  end

  # def set_start_location
  #   location_ids    = Location.all.map(&:id)
  #   already_taken   = Hunt.find_by(id: self.hunt_id).teams.pluck(:location_id)
  #   unique_start    = location_ids.sample
  #   while already_taken.include?(unique_start)
  #     unique_start = location_ids.sample
  #   end
  #   self.update(location_id: unique_start)
  # end

  def data
    submission = self.submissions.last || OpenStruct.new(correct: false, responded_to: true, accepted: true)
    
    { team_info:       { id: id, name: name, hunt_id: hunt_id, slug: slug, phone_number: phone_number, hunt_initiated:  hunt_initiated },
      location_info:   { found_locations: found_locations, location_id: location_id, location: self.location, clue: self.location.name },
      submission_info: { correct: submission.correct, responded_to: submission.responded_to, accepted: submission.accepted }
    }.to_json
  end

  def next_location(correct)
    set_next_location if correct == "true"
  end

  def set_next_location
    locations = Location.all
    location_id == locations.last.id ? (new_id = locations.first.id) : (new_id = location_id + 1)
    self.update(location_id: new_id)
  end

  def self.on_current_hunt(hunt_id)
    self.joins(:hunt).where(hunt_id: hunt_id)
  end
end
