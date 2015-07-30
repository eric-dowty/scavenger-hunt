class Seed

  def self.go
    Rails.env == "production" ? production : development
  end

  def self.production
    generate_locations
  end

  def self.development
    generate_locations
    generate_hunts
    generate_submissions
  end

  def self.generate_locations
    locations = [{name: "Colorado State Capitol", clue: "The 13th step on the west side of the State Capitol building is 5,280 feet above sea level, or one mile high. Take a photograph of your teammates on the 13th step."}, 
                 {name: "Big Sweep sculpture by Claes Oldenburg and Coosje Van Bruggenat at Denver Art Museum (outside grounds)", clue: "The same man responsible for the Clothespin and the Broken Button in the City of Brotherly Love bestowed Denver with its own objets d’arts. Find and photograph these “ordinary” items. Throw some team members in the picture."},
                 {name: "The Yearling sculpture by Donald Lipski at the Denver Art Museum (outside grounds)", clue: "Like the caterpillar sitting on a mushroom, only it’s a pinto pony sitting on a red chair - no hookah. Prove this sculpture exists with a photograph of your teammates beside it."},
                 {name: "U.S. Mint", clue: "Mmmm, minty fresh money. Photograph your team next to the emblem of this currency bakery, one of five in the United States."}, 
                 {name: "Title of blue bear sculpture outside the Colorado Convention Center", clue: "'I see what you mean.' Now take a photo of this Denver icon."},
                 {name: "16th Street Mall", clue: "This mall was designed by I.M Pei, the same architect who designed the glass pyramids outside the Louvre in Paris. Viewed from above, the 400,000 pieces of granite paving resemble a western diamondback rattlesnake. Find and photograph the tower with four “faces” along this mall. Tell me one reason why it is historically significant."},
                 {name: "El Chapultapec", clue: "This tiny jazz club opened in 1933, one day after Prohibition was repealed. Since then, the likes of Miles Davis, Stan Getz, and Chet Baker have played this club. Ella Fitzgerald was a friend of the club. Even President Clinton took the stage once. Photograph your teammates inside this club."},
                 {name: "Wynkoop Brewing Company", clue: "Housed in a J.S. Mercantile building from 1899, the largest brewpub in America was founded in part by the current state governor John Hickenlooper. Photograph a shot of the beer list."},
                 {name: "Tattered Cover bookstore", clue: "This independent bookstore was involved in a Colorado Supreme Court case in 2000 when it resisted, on First Amendment grounds, a search warrant for records related to purchases made by a customer suspected of illegally manufacturing methamphetamine. Take a picture in the cookbook section."}, 
                 {name: "My Brother’s Bar", clue: "This place claims it is the oldest continuously operating bar in Denver, dating to 1871. Beatniks Jack Kerouac and Neal Cassady used to drink here, and a letter written by Mr. Cassady hangs on the wall. Tell us what the letter requests."}, 
                 {name: "Millennium Bridge", clue: "This steel marvel will take you back to the millennium. Climb the stairs and photograph your team near the 200 foot mast of this suspension footbridge, the first in the world to use post-tensioned structural construction."},
                 {name: "Toxic Schizophrenia sculpture outside Museum of Contemporary Art", clue: "Tim and Sue brought their Toxic Schizophrenia all the way from the UK. They bear their bloody heart for all to see. Find it and photograph it."},
                 {name: "National Velvet Sculpture", clue: "Commissioned by the Denver Office of Cultural Affairs, National Velvet may not be as disturbing as Blue Velvet, but it has surely elicited some calls to the mayor's office. Photograph your teammates with this one of a kind sculpture."}
                ] 
    locations.each do |location|
      new_location = Location.create(name: location[:name])
      new_location.clues << Clue.create(info: location[:clue])
    end
    puts "Locations generated."
  end

  def self.generate_team
    puts "Team generated."
    Team.create(phone_number: generate_phone_number)
  end

  def self.generate_submissions
    Team.all.each do |team|
      correct_bool = [true, false].sample
      responded_bool = [true, false].sample
      Submission.create(correct: correct_bool, team_id: team.id, location_id: team.location_id, responded_to: responded_bool)
    end
    puts "Submissions generated."
  end

  def self.generate_hunts
    old_hunt = Hunt.create(name: Faker::Lorem.word, number_of_teams: 3, active: false)
    3.times { old_hunt.teams << generate_team }
    new_hunt = Hunt.create(name: Faker::Lorem.word, number_of_teams: 3)
    3.times { new_hunt.teams << generate_team }
    puts "Hunts generated."
  end

  def self.generate_phone_number
    "1#{rand.to_s[2..11]}" 
  end

end

Seed.go