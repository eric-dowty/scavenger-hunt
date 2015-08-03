ScavengerHunt.Views.HuntsNew = Backbone.View.extend({

  initialize: function(data) {
    this.collection = new ScavengerHunt.Collections.Hunts;
    this.data = data
  },

  templateNew: JST['hunts/new'],
  templatePhone: JST['hunts/phone'],
  templateDashboard: JST['hunts/dashboard'],

  render: function(currentHuntData) {
    this.renderCorrectTemplate(currentHuntData);
    return this
  },

  renderCorrectTemplate: function(currentHuntData){
    if(currentHuntData.active && currentHuntData.teams.length > 0){
      $(".container").html(this.$el.html(this.templateDashboard()));

      for (var i = 0; i < currentHuntData.teams.length; i++) {
        $("#standings-list").append("<tr><td>" + currentHuntData.teams[i].name + "</td><td>" + currentHuntData.teams[i].current_location + "</td><td>" + currentHuntData.teams[i].found_locations + "</td></tr>")
        $("#submissions").append("<div class='row'>"
                                  + "<div class='col s12 m9'>"
                                    + "<div class='card'>"
                                      + "<div class='card-image hoverable'>"
                                        + "<img src='https://icorockies.com/wp-content/uploads/2010/11/colorado_capital.jpg'>"
                                        + "<span class='card-title'>Card Title</span>"
                                      + "</div>"
                                        + "<div class='card-content'>"
                                          + "<p>I am a very simple card. I am good at containing small bits of information. I am convenient because I require little markup to use effectively.</p>"
                                        + "</div>"
                                        + "<div class='card-action'><a href='#'>This is a link</a>"
                                        + "</div>"
                                      + "</div>"
                                    +"</div>"
                                  +"</div>"
      )}
    } else if(currentHuntData['active']){
      $(".container").html(this.$el.html(this.templatePhone()));
      for (var i = 0; i < currentHuntData['number_of_teams']; i++) {
        $(".phone-numbers").append("<li><label for='phone_number'>" + i + "</label><br><input name='phone_number' id='team" + [i] + "'></input></li>")
      }
    } else {
      return $(".container").html(this.$el.html(this.templateNew()));

      $("#standings").append("<table>")
    }
  },

  events: {
    "click #new-game-button": "setupGame",
    "click #submit-team-phone-numbers": "createTeams"
  },

  createTeams: function(event) {
    event.preventDefault();
    teamCollection = new ScavengerHunt.Collections.Teams;
    var teamCount = $(".phone-numbers").children().length;
    var huntID = data.responseJSON['id'];
    for (var i = 0; i < teamCount; i++) {
      teamCollection.create({
        phone_number: $("#team"+i).val(),
        hunt_id: huntID
      })
    }

  },

  setupGame: function(event) {
    event.preventDefault();
    this.createNewHunt();
  },

  createNewHunt: function(){
    var huntName = $("#name-of-hunt-input").val()
    var numberOfTeams = $("#number-of-teams-input").val()
    this.collection.create({
      name: huntName,
      number_of_teams: numberOfTeams
    },
      {
    wait: true,
    success: function(){ScavengerHunt.Routers.Hunts()},
    error: function(){alert("Error when creating your hunt. Try again.")}
    }
  );
}
});
