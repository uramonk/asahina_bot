# Author:
#   uramonk <https://github.com/uramonk>

require('date-utils')
dateFunc = require('../src/date')

FIRST_DAY = "asahina_bot_firstday"

module.exports = {
	getKey: (date) ->
		return 'asahina_bot_' + date.toFormat 'YYYYMMDD'

	getCount: (robot, key) ->
		count = robot.brain.get key
		if count == null
			count = 0
		return count

	getCountToday: (robot) ->
		date = new Date()
		key = this.getKey date
		return this.getCount robot, key

	getCountYesterday: (robot) ->
		date = Date.yesterday()
		key = this.getKey date
		return this.getCount robot, key

	getCountWeekFromToday: (robot) ->
		date = new Date()
		return this.getCountWeek robot, date

	getCountWeek: (robot, fromDate) ->
		count = 0
		while true
			key = this.getKey fromDate
			count += this.getCount robot, key
			fromDate = fromDate.addHours(-24)
			daynum = fromDate.getDay()
			# 土曜日なら終了
			if daynum == 6
				break
		return count

	getCountMonth: (robot, year, month) ->
		# new Dateの時はmonthを-1する
		date = new Date(year, month - 1, 1)
		daysInMonth = dateFunc.getDaysInMonth year, month
		count = 0
		for i in [1..daysInMonth]
			key = this.getKey date
			count += this.getCount robot, key
			date = date.addHours(24)
		return count

	getCountYear: (robot, year) ->
		date = new Date(year, 0, 1)
		count = 0
		for month in [1..12]
			count += this.getCountMonth robot, year, month
			date = date.addMonths(1)
		return count

	getCountTotal: (robot) ->
		firstday = this.getFirstDay robot
		if firstday == null
			return 0
		ymd = firstday.split '/'
		# new Dateの時はmonthを-1する
		fromDate = new Date(Number(ymd[0]), Number(ymd[1]) - 1, Number(ymd[2]))
		toDate = new Date()
		count = 0
		while true
			key = this.getKey fromDate
			count += this.getCount robot, key
			fromDate = fromDate.addHours(24)
			if Date.compare(fromDate, toDate) == 1
				break
		return count

	clearCount: (robot, key) ->
		count = robot.brain.get key
		if count == null
			return count
		else
			robot.brain.remove key
			robot.brain.save
			return this.getCount robot, key

	clearCountToday: (robot) ->
		date = new Date()
		key = this.getKey date
		return this.clearCount robot, key

	clearCountMonth: (robot, year, month) ->
		# new Dateの時はmonthを-1する
		date = new Date(year, month - 1, 1)
		daysInMonth = dateFunc.getDaysInMonth year, month
		count = 0
		for i in [1..daysInMonth]
			key = this.getKey date
			count += this.clearCount robot, key
			date = date.addHours(24)
		return count

	clearCountYear: (robot, year) ->
		date = new Date(year, 0, 1)
		count = 0
		for month in [1..12]
			count += this.clearCountMonth robot, year, month
			date = date.addMonths(1)
		return count

	clearCountAll: (robot) ->
		firstday = this.getFirstDay robot
		if firstday == null
			return 0
		ymd = firstday.split '/'
		# new Dateの時はmonthを-1する
		fromDate = new Date(Number(ymd[0]), Number(ymd[1]) - 1, Number(ymd[2]))
		toDate = new Date()
		count = 0
		while true
			key = this.getKey fromDate
			count += this.clearCount robot, key
			fromDate = fromDate.addHours(24)
			if Date.compare(fromDate, toDate) == 1
				break
		this.clearCount robot, FIRST_DAY
		return count

	addCount: (robot, key, addcount) ->
		count = robot.brain.get key
		if count == null
			count = 0
		addnum = count + addcount
		if addnum < 0
			addnum = 0
		robot.brain.set key, addnum
		robot.brain.save
		return robot.brain.get key

	addCountToday: (robot, addcount) ->
		date = new Date()
		key = this.getKey date
		return this.addCount robot, key, addcount

	setFirstDay: (robot) ->
		date = new Date()
		formatted = date.toFormat 'YYYY/MM/DD'
		firstday = this.getFirstDay robot
		if firstday == null
			robot.brain.set FIRST_DAY, formatted
			robot.brain.save

	getFirstDay: (robot) ->
		return robot.brain.get FIRST_DAY

	setFirstSpecificDay: (robot, ymdString) ->
		date = new Date(ymdString)
		formatted = date.toFormat 'YYYY/MM/DD'
		firstday = this.getFirstDay robot
		firstDate = new Date(firstday)
		if firstday == null or Date.compare(date, firstDate) == -1
			robot.brain.set FIRST_DAY, formatted
			robot.brain.save
}
