# Commands:

module.exports = (robot) ->

  robot.hear /帰りたい|かえりたい/i, (msg) ->
    msg.send "かえろう！今すぐかえろう！"
