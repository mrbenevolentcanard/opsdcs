--- OpsdcsCrew - Virtual Crew (mission script)

-- if OpsdcsCrew then return end -- do not load twice (mission+hook)

OpsdcsCrew = {
    --- @type table @default options
    options = {
        debug = false,              --- @type boolean @debug mode, set true for ingame debug messages
        timeDelta = 0.1,            --- @type number @seconds between updates
        showChecklist = true,       --- @type boolean @show interactive checklist when true
        showSingleItem = false,     --- @type boolean @show only a single item when true (declutter for VR) @todo
        showSingleItemTime = 0.5,   --- @type number @seconds to show single item before advancing (set to 0 to immediately show first unchecked)
        showHighlights = false,     --- @type boolean @shows highlights for next check
        playSounds = false,         --- @type boolean @play sounds
        autoAdvance = 2,            --- @type number @auto advance to next state if all checked within this time (0 to disable)
        commandAdvance = 0,         --- @type number @advance on user command @todo
        autoStartProcedures = true, --- @type boolean @autostart procedures when condition is met @todo
    },

    --- @type string[] @supported types (@todo: autocheck, variants)
    aircraftTypes = {
        -- heli
        "AH-64D_BLK_II",
        "CH-47Fbl1",
        "Ka-50_3",
        "Mi-8MT",
        "Mi-24P",
        "OH-6A",
        "OH58D",
        "SA342L",
        "SA342M",
        "SA342Minigun",
        "UH-1H",
        -- jet
        "F-16C_50",
        -- piston
        "Bf-109K-4",
        "FW-190A8",
        "MosquitoFBMkVI",
        "P-51D",
        "SpitfireLFMkIX",
    },

    typeName = nil,                --- @type string? @player unit type
    groupId = nil,                 --- @type number? @player group id
    menu = {},                     --- @type table @stores f10 menu items
    params = {},                   --- @type table @current params
    args = {},                     --- @type table @current args
    indications = {},              --- @type table @current indications
    state = nil,                   --- @type string? @current state
    firstUnchecked = nil,          --- @type number? @first unchecked item
    numHighlights = 0,             --- @type number @current number of highlights
    zones = {},                    --- @type table @opsdcs-crew zones
    isRunning = false,             --- @type boolean @true when procedure is running
    argsDebugMaxId = 4000,         --- @type number @maximum argument id for debug
    sndPlayUntil = nil,            --- @type number? @sound play until time
    sndRepeatAfter = 30,           --- @type number @repeat sound after seconds
    mainmenu = "Crew",             --- @type string @main menu name
    eventHandlerId = "OpsdcsCrew", --- @type string @event handler id
}

------------------------------------------------------------------------------

--- get option (default or from plugin)
--- @param string name @option name
--- @return any @option value
function OpsdcsCrew:getOption(name)
    local option = self.options[name]
    if self[self.typeName] and self[self.typeName].options and self[self.typeName].options[name] ~= nil then
        option = self[self.typeName].options[name]
    end
    return option
end

--- debug log helper
--- @param msg string @message
--- @param duration number @duration
function OpsdcsCrew:log(msg, duration)
    if self:getOption("debug") then
        trigger.action.outText("[opsdcs-crew] " .. msg, duration or 3)
    end
end

--- load script (from inside mission or from file system)
--- @param filename string @filename relative to basedir
function OpsdcsCrew:loadScript(filename)
    self:log("loading " .. filename)
    if OpsdcsCrewBasedir then
        dofile(OpsdcsCrewBasedir .. filename)
    else
        net.dostring_in("mission", "a_do_script_file('" .. filename .. "')")
    end
end

--- loads/resets plugin data and states
function OpsdcsCrew:loadPluginData()
    for _, aircraft in ipairs(self.aircraftTypes) do
        self:loadScript("aircraft/" .. aircraft .. ".lua")
    end
end

------------------------------------------------------------------------------

--- start script
function OpsdcsCrew:start()
    self:log("start")
    self:loadPluginData()
    world.addEventHandler(self)
    missionCommands.addSubMenu(self.mainmenu, nil)
    local player = world.getPlayer()
    if player then
        self:initPlayer(player)
    end
end

