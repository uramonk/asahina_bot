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
	
	robot.respond /count today$/, (msg) ->
		count = counter.getCountToday robot
		msg.send '今日食べたドーナツは' + count + '個だよ'
	
	robot.respond /count week$/, (msg) ->
		count = counter.getCountWeek robot
		msg.send '今週食べたドーナツは' + count + '個だよ'
		
	robot.respond /count total$/, (msg) ->
		count = counter.getCountTotal robot
		msg.send '今まで食べたドーナツは' + count + '個だよ'
		
	robot.respond /count day (\d{4}\/\d{2}\/\d{2})$/, (msg) ->
		date = new Date(msg.match[1])
		count = counter.getCount robot, msg.match[1].replace /\//g, ''
		dateString = date.toFormat 'YYYY年MM月DD日'
		msg.send dateString + 'に食べたドーナツは' + count + '個だよ'
	
	robot.respond /count month (\d{4}\/\d{2})$/, (msg) ->
		yearMonthString = msg.match[1].split '/'
		count = counter.getCountMonth robot, Number(yearMonthString[0]), Number(yearMonthString[1])
		date = new Date(msg.match[1])
		dateString = date.toFormat 'YYYY年MM月'
		msg.send dateString + 'に食べたドーナツは' + count + '個だよ'
		
	robot.respond /count year (\d{4})$/, (msg) ->
		count = counter.getCountYear robot, Number(msg.match[1])
		date = new Date(msg.match[1])
		dateString = date.toFormat 'YYYY年'
		msg.send dateString + 'に食べたドーナツは' + count + '個だよ'
	
	robot.respond /clear today$/, (msg) ->
		count = counter.clearCountToday robot
		msg.send '今日食べたドーナツ、' + count + '個にしたよ'
		
	robot.respond /clear day (\d{4}\/\d{2}\/\d{2})$/, (msg) ->
		date = new Date(msg.match[1])
		count = counter.clearCount robot, msg.match[1].replace /\//g, ''
		dateString = date.toFormat 'YYYY年MM月DD日'
		msg.send dateString + 'に食べたドーナツ、' + count + '個にしたよ'
	
	robot.respond /clear month (\d{4}\/\d{2})$/, (msg) ->
		yearMonthString = msg.match[1].split '/'
		count = counter.clearCountMonth robot, Number(yearMonthString[0]), Number(yearMonthString[1])
		date = new Date(msg.match[1])
		dateString = date.toFormat 'YYYY年MM月'
		msg.send dateString + 'に食べたドーナツ、' + count + '個にしたよ'
	
	robot.respond /clear year (\d{4})$/, (msg) ->
		count = counter.clearCountYear robot, Number(msg.match[1])
		date = new Date(msg.match[1])
		dateString = date.toFormat 'YYYY年'
		msg.send dateString + 'に食べたドーナツ、' + count + '個にしたよ'
	
	robot.respond /clear all/, (msg) ->
		count = counter.clearCountAll robot
		firstday = counter.getFirstDay robot
		date = new Date(firstday)
		dateString = date.toFormat 'YYYY年MM月DD日'
		msg.send dateString + 'から今日まで食べたドーナツ、' + count + '個にしたよ'
	
	robot.respond /list$/, (msg) ->
		firstday = counter.getFirstDay robot
		if firstday == null
			return
		year = firstday.split('/')[0]
		today = new Date()
		date = new Date(year, 0, 1)
		sendMessage = ''
		while true
			count = counter.getCountYear robot, year
			dateString = date.toFormat 'YYYY年'
			sendMessage += dateString + ': ' + count + '個\n'
			date.addYears(1)
			if Date.compare(date, today) == 1
				break
		msg.send '```\n' + sendMessage + '```\n'
		
	robot.respond /list month (\d{4}\/\d{2})$/, (msg) ->
		ym = msg.match[1].split('/')
		year = ym[0]
		month = ym[1]
		date = new Date(Number(year), Number(month) - 1, 1)
		sendMessage = ''
		while true
			formatted = date.toFormat 'YYYYMMDD'
			count = counter.getCount robot, formatted
			dateString = date.toFormat 'YYYY年MM月DD日'
			sendMessage += dateString + ': ' + count + '個\n'
			date.addHours(24)
			if date.getMonth() > Number(month) - 1 or date.getFullYear() > Number(year)
				break
		msg.send '```\n' + sendMessage + '```\n'
	
	robot.respond /list year (\d{4})$/, (msg) ->
		year = msg.match[1]
		date = new Date(Number(year), 0, 1)
		sendMessage = ''
		while true
			formatted = date.toFormat 'YYYYMMDD'
			# getMonthは0-11なので1加える
			count = counter.getCountMonth robot, Number(year), date.getMonth() + 1
			dateString = date.toFormat 'YYYY年MM月'
			sendMessage += dateString + ': ' + count + '個\n'
			date.addMonths(1)
			if date.getFullYear() > Number(year)
				break
		msg.send '```\n' + sendMessage + '```\n'
	
	robot.respond /oogami$/, (msg) ->
		msg.send 'さくらちゃん！'
	
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

				
	