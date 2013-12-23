// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-fileupload
//= require twitter/bootstrap
//= require lib/angular.min
//= require lib/angular-resource.min
//= require app/main
//= require app-init
//= require_tree ./app/controllers
//= require_tree ./app/directives
//= require_tree ./app/filters
//= require_tree ./app/services
//= require_directory ./shared
//= require_tree ./controllers
//= require_self


$(document).ready(function(){
  //reload default to false;
  App.init(document.body);
});
