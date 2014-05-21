'use strict';

describe('Directive: hoverInfo', function () {

  // load the directive's module
  beforeEach(module('ethosiaClientApp'));

  var element,
    scope;

  beforeEach(inject(function ($rootScope) {
    scope = $rootScope.$new();
  }));

  it('should make hidden element visible', inject(function ($compile) {
    element = angular.element('<hover-info></hover-info>');
    element = $compile(element)(scope);
    expect(element.text()).toBe('this is the hoverInfo directive');
  }));
});
