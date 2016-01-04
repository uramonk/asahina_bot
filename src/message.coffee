module.exports = {
	addDoughnutToMessage: (message, count) ->
		if count <= 0
			return message
		message += 'x' + count
		return message
	
	addDoughnutToMessageWithPrefixAndSuffix: (message, count, prefix, suffix) ->
		message += prefix
		message = this.addDoughnutToMessage message, count
		message += suffix
		return message
}