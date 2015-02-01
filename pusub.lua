json = loadfile ("./libs/JSON.lua")()
loadfile ("./libs/Utils.lua")()

local redis = require 'redis'

local params = {
    host = '127.0.0.1',
    port = 6379,
}


local client = redis.connect(params)
-- client:set('foo', 'bar')
-- client:incr('id:users')
-- client:set('messages:1', '{"message":"Commit!!!","channel":100}')
-- client.sadd('users', '{id}')
message = {
  -- to="chat#13217234",
  to="user#id1036213",
  body="Im message from redis!"
}
message = json:encode(message)
-- var_dump(message)
-- client:rpush("messages_to_send", message)
records = client:raw_cmd("LRANGE messages_to_send -100 100")
var_dump("Records:"..#records)

for k, item in ipairs(records) do
  item = json:decode(item)
  -- send_msg (item.to, body)
  -- client:raw_cmd("RPOP messages_to_send")
end
-- var_dump(client:raw_cmd("RPOP messages_to_send"))


