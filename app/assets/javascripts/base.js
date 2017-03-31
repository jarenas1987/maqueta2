//dropdown menu
$( document ).ready(function(){
    $(".dropdown-button").dropdown();
});

 // Initialize collapsible (uncomment the line below if you use the dropdown variation)
 $('.collapsible').collapsible();

$(document).ready(function() {//initialize select
   $('select').material_select();
 });

 $('.carousel').carousel();
 $('.modal').modal();
 $(document).ready(function(){
       $('.carousel').carousel({
             dist:0,
             shift:0,
             padding:150,

       });

     });
     $(document).ready(function(){
       $('.materialboxed').materialbox();
     });
     $(document).ready(function(){
         $('.slider').slider();
       });

$('a.category-link').on('click', function(e){
  e.preventDefault();
  var url = this.href;

  $.ajax({
    url: url,
    method: "get",
    beforeSend: function()
    {
    }
  }).done(function(data, textStatus, jqXHR) {
      console.log(data);

  }).fail(function(jqXHR, textStatus, errorThrown) {
    var error_json = jqXHR.responseJSON;
    console.log(error_json.msg);

  }).always(function(data, textStatus, errorThrown) {
      
  }); 

});