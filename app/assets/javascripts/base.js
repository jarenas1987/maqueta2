//dropdown menu
$( document ).ready(function(){
    $(".dropdown-button").dropdown();
});
// Initialize collapse button
$('.button-collapse').sideNav({
    menuWidth: 250, // Default is 300
    edge: 'left', // Choose the horizontal origin
    closeOnClick: true, // Closes side-nav on <a> clicks, useful for Angular/Meteor
    draggable: true // Choose whether you can drag to open on touch screens
  }
);
 // Initialize collapsible (uncomment the line below if you use the dropdown variation)
 $('.collapsible').collapsible();

$(document).ready(function() {//initialize select
   $('select').material_select();
 });

 $('.carousel').carousel();
 $('.modal').modal();
