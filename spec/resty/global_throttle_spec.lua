describe("global_throttle", function()
  it("can be initialized", function()
    local global_throttle = require("resty.global_throttle")
    local my_throttle, err = global_throttle.new(100, 100, {})
    assert.is_nil(err)
    assert.is_not_nil(my_throttle)
  end)
end)
