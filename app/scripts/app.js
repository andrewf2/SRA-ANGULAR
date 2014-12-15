'use strict';

/**
 * @ngdoc overview
 * @name sraAngularApp
 * @description
 * # sraAngularApp
 *
 * Main module of the application.
 */
angular
  .module('sraAngularApp', [
    'ngAnimate',
    'ngAria',
    'ngCookies',
    'ngMessages',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch',
    'firebase'
  ]).run(function($rootScope,$firebase) {
    
    $rootScope.current_user = {};

    $rootScope.firebaseSession = localStorage['firebase:session::intense-inferno-7741'];

  var ref = new Firebase("https://intense-inferno-7741.firebaseio.com/Organizations/SRA/Regions");
  var regionsArr = $firebase(ref).$asArray();
  var regions = [];
  var areasArr = [];
  regionsArr.$loaded().then(function(data){
    for(var region in regionsArr){
      if(regionsArr[region].$id != undefined){
        regions.push(regionsArr[region].$id)
       }
      }
      regions = JSON.stringify(regions);
      localStorage.setItem('regions', regions)
      $rootScope.regions = JSON.parse(localStorage['regions']);
    });


})
  .config(function ($routeProvider) {
    $routeProvider
      .when('/', {
        templateUrl: 'views/static/landing.html',
        controller: ''
      })
      .when('/login', {
        templateUrl: 'views/sessions/new.html',
        controller: 'LoginController'
      })
      .when('/regions', {
        templateUrl: 'views/regions/index.html',
        controller: 'regionsIndexCtrl'
      })
      .when('/region/show/:name', {
        templateUrl: 'views/regions/show.html',
        controller: 'regionShowCtrl'
      })
      .when('/region/new', {
        templateUrl: 'views/regions/new.html',
        controller: 'regionNewCtrl'
      })
      .when('/region/edit/:name', {
        templateUrl: 'views/regions/edit.html',
        controller: 'regionEditCtrl'
      })
      .when('/dashboard', {
        templateUrl: 'views/dashboard/worker.html',
        controller: 'DashboardController'
      })
      .when('/admin/dashboard', {
        templateUrl: 'views/dashboard/admin.html',
        controller: 'AdminDashboardController'
      })
      .when('/admin/areas',{
        templateUrl: 'views/admin/areas.html',
        controller: 'AdminAreasController'
      })
      .when('/areas', {
        templateUrl: 'views/areas/index.html',
        controller: 'AreasIndexController'
      })
      .when('/areas/show/:name', {
        templateUrl: 'views/areas/show.html',
        controller: 'AreasShowController'
      })
      .when('/areas/edit/:name',{
        templateUrl: 'views/areas/edit.html',
        controller: 'AreasEditController'
      })
      .otherwise({
        redirectTo: '/'
      });
  });

angular.module('sraAngularApp')
  .factory('RestClient', function ($firebase) {
    RestClient.getArea = function(name){
      
       var ref = new Firebase("https://intense-inferno-7741.firebaseio.com/Organizations/SRA/Regions/South%20Africa/Areas/" + name);
       var sync = $firebase(ref).$asObject();
       return sync;
    }
    RestClient.getAreas = function(){

      var ref = new Firebase("https://intense-inferno-7741.firebaseio.com/Organizations/SRA/Regions/South%20Africa/Areas/")
      var sync = $firebase(ref).$asArray();
      return sync;
    }
    RestClient.getUsers = function(){

      var ref = new Firebase("https://intense-inferno-7741.firebaseio.com/Users");
      var sync = $firebase(ref).$asArray();
      return sync;
    }
    RestClient.getUser = function(email){

      var node = email.split('@');
      var ref = new Firebase("https://intense-inferno-7741.firebaseio.com/Users/" + node[0])
      var sync = $firebase(ref).$asObject();
      return sync;
    }
    RestClient.getRegions =  function(){

      var ref = new Firebase("https://intense-inferno-7741.firebaseio.com/Organizations/SRA/Regions");
      var sync = $firebase(ref).$asArray();
    }
    RestClient.getRegion =function (name){

      var ref = new Firebase("https://intense-inferno-7741.firebaseio.com/Organizations/SRA/Regions" + name);
      var sync = $firebase(ref).$asObject();
    }
     
    return RestClient;
  });