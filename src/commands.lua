local stepcount = 0
local newspawn_cooldown = {}

-- Command privileges

minetest.register_privilege("spawn", "Can teleport to spawn position.")
minetest.register_privilege("setspawn", "Can manually set a spawn point")
minetest.register_privilege("newspawn", "Can get a new randomized spawn position.")
minetest.register_privilege("spawnadmin", "Can clean up timers and set new spawns for players.")

-- Commands

minetest.register_chatcommand("spawn", {
	description = "Teleport to spawn position.",
	params = "",
	privs = "spawn",
	func = function(name)
		local target = rspawn.playerspawns[name]
        if target then
		    minetest.get_player_by_name(name):setpos(target)
        else
            minetest.chat_send_player(name, "You have no spawn position!")
        end
	end
})

minetest.register_chatcommand("setspawn", {
	description = "Assign current position as spawn position.",
	params = "",
	privs = "setspawn",
	func = function(name)
		rspawn.playerspawns[name] = minetest.get_player_by_name(name):getpos()
		rspawn:spawnsave()
		minetest.chat_send_player(name, "New spawn set !")
	end
})

local function request_new_spawn(username, targetname)
    local timername = username
    if targetname ~= username then
        timername = username.." "..targetname
    end

    if not newspawn_cooldown[timername] then
        rspawn:renew_player_spawn(targetname)
        newspawn_cooldown[timername] = 300
    else
        minetest.chat_send_player(username, tostring(math.ceil(newspawn_cooldown[timername])).."sec until you can randomize a new spawn for "..targetname)
    end
end

minetest.register_chatcommand("newspawn", {
	description = "Randomly select a new spawn position.",
	params = "",
	privs = "newspawn",
	func = function(name, args)
        request_new_spawn(name, name)
    end
})

minetest.register_chatcommand("playerspawn", {
	description = "Randomly select a new spawn position for a player.",
	params = "playername",
	privs = "spawnadmin",
	func = function(adminname, playername)
        request_new_spawn(adminname, playername)
	end
})

-- Prevent players from spamming newspawn
minetest.register_globalstep(function(dtime)
    local playername, playertime, shavetime
    stepcount = stepcount + dtime
    shavetime = stepcount
    if stepcount > 0.5 then
        stepcount = 0
    else
        return
    end

    for playername,playertime in pairs(newspawn_cooldown) do
        playertime = playertime - shavetime
        if playertime <= 0 then
            newspawn_cooldown[playername] = nil
            minetest.chat_send_player(playername, "/newspawn available")
        else
            newspawn_cooldown[playername] = playertime
        end
    end
end)