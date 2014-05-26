'use strict';

describe('Service: BACKEND_URL', function () {

  // load the service's module
  beforeEach(module('ibliApp'));

  // instantiate service
  var backendUrl;
  beforeEach(inject(function (_BACKEND_URL_) {
    backendUrl = _BACKEND_URL_;
  }));

  it('should do something', function () {
    expect(!!backendUrl).toBe(true);
  });

});
