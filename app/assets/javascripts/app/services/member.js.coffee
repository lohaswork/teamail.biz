angular.module('teamailApp').factory 'Member', ($resource) ->
  $resource('/api/members')
