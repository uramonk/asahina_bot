CronJob = require('cron').CronJob
counter = require('../src/counter')
config = require('../src/config')

module.exports = (robot) ->
	weekJob = new CronJob(
		cronTime: '00 00 00 * * 0'
		onTick: ->
			showCountWeek()
			return
		start: true
	)
	showCountWeek = () ->
		date = Date.yesterday()
		count = counter.getCountWeek robot, date
		slackChannel = config.getSlackChannel()
		if slackChannel != null
			envelope = {room: slackChannel}
			robot.send envelope, '先週食べたドーナツは' + count + '個だよ'
			if count == 0
				robot.send envelope, 'ドーナツ食べないなんて、絶対人生の半分ぐらい損してるよ！'
			else if count < 5
				robot.send envelope, 'とりあえずドーナツ屋にいくよ！'
			else if count >= 5
				robot.send envelope, 'リングドーナツ、ツイストドーナツ、あんドーナツ、ジェリードーナツ、マラサダ、サーターアンダギー\nドーナツの神様！私に素敵な出会いがありますように！'
