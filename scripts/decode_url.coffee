# Description:
#   encodeされたURLを日本語に戻す
#

module.exports = (robot) ->

  robot.hear /(https?:\/\/[^ ]+)/i, (msg) ->

    who = msg.message.user.name
    url = msg.match[1]
    url_decoded = decodeURI url
    return if url is url_decoded
    url = url_decoded.replace /[ <>]/g, (c) -> encodeURI c
    msg.send "@#{who} 日本語でおｋ\n#{url}"