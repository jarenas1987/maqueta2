var slick_carousel = $('div.slick-carousel');
var slick_carousel_config = {
    infinite: true,
    slidesToShow: 3,
    slidesToScroll: 1
  };

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

  // Inicializar slick carrusel
  slick_carousel.slick(slick_carousel_config);
});

$(document).ready(function(){
  $('.materialboxed').materialbox();
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
      var carousel;

      if (data.carousel_type == 'piso')
        carousel = $('div#pisos_carousel');
      else if(data.carousel_type == 'muro')
        carousel = $('div#muros_carousel');
      else
        carousel = null;

      if (carousel !== null) {
        // Quitar todos los elementos del carrusel
        carousel.slick('removeSlide', null, null, true);

        // Luego agregarlos.
        for (var i = 0; i < data.carousel_items.length; i++) {
          carousel.slick('slickAdd', data.carousel_items[i]);
        }
      }

  }).fail(function(jqXHR, textStatus, errorThrown) {
    var error_json = jqXHR.responseJSON;
    console.log(error_json.msg);

  }).always(function(data, textStatus, errorThrown) {
      
  }); 

});