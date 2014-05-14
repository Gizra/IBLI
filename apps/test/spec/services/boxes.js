'use strict';

describe('Service: Boxes', function () {

  // load the service's module
  beforeEach(module('ethosiaClientApp'));

  // instantiate service
  var Boxes;
  beforeEach(inject(function (_Boxes_) {
    Boxes = _Boxes_;
  }));

  it('should do something', function () {
    expect(!!Boxes).toBe(true);
  });

});
