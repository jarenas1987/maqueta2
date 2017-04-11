var slick_carousel = $('div.slick-carousel');
var slick_carousel_config = {
    infinite: true,
    slidesToShow: 3,
    slidesToScroll: 1,
    edgeFriction: 0,
    swipeToSlide: true,
    respondTo: "window"
  };
var badge_element = document.getElementById('carrito-badge');
var bagde_count = 0
if (badge_element != null)
  bagde_count = parseInt(badge_element.dataset.count);
var home_url = null;

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

$('a.dropdown-button').on('click', function(e){
  resetBadge();
});

$(document).ready(function(){
  $('.materialboxed').materialbox();
});

$(".btn-floating").on("click", function(e){//funcion del boton ver
  $(".fav").removeClass("hide");
})

// Click en cada boton (categorias) del sidebar
$('a.category-link').on('click', function(e){
  e.preventDefault();
  var url = this.href;
  var span = $(this).find('span');
  var error_json = null;

  // Quitar nombre de clase a todos los span para dejarlos deseleccionados.
  $(this).parents('div.container').find('span').removeClass('text_link_selected');
  // Agregar clase al span para dejar seleccionado el link.
  span.addClass('text_link_selected');

  $.ajax({
    url: url,
    method: "get",
    beforeSend: function()
    {
      $('a.category-link').toggleClass('disable_link');
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
    error_json = jqXHR.responseJSON;

  }).always(function(data, textStatus, errorThrown) {
    $('a.category-link').toggleClass('disable_link');
    console.log(error_json);

  });
});

// Envio de formulario del carrito de pisos y muros gustados.
$('form#carrito_form').on('submit', function(event){
  event.preventDefault();
  data = $(event.target).serialize();
  // Se agrega el parametro de email en los datos que enviara ajax.
  // (POR HACER)Hay que obtener el email ingresado por el usuario en el modal...
  // data.push({name: "email", value: ''});
  console.log(data);

  $.ajax({
    url: event.target.action,
    data: data,
    method: event.target.method,
    beforeSend: function()
    {
    }
  }).done(function(data, textStatus, jqXHR) {
    // Aqui se debe agregar el par de productos gustados al carrito.
    console.log(data);

  }).fail(function(jqXHR, textStatus, errorThrown) {
    var error_json = jqXHR.responseJSON;
    console.log(error_json.msg);
  }).always(function(data, textStatus, errorThrown) {

  });
});

// Evento de click en el carrito de cada elemento del carrusel.
$('div.slick-carousel').on('click', 'a.shopping_cart', function(event){
  event.preventDefault();
  var url = this.href;
  var data = $(this).parents('div.card-content').find('input').serialize();

  $.ajax({
    url: url,
    data: data,
    method: 'get',
    beforeSend: function()
    {
    }
  }).done(function(data, textStatus, jqXHR) {
    // Aqui se debe agregar el par de productos gustados al carrito.
    console.log(data);

    addItemToCarrito(data);

  }).fail(function(jqXHR, textStatus, errorThrown) {
    var error_json = jqXHR.responseJSON;
    console.log(error_json.msg);
  }).always(function(data, textStatus, errorThrown) {

  });

});


$('div.slick-carousel').on('click', 'a.set_background', function(event){
  event.preventDefault();
  var url = this.href;

  $.ajax({
    url: url,
    method: 'get',
    beforeSend: function()
    {
    }
  }).done(function(data, textStatus, jqXHR) {
    // Aqui se debe agregar el par de productos gustados al carrito.
    console.log(data);

  }).fail(function(jqXHR, textStatus, errorThrown) {
    var error_json = jqXHR.responseJSON;
    console.log(error_json.msg);
  }).always(function(data, textStatus, errorThrown) {

  });

});

function numberWithCommas(x) {
  return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

// Funcion que revisa si existe un par de productos gustados en el carrito antes de agregar un nuevo par para evitar duplicados.
function addItemToCarrito(carrito_data)
{
  var carrito_container = $('div#carrito_container');
  var carrito_items = carrito_container.children();
  var add_item = true;

  for (var i = 0; i < carrito_items.length; i++) {
    var data_set = carrito_items[i].dataset;
    if (data_set.productSku == carrito_data.item_sku){
      add_item = false;
      break;
    }
  }

  if (add_item) {
    // Si no existe el par de productos en el carrito, se agrega.
    carrito_container.append(carrito_data.carrito_item);

    // Calcular el precio total de los items del carrito.
    // Se toma el atributo 'total' y se le suma el precio del par de productos gustado entrante.
    var total_element = $('li#carrito-precio-total');
    var precio_total_carrito = total_element.data().total;
    precio_total_carrito += carrito_data.precio_total_item;

    total_element.data('total', precio_total_carrito);
    total_element.find('span').html("Total: $ " + numberWithCommas(precio_total_carrito));

    // Se actualiza el estado del badge.
    updateBagde();
  }
}

function resetBadge() {
  bagde_count = 0;
  badge_element.dataset.count = bagde_count;
  badge_element.innerHTML = "";

  $(badge_element).addClass('hide');
}

function updateBagde() {
  // Se suma +1 al contador del badge.
  bagde_count += 1;
  badge_element.dataset.count = bagde_count;
  badge_element.innerHTML = "+" + bagde_count;

  // Se hace visible el badge solo si el numero de items sin ver es distinto de 0.
  if (bagde_count !== 0)
    $(badge_element).removeClass('hide');
  else
    $(badge_element).addClass('hide');
}

function redirectToHome()
{
  if (home_url != null)
    window.location = home_url;
}

// tool tip activator
$(document).ready(function(){
  $('.tooltipped').tooltip({delay: 50});

  // Inicializar el modal2 para que se pueda abrir mediante JS.
  $('#modal2').modal(
    {
      complete: function() {
        redirectToHome();
      }
    });
  $('#modal1').modal();
});

// Cerrar el modal1 al presionar el boton X.
$('button#close-modal1').click(function(e){
  $('#modal1').modal('close');
});

// Cerrar el modal2 al presionar el boton X y redirigir al home.
$('button#close-modal2').click(function(e){
  $('#modal2').modal('close');
});

// Evento de click en "Enviar" del primer modal.
$("#buttonModal1").click(function(e) {
  var email = document.getElementById('email_modal').value;
  var button = $(this);

  if (email.length !== 0) {
    var form_element = document.getElementById('carrito_form');
    data = $(form_element).serializeArray();

    // Se agrega el parametro de email en los datos que enviara ajax.
    data.push({name: "email", value: email});

    $.ajax({
      url: form_element.action,
      data: data,
      method: form_element.method,
      beforeSend: function()
      {
        button.val('Enviando correo...');
        button.prop('disabled', true);
      }
    }).done(function(data, textStatus, jqXHR) {
      console.log(data);
      document.getElementById('email_modal').value = "";
      home_url = data.home_url;

      // Cerrar modal del email.
      $('#modal1').modal('close');

      // Abrir modal de termino.
      $('#modal2').modal('open');

    }).fail(function(jqXHR, textStatus, errorThrown) {
      var error_json = jqXHR.responseJSON;
      console.log(error_json);
    }).always(function(data, textStatus, errorThrown) {
      button.val('Enviar');
      button.prop('disabled', false);
    });

  }
});
