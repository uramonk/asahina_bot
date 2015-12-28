require('date-utils');
counter = require('./counter')

module.exports = (robot) -> 
	robot.respond /(:doughnut:)/, (msg) ->
		count = counter.addCountToday robot, 1
		msg.send 'ドーナツ' + count + '個食べたよ！'
	
	robot.respond /count today/, (msg) ->
		count = counter.getCountToday robot
		msg.send '今日食べたドーナツは' + count + '個だよ！'
		
	robot.respond /count total/, (msg) ->
		count = counter.getCountTotal robot
		msg.send '今まで食べたドーナツは' + count + '個だよ！'
	
	robot.respond /count clear today/, (msg) ->
		count = counter.clearCountToday robot
		msg.send '今日食べたドーナツが' + count + '個になっちゃった…'
		
	###robot.respond /count clear total/, (msg) ->
		count = clearCountTotal robot
		msg.send '今まで食べたドーナツが' + count + '個になっちゃった…'###