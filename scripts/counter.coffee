require('date-utils');

TOTALCOUNT = 'totalcount'

module.exports = {
	getCount: (robot, key) -> 
		count = robot.brain.get key or 0
		return count
		
	getCountToday: (robot) ->
		date = new Date()
		formatted = date.toFormat 'YYYYMMDD'
		return this.getCount robot, formatted
	
	getCountTotal: (robot) ->
		count = robot.brain.get TOTALCOUNT or 0
		return this.getCount robot, TOTALCOUNT
		
	clearCount: (robot, key) ->
		robot.brain.set key, 0
		robot.brain.save
		return robot.brain.get key
		
	clearCountToday: (robot) ->
		date = new Date()
		formatted = date.toFormat 'YYYYMMDD'
		# トータル数から今日食べた数を引く
		count = this.getCountToday robot
		this.subtractCountTotal robot, count
		return this.clearCount robot, formatted
	
	clearCountTotal: (robot) ->
		return this.clearCount robot, TOTALCOUNT
	
	addCount: (robot, key, addcount) ->
		count = robot.brain.get key or 0
		robot.brain.set key, count + addcount
		robot.brain.save
		if robot.brain.get key < 0
			return 0
		return robot.brain.get key
	
	addCountToday: (robot, addcount) ->
		date = new Date()
		formatted = date.toFormat 'YYYYMMDD'
		# トータル数も増加させる
		this.addCountTotal robot, addcount
		return this.addCount robot, formatted, addcount
	
	addCountTotal: (robot, addcount) ->
		return this.addCount robot, TOTALCOUNT, addcount
	
	subtractCountTotal: (robot, subcount) ->
		return this.addCount robot, TOTALCOUNT, subcount * -1
}