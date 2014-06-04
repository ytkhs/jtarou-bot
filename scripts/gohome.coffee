# Commands:

sprintf = require('sprintf').sprintf

module.exports = (robot) ->

  robot.hear /帰りたい|かえりたい/i, (msg) ->
    
    json = ""
    request = msg.http('https://gist.githubusercontent.com/qube81/4a71734898e2decfd3f5/raw/schedule.js').get()
    request (err, res, body) ->
      json = JSON.parse body
     
      d = new Date();
      nowHour = if d.getHours() is 0 then 24 else d.getHours()
      nowMinute =  d.getMinutes()
    
      result = []
      for i, val of json
        if nowHour > i
          continue
        for j in val
          if nowHour is parseInt(i) and nowMinute > parseInt(j)
            continue
          result.push sprintf ':train:  %1$02s:%2$02s', i, j
      
       msg.send ["新富町池袋方面行き！（平日しか対応してないです:whale:）", result.slice(0, 5).join("\n")].join("\n")