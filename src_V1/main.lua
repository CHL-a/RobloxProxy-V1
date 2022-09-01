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
	-- v1
	res.statusCode = 404
	res.statusMessage = 'Bad request'
	res.headers.connection = 'close'
	res.body = 'Bad Request: correct webpage, conditional failed'

	local authKey = req.headers['Proxy-Auth-Key']
	---@type string
	local url = req.headers['Proxy-Url']
	url = url:gsub('%%%x%x', function (a)
		return string.char(
			assert(tonumber('0x' .. a:sub(2)))
		)
	end)

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

	if not resA.success then
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