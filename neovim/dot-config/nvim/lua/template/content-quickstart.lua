return {
  makefile = [[
###########################################################
#
# Makefile for ?
#
###########################################################

SRC=$(wildcard src/*.c)
HEADERS=$(wildcard src/*.h)

BIN=a.out

BASE_OPTS=-Wpedantic -Wall -Wextra -o $(BIN)
DBG_OPTS=-g -O2
OPTI_OPTS=-O3

all: $(BIN)

$(BIN): Makefile $(SRC) $(HEADERS)
	$(CC) $(OPTI_OPTS) $(BASE_OPTS) $(SRC)

debug: Makefile $(SRC) $(HEADERS)
	$(CC) $(DBG_OPTS) $(BASE_OPTS) $(SRC)

release: Makefile $(SRC) $(HEADERS)
	$(CC) $(OPTI_OPTS) -DNDEBUG $(BASE_OPTS) $(SRC)]],

  python = [[
def main():
    pass

if __name__ == "__main__":
    main()]],
  nvimpluginspec = [[
---@return { spec: function, config: nil|function, priority: nil|string }

local M = {
  spec = function(spec)
    -- Add_plugin(spec, 'name', { version = 'v' })
    -- Add_plugin(spec, 'name', nil)
  end,
  -- priority = 'z',
}
function M.config()

end

return M]],
}
