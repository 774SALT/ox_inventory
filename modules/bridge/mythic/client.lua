AddEventHandler("Characters:Client:Updated", function(key)
	if key == "Cash" then
		TriggerServerEvent('Inventory:Cash', key)
	end
end)

-- TODO MYTHIC:

function client.setPlayerStatus(values)
    
end
