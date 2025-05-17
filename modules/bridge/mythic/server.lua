local Inventory = require 'modules.inventory.server' -- Load ox inventory

-- Setup inventory for a player when they load in
local function setupPlayer(src)
    local source = src
    local player = Fetch:Source(source)
    local char = player:GetData("Character")
    local sid = char:GetData("SID")
    local inventory = MySQL.query.await('SELECT id, count(id) as Count, name as Owner, item_id as Name, dropped as Temp, MAX(quality) as Quality, information as MetaData, slot as Slot, MIN(creationDate) AS CreateDate FROM inventory WHERE NAME = ? GROUP BY slot ORDER BY slot ASC', { string.format("%s-%s", sid, 1)}) or {}

    server.setPlayerInventory({
        source = source,
        inventory = inventory,
        identifier = sid,
        name = ('%s %s'):format(char:GetData("First"), char:GetData("Last")),
    })

    Inventory.SetItem(source, 'money', char:GetData("Cash"))
end

RegisterServerEvent('Inventory:Cash', function(key)
    Middleware:TriggerEvent('Inventory:Wallet', source)
end)


AddEventHandler("Inventory:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Fetch = exports["mythic-base"]:FetchComponent("Fetch")
	Utils = exports["mythic-base"]:FetchComponent("Utils")
	Middleware = exports["mythic-base"]:FetchComponent("Middleware")
    Wallet = exports["mythic-base"]:FetchComponent("Wallet")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Inventory", {
        "Fetch",
        "Utils",
        "Middleware",
        "Wallet",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()

		Middleware:Add("Characters:Spawning", function(source)
			setupPlayer(source)
		end, 1)

        Middleware:Add("Inventory:Wallet", function(source)
            local player = Fetch:Source(source)
            local char = player:GetData("Character")
            Inventory.SetItem(source, 'money', char:GetData("Cash"))
		end, 1)
	end)
end)

function server.setPlayerData(player)
    -- TODO MYTHIC:
end

function server.syncInventory(inv)
    -- TODO MYTHIC:
end

function server.UseItem(source, itemName, data)
    -- TODO MYTHIC:
end

function server.hasLicense(inv, license)
    -- TODO MYTHIC:
end

function server.buyLicense(inv, license)
    -- TODO MYTHIC:
end

function server.isPlayerBoss(playerId, group, grade)
    -- TODO MYTHIC:
end
