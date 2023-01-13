"use strict";

function _classPrivateFieldInitSpec(obj, privateMap, value) { _checkPrivateRedeclaration(obj, privateMap); privateMap.set(obj, value); }
function _checkPrivateRedeclaration(obj, privateCollection) { if (privateCollection.has(obj)) { throw new TypeError("Cannot initialize the same private elements twice on an object"); } }
function _classPrivateFieldGet(receiver, privateMap) { var descriptor = _classExtractFieldDescriptor(receiver, privateMap, "get"); return _classApplyDescriptorGet(receiver, descriptor); }
function _classPrivateFieldSet(receiver, privateMap, value) { var descriptor = _classExtractFieldDescriptor(receiver, privateMap, "set"); _classApplyDescriptorSet(receiver, descriptor, value); return value; }
function _classExtractFieldDescriptor(receiver, privateMap, action) { if (!privateMap.has(receiver)) { throw new TypeError("attempted to " + action + " private field on non-instance"); } return privateMap.get(receiver); }
function _defineProperty(obj, key, value) { key = _toPropertyKey(key); if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }
function _toPropertyKey(arg) { var key = _toPrimitive(arg, "string"); return typeof key === "symbol" ? key : String(key); }
function _toPrimitive(input, hint) { if (typeof input !== "object" || input === null) return input; var prim = input[Symbol.toPrimitive]; if (prim !== undefined) { var res = prim.call(input, hint || "default"); if (typeof res !== "object") return res; throw new TypeError("@@toPrimitive must return a primitive value."); } return (hint === "string" ? String : Number)(input); }
function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }
function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }
function _classStaticPrivateFieldSpecGet(receiver, classConstructor, descriptor) { _classCheckPrivateStaticAccess(receiver, classConstructor); _classCheckPrivateStaticFieldDescriptor(descriptor, "get"); return _classApplyDescriptorGet(receiver, descriptor); }
function _classApplyDescriptorGet(receiver, descriptor) { if (descriptor.get) { return descriptor.get.call(receiver); } return descriptor.value; }
function _classStaticPrivateFieldSpecSet(receiver, classConstructor, descriptor, value) { _classCheckPrivateStaticAccess(receiver, classConstructor); _classCheckPrivateStaticFieldDescriptor(descriptor, "set"); _classApplyDescriptorSet(receiver, descriptor, value); return value; }
function _classCheckPrivateStaticFieldDescriptor(descriptor, action) { if (descriptor === undefined) { throw new TypeError("attempted to " + action + " private static field before its declaration"); } }
function _classCheckPrivateStaticAccess(receiver, classConstructor) { if (receiver !== classConstructor) { throw new TypeError("Private static access of wrong provenance"); } }
function _classApplyDescriptorSet(receiver, descriptor, value) { if (descriptor.set) { descriptor.set.call(receiver, value); } else { if (!descriptor.writable) { throw new TypeError("attempted to set read only private field"); } descriptor.value = value; } }
class SentinelCommon {
  static init(authToken, apiDomain) {
    var _this = this;
    return _asyncToGenerator(function* () {
      _classStaticPrivateFieldSpecSet(_this, SentinelCommon, _authToken, authToken);
      _classStaticPrivateFieldSpecSet(_this, SentinelCommon, _apiDomain, apiDomain);
      SentinelLayout.init();
      try {
        var accessToken = localStorage.getItem('nitradoAccessToken') || null;
        var validUntil = localStorage.getItem('nitradoAccessTokenExpiration') || null;
        var now = Math.floor(Date.now() / 1000);
        if (Boolean(accessToken) === false || Boolean(validUntil) === false || validUntil - 86400 <= now) {
          var nitradoTokenResponse = yield SentinelAPIRequest.start('GET', 'sentinel/oauth/Nitrado');
          var nitradoToken = nitradoTokenResponse.jsonObject;
          accessToken = nitradoToken.access_token;
          validUntil = nitradoToken.valid_until;
          localStorage.setItem('nitradoAccessToken', accessToken);
          localStorage.setItem('nitradoAccessTokenExpiration', validUntil);
        }
        _classStaticPrivateFieldSpecSet(_this, SentinelCommon, _nitradoAccessToken, accessToken);
      } catch (e) {}
    })();
  }
  static get authToken() {
    return _classStaticPrivateFieldSpecGet(this, SentinelCommon, _authToken);
  }
  static get apiDomain() {
    return _classStaticPrivateFieldSpecGet(this, SentinelCommon, _apiDomain);
  }
  static get nitradoAccessToken() {
    return _classStaticPrivateFieldSpecGet(this, SentinelCommon, _nitradoAccessToken);
  }
}
var _authToken = {
  writable: true,
  value: null
};
var _apiDomain = {
  writable: true,
  value: null
};
var _nitradoAccessToken = {
  writable: true,
  value: null
};
class SentinelWebRequest {
  static prepareResponse(xhr) {
    return {
      xhr: xhr,
      status: xhr.status,
      statusText: xhr.statusText,
      body: xhr.responseText,
      success: xhr.status >= 200 && xhr.status < 300
    };
  }
  static start(method, url) {
    var body = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : null;
    var headers = arguments.length > 3 && arguments[3] !== undefined ? arguments[3] : {};
    return new Promise((resolve, reject) => {
      var xhr = new XMLHttpRequest();
      xhr.open(method, url, true);
      if (typeof headers === 'object' && headers !== null && Array.isArray(headers) === false) {
        var keys = Object.keys(headers);
        for (var key of keys) {
          xhr.setRequestHeader(key, headers[key]);
        }
      }
      xhr.onload = () => {
        var response = this.prepareResponse(xhr);
        if (response.success) {
          resolve(response);
        } else {
          reject(response);
        }
      };
      xhr.onerror = () => {
        reject(this.prepareResponse(xhr));
      };
      xhr.send(body);
    });
  }
}
class NitradoAPIRequest extends SentinelWebRequest {
  static start(method, url) {
    var body = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : null;
    var headers = arguments.length > 3 && arguments[3] !== undefined ? arguments[3] : {};
    headers.Accept = 'application/json';
    headers.Authorization = "Bearer ".concat(SentinelCommon.nitradoAccessToken);
    return super.start(method, "https://api.nitrado.net/".concat(url), body, headers);
  }
}
class SentinelAPIRequest extends SentinelWebRequest {
  static prepareResponse(xhr) {
    var response = super.prepareResponse(xhr);
    response.message = '';
    response.jonObject = null;
    try {
      response.jsonObject = JSON.parse(response.body);
      if (response.jsonObject.message) {
        response.message = response.jsonObject.message;
      }
    } catch (e) {}
    return response;
  }
  static start(method, url) {
    var body = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : null;
    var headers = arguments.length > 3 && arguments[3] !== undefined ? arguments[3] : {};
    if (url.startsWith('https://') === false) {
      if (url.startsWith('/') === false) {
        url = "/v3/".concat(url);
      }
      url = "https://".concat(SentinelCommon.apiDomain).concat(url);
    }
    headers.Accept = 'application/json';
    headers.Authorization = "Session ".concat(SentinelCommon.authToken);
    return super.start(method, url, body, headers);
  }
}
class SentinelLayout {
  static init() {
    this.sidebarButton = document.getElementById('menu-button');
    this.sidebar = document.getElementById('main-sidebar');
    this.userMenuButton = document.getElementById('header-user-button');
    this.userMenu = document.getElementById('user-menu');
    this.blurOverlay = document.getElementById('blur');
    if (this.sidebar && this.sidebarButton) {
      this.sidebarButton.addEventListener('click', ev => {
        this.toggleSidebar();
        ev.preventDefault();
        return false;
      });
    }
    if (this.userMenu && this.userMenuButton) {
      var showMenu = ev => {
        this.showUserMenu(ev.type === 'touchstart');
        ev.preventDefault();
        return false;
      };
      this.userMenuButton.addEventListener('mouseenter', showMenu);
      this.userMenuButton.addEventListener('touchstart', showMenu);
      this.userMenu.addEventListener('mouseleave', ev => {
        this.closeUserMenu();
        ev.preventDefault();
        return false;
      });
      this.blurOverlay.addEventListener('touchstart', ev => {
        this.closeUserMenu();
        ev.preventDefault();
        return false;
      });
    }
    var copyUserIdLink = document.getElementById('user-menu-copy-id');
    copyUserIdLink.addEventListener('click', ev => {
      var userId = copyUserIdLink.getAttribute('userid');
      navigator.clipboard.writeText(userId);
      copyUserIdLink.innerText = 'Copied!';
      setTimeout(() => {
        copyUserIdLink.innerText = 'Copy User ID';
      }, 3000);
      ev.preventDefault();
      return false;
    });
  }
  static sidebarVisible() {
    return this.sidebar.classList.contains('visible');
  }
  static closeSidebar() {
    if (this.sidebarVisible()) {
      this.sidebar.classList.remove('visible');
      this.sidebarButton.classList.remove('visible');
    }
  }
  static showSidebar() {
    this.closeUserMenu();
    if (this.sidebarVisible() === false) {
      this.sidebar.classList.add('visible');
      this.sidebarButton.classList.add('visible');
    }
  }
  static toggleSidebar() {
    if (this.sidebarVisible()) {
      this.closeSidebar();
    } else {
      this.showSidebar();
    }
  }
  static userMenuVisible() {
    return this.userMenu.classList.contains('visible') || this.userMenu.classList.contains('exists');
  }
  static closeUserMenu() {
    if (this.userMenuVisible()) {
      this.userMenu.classList.remove('visible');
      this.blurOverlay.classList.remove('visible');
      setTimeout(() => {
        this.userMenu.classList.remove('exists');
        this.blurOverlay.classList.remove('exists');
      }, 150);
    }
  }
  static showUserMenu(withOverlay) {
    this.closeSidebar();
    if (this.userMenuVisible() === false) {
      this.userMenu.classList.add('exists');
      if (withOverlay) {
        this.blurOverlay.classList.add('exists');
      }
      setTimeout(() => {
        this.userMenu.classList.add('visible');
        if (withOverlay) {
          this.blurOverlay.classList.add('visible');
        }
      }, 1);
    }
  }
  static toggleUserMenu() {
    if (this.userMenuVisible()) {
      this.closeUserMenu();
    } else {
      this.showUserMenu();
    }
  }
}
_defineProperty(SentinelLayout, "sidebarButton", null);
_defineProperty(SentinelLayout, "sidebar", null);
_defineProperty(SentinelLayout, "userMenuButton", null);
_defineProperty(SentinelLayout, "userMenu", null);
_defineProperty(SentinelLayout, "blurOverlay", null);
var _serviceInfo = /*#__PURE__*/new WeakMap();
class SentinelService {
  static getUserServices() {
    return _asyncToGenerator(function* () {
      try {
        var response = yield SentinelAPIRequest.start('GET', 'sentinel/service');
        var servicesList = response.jsonObject;
        var services = [];
        for (var serviceInfo of servicesList) {
          services.push(new SentinelService(serviceInfo));
        }
        return services;
      } catch (e) {
        console.log(e.message);
      }
    })();
  }
  constructor(serviceInfo) {
    _classPrivateFieldInitSpec(this, _serviceInfo, {
      writable: true,
      value: null
    });
    _classPrivateFieldSet(this, _serviceInfo, serviceInfo);
  }
  get serviceId() {
    return _classPrivateFieldGet(this, _serviceInfo).service_id;
  }
}
window.browserSupported = true;