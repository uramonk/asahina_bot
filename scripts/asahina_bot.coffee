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
#	asabina_bot :doughnut:		- add a doughnut
#	asabina_bot count today		- show today's doughnuts
#	asabina_bot count week		- show week's (from Sunday to Today) doughnuts
#	asabina_bot count total		- show total doughnuts
#	asabina_bot count day YYYYMM/DD - show specified day's doughnuts
#	asabina_bot count month YYYY/MM - show specified month's doughnuts
#	asabina_bot count year YYYY	- show specified year's doughnuts
#	asabina_bot list		- list all doughnuts
#	asabina_bot list month YYYY/MM	- list specified month's doughnuts
#	asabina_bot list year YYYY	- list specified year's doughnuts
#	asabina_bot clear today		- clear today's doughnuts
#	asabina_bot clear all		- clear all doughnuts
#	asabina_bot clear day YYYYMM/DD - clear specified day's doughnuts
#	asabina_bot clear month YYYY/MM - clear specified month's doughnuts
#	asabina_bot clear year YYYY	- clear specified year's doughnuts
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   uramonk <https://github.com/uramonk>

require('date-utils');
counter = require('../src/counter')
config = require('../src/config')

respond_flag = false

module.exports = (robot) ->		
	robot.respond /:doughnut:/, (msg) ->
		respond_flag = true
		counter.setFirstDay robot
		dc = msg.message.text.split(/:doughnut:/).length - 1;
		count = counter.addCountToday robot, dc
		msg.send 'ドーナツ' + dc + '個食べたんだね'	
	
	robot.respond /add day (\d{4}\/\d{2}\/\d{2}) (\d+)$/, (msg) ->
		counter.setFirstSpecificDay robot, msg.match[1]
		date = new Date(msg.match[1])
		formatted = date.toFormat 'YYYYMMDD'
		count = counter.addCount robot, formatted, Number(msg.match[2])
		dateString = date.toFormat 'YYYY年MM月DD日'
		msg.send dateString + 'にドーナツ' + msg.match[2] + '個食べたんだね'
	
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

				
	