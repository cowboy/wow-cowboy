-- ===============================================
-- CBEvent
-- ===============================================

-- Old and simple.
-- Cowboy:SetScript('OnEvent', function(self, event, ...) self[event](self, event, ...); end)
-- function Cowboy:On(event, fn) self:RegisterEvent(event); self[event] = fn; end
-- function Cowboy:Off(event) self:UnregisterEvent(event); self[event] = nil; end

-- Create and hide UI frame.
local CBEvent = CreateFrame('Frame', 'CBEvent'); CBEvent:Hide()

-- A table of event types.
CBEvent.cbevents = {}

-- When OnCBEvent is called (an event is fired) call the event-named function
-- (if it exists). Much of the logic from the CBEvent:On wrapper could be moved
-- into here, but it's kept as-is for debugging purposes.
local function SetScriptOnEvent(self, event, ...) self[event](self, event, ...); end
CBEvent:SetScript('OnEvent', SetScriptOnEvent)

-- Bind an event handler. Inside the handler, an event table is passed in as
-- the first argument {type = eventname, handler = eventhandler}.
function CBEvent:On(event, handler)
  local events = self.cbevents[event]
  if (not events) then
    events = {}
    self.cbevents[event] = events
    self[event] = function(self, type, ...)
      for i, fn in ipairs(events) do
        local event = {type = type, handler = fn}
        if (self ~= CBEvent) then fn(self, event, ...); else fn(event, ...); end
      end
    end
    self:RegisterEvent(event)
  end
  table.insert(events, handler)
end

-- Unbind an event handler. If no handler reference is specified, all event
-- handlers for this event type will be unbound.
function CBEvent:Off(event, handler)
  local events = self.cbevents[event]
  if (handler and events) then
    for i = #events, 1, -1 do
      if (events[i] == handler) then table.remove(events, i); end
    end
  end
  if (not handler or (events and #events == 0)) then
    self:UnregisterEvent(event)
    self.cbevents[event] = nil
    self[event] = nil
  end
end

-- Mix-in the event system to your own stuff for much win.
function CBEvent:Mixin(target)
  target:SetScript('OnEvent', SetScriptOnEvent)
  target.cbevents = {}
  target.OnEvent = self.On
  target.OffEvent = self.Off
end

--[[ Usage:

Other = {val = 0}
function Other:Sample(event) print(self.val, event.type, event.handler); end

print('Mixed-in: ')
CBEvent:Mixin(Other)

Other:OnEvent('TEST', Other.Sample)
Other:OnEvent('TEST', function(self, event) print(2, event.type, event.handler); Other:OffEvent(event.type, event.handler); end)
Other:OnEvent('TEST', function(self, event) print(1, event.type, event.handler); end)

Other:TEST('TEST') // logs 0, 1, 2
print('---')
Other:TEST('TEST') // logs 0, 1

print('---')

print('Static: ')

CBEvent:On('TEST', function(...) Other:Sample(...); end)
CBEvent:On('TEST', function(event) print(1, event.type, event.handler); end)
CBEvent:On('TEST', function(event) print(2, event.type, event.handler); CBEvent:Off(event.type, event.handler); end)

CBEvent:TEST('TEST') // logs 0, 1, 2
print('---')
CBEvent:TEST('TEST') // logs 0, 1

]]
