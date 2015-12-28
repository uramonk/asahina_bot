require('date-utils');

module.exports = (robot) -> 
	robot.respond /(:doughnut:)/, (msg) ->
		date = new Date()
		formatted = date.toFormat "YYYYMMDD"
		count = robot.brain.get formatted or 0
		robot.brain.set formatted, count + 1
		
		total = robot.brain.get 'totalcount'
		total += 1
		robot.brain.set 'totalcount', total
		robot.brain.save
		msg.send "ドーナツ食べたよ！"
	
	robot.respond /count all/, (msg) ->
		total = robot.brain.get 'totalcount'
		if total == null
			total = 0
		msg.send "今まで食べたドーナツは" + total + "個だよ！"
	
	robot.respond /count clear all/, (msg) ->
		robot.brain.set 'totalcount', 0
		msg.send 'ドーナツ食べた数を消したよ！'
				