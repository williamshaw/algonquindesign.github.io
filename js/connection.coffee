###
  Network connection speed test, modified from Foresight.js
  (c) Adam Bradley
  https://github.com/adamdbradley/foresight.js/
  Foresight.js licensed under the MIT license:
  https://github.com/adamdbradley/foresight.js/blob/master/LICENSE-MIT.txt

  Network connection feature detection referenced from Modernizr
  (c) Faruk Ates, Paul Irish, Alex Sexton
  Available under the BSD and MIT licenses: http://www.modernizr.com/license/
  https://github.com/Modernizr/Modernizr/blob/master/feature-detects/network-connection.js
###
this.ConnectionSpeed = do () ->
  "use strict"

  options = {
    minKbpsForHighBandwidth: 300
    speedTestUrl: '/25k.jpg'
    speedTestKb: 25
    speedTestExpireMinutes: 30
    forcedBandwidth: false
  }

  LOCAL_STORAGE_KEY = 'ConnectionSpeed'

  isLoading = false

  BANDWIDTH_LOW = 'low'
  BANDWIDTH_HIGH = 'high'
  bandwidth = BANDWIDTH_LOW

  get = (success) ->
    return if isLoading

    if options.forcedBandwidth
      bandwidth = options.forcedBandwidth
      success(bandwidth)
      return

    isLoading = true

    connection = navigator.connection or {type: 'unknown'}
    isSlowConnection = connection.type is 3 or connection.type is 4 or /^[23]g$/.test(connection.type)

    if isSlowConnection
      isLoading = false
      success(BANDWIDTH_LOW)
      return

    try
      connectionData = JSON.parse localStorage.getItem(LOCAL_STORAGE_KEY)

      if connectionData is not null and (new Date()).getTime() < connectionData.exp
        isLoading = false
        success(connectionData.bw)
        return
    catch e

    speedTestImg = document.createElement('img')
    connectionKbps = 0

    startTime = (new Date()).getTime()
    speedTestImg.src = options.speedTestUrl + "?r=" + Math.random();
    speedTestTimeoutMS = (((options.speedTestKb * 8) / options.minKbpsForHighBandwidth) * 1000) + 350

    timeout = setTimeout () ->
      bandwidth = BANDWIDTH_LOW
      speedTestComplete(success)
    , speedTestTimeoutMS

    speedTestImg.onload = () ->
      clearTimeout(timeout)

      endTime = (new Date()).getTime()
      duration = (endTime - startTime) / 1000
      duration = if duration > 1 then duration else 1

      connectionKbps = ((options.speedTestKb * 1024 * 8) / duration) / 1024
      bandwidth = if connectionKbps >= options.minKbpsForHighBandwidth or duration is 1 then BANDWIDTH_HIGH else BANDWIDTH_LOW

      speedTestComplete(success)

    speedTestImg.onerror = () ->
      speedTestComplete(success, 5)

    speedTestImg.onabort = () ->
      speedTestComplete(success, 5)

  speedTestComplete = (success, expireMinutes) ->
    try
      if not expireMinutes
        expireMinutes = options.speedTestExpireMinutes

      connectionDataToSet = {
        bw: bandwidth
        exp: (new Date()).getTime() + (expireMinutes * 60000)
      }

      localStorage.setItem LOCAL_STORAGE_KEY, JSON.stringify(connectionDataToSet)
    catch e

    isLoading = false
    success(bandwidth)

  return {
    options: options
    get: get
  }
