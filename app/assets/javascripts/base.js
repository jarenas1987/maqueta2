//dropdown menu
$( document ).ready(function(){
    $(".dropdown-button").dropdown({gutter: -15, constrainWidth: false});
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
