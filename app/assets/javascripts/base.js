//dropdown menu
$( document ).ready(function(){
  $(".dropdown-button").dropdown({
    inDuration: 300,
    outDuration: 225,
    constrainWidth: false, // Does not change width of dropdown to that of the activator
    hover: false, // Activate on hover
    gutter: 0, // Spacing from edge
    belowOrigin: false, // Displays dropdown below the button
    alignment: 'right', // Displays dropdown with edge aligned to the left of button
    stopPropagation: false // Stops event propagation
  });
});



$(document).ready(function(){
  $('.materialboxed').materialbox();
});

$(document).ready(function(){
  $(".owl-carousel").owlCarousel({
    margin:10,
    loop:true,
    autoWidth:true,
    items:4

  });
});

$(".btn-floating").on("click", function(e){//funcion del boton ver
  $(".fav").removeClass("hide");
})


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