teamailApp = angular.module("teamailApp")

teamailApp.controller "MembersController", ($scope, Member) ->
  $scope.members = Member.query()

  $scope.create = ->
    member = new Member
    member.email = $scope.memberEmail
    member.$save()
