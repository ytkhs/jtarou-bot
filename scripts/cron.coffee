# Author:
#   qube81

cron = require('cron').CronJob
module.exports = (robot) ->
  new cron '0 0 20 * * 1-5', () ->
    user = {}
    robot.send user, "@all 八時だョ！全員帰ろう！"
  , null, true
  new cron '0 0 13 * * 1-5', () ->
    user = {}
    robot.send user, "@all お昼だよ！メッシメッシ！"
  , null, true