# Description
#   This bot is doughnut management bot.
#
# Dependencies:
#   "hubot": "^2.17.0",
#   "hubot-help": "^0.1.2",
#   "hubot-heroku-keepalive": "^1.0.1",
#   "hubot-scripts": "^2.16.2",
#   "hubot-slack": "^3.4.2",
#   "lodash": "^3.10.1",
#   "cron": "^1.1.0",
#   "date-utils": "^1.2.17",
#   "time": "^0.11.4"
#
# Configuration:
#   HUBOT_SLACK_CHANNEL: required
#	HUBOT_SLACK_USER_NAME: required
#
# Commands:
#	asabina_bot :doughnut:  - add a doughnut
#	asabina_bot count today - show today doughnuts
#	asabina_bot count total - show total doughnuts
#	asabina_bot clear today - clear today doughnuts
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   uramonk <https://github.com/uramonk>

require('date-utils');
CronJob = require('cron').CronJob
counter = require('../src/counter')
config = require('../src/config')

respond_flag = false

module.exports = (robot) ->		
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
		if slackChannel != null
			envelope = {room: slackChannel}
			robot.send envelope, '先週食べたドーナツは' + count + '個だよ！'
			if count == 0
				robot.send envelope, 'ドーナツ食べないなんて、絶対人生の半分ぐらい損してるよ！'
			else if count < 5
				robot.send envelope, 'とりあえずドーナツ屋にいくよ！'
			else if count >= 5
				robot.send envelope, 'リングドーナツ、ツイストドーナツ、あんドーナツ、ジェリードーナツ、マラサダ、サーターアンダギー\nドーナツの神様！私に素敵な出会いがありますように！'
	
	robot.respond /:doughnut:/, (msg) ->
		respond_flag = true
		dc = msg.message.text.split(/:doughnut:/).length - 1;
		count = counter.addCountToday robot, dc
		msg.send 'ドーナツ' + dc + '個食べたよ！'
	
	robot.respond /count today/, (msg) ->
		count = counter.getCountToday robot
		msg.send '今日食べたドーナツは' + count + '個だよ！'
	
	robot.respond /count week/, (msg) ->
		count = counter.getCountWeek robot
		msg.send '今週食べたドーナツは' + count + '個だよ！'
		
	robot.respond /count total/, (msg) ->
		count = counter.getCountTotal robot
		msg.send '今まで食べたドーナツは' + count + '個だよ！'
		
	robot.respond /count day (\d{4}\/\d{2}\/\d{2})$/, (msg) ->
		date = new Date(msg.match[1])
		count = counter.getCount robot, msg.match[1].replace /\//g, ''
		dateString = date.toFormat 'YYYY年MM月DD日'
		msg.send dateString + 'に食べたドーナツは' + count + '個だよ！'
	
	robot.respond /clear today/, (msg) ->
		count = counter.clearCountToday robot
		msg.send '今日ドーナツ食べたと思ったら夢だった…'
	
	robot.hear /:doughnut:/, (msg) ->
		if respond_flag
			respond_flag = false
			return
		num = Math.floor(Math.random() * 3) + 1
		switch num
			when 1
				msg.send 'ドーナツ！'
			when 2
				count = counter.getCountToday robot
				if count == 0
					msg.send '今日ドーナツ食べてない…'
				else 
					msg.send '今日ドーナツ食べた！'
			when 3
				msg.send ':doughnut:'

				
	