'use strict';

describe('Service: ibliData', function () {

  // load the service's module
  beforeEach(module('ibliApp'));

  // instantiate service
  var ibliData;
  beforeEach(inject(function (_ibliData_) {
    ibliData = _ibliData_;
  }));

  it('should do something', function () {
    expect(!!ibliData).toBe(true);
  });

});
