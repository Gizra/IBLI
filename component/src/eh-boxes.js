'use strict';

angular.module('ehBoxes', [
    'wu.masonry',
    'LocalStorageModule'
  ])
  .config(function($httpProvider) {
    // Inject interceptor.
    $httpProvider.interceptors.push('ehHttpInterceptor');
  })
  .constant('BACKEND_URL', 'http://localhost/ethosia/www')
  .factory('ehHttpInterceptor', function ($q, BACKEND_URL) {
    // Public API here
    return {
      /**
       * This interceptor construct the path to get the data translated,
       * check the config and according this generated the new path in relation
       * the language selected by the user.
       *
       * @param config
       *   In the $http config add two new variables:
       *
       *   - serverPredefined: true|false if the value is true take the constant
       *     WEB_URL defined in the config.js to set the server URI. Otherwise
       *     keep the original config.url.       *
       *   - apiMock: true|false indicate if use the interceptor angular-apimock.
       *     to maintain compatibility.
       *
       * @returns {*}
       */
      'request': function(config) {
        // Validate if use the server url defined in the constant.
        if (config.serverPredefined) {
          config._url = BACKEND_URL;

          // Have the condition to work with the module angular-apimock
          // https://github.com/seriema/angular-apimock
          config.url = (angular.isDefined(config.apiMock) && config.apiMock) ? config.url : config._url + config.url;
        }

        return config || $q.when(config);
      }
    };
  })
  .factory('Boxes', function ($http, $q, $timeout, localStorageService) {

    /**
     * Boxes Object definition.
     *
     *  {
     *    updated: number,
     *    list: [
     *      {...}
     *    ]
     *  }
     *
     *  - updated: Time in milliseconds format of boxes data was updated.
     *  - list: Array of box object data.
     *
     * @constructor
     */
    function Boxes() {
      Array.call();
    }
    Boxes.prototype = Array.prototype;

    /**
     * Default properties.
     *
     * @type {{data: {cache: boolean, offline: boolean, expired: number}}}
     *
     *  - cache: true if get the Boxes.data until the expiry time it's completed.
     *  - offline: true if get the data storage with HTML5 LocalStorage.
     *  - expired: time in milliseconds to refresh the data. By default 20 minutes.
     * @private
     */
    Boxes.prototype._config = {
      data: {
        cache: true,
        offline: true,
        expired: 1200000
      }
    };

    /**
     * Return the promise of getting the boxes data.
     *
     * @returns {promise|exports.promise|Q.promise}
     */
    Boxes.prototype.$gettingBoxes = function() {
      var _boxes = this,
        deferred = $q.defer();

      $http({
        method: 'GET',
        url: '/api/v1/homepage',
        transformResponse: _boxes.$prepareResponse,
        serverPredefined: true,
        cache: false
      })
        .success(function(response) {
          deferred.resolve(response);
        });

      return deferred.promise;
    };

    /**
     * Add last updated date in miliseconds format before dispatch the response.
     *
     * @param data
     * @returns {*}
     */
    Boxes.prototype.$prepareResponse = function(data) {
      var response = JSON.parse(data);
      response.updated = new Date().getTime();
      return response;
    };

    /**
     * Unwrap the boxes.
     */
    Boxes.prototype.$unwrap = function() {
      var _boxes = this;

      _boxes.$gettingBoxes().then(function(data) {
        // If there is not change in the data, not update data.
        if (angular.isDefined(_boxes.data) && angular.isDefined(_boxes.data.list) && angular.equals(_boxes.data.list, data.list)) {
          return;
        }

        _boxes.data = data;

        // Keep data locally.
        if (_boxes._config.data.offline) {
          localStorageService.set('boxes', _boxes.data);
        }
      });
    };

    /**
     * Request the first data from the server and wait the expire time until refresh the boxes data.
     *
     * @param expired
     *  - time in milliseconds to wait until the next boxes data request.
     */
    Boxes.prototype.$startCache = function(newExpired) {
      var _boxes = this,
        expired = newExpired || _boxes._config.data.expired;

      // Get the boxes information every period of time.
      $timeout(function() {
        _boxes.$unwrap();
      }, expired).then(function() {
          _boxes.$startCache();
        });
    };

    /**
     * Create a new instance of Boxes Object, get the data from the server and unwrap into data property the
     * boxes instance.
     *
     * @returns {Boxes}
     */
    function boxes() {
      // Create a new instance of boxes.
      var _boxes = new Boxes();

      // Get boxes.
      _boxes.$unwrap();

      // Caching system.
      _boxes.$startCache();

      return _boxes;
    }

    // Public API here
    return boxes;
  })
  /**
   * Handle controls to update the HTML layout used in the boxFrame directive.
   */
  .directive('boxesControls', function () {
    return {
      priority: 100,
      templateUrl: 'scripts/directives/eh-boxes/boxes-controls.html',
      restrict: 'E',
      controller: function($scope, $element, $attrs) {
        // Get initial configuration of the layout.
        $scope.layout = $attrs.layout || 'grid';

        /**
         * Change layout by name of the layout.
         */
        $scope.switchLayout = function(name) {
          $scope.layout = name;
        };

        $scope.defaultLayout = function() {
          return $scope.layout;
        };
      }
    };
  })
  /**
   * Define HTML with the selected layout, according this, load boxes content and set controls.
   *
   * These directive is the parent directive for boxControls and box.
   */
  .directive('boxes', function ($compile) {
    return {
      priority: 30,
      templateUrl: function(tElement, tAttributes) {
        return 'scripts/directives/eh-boxes/boxes-' + tAttributes.boxesLayout + '.html';
      },
      restrict: 'AE'
    };
  })
  /**
   * Wrap de contents of element, after remove the element tag with a div. all the content
   * it's copy element.contents() inside the div.
   */
  .directive('boxWrap', function () {
    return {
      priority: 40,
      restrict: 'A',
      scope: {
        boxWrap: '='
      },
      link: function(scope, element) {

        scope.$watch('boxWrap', function(style) {
          // Prepare dynamic wraper class.
          var classStyle = (angular.isDefined(style)) ? '-' + style : '';
          var wrap = angular.element('<div class="box box' + classStyle + '"></div>');

          // Apply the replace and wrap to the element.
          element.replaceWith(wrap.append(element.contents()));
        });

      }
    };
  })
  /**
   * Remove the element tag with a div. all the content it's copy element.contents() inside the div.
   */
  .directive('replace', function () {
    return {
      priority: 40,
      restrict: 'A',
      link: function(scope, element) {
        element.replaceWith(element.contents());
      }
    };
  });