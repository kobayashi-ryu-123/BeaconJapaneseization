"use strict";

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }
function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }
var updateScreenNotice = () => {
  var screen = window.screen;
  var screenWidthPoints = screen.width;
  var screenHeightPoints = screen.height;
  var screenWidthPixels = screenWidthPoints * window.devicePixelRatio;
  var screenHeightPixels = screenHeightPoints * window.devicePixelRatio;
  var isMac = navigator.platform.indexOf('Mac') > -1;
  var isWindows = navigator.platform.indexOf('Win') > -1;
  var notice = null;
  if (screenWidthPoints < 1280 || screenHeightPoints < 720) {
    notice = 'This screen may not be supported. A resolution of at least 1280x720 points is required.';
    if (screenWidthPixels >= 1280 && screenHeightPixels >= 720) {
      var maxScalingSupported = Math.round(Math.min(screenWidthPixels / 1280, screenHeightPixels / 720) * 100);
      if (isWindows) {
        notice = 'Your display scaling settings may prevent Beacon from fitting on your screen. If you experience trouble fitting Beacon\'s window on your screen, try changing your display scaling to ' + maxScalingSupported + '% or lower. <a href="https://www.windowscentral.com/how-set-custom-display-scaling-setting-windows-10#change_display_scaling_default_settings_windows10">Learn how to change scaling settings.</a>';
      }
    }
  }
  if (notice) {
    var screenNotice = document.getElementById('screenCompatibilityNotice');
    if (screenNotice) {
      screenNotice.innerHTML = notice;
      screenNotice.classList.remove('hidden');
    }
  }
};
var buildDownloadsTable = /*#__PURE__*/function () {
  var _ref = _asyncToGenerator(function* () {
    var downloadMac = 'macOS';
    var downloadWinUniversal = 'windows-universal';
    var downloadWinIntel64 = 'windows-x64';
    var downloadWinIntel = 'windows-x86';
    var downloadWinARM64 = 'windows-arm64';
    var priorities = [downloadWinIntel64, downloadMac, downloadWinIntel, downloadWinARM64];
    var hasRecommendation = false;
    switch (navigator.platform) {
      case 'Win32':
        // Try to use client hints to determine the best version, but this isn't supported in Firefox
        if ('userAgentData' in navigator) {
          yield navigator.userAgentData.getHighEntropyValues(['architecture', 'bitness']).then(ua => {
            if (ua.bitness == 32) {
              priorities = [downloadWinIntel, downloadWinIntel64, downloadWinARM64, downloadMac];
              hasRecommendation = true;
            } else if (ua.bitness == 64) {
              if (ua.architecture == 'arm') {
                priorities = [downloadWinARM64, downloadWinIntel, downloadWinIntel64, downloadMac];
                hasRecommendation = true;
              } else if (ua.architecture == 'x86') {
                priorities = [downloadWinIntel64, downloadWinIntel, downloadWinARM64, downloadMac];
                hasRecommendation = true;
              }
            }
          }).catch(() => {});
        }
        if (hasRecommendation === false) {
          priorities = [downloadWinUniversal, downloadWinIntel64, downloadWinIntel, downloadWinARM64, downloadMac];
          hasRecommendation = true;
        }
        break;
      case 'MacIntel':
        // Mac is simple, there's only one version
        priorities = [downloadMac, downloadWinIntel64, downloadWinIntel, downloadWinARM64];
        hasRecommendation = true;
        break;
    }
    var addChildRow = function (table, label, url) {
      var buttonCaption = arguments.length > 3 && arguments[3] !== undefined ? arguments[3] : 'Download';
      var childRow = document.createElement('div');
      childRow.classList.add('row');
      var childLabel = document.createElement('div');
      childLabel.classList.add('label');
      childLabel.innerHTML = label;
      var childDownload = document.createElement('div');
      childDownload.classList.add('button');
      var childButton = document.createElement('a');
      childButton.classList.add('button');
      childButton.classList.add('default');
      childButton.href = url;
      childButton.innerText = buttonCaption;
      childButton.setAttribute('rel', 'nofollow');
      childDownload.appendChild(childButton);
      childRow.appendChild(childLabel);
      childRow.appendChild(childDownload);
      table.appendChild(childRow);
    };
    var addChildRows = (table, data, recommend) => {
      if (hasRecommendation === false) {
        var warningRow = document.createElement('div');
        warningRow.classList.add('row');
        var warningLabel = document.createElement('div');
        warningLabel.classList.add('full');
        warningLabel.classList.add('text-red');
        warningLabel.innerText = 'Sorry, this version of Beacon is not compatible with your device. But just in case a mistake was made, here are the download links.';
        warningRow.appendChild(warningLabel);
        table.appendChild(warningRow);
      }
      var first = true; // Set first only after a row is added, in case one gets skipped
      for (var downloadKey of priorities) {
        var recommendedTag = recommend === true && hasRecommendation === true && first === true ? '<span class="tag blue mini left-space">Recommended</span>' : '';
        switch (downloadKey) {
          case downloadMac:
            if (data.hasOwnProperty('mac_url')) {
              addChildRow(table, "Mac".concat(recommendedTag, "<br><span class=\"mini text-lighter\">For macOS ").concat(data.mac_display_versions, "</span>"), data.mac_url);
              first = false;
            }
            break;
          case downloadWinIntel:
            if (data.hasOwnProperty('win_32_url')) {
              addChildRow(table, "Windows x86 32-bit".concat(recommendedTag, "<br><span class=\"mini text-lighter\">For 32-bit versions of ").concat(data.win_display_versions, "</span>"), data.win_32_url);
              first = false;
            }
            break;
          case downloadWinIntel64:
            if (data.hasOwnProperty('win_64_url')) {
              addChildRow(table, "Windows x86 64-bit".concat(recommendedTag, "<br><span class=\"mini text-lighter\">For 64-bit versions of ").concat(data.win_display_versions, "</span>"), data.win_64_url);
              first = false;
            }
            break;
          case downloadWinARM64:
            if (data.hasOwnProperty('win_arm64_url')) {
              addChildRow(table, "Windows ARM 64-bit".concat(recommendedTag, "<br><span class=\"mini text-lighter\">For 64-bit versions of ").concat(data.win_arm_display_versions, "</span>"), data.win_arm64_url);
              first = false;
            }
            break;
          case downloadWinUniversal:
            if (data.hasOwnProperty('win_combo_url')) {
              addChildRow(table, "Windows Universal".concat(recommendedTag, "<br><span class=\"mini text-lighter\">For all versions of ").concat(data.win_display_versions, "</span>"), data.win_combo_url);
              first = false;
            }
            break;
        }
      }
      addChildRow(table, 'Engrams Database, updated <time datetime="' + data.engrams_date + '">' + data.engrams_date_display + '</time>', data.engrams_url);
      addChildRow(table, 'Release Notes', data.history_url, 'View');
    };
    var stableTable = document.getElementById('stable-table');
    var prereleaseTable = document.getElementById('prerelease-table');
    var legacyTable = document.getElementById('legacy-table');
    var current = downloadData.current;
    if (current) {
      var headerRow = document.createElement('div');
      headerRow.classList.add('row');
      var headerBody = document.createElement('div');
      headerBody.classList.add('full');
      headerBody.innerText = 'Stable Version: Beacon ' + current.build_display;
      headerRow.appendChild(headerBody);
      stableTable.appendChild(headerRow);
      addChildRows(stableTable, current, true);
    }
    var prerelease = downloadData.preview;
    if (prerelease) {
      var _headerRow = document.createElement('div');
      _headerRow.classList.add('row');
      var _headerBody = document.createElement('div');
      _headerBody.classList.add('full');
      _headerBody.innerText = 'Preview Version: Beacon ' + prerelease.build_display;
      _headerRow.appendChild(_headerBody);
      prereleaseTable.appendChild(_headerRow);
      addChildRows(prereleaseTable, prerelease, false);
    } else {
      prereleaseTable.classList.add('hidden');
    }
    var legacy = downloadData.legacy;
    if (legacy) {
      var _headerRow2 = document.createElement('div');
      _headerRow2.classList.add('row');
      var _headerBody2 = document.createElement('div');
      _headerBody2.classList.add('full');
      _headerBody2.innerText = 'Legacy Version: Beacon ' + legacy.build_display;
      _headerRow2.appendChild(_headerBody2);
      legacyTable.appendChild(_headerRow2);
      addChildRows(legacyTable, legacy, false);
    } else {
      legacyTable.classList.add('hidden');
    }
    document.getElementById('mac_version_requirements').innerText = 'macOS ' + current.mac_display_versions;
    document.getElementById('win_version_requirements').innerText = current.win_display_versions;
  });
  return function buildDownloadsTable() {
    return _ref.apply(this, arguments);
  };
}();
document.addEventListener('DOMContentLoaded', () => {
  updateScreenNotice();
  buildDownloadsTable();
});