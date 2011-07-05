-- ===============================================
-- CBSlash
-- ===============================================

-- Create and hide UI frame.
local CBSlash = CreateFrame('Frame', 'CBSlash'); CBSlash:Hide()

-- Slash commands.
CBSlash.slashes = {}

-- Register a slash command.
function CBSlash:On(cmds, desc, fn)
  if type(cmds) == 'string' then cmds = {cmds}; end
  local id = 'COWBOYSLASH_'..cmds[1]:upper()
  for i, cmd in ipairs(cmds) do _G['SLASH_'..id..i] = cmd:lower(); end
  self.slashes[cmds] = desc
  SlashCmdList[id] = function(str)
    local args = {}
    for arg in str:gmatch('([^%s]+)') do table.insert(args, arg); end
    fn(str, unpack(args))
  end
end

-- Get a generic iterator for all registered slash commands.
function CBSlash:Slashes()
  return pairs(self.slashes)
end

--[[ Usage:

CBSlash:On('/example', 'Useful description', function(str, a, b)
  -- With this command:
  --   /example foo  bar
  -- These values exist inside this callback:
  --   str == "foo  bar"
  --   a == "foo"
  --   b == "bar"
end)

]]

