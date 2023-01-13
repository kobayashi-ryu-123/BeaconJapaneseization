"use strict";

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }
function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }
document.addEventListener('DOMContentLoaded', () => {
  var services = SentinelService.getUserServices().then(services => {
    for (var service of services) {
      console.log(service.serviceId);
    }
  });
  var addServersButton = document.getElementById('button-add-servers');
  addServersButton.addEventListener('click', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator(function* (ev) {
      var token = SentinelCommon.nitradoAccessToken;
      if (!token) {
        // Start OAuth
        try {
          var obj = yield SentinelAPIRequest.start('GET', '/oauth/index.php?provider=Nitrado&return_uri=' + encodeURIComponent(window.location.href));
          window.location.href = obj.location;
        } catch (e) {
          // Do something with the error
          return;
        }
      }
      addServersButton.innerText = 'Waiting…';
      try {
        var nitradoServices = yield NitradoAPIRequest.start('GET', 'services');
        console.log(nitradoServices);
      } catch (e) {
        // Do another something
        return;
      }
      addServersButton.innerText = 'Add Servers';
      ev.preventDefault();
    });
    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }());
});