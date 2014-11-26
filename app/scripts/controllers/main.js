'use strict';

/**
 * @ngdoc function
 * @name sraAngularApp.controller:MainCtrl
 * @description
 * # MainCtrl
 * Controller of the sraAngularApp
 */
angular.module('sraAngularApp')
  .controller('MainCtrl', function ($scope) {
    $scope.awesomeThings = [
      'HTML5 Boilerplate',
      'AngularJS',
      'Karma'
    ];
  });

angular.module('myApp', [])
  .service('sharedData', function () {
      var region;
      var area;
      var resource;

      // place getters/setters here
      return {
          getRegion: function () {
              return region;
          },
          setRegion: function(value) {
              region = value;
          },
          getArea: function() {
            return area;
          },
          setArea: function(value) {
            area = value;
          },
          getResource: function() {
            return resource;
          },
          setResource: function(value) {
            resource = value;
          }
      };
  });


/*Constants*/
angular.module('sraAngularApp').constant("firebaseURL", "https://intense-inferno-7741.firebaseio.com/" /*"https://torid-inferno-2841.firebaseio.com/"*/);

angular.module('sraAngularApp')
  .controller('regionsCtrl', ["$scope", "$http", "firebaseURL", function ($scope, $http, firebaseURL) {

    // variables
    $scope.regions;
    var regionsURL;

    /**
    * init() acts as a constructor for the controller.
    */
    $scope.init = function() {
      regionsURL = firebaseURL + "Organizations/Organization/Regions";
      $scope.getRegions();
    };

    $scope.createRegion = function() {
      if(typeof($scope.name) != "undefined" && $scope.name != null ) {
         $http.post(regionsURL, $scope.name).success( function(data, status, headers, config) {
           $scope.region = data;
         });
      } else {
        alert("Please enter a name");
      }
    };

    $scope.getRegion = function(regionName) {
      $http.get(regionsURL + "/" + regionName + ".json").success(function(data, status, headers, config) {
        console.dir(data);
        $scope.areas = data.Areas;
      });
    };

    $scope.getRegions = function() {
      $http.get(regionsURL + ".json").success(function(data, status, headers, config) {
        console.dir(data);
        $scope.regions = data;
      });
    };
    $scope.init();
  }]);

angular.module('sraAngularApp')
  .controller('areasCtrl', ["$scope", "$http", "firebaseURL", function ($scope, $http, firebaseURL) {

    // variables
    $scope.areas;
    var areasURL;

    /**
    * init() acts as a constructor for the controller.
    */
    $scope.init = function() {
      areasURL = firebaseURL + "Organizations/Organization/Regions";
      $scope.getAreas(sharedData.getRegion());
      $scope.getAreas();
    };

    $scope.createRegion = function() {
      if(typeof($scope.name) != "undefined" && $scope.name != null ) {
         $http.post(regionsURL, $scope.name).success( function(data, status, headers, config) {
           $scope.region = data;
         });
      } else {
        alert("Please enter a name");
      }
    };

    $scope.getAreas = function(regionName) {
      $http.get(areasURL + "/" + regionName + ".json").success(function(data, status, headers, config) {
        console.dir(data);
        $scope.areas = data.Areas;
      });
    };

    $scope.init();
  }]);