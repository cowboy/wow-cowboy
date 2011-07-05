-- ===============================================
-- Core
-- ===============================================

-- Create and hide UI frame.
local Cowboy = CreateFrame('Frame', 'Cowboy'); Cowboy:Hide()

-- Mix-in event methods.
CBEvent:Mixin(Cowboy)

-- Testing
--CBEvent:On('PLAYER_LOGIN', function(event) print('CBEvent', event.type, event.handler); end)
--Cowboy:OnEvent('PLAYER_LOGIN', function(self, event) self:Log('OnEvent', event.type, event.handler); end)

-- Log to chat.
function Cowboy:Log(...)
  local a, b, c = '|cff00BBEE', '|cff00CCFF', '|cff77EEFF'
  return print(a..'['..b..'['..c..'CB'..b..']'..a..']|r:', ...)
end

-- ===============================================
-- Key bindings
-- ===============================================

BINDING_HEADER_COWBOY = 'Cowboy'
for i = 0, 9 do _G['BINDING_NAME_COWBOY_'..i] = 'Ignore for now'; end

-- Route keypresses through the CBEvent system.
function Cowboy:KeyPress(state, i)
  state = state:upper()
  self['KEY'..state..'_'..i](self, i)
  self['KEYPRESS_'..i](self, state, i)
end

--[[
Cowboy:OnEvent('KEYDOWN_0', function(self, i) self:Log('Key '..i..' DOWN'); end)
Cowboy:OnEvent('KEYUP_0', function(self, i) self:Log('Key '..i..' UP'); end)
Cowboy:OnEvent('KEYPRESS_0', function(self, state, i) self:Log('Key '..i..' '..state); end)
]]

-- Set camera zoom max distance to 150 (WoW max)
SetCVar('cameraDistanceMax', 50)
SetCVar('cameraDistanceMaxFactor', 1)

--BINDING_NAME_COWBOY_0 = 'Zoom camera in'
--Cowboy:OnEvent('KEYDOWN_0', function() CameraZoomIn(10); end)
--BINDING_NAME_COWBOY_1 = 'Zoom camera out'
--Cowboy:OnEvent('KEYDOWN_1', function() CameraZoomOut(10); end)

-- ===============================================
-- Slash commands
-- ===============================================

CBSlash:On({'/reloadui', '/rl'}, 'Reload UI', ReloadUI)

-- Use before running a macro command that might "complain."
CBSlash:On('/s0', nil, function()
  SetCVar('Sound_EnableSFX', '0')
end)

-- Use after running a macro command that might "complain."
CBSlash:On('/s1', nil, function()
  SetCVar('Sound_EnableSFX', '1')
  UIErrorsFrame:Clear()
end)

-- List /commands.
Cowboy:OnEvent('PLAYER_LOGIN', function(self, event)
  self:Log('Slash commands:')
  for cmds, desc in CBSlash:Slashes() do
    if desc then self:Log('  '..table.concat(cmds, ', ')..': '..desc); end
  end
end)

-- ===============================================
-- Fonts
-- ===============================================

Cowboy:OnEvent('PLAYER_LOGIN', function(self, event)
  local f = {}
  f['mplus-2p-black.ttf'] = 'M+ 2p Black'
  f['mplus-2p-bold.ttf'] = 'M+ 2p Bold'
  f['mplus-2p-heavy.ttf'] = 'M+ 2p Heavy'
  f['mplus-2p-light.ttf'] = 'M+ 2p Light'
  f['mplus-2p-medium.ttf'] = 'M+ 2p Medium'
  f['mplus-2p-regular.ttf'] = 'M+ 2p Regular'
  f['mplus-2p-thin.ttf'] = 'M+ 2p Thin'

  for file in pairs(f) do
    local path = 'Interface\\Addons\\Cowboy\\fonts\\'..file
    SharedMediaAdditionalFonts:Register('font', f[file], path)
  end

  self:Log('Fonts loaded.')
end)

-- ===============================================
-- Core
-- ===============================================

Cowboy:OnEvent('PLAYER_LOGIN', function(self, event) self:Log('Ready to go.'); end)
Cowboy:Log('Cowboy.lua loaded.')
