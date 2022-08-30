--run code below
local Static = require('Static')
local WebServer = require('WebServer')
	.new()
local cURL = require('cURL')
local Environment = require('Environment')

-- sample:
-- let our domain be `https://google.com`

-- client sent http request to home, being `google.com`
WebServer.onRequest('/robloxproxy', 'GET', function(client, req, res)
	res.statusCode = 404
	res.statusMessage = 'Bad request'
	res.headers.connection = 'close'
	res.body = 'Bad Request: correct webpage, conditional failed'

	local authKey = req.headers['Proxy-Auth-Key']
	local url = req.headers['Proxy-Url']
	
	local check = Environment.get 'authKey'

	if (not authKey or authKey == Environment.get 'authKey') 
		and (url:match '^https://[%w]-%.roblox%.com') then
		---TODO: check validity of response of res.body
		res.success = true
		res.statusCode = 200
		res.statusMessage = 'OK'
		res.body = cURL.get(url).body
	end
end).onRequest('/', 'GET', function (_, _, res)
	res.success = true
	res.statusCode = 200
	res.statusMessage = 'OK'
	res.body = 'Roblox proxy home page, nothing to show, see CHL-a on github'
end).onInvalidRequest(function (client, req, res)
	res.statusCode = 404
	res.statusMessage = 'Bad request'
	res.headers.connection = 'close'
	res.body = 'Bad Request: unknown webpage'
end)

-- always last step
.launch()