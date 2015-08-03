ScavengerHunt.Routers.Hunts = Backbone.Router.extend({
  routes: {
    "admin-dashboard": "dashboard"
  },

  dashboard: function() {
    view = new ScavengerHunt.Views.HuntsNew;
    debugger    
    data = $.ajax({
              url: "/hunts",
              method: "get",
              dataType: "json",
              success: function(xhr){
                view.render(xhr);
                this.collection = new ScavengerHunt.Collections.Hunts(xhr);
              }
            });
    // view.render(data);
  }
});
