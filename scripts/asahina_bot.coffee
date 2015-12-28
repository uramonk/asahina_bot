# Description
#   This bot is doughnut management bot.
#
# Dependencies:
#	"date-utils": "^1.2.17",
#   "hubot": "^2.17.0",
#   "hubot-diagnostics": "0.0.1",
#   "hubot-google-images": "^0.2.6",
#   "hubot-google-translate": "^0.2.0",
#   "hubot-help": "^0.1.2",
#   "hubot-heroku-keepalive": "^1.0.1",
#   "hubot-maps": "0.0.2",
#   "hubot-pugme": "^0.1.0",
#   "hubot-redis-brain": "0.0.3",
#   "hubot-rules": "^0.1.1",
#   "hubot-scripts": "^2.16.2",
#   "hubot-shipit": "^0.2.0",
#  	"hubot-slack": "^3.4.2",
#   "lodash": "^3.10.1"
#
# Configuration:
#   HUBOT_SLACK_CHANNEL: required
#	HUBOT_SLACK_USER_NAME: required
#
# Commands:
#	asabina_bot :doughnut: - add a doughnut
#	asabina_bot count today - show today doughnuts
#	asabina_bot count total - show total doughnuts
#	asabina_bot count clear today - clear today doughnuts
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   uramonk <https://github.com/uramonk>

require('date-utils');
CronJob = require('cron').CronJob
counter = require('../src/counter')
config = require '../src/config'

module.exports = (robot) ->
	###todayJob = new CronJob(
		cronTime: '00 00 00 * * 0-6'
		onTick: ->
			showCountToday()
			return
		start: true
	)
	showCountToday = () ->
		count = counter.getCountYesterday
		slackChannel = config.getSlackChannel()
		if slackChannel
			envelope = room: slackChannel
			robot.send '今日食べたドーナツは' + count + '個だよ！'
		
	weekJob = new CronJob(
		cronTime: '00 00 00 * * 0'
		onTick: ->
			showCountWeek()
			return
		start: true
	)
	showCountWeek = () ->
		count = counter.getCountWeek robot
		counter.clearCountWeek robot
		slackChannel = config.getSlackChannel()
		if slackChannel
			envelope = room: slackChannel
			robot.send '今週食べたドーナツは' + count + '個だよ！'###
	
	robot.respond /(:doughnut:)/, (msg) ->
		count = counter.addCountToday robot, 1
		msg.send 'ドーナツ' + count + '個食べたよ！'
	
	robot.respond /count today/, (msg) ->
		count = counter.getCountToday robot
		msg.send '今日食べたドーナツは' + count + '個だよ！'
	
	robot.respond /count week/, (msg) ->
		count = counter.getCountWeek robot
		msg.send '今週食べたドーナツは' + count + '個だよ！'
		
	robot.respond /count total/, (msg) ->
		count = counter.getCountTotal robot
		msg.send '今まで食べたドーナツは' + count + '個だよ！'
	
	robot.respond /count clear today/, (msg) ->
		count = counter.clearCountToday robot
		msg.send '今日食べたドーナツが' + count + '個になっちゃった…'
		
	###robot.respond /count clear total/, (msg) ->
		count = clearCountTotal robot
		msg.send '今まで食べたドーナツが' + count + '個になっちゃった…'###