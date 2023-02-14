--run code below
local Static = require('Static')
local WebServer = require('WebServer')
	.new()
local cURL = require('cURL')
local Environment = require('Environment')

-- sample:
-- let our domain be `https://google.com`

-- client sent http request to home, being `google.com`
WebServer.onRequest('/', 'GET', function (_, _, res)
	res.success = true
	res.statusCode = 200
	res.statusMessage = 'OK'
	res.body = 'Roblox proxy home page, nothing to show, see CHL-a on github'
end).onInvalidRequest(function (client, req, res)
	res.statusCode = 404
	res.statusMessage = 'Bad request'
	res.headers.connection = 'close'
	res.body = 'Bad Request: unknown webpage'

	local webPage = Static.string.split(
		req.webPage,
		'/',
		true
	)

	-- pre
	if not (webPage[2] == 'robloxproxy' and webPage[3] == 'v2') then
		return
	end

	local authKey = req.headers['Proxy-Auth-Key']

	if not (not authKey or authKey == Environment.get 'authKey') then
		res.statusCode = 401
		res.body = 'Bad Request: Unauthorized'
		return
	end

	if req.requestType ~= 'GET' then
		res.statusCode = 400
		req.body = 'Bad Request: Expected GET Request'
		return
	end

	local url = ('https://%s.roblox.com/%s'):format(
		webPage[4],
		table.concat(webPage, '/', 5, #webPage)
	)

	local resA = cURL.get(url)

	if not (resA.success or resA.statusCode == 302) then
		res.statusCode = 400
		res.body = 'Http Request from Url gave bad '
			.. 'server response: '
			.. Static.table.toString(resA)
		return
	end

	-- main
	res.statusCode = 200
	res.success = true
	res.statusMessage = 'OK'
	res.body = resA.body
end).launch()
