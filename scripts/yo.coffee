# Description:
#   Utility commands yo
#   export HUBOT_YO_API_TOKEN=YOURTOKEN

cron = require('cron').CronJob
QS = require 'querystring'

module.exports = (robot) ->
  robot.hear /yo$/i, (msg) ->
    msg.send 'YO'
             
  robot.enter ->
  new cron
    cronTime: "0 0 13 * * 1-5"
    start: true
    timeZone: "Asia/Tokyo"
    onTick: ->
      if process.env.HUBOT_YO_API_TOKEN
        data = QS.stringify({api_token: process.env.HUBOT_YO_API_TOKEN})
        robot.http('http://api.justyo.co/yoall/')
          .header('Content-type', 'application/x-www-form-urlencoded')
          .post(data) (err, res, body) ->
            robot.send {room: "#general"}, "YO"
 

