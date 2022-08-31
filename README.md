# RobloxProxy-V1
Webservice for Roblox Servers to use roblox domains.
## Notes: 
 - Use [replit](https://replit.com)
 - Optionally, you can set an environment variable called `authKey` for access restrictions.
 - For Roblox Servers, in order to recieve the response body of the target url, you need some headers, Note that each header listed below must have the prefix `Proxy-`
| Header Name | Description |
| Auth-Key | Tighter access key, must match server's environment variable `authKey` | 