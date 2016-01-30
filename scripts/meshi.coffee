# Description:
#   notify meshi time

cron = require('cron').CronJob
module.exports = (robot) ->
  robot.enter ->
  new cron
    cronTime: "0 0 13 * * 1-5"
    start: true
    timeZone: "Asia/Tokyo"
    onTick: ->
      #robot.send {room: "#general"}, "メッシ"