# Create 'app' angular application (module)
teamailApp = angular.module("teamailApp", ['ngResource'])

# Csrf token to make forms in Angular work with Rails
teamailApp.config ($httpProvider) ->
  authToken = $("meta[name=\"csrf-token\"]").attr("content")
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken

# Make push-state default on
teamailApp.config ($locationProvider) ->
  $locationProvider.html5Mode true
