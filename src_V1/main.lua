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
	
	if (not authKey or authKey == Environment.get 'authKey') 
		and (url:match '^https://[%w]-%.roblox%.com') then
		---TODO: check validity of response of res.body
		local resA = cURL.get(url)

		if resA.success then
			res.success = true
			res.statusCode = 200
			res.statusMessage = 'OK'
			res.body = resA.body
		else
			res.body = ('Bad request: conditional success, '
				.. 'http roblox request failed: response struct: %s'
				):format(Static.table.toString(resA))
		end
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
end).launch()