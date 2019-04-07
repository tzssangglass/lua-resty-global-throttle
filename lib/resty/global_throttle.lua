local store_new = require("resty.global_throttle.store").new
local sliding_window_new = require("resty.global_throttle.sliding_window").new

local string_format = string.format
local ngx_log = ngx.log

local _M = { _VERSION = "0.1.0" }
local mt = { __index = _M }

function _M.new(limit, window_size_in_seconds, options)
  local store, err = store_new(options)
  if err then
    return nil, string_format("error initiating a store: %s", err)
  end
  
  local window_size = window_size_in_seconds * 1000
  local sw, err = sliding_window_new(store, window_size)
  if err then
    return nil, string_format("error while creating sliding window instance: %s", err)
  end

  return setmetatable({
    sliding_window = sw,
    limit = limit,
    window_size = window_size
  }, mt), nil
end

function _M.process(self, key)
  local estimated_total_count, err = self.sliding_window:add_sample_and_estimate_total_count(key)
  if err then
    return nil, err
  end

  local should_throttle = estimated_total_count > self.limit
  return should_throttle, nil
end

return _M
