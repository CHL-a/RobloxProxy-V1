# RobloxProxy-V1
Webservice for Roblox Servers to use roblox domains.
## Notes: 
 - Use [replit](https://replit.com)
 - Optionally, you can set an environment variable called `authKey` for access restrictions.
 - For Roblox Servers, in order to recieve the response body of the target url, you need to send an http GET request to your url's webpage, `/robloxproxy/v2/robloxSubDomain/otherURLDirectories`, and some headers. Note that each header listed below must have the prefix `Proxy-`, and that exactly one subdomain is acceptable
```
+-----------+------------------------------------------------------+
|Header Name|Description                                           |
+-----------+------------------------------------------------------+
| Auth-Key  | Tighter access key, must match server's environment  |
|           | variable `authKey`, or can be left blank if the      |
|           | environment variable is blank                        |
+-----------+------------------------------------------------------+
```
   - Code example
```lua
game.HttpService:RequestAsync{
  Url = 'https://your.proxy.url/robloxproxy/v2/www/games/292439477/Phantom-Forces';
  Method = 'GET';
  Headers = {
    ['Proxy-Auth-Key'] = 'sampleKeyHere';
  }
}
```