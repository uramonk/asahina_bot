_ = require 'lodash'
config = require '../src/config'

module.exports = (robot) ->
  robot.respond /.*/, (msg) ->
    unless _.contains [config.getSlackChannel()], msg.envelope.room
      msg.finish()
      return
    unless _.contains [config.getSlackUser()], msg.envelope.user.name
      msg.send '君の名は？'
      msg.finish()
      return
    if /bot/.test msg.envelope.user.name
      msg.finish()
      return

  robot.hear /.*/, (msg) ->
    unless _.contains [config.getSlackChannel()], msg.envelope.room
      msg.finish()
      return
