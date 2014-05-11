# description:
# set jobs

cron = require('cron').CronJob
module.exports = (robot) ->
  robot.enter ->
  new cron
    cronTime: "0 * * * * *"
    start: true
    timeZone: "Asia/Tokyo"
    onTick: ->
      robot.send {room: ""}, "テストです。"