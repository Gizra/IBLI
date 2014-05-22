'use strict';

describe('Service: ethosiaHttpInterceptor', function () {

  // load the service's module
  beforeEach(module('ibliApp'));

  // instantiate service
  var ethosiaHttpInterceptor;
  beforeEach(inject(function (_ethosiaHttpInterceptor_) {
    ethosiaHttpInterceptor = _ethosiaHttpInterceptor_;
  }));

  it('should do something', function () {
    expect(!!ethosiaHttpInterceptor).toBe(true);
  });

});
