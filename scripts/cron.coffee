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
    cronTime: "0 0 5 * * *"
    start: true
    timeZone: "Asia/Tokyo"
    onTick: ->
      redis = require('redis')
      redisCli = redis.createClient()
      request = robot.http('http://animemap.net/api/table/tokyo.json').get()
      request (err, res, body) ->
        dateFormat = require('dateformat')
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
            anime.sended = false
            anime_key = ANIME_KEY_PREFIX+i
            redisCli.hmset(anime_key, anime)
            redisCli.sadd(LIST_KEY, anime_key)
        redisCli.end()
  new cron
    cronTime: "*/5 * * * * *"
    start: true
    timeZone: "Asia/Tokyo"
    onTick: ->
      dateObj = new Date()
      now = Math.floor(dateObj.getTime() / 1000)
      redis = require('redis')
      redisCli = redis.createClient()
      redisCli.smembers(LIST_KEY, (err, result) ->
        for anime_key, i in result
          redisCli.hgetall(anime_key, (err, anime) ->
            if !anime.sended && anime.timestamp in [now+(60*5)..now+(60*10)-1]
              robot.send {room: "#general"}, anime.time + " から『" + anime.title + "』の" + anime.next + "が" + anime.station + "ではっじまっるよー"
              anime.sended = true
              redisCli.hmset(anime_key, anime)
          )
      )
      redisCli.end()