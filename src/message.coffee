module.exports = {
	addDoughnutToMessage: (message, count) ->
		if count <= 0
			message += '\n'
			return message
		if count >= 10
			message += ':doughnut:x' + count + '\n'
			return message
		for i in [0..count-1]
			message += ':doughnut:'
		message += '\n'
		return message
	
	addDoughnutToMessageWithPrefixAndSuffix: (message, count, prefix, suffix) ->
		message += prefix
		message = this.addDoughnutToMessage message, count
		message += suffix
		return message
}