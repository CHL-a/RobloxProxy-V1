--run code below
local Static = require('Static')
local WebServer = require('WebServer')
	.new()
local cURL = require('cURL')
local Environment = require('Environment')

-- sample:
-- let our domain be `https://google.com`

-- client sent http request to home, being `google.com`
WebServer.onRequest('/rproxy', 'GET', function(client, req, res)
	res.statusCode = 404
	res.statusMessage = 'Bad request'
	res.headers.connection = 'close'
	res.body = 'bad request idk'

	local authKey = req.headers['X-Auth-Key']

	print(
		Static.table.toString(req)
	)

	if not authKey or authKey == Environment.get 'authKey' then
		do return end

		res.success = true
		res.statusCode = 200
		res.statusMessage = 'OK'
		res.body = cURL.get('').body
	end
end).onInvalidRequest(function (client, req, res)
	res.statusCode = 404
	res.statusMessage = 'Bad request'
	res.headers.connection = 'close'
	res.body = 'bad request idk'
end)

-- always last step
.launch()