# description:
# set jobs

cron = require('cron').CronJob
lunch_message = ["メッシ！", "はらへ", "ｼｭｯｼｭｯｼｭｯｼｭｯ"]
LIST_KEY = 'hubot:anime:keys'
ANIME_KEY_PREFIX = 'hubot:anime:'


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
  new cron
    cronTime: "0 0 * * * *"
    start: true
    timeZone: "Asia/Tokyo"
    onTick: ->
      request = robot.http('http://animemap.net/api/table/tokyo.json').get()
      request (err, res, body) ->
        dateFormat = require('dateformat')
        anime_keys = []
        json = JSON.parse body
        for anime, i in json.response.item
          if anime.today is "1"
            dateObj = new Date()
            start_time_array = anime.time.split(':')
            start_hours = parseInt(start_time_array[0])
            if start_hours >= 24
              dateObj = new Date(dateObj.getTime() + (24*60*60*1000))
              start_time_array[0] = ('0' + String(start_hours - 24)).slice(-2)
            start_time_array.push('00')
            start_time = start_time_array.join(':')
            start_datetime = dateFormat(dateObj, 'yyyy/mm/dd ') + start_time
            anime.timestamp = Date.parse(start_datetime) / 1000

            anime_key = ANIME_KEY_PREFIX+i
            if anime_keys.length is not 0
              anime_keys = JSON.parse(robot.brain.get(LIST_KEY))
            anime_keys.push(anime_key)
            robot.brain.set LIST_KEY, JSON.stringify(anime_keys)

            anime.sended = 0
            robot.brain.set anime_key, JSON.stringify(anime)
  new cron
    cronTime: "0 * * * * *"
    start: true
    timeZone: "Asia/Tokyo"
    onTick: ->
      dateObj = new Date()
      now = Math.floor(dateObj.getTime() / 1000)
      anime_keys = JSON.parse(robot.brain.get(LIST_KEY))
      for anime_key, i in anime_keys
        anime = JSON.parse(robot.brain.get(anime_key))
        if anime.sended is 0 && anime.timestamp in [now..now+(60*5)]
          robot.send {room: "#general"}, "#{anime.time}から#{anime.station}で『#{anime.title}』#{anime.next}がはっじまっるよー"
          anime.sended = 1
          robot.brain.set anime_key, JSON.stringify(anime)
