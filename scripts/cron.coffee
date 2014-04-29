# Author:
#   qube81

cron = require('cron').CronJob
module.exports = (robot) ->
  new cron
    cronTime: '0 0 20 * * 1-5'
    start: true
    timeZone: "Asia/Tokyo"
    onTick: ->
      robot.send {}, "@all 八時だョ！全員帰ろう！"
  new cron
    cronTime: '0 0 13 * * 1-5'
    start: true
    timeZone: "Asia/Tokyo"
    onTick: ->
      robot.send {}, "@all お昼だよ！メッシメッシ！"
  new cron
    cronTime: '*/10 * * * * 1-5'
    start: true
    timeZone: "Asia/Tokyo"
    onTick: ->
      robot.send {}, "10秒おきにしゃべるてすとだお"