--- init player
function OpsdcsCrew:initPlayer(unit)
    self.groupId = unit:getGroup():getID()
    self:log("group id: " .. self.groupId)
    self.typeName = unit:getTypeName()
    local isSupported = false
    for _, typeName in ipairs(self.aircraftTypes) do
        isSupported = isSupported or self.typeName == typeName
    end
    if not isSupported then return end
    self:log("start: " .. self.typeName .. " (" .. (OpsdcsCrewInject and "hook" or "mission") .. ")")
    self:setupWaitForUserFlags()
    self:refreshMenu()
end

--- stop script
function OpsdcsCrew:stop()
    self:log("stop")
    self.isRunning = false
    self:clearHighlights()
    missionCommands.removeItem(self.mainmenu)
    for index, handler in world.eventHandlers do
        if handler.eventHandlerId == self.eventHandlerId then
            world.eventHandlers[index] = nil
        end
    end
end

--- event handler
--- @param event Event @event
function OpsdcsCrew:onEvent(event)
    if event.id == world.event.S_EVENT_PLAYER_ENTER_UNIT then
        self:initPlayer(event.initiator)
    elseif event.id == world.event.S_EVENT_PLAYER_LEAVE_UNIT then
        self.isRunning = false
        self:clearMenu()
        trigger.action.outText("", 0, true)
    else
        --self:genericOnEvent(event)
    end
end

--- generic debug event handler
--- @param event Event @event
function OpsdcsCrew:genericOnEvent(event)
    if self.eventNamesById == nil then
        self.eventNamesById = {}
        for key, value in pairs(world.event) do
            self.eventNamesById[value] = key
        end
    end
    self:log("event: " .. self.eventNamesById[event.id])
end

------------------------------------------------------------------------------

--- plays sound (from inside miz, or absolute path when using basedir)
--- @param string filename
--- @param number duration
function OpsdcsCrew:playSound(filename, duration)
    if OpsdcsCrewBasedir then
        local code = "require('sound').playSound('" .. OpsdcsCrewBasedir .. filename .. "')"
        net.dostring_in("gui", code)
    else
        trigger.action.outSound(filename)
    end
    self.sndPlayUntil = timer.getTime() + (duration or 1)
    self.sndLastPlayed = timer.getTime()
end

-- plays sound from text/seat/soundpack (sounds/typename/seat/soundpack/state/text.ogg)
function OpsdcsCrew:playSoundFromText(text, duration, seat)
    seat = seat or "cp"
    local filename = "sounds/" .. self.typeName .. "/" .. seat .. "/" .. self[self.typeName].soundpack[seat] .. "/" .. self.state .. "/"
    filename = filename .. text:gsub("[/>:]", "-") .. ".ogg"
    self:playSound(filename, duration)
end

------------------------------------------------------------------------------

--- sets up user input (space and backspace)
function OpsdcsCrew:setupWaitForUserFlags()
    local code = "a_clear_flag('pressedSpace');a_clear_flag('pressedBS');c_start_wait_for_user('pressedSpace','pressedBS')"
    net.dostring_in("mission", code)
end

--- returns all cockpit params @todo refactor usage
function OpsdcsCrew:getCockpitParams()
    local list = net.dostring_in("export", "return list_cockpit_params()")
    local params = {}
    for line in list:gmatch("[^\n]+") do
        local key, value = line:match("([^:]+):(.+)")
        if key and value then
            value = value:match("^%s*(.-)%s*$")
            if tonumber(value) then
                params[key] = tonumber(value)
            else
                params[key] = value:match('^"(.*)"$') or value
            end
        end
    end
    return params
end

--- returns cockpit args
--- @param number maxId @maximum argument id (if nil, get named arguments from aircraft definition)
--- @param table idList @optional list of argument ids to get
function OpsdcsCrew:getCockpitArgs(maxId, idList)
    if self[self.typeName].argsById == nil then
        self[self.typeName].argsById = {}
        for k, v in pairs(self[self.typeName].args) do
            self[self.typeName].argsById[v] = k
        end
    end
    local code
    local keys = {}
    if maxId == nil and idList == nil then
        idList = {}
        for _, v in pairs(self[self.typeName].args) do
            table.insert(idList, v)
        end
    end
    if maxId then
        code = "local d,r=GetDevice(0),'';for i=1," .. maxId .. " do r=r..d:get_argument_value(i)..';' end;return r"
    elseif idList then
        code = "local d,r=GetDevice(0),'';for _,i in ipairs({" .. table.concat(idList, ",") .. "}) do r=r..d:get_argument_value(i)..';' end;return r"
    end
    local csv = net.dostring_in("export", code)
    local args = {}
    local i = 1
    for value in csv:gmatch("([^;]+)") do
        if maxId then
            args[i] = tonumber(value)
        elseif idList then
            local key = self[self.typeName].argsById[idList[i]] or idList[i]
            args[key] = tonumber(value)
        end
        i = i + 1
    end
    return args
end

--- returns indications from specified devices
--- @param number maxId @maximum device id (if nil, get only devices from aircraft definition)
function OpsdcsCrew:getIndications(maxId)
    local code = "return ''"
    if maxId == nil then
        for device_id, _ in pairs(self[self.typeName].indications) do
            code = code .. "..'##" .. device_id .. "##\\n'..list_indication(" .. device_id .. ")"
        end
    else
        for device_id = maxId, maxId do
            code = code .. "..'##" .. device_id .. "##\\n'..list_indication(" .. device_id .. ")"
        end
    end
    local lfsv = net.dostring_in("export", code)
    local indications = {}
    local device_id, key, content = nil, nil, ""
    for line in lfsv:gmatch("[^\n]+") do
        if line:match("^##(%d+)##$") then
            device_id = tonumber(line:match("^##(%d+)##$"))
            indications[device_id] = {}
        elseif line == "-----------------------------------------" then
            if key then
                indications[device_id][key] = content:sub(1, -2)
            end
            key, content = nil, ""
        elseif not key then
            key = line
        else
            if line ~= "}" then
                content = content .. line .. "\n"
            end
        end
    end
    if key then
        indications[device_id][key] = content:sub(1, -2)
    end
    return indications
end

------------------------------------------------------------------------------

--- converts ranges string to list
--- @param string str @ranges string (e.g. "1-3 5 7-12 18 33")
function OpsdcsCrew:rangesToList(str)
    local ids = {}
    for range in str:gmatch("%S+") do
        local from, to = range:match("(%d+)-(%d+)")
        if not (from and to) then
            table.insert(ids, tonumber(range))
        else
            for j = tonumber(from), tonumber(to) do
                table.insert(ids, j)
            end
        end
    end
    return ids
end

--- diy condition construct
--- @param table cond
--- @return boolean @condition true/false
--- @return table @args for highlights
function OpsdcsCrew:evaluateCond(cond)
    local delta = 0.001
    local i, result, highlights = 1, true, {}
    local check = {
        skip = { 0, function() return true end },
        arg_eq = { 2, function(a, b) return math.abs(self.args[a] - b) < delta end },
        arg_neq = { 2, function(a, b) return math.abs(self.args[a] - b) >= delta end },
        arg_gt = { 2, function(a, b) return self.args[a] > b end },
        arg_lt = { 2, function(a, b) return self.args[a] < b end },
        arg_diff_lt = { 3, function(a, b, c) return math.abs(self.args[a] - self.args[b]) < c end },
        arg_between = { 3, function(a, b, c) return self.args[a] >= b and self.args[a] <= c end },
        param_eq = { 2, function(a, b) return self.params[a] == b end },
        param_neq = { 2, function(a, b) return self.params[a] ~= b end },
        param_gt = { 2, function(a, b) return self.params[a] > b end },
        param_lt = { 2, function(a, b) return self.params[a] < b end },
        param_between = { 3, function(a, b, c) return self.params[a] >= b and self.params[a] <= c end },
        ind_eq = { 3, function(a, b, c) return self.indications[a][b] == c end },
        ind_neq = { 3, function(a, b, c) return self.indications[a][b] ~= c end },
        ind_match = { 3, function(a, b, c) return self.indications[a][b] ~= nil and self.indications[a][b]:match(c) end },
        ind_gt = { 3, function(a, b, c)
            local x = tonumber(self.indications[a][b])
            if x == nil then return false end
            return x > c
        end },
        ind_lt = { 3, function(a, b, c)
            local x = tonumber(self.indications[a][b])
            if x == nil then return false end
            return x < c
        end },
        ind_between = { 4, function(a, b, c, d)
            local x = tonumber(self.indications[a][b])
            if x == nil then return false end
            return x >= c and x <= d
        end },
        any_ind_eq = { 2, function(a, b)
            for _, v in pairs(self.indications[a]) do
                if v == b then return true end
            end
            return false
        end },
        no_ind_eq = { 2, function(a, b)
            for _, v in pairs(self.indications[a]) do
                if v == b then return false end
            end
            return true
        end },
        arg_range_between = { 3, function(a, b, c)
            local ids = self:rangesToList(a)
            local args = self:getCockpitArgs(nil, ids)
            for _, v in pairs(args) do
                if v < b or v > c then return false end
            end
            return true
        end }
    }
    while i <= #cond do
        local op = cond[i]
        if op == "arg_eq" or op == "arg_neq" or op == "arg_gt" or op == "arg_lt" or op == "arg_between" then table.insert(highlights, cond[i + 1]) end
        if check[op] then
            if check[op][1] == 0 then
                result = result and check[op][2]()
            elseif check[op][1] == 1 then
                result = result and check[op][2](cond[i + 1])
            elseif check[op][1] == 2 then
                result = result and check[op][2](cond[i + 1], cond[i + 2])
            elseif check[op][1] == 3 then
                result = result and check[op][2](cond[i + 1], cond[i + 2], cond[i + 3])
            else
                result = result and check[op][2](cond[i + 1], cond[i + 2], cond[i + 3], cond[i + 4])
            end
            i = i + check[op][1] + 1
        else
            self:log("unknown condition: " .. op)
            i = i + 1
        end
    end
    return result, highlights
end

--- update loop
function OpsdcsCrew:update()
    if not self.isRunning then return end

    local timeDelta = self:getOption("timeDelta")
    if self.sndPlayUntil and timer.getTime() > self.sndPlayUntil then
        self.sndPlayUntil = nil
    end

    self.params = self:getCockpitParams()
    self.args = self:getCockpitArgs()
    self.indications = self:getIndications()
    local state = self[self.typeName].states[self.state]
    local lines = { state.text }
    local allCondsAreTrue = true
    local previousWasTrue = true
    local foundUnchecked = nil

    -- play state sound (played only once when state is entered)
    if self:getOption("playSounds") and state.sndPlayed == nil and state.snd ~= nil then
        self:playSoundFromText(state.text, state.snd, state.seat)
        state.sndPlayed = true
    end

    -- check conditions
    for i, condition in ipairs(state.conditions or {}) do
        local condIsTrue, highlights = self:evaluateCond(condition.cond)

        -- needPrevious=true - previous check must be true first
        if condition.needPrevious then condIsTrue = condIsTrue and previousWasTrue end

        -- needAllPrevious=true - all previous checks must be true first (if set as state property, applies to all conditions)
        if state.needAllPrevious or condition.needAllPrevious then condIsTrue = condIsTrue and allCondsAreTrue end

        -- duration=SECONDS - check if condition was true for a certain time
        condition.trueSince = condIsTrue and (condition.trueSince or timer.getTime()) or nil
        if condition.duration then
            condIsTrue = condition.trueSince ~= nil and timer.getTime() - condition.trueSince >= condition.duration
        end

        -- onlyOnce=true - condition must be true only once (no uncheck once checked)
        if condition.onlyOnce then
            condition.wasTrueOnce = condition.wasTrueOnce or condIsTrue
            condIsTrue = condition.wasTrueOnce
        end

        -- sounds
        if self:getOption("playSounds") then

            -- check if condition sound finished playing
            if condition.sndPlayUntil and timer.getTime() > condition.sndPlayUntil then
                condition.sndPlayed = true
            end

            -- condition sound not played yet - mark false
            if condition.snd and condition.sndPlayed == nil then
                condIsTrue = false
                -- play when nothing else playing and all other checked so far
                if condition.sndPlayUntil == nil and self.sndPlayUntil == nil and allCondsAreTrue then
                    self:playSoundFromText(condition.text, condition.snd, condition.seat)
                    condition.sndPlayUntil = timer.getTime() + condition.snd
                end
            end

            -- play check if not played yet and everything checked until here
            if condIsTrue and condition.check and allCondsAreTrue and condition.checkPlayed == nil and self.sndPlayUntil == nil then
                local n = math.random(1, 8)
                self:playSound("sounds/" .. self.typeName .. "/plt/" .. self[self.typeName].soundpack.plt .. "/check" .. n .. ".ogg", 1)
                condition.checkPlayed = true
            end

            -- long pause, repeat
            if not condIsTrue and condition.snd and self.sndLastPlayed and timer.getTime() - self.sndLastPlayed > self.sndRepeatAfter then
                condition.sndPlayed, condition.sndPlayUntil = nil, nil
                -- play random chatter sound before repeating
                local n = math.random(1, 5)
                self:playSound("sounds/" .. self.typeName .. "/cp/" .. self[self.typeName].soundpack.cp .. "/wait" .. n .. ".ogg", 2)
            end

        end

        -- condition true: create checked item, clear highlights
        if condIsTrue then
            if not condition.hide then
                table.insert(lines, "[X]  " .. condition.text)
            end
            if self.firstUnchecked == i then
                self.firstUnchecked = nil
                self:clearHighlights()
            end
        end

        -- condition false: create unchecked item, show highlights when first unchecked changed
        if not condIsTrue then
            if not condition.hide then
                table.insert(lines, "[  ]  " .. condition.text)
            end
            if not foundUnchecked then
                foundUnchecked = i
                if foundUnchecked ~= self.firstUnchecked then
                    self.firstUnchecked = foundUnchecked
                    if self:getOption("showHighlights") then
                        self:showHighlights(condition.highlights or highlights)
                    end
                end
            end
        end

        -- needed for needPrevious and needAllPrevious
        allCondsAreTrue = allCondsAreTrue and condIsTrue
        previousWasTrue = condIsTrue
    end

    -- check for user space/BS input, hacky AF but works
    local code = "return (c_flag_is_true('pressedSpace') and '1' or '0') .. (c_flag_is_true('pressedBS') and '1' or '0')"
    local keys = net.dostring_in("mission", code)
    if keys ~= "00" then self:setupWaitForUserFlags() end
    local pressedSpace, pressedBS = keys:sub(1, 1) == "1", keys:sub(2, 2) == "1"

    -- advance state when all conditions are true (auto or spacebar) TODO: and/or for skip? (BS for skip?)
    state.allCondsAreTrueSince = allCondsAreTrue and (state.allCondsAreTrueSince or timer.getTime()) or nil
    if state.allCondsAreTrueSince and timer.getTime() - state.allCondsAreTrueSince >= self:getOption("autoAdvance") then
        if self:getOption("autoAdvance") > 0 then
            self:transition(state)
        else
            if pressedSpace or state.next_state == nil then
                self:transition(state)
            else
                table.insert(lines, "\n[Press SPACEBAR to continue]")
                timeDelta = 0.5
            end
        end
    end

    -- show text/checklist
    if self:getOption("showChecklist") then
        local text = lines[1] .. (#lines > 1 and "\n\n" or "")
        text = text .. table.concat(lines, "\n", 2)
        trigger.action.outText(text, 3, true)
    end

    timer.scheduleFunction(self.update, self, timer.getTime() + timeDelta)
end

--- transition to state
--- @param string state
function OpsdcsCrew:transition(state)
    self.state = state.next_state
    self.firstUnchecked = nil
    if self.state == nil then
        self.isRunning = false
        self:refreshMenu()
    end
end

--- shows highlights for next check
--- @param table highlights
function OpsdcsCrew:showHighlights(highlights)
    local code, id = "", 1
    for _, arg in ipairs(highlights) do
        code = code .. "a_cockpit_highlight(" .. id .. ', "' .. arg .. '", 0, "");'
        id = id + 1
    end
    net.dostring_in("mission", code)
    self.numHighlights = id - 1
end

--- clears highlights
function OpsdcsCrew:clearHighlights()
    local code = ""
    for id = 1, self.numHighlights do
        code = code .. "a_cockpit_remove_highlight(" .. id .. ");"
    end
    net.dostring_in("mission", code)
end

------------------------------------------------------------------------------

--- toggles cockpit argument debug display
function OpsdcsCrew:onArgsDebug()
    if self.isRunningArgsDebug then
        self.isRunningArgsDebug = false
    else
        self.isRunningArgsDebug = true
        self.argsDebugLastArgs = self:getCockpitArgs(self.argsDebugMaxId)
        timer.scheduleFunction(self.argsDebugLoop, self, timer.getTime() + 0.5)
    end
end

--- cockpit argument debug display loop, excluding stuff in excludeDebugArgs
function OpsdcsCrew:argsDebugLoop()
    local maxDelta = 0.02
    if not self.isRunningArgsDebug then return end
    local currentArgs = self:getCockpitArgs(self.argsDebugMaxId)
    for i = 1, self.argsDebugMaxId do
        local last, current = self.argsDebugLastArgs[i], currentArgs[i]
        self.argsDebugLastArgs[i] = current
        if math.abs(tonumber(last) - tonumber(current)) > maxDelta and self[self.typeName].excludeDebugArgs[i] == nil then
            local argName = i
            if self[self.typeName].argsById[i] then
                argName = self[self.typeName].argsById[i]
            end
            trigger.action.outText("arg " .. argName .. " changed: " .. last .. " -> " .. current, 10)
        end
    end
    timer.scheduleFunction(self.argsDebugLoop, self, timer.getTime() + 0.2)
end

--- toggles whats this
function OpsdcsCrew:onWhatsThis()
    if self.isRunningWhatsThis then
        self.isRunningWhatsThis = false
    else
        self.isRunningWhatsThis = true
        self.whatsThisLastArgs = self:getCockpitArgs()
        timer.scheduleFunction(self.whatsThisLoop, self, timer.getTime() + 0.5)
    end
end

--- plays sounds on cockpit argument changes
function OpsdcsCrew:whatsThisLoop()
    local maxDelta = 0.08
    if not self.isRunningWhatsThis then return end
    local currentArgs = self:getCockpitArgs()
    for i, _ in pairs(self[self.typeName].args) do
        local last, current = self.whatsThisLastArgs[i], currentArgs[i]
        self.whatsThisLastArgs[i] = current
        if math.abs(tonumber(last) - tonumber(current)) > maxDelta then
            local filename = "sounds/" .. self.typeName .. "/cockpit-tutor/" .. i .. ".ogg"
            trigger.action.outText("playing sound: " .. filename, 10)
            self:playSound(filename)
            -- delay
            timer.scheduleFunction(self.whatsThisLoop, self, timer.getTime() + 3)
            return
        end
    end
    timer.scheduleFunction(self.whatsThisLoop, self, timer.getTime() + 0.1)
end

--- refresh f10 menu (one item per procedure, debug, options)
function OpsdcsCrew:refreshMenu()
    self:clearMenu()
    for _, procedure in ipairs(self[self.typeName].procedures) do
        self.menu[procedure.name] = missionCommands.addCommandForGroup(self.groupId, procedure.name, { self.mainmenu }, OpsdcsCrew.onProcedure, self, procedure)
    end
    --self.menu["whats_this"] = missionCommands.addCommandForGroup(self.groupId, "Cockpit Tutor", { self.mainmenu }, OpsdcsCrew.onWhatsThis, self)
    self.menu["options"] = missionCommands.addSubMenuForGroup(self.groupId, "Options", { self.mainmenu })
    self.menu["args_debug"] = missionCommands.addCommandForGroup(self.groupId, "Toggle Arguments Debug", { self.mainmenu, "Options" }, OpsdcsCrew.onArgsDebug, self)
end

--- clears f10 menu for group
function OpsdcsCrew:clearMenu()
    for name, item in pairs(self.menu) do
        self.menu[name] = nil
        missionCommands.removeItemForGroup(self.groupId, item)
    end
end

--- f10 menu procedure
--- @param string name
--- @param table procedure
function OpsdcsCrew:onProcedure(procedure)
    self:clearHighlights()
    self:clearMenu()
    self:loadPluginData()
    self.menu["abort-" .. procedure.name] = missionCommands.addCommandForGroup(self.groupId, "Abort " .. procedure.name, { self.mainmenu }, OpsdcsCrew.onAbort, self)
    self.state = procedure.start_state
    self.isRunning = true
    self.sndLastPlayed = nil
    self:update()
end

--- f10 menu abort
function OpsdcsCrew:onAbort()
    self.isRunning = false
    self:clearHighlights()
    self:refreshMenu()
    trigger.action.outText("", 0, true)
end

OpsdcsCrew:start()
