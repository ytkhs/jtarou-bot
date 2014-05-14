# description:
# set jobs

cron = require('cron').CronJob
lunch_message = ["メッシ！", "はらへ", "ｼｭｯｼｭｯｼｭｯｼｭｯ"]


module.exports = (robot) ->
  robot.enter ->
  new cron
    cronTime: "0 0 13 * * 1-5"
    start: true
    timeZone: "Asia/Tokyo"
    onTick: ->
      robot.send {room: "#general"}, ["@everyone", lunch_message[Math.floor(Math.random() * lunch_message.length)]].join(" ")
  new cron
    cronTime: "0 0 19 * * *"
    start: true
    timeZone: "Asia/Tokyo"
    onTick: ->
      request = robot.http('http://animemap.net/api/table/tokyo.json').get()
      request (err, res, body) ->
        json = JSON.parse body
        result = "@moyashi @j_taro_origin 今日のアニメです！\n"
        for anime, i in json.response.item
          if anime.today is "1"
            result += [anime.time, "『" + anime.title + "』", anime.next, anime.station].join(" ")
            result += "\n"
        robot.send {room: "#general"}, result