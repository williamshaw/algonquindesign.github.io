/*
  Network connection speed test, modified from Foresight.js
  (c) Adam Bradley
  https://github.com/adamdbradley/foresight.js/
  Foresight.js licensed under the MIT license:
  https://github.com/adamdbradley/foresight.js/blob/master/LICENSE-MIT.txt

  Network connection feature detection referenced from Modernizr
  (c) Faruk Ates, Paul Irish, Alex Sexton
  Available under the BSD and MIT licenses: http://www.modernizr.com/license/
  https://github.com/Modernizr/Modernizr/blob/master/feature-detects/network-connection.js
*/


(function() {
  this.ConnectionSpeed = (function() {
    "use strict";
    var BANDWIDTH_HIGH, BANDWIDTH_LOW, LOCAL_STORAGE_KEY, bandwidth, get, isLoading, options, speedTestComplete;
    options = {
      minKbpsForHighBandwidth: 300,
      speedTestUrl: '/25k.jpg',
      speedTestKb: 25,
      speedTestExpireMinutes: 30,
      forcedBandwidth: false
    };
    LOCAL_STORAGE_KEY = 'ConnectionSpeed';
    isLoading = false;
    BANDWIDTH_LOW = 'low';
    BANDWIDTH_HIGH = 'high';
    bandwidth = BANDWIDTH_LOW;
    get = function(success) {
      var connection, connectionData, connectionKbps, e, isSlowConnection, speedTestImg, speedTestTimeoutMS, startTime, timeout;
      if (isLoading) {
        return;
      }
      if (options.forcedBandwidth) {
        bandwidth = options.forcedBandwidth;
        success(bandwidth);
        return;
      }
      isLoading = true;
      connection = navigator.connection || {
        type: 'unknown'
      };
      isSlowConnection = connection.type === 3 || connection.type === 4 || /^[23]g$/.test(connection.type);
      if (isSlowConnection) {
        isLoading = false;
        success(BANDWIDTH_LOW);
        return;
      }
      try {
        connectionData = JSON.parse(localStorage.getItem(LOCAL_STORAGE_KEY));
        if (connectionData === !null && (new Date()).getTime() < connectionData.exp) {
          isLoading = false;
          success(connectionData.bw);
          return;
        }
      } catch (_error) {
        e = _error;
      }
      speedTestImg = document.createElement('img');
      connectionKbps = 0;
      startTime = (new Date()).getTime();
      speedTestImg.src = options.speedTestUrl + "?r=" + Math.random();
      speedTestTimeoutMS = (((options.speedTestKb * 8) / options.minKbpsForHighBandwidth) * 1000) + 350;
      timeout = setTimeout(function() {
        bandwidth = BANDWIDTH_LOW;
        return speedTestComplete(success);
      }, speedTestTimeoutMS);
      speedTestImg.onload = function() {
        var duration, endTime;
        clearTimeout(timeout);
        endTime = (new Date()).getTime();
        duration = (endTime - startTime) / 1000;
        duration = duration > 1 ? duration : 1;
        connectionKbps = ((options.speedTestKb * 1024 * 8) / duration) / 1024;
        bandwidth = connectionKbps >= options.minKbpsForHighBandwidth || duration === 1 ? BANDWIDTH_HIGH : BANDWIDTH_LOW;
        return speedTestComplete(success);
      };
      speedTestImg.onerror = function() {
        return speedTestComplete(success, 5);
      };
      return speedTestImg.onabort = function() {
        return speedTestComplete(success, 5);
      };
    };
    speedTestComplete = function(success, expireMinutes) {
      var connectionDataToSet, e;
      try {
        if (!expireMinutes) {
          expireMinutes = options.speedTestExpireMinutes;
        }
        connectionDataToSet = {
          bw: bandwidth,
          exp: (new Date()).getTime() + (expireMinutes * 60000)
        };
        localStorage.setItem(LOCAL_STORAGE_KEY, JSON.stringify(connectionDataToSet));
      } catch (_error) {
        e = _error;
      }
      isLoading = false;
      return success(bandwidth);
    };
    return {
      options: options,
      get: get
    };
  })();

}).call(this);

(function() {
  var btns, closeAllInfos, infos;

  btns = $('.course__btn');

  infos = $('.course__info');

  closeAllInfos = function() {
    return infos.forEach(function(elem, index) {
      return elem.setAttribute('data-state', 'hidden');
    });
  };

  btns.on('click', function(e) {
    var id, info, isVisible;
    id = this.getAttribute('id');
    info = $(".course__info[data-id=\"" + id + "\"]");
    isVisible = info.getAttribute('data-state') === 'visible' ? true : false;
    if (isVisible) {
      return info.setAttribute('data-state', 'hidden');
    } else {
      closeAllInfos();
      return info.setAttribute('data-state', 'visible');
    }
  });

}).call(this);

(function() {
  "use strict";
  var closeNav, insideNav, navBtn, navLinks, navTop, openNav, toggleNav, waitToCloseNav;

  navTop = $('.nav--top');

  navBtn = $('.nav-btn');

  navLinks = $('.nav--top a');

  insideNav = false;

  openNav = function() {
    navTop.setAttribute('data-state', 'expanded');
    return navBtn.setAttribute('data-state', 'active');
  };

  closeNav = function() {
    navTop.setAttribute('data-state', 'collapsed');
    return navBtn.setAttribute('data-state', 'inactive');
  };

  toggleNav = function() {
    if (navTop.getAttribute('data-state') === 'expanded') {
      return closeNav();
    } else {
      return openNav();
    }
  };

  waitToCloseNav = function() {
    return setTimeout(function() {
      if (!insideNav) {
        return closeNav();
      }
    }, 100);
  };

  navBtn.on('click', function(e) {
    e.preventDefault();
    return toggleNav();
  });

  navBtn.on('focus', function(e) {
    insideNav = true;
    return openNav();
  });

  navBtn.on('blur', function(e) {
    insideNav = false;
    return waitToCloseNav();
  });

  navLinks.on('focus', function(e) {
    insideNav = true;
    return openNav();
  });

  navLinks.on('blur', function(e) {
    insideNav = false;
    return waitToCloseNav();
  });

}).call(this);
