json = loadfile ("./libs/JSON.lua")()
loadfile ("./libs/Utils.lua")()
-- require "simpleCgiHandler"

local xavante = require "xavante"
local wsapi = require "wsapi.xavante"
local common = require "wsapi.common"

function set_api (req, res)
  local SAPI = {
  Response = {},
  Request = {},
  }
  -- Headers
  SAPI.Response.contenttype = function (s)
  res.headers ["Content-Type"] = s
  end
  SAPI.Response.redirect = function (s)
  res.headers ["Location"] = s
  res.statusline = "HTTP/1.1 301 Moved Permanently\r\n"
  res.content = " " --one blank to force output
  end
  SAPI.Response.header = function (h, v)
  res.headers [h] = v
  end
  -- Contents
  SAPI.Response.write = function (s)
  httpd.send_res_data (res, s)
  end
  SAPI.Response.errorlog = function (s) io.stderr:write (s) end
  -- Input POST data
  SAPI.Request.getpostdata = function (n)
    return req.socket:receive (n)
  end
  -- Input general information
  SAPI.Request.servervariable = function (n)
  return req.cgivars[n]
  end

  return SAPI
end

local hex_to_char = function(x)
  return string.char(tonumber(x, 16))
end

local unescape = function(url)
  return url:gsub("%%(%x%x)", hex_to_char)
end


function makeHandler()
  return function(req, res)
    -- var_dump(req.relpath)
    req.socket:settimeout(2)
    local payload = req.socket:receive(req.headers['content-length'])
    local uri = unescape(payload)
    -- var_dump(json:decode(uri:gsub("payload=", "")))
    send_msg ("chat#13217234", "OLOLO! Commit!")
  end
end

xavante.start_message(function (ports)
    local date = os.date("[%Y-%m-%d %H:%M:%S]")
    print(string.format("%s Xavante started on port(s) %s",
      date, table.concat(ports, ", ")))
  end)

xavante.HTTP{
    server = {host = "*", port = 8989},
    defaultHost = {
        rules = {
          { match= { "/", "/*" }, with = makeHandler() }
        }
    },
}

function run(msg, matches)
  xavante.start()
end

return {
  description = "Github as is",
  usage = "!github",
  patterns = {
  "^!github$"
  },
  run = run
}


