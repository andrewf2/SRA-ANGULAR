"use strict"
window.app.controller "AdminAreasController", ($scope, $location, $firebase, $routeParams, $rootScope, firebaseURL) ->
  $rootScope.currentUser = JSON.parse(sessionStorage.getItem("user"))
  regions = JSON.parse(localStorage.regions)
  if regions isnt `undefined`
    
    # Don't define functions inside a loop. It's a performance killer.
    callMe = (areaData) ->
      areasArr.push areaData
      areas = []
      $scope.areas = areas.concat.apply(areas, areasArr)
      return

    i = 0

    while i < regions.length
      ref = new Firebase(firebaseURL + "Organizations/sra/regions/" + regions[i] + "/areas")
      sync = $firebase(ref).$asArray()
      areasArr = []
      sync.$loaded().then callMe #Maybe?
      i++
  return

window.app.controller "AdminDashboardController", ($scope, $location, $firebase, $routeParams, $rootScope, orgBuilder) ->
  $rootScope.title = "Dashboard"
  $scope.fromService = orgBuilder.getHouseholdsFromOrg()
  console.log($scope.fromService)
  $rootScope.currentUser = JSON.parse(sessionStorage.getItem("user"))
  $rootScope.sra = JSON.parse(localStorage.sra)
  $scope.firstName = $rootScope.currentUser.firstName
  $scope.lastName = $rootScope.currentUser.lastName
  console.log($scope.firstName)
  return

window.app.controller "AdminUsersController", ($scope, $location, $firebase, $routeParams, $rootScope, firebaseURL) ->
  $rootScope.currentUser = JSON.parse(sessionStorage.getItem("user"))
  $scope.users = []
  ref = new Firebase(firebaseURL + "organizations/sra/users")
  users = $firebase(ref).$asArray()
  users.$loaded().then (data) ->   
    for user in data
      fb = new Firebase(firebaseURL + "users/"+ user.$id)
      sync = $firebase(fb).$asObject()
      
      sync.$loaded().then (userObj) ->
        console.log(userObj)
        if(userObj.email != undefined)
          $scope.users.push userObj
        
    return
  return

window.app.controller "EditUsersController", ($scope, $location, $firebase, $routeParams, $rootScope, firebaseURL) ->
  $rootScope.currentUser = JSON.parse(sessionStorage.getItem("user"))
  $scope.username = $routeParams.id
  $scope.UpdateUser = ->
    fname = $scope.user.fname
    lname = $scope.user.lname
    ref = new Firebase(firebaseURL + "organizations/sra/users/" + $scope.username)
    sync = $firebase(ref)
    sync.$update(
      FirstName: fname
      LastName: lname
    ).then ((ref) ->
      ref.key() # bar
      return
    ), (error) ->
      return

    return

  return

window.app.controller "AreasUsersController", ($scope, $location, $firebase, $routeParams, $rootScope, firebaseURL) ->
  $rootScope.currentUser = JSON.parse(sessionStorage.getItem("user"))

  localStorage.regionParam = $routeParams.region  if $routeParams.region isnt `undefined`
  localStorage.usernameParam = $routeParams.id  if $routeParams.id isnt `undefined`
  localStorage.areaParam = $routeParams.area  if $routeParams.area isnt `undefined`
  localStorage.countryParam = $routeParams.country if $routeParams.country isnt 'undefined'
  $scope.region = localStorage.regionParam
  $scope.username = localStorage.usernameParam
  $scope.area = localStorage.areaParam
  $scope.country = localStorage.countryParam
  $scope.areaNames = []
  $scope.areas = []

  countryRef = new Firebase(firebaseURL + "organizations/sra/countries")
  countries = $firebase(countryRef).$asArray()
  countries.$loaded().then (data) ->
    $scope.countries = data
    return
  $scope.regionInit = ->
    ref = new Firebase(firebaseURL + "organizations/sra/countries/" + $scope.country + "/regions")
    regions = $firebase(ref).$asArray()
    regions.$loaded().then (data) ->
      $scope.regions = data
      return

  $scope.regionAssign = ->
    console.log($scope.country)
    console.log($scope.region)
    ref = new Firebase(firebaseURL + "organizations/sra/countries/" + $scope.country + "/regions/" + $scope.region + "/areas")
    sync = $firebase(ref).$asArray()
    sync.$loaded().then (data) ->
      $scope.areas = data
      console.log($scope.areas)
      return
    return


   

  $scope.areaAssignment = ->
    console.log $scope.areaNames
    console.log $scope.username
    console.log $scope.country
    ref = new Firebase(firebaseURL + "users/" + $scope.username + "/organizations/sra/countries/"+$scope.country+"/regions")
    sync = $firebase(ref).$asArray()
    sync.$loaded().then (data) ->
      console.log(data)
      return
    
    return

  return

window.app.controller "NewUsersController", ($scope, $location, $firebase, $routeParams, $rootScope, $firebaseAuth, firebaseURL) ->
  $rootScope.currentUser = JSON.parse(sessionStorage.getItem("user"))
  $scope.CreateUser = ->
    userNode = new Firebase(firebaseURL + "organizations/sra/users")
    email = $scope.user.email
    password = $scope.user.password
    fname = $scope.user.fname
    lname = $scope.user.lname
    ref = new Firebase(firebaseURL)
    $scope.authObj = $firebaseAuth(ref)
    $scope.authObj.$createUser(email, password).then(->
      userNode.push userNode.child(email.split("@")[0]).set(
        FirstName: fname
        LastName: lname
      )
      $scope.authObj.$authWithPassword
        email: email
        password: email

    ).catch (error) ->
      console.error "Error: ", error
      return

    return

  return

window.app.controller "AreasNewController", ($scope, $location, $firebase, $routeParams, $rootScope, firebaseURL) ->
  $rootScope.currentUser = JSON.parse(sessionStorage.getItem("user"))
  $scope.regions = JSON.parse(localStorage.getItem("regions"))
  region = $routeParams.name
  $scope.region = $routeParams.name
  ref = new Firebase(firebaseURL + "organizations/sra/regions/" + region + "/areas")
  areasRef = new Firebase(firebaseURL + "organizations/sra/regions/" + region)
  areas = $firebase(areasRef).$asArray()
  areas.$loaded ->
    $scope.areas = areas[0]
    return

  $scope.CreateArea = ->
    name = $scope.area.name
    ref.push ref.child(name).set(Name: name)
    return

  return

window.app.controller "AreasEditController", ($scope, $location, $firebase, $routeParams, firebaseURL) ->
  $scope.area = $routeParams.name
  $scope.region = $routeParams.region
  $scope.UpdateArea = ->
    ref = new Firebase(firebaseURL + "organizations/sra/regions/" + $scope.region + "/areas/" + $scope.area)
    name = $scope.area.name
    ref.set name
    return

  return

window.app.controller "AdminHouseholdsController", ($scope, $rootScope, $location, $firebase, $routeParams, firebaseURL, orgBuilder) ->
  $scope.fromService = orgBuilder.getHouseholdsFromOrg();
  console.log($rootScope.households)
  return

