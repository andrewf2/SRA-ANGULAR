window.app.controller "LoginController", ($scope, $location, $rootScope, $firebase, firebaseURL, $firebaseAuth, orgBuilder) ->
  $rootScope.title = "Login"
  loginFunction = undefined
  loginFunction = ->
    email = $scope.user.email
    password = $scope.user.password
    ref = new Firebase(firebaseURL)
    $scope.authObj = $firebaseAuth(ref)
    $scope.authObj.$authWithPassword(
      email: email
      password: password
    ).then(->
      node = undefined
      userRef = undefined
      userObj = undefined
      node = email.split("@")
      userRef = new Firebase(firebaseURL + "users/" + node[0])
      userObj = $firebase(userRef).$asObject()
      userObj.$loaded().then((data) ->
        $scope.fromService = orgBuilder.userCache(data)
        return
      ).then ->
        if $rootScope.currentUser.organizations.roles isnt `undefined`
          if $rootScope.currentUser.organizations.roles.name is "admin"
            $scope.fromService = orgBuilder.orgCache(firebaseURL)
            $location.path "/admin/dashboard"
            $scope.$apply()
          else if $rootScope.currentUser.organizations.roles.name is "developer"
            $location.path "/dashboard"
            $scope.$apply()
          else
            $location.path "/dashboard"
        return

      return
    ).catch (error) ->
      console.error "Authentication Failed:", error
      return

    return

  $scope.submit = loginFunction
  return

window.app.controller "DashboardController", ($scope, $location, $firebase, $rootScope) ->
  $rootScope.currentUser = JSON.parse(sessionStorage.getItem("user"))
  $rootScope.title = "Dashboard"
  $scope.user = $rootScope.currentUser
  $scope.areas = $rootScope.currentUser.areas
  $scope.firstname = $rootScope.currentUser.firstname
  $scope.lastname = $rootScope.currentUser.lastname
  if $rootScope.currentUser.roles is "Admin"
    $location.path "/admin/dashboard"
    $scope.$apply()
  return
