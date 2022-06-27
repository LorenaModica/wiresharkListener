local hyperloglog = require 'hyperloglog'
local utils = require 'utils'

-- Define the menu entry's callback
local function host_info ()
	
	local function host_func(ipv4_address)
    	
    	local window = TextWindow.new("Host Info")
   
    	if check_ipv4(ipv4_address) then
        
        	local hll_hosts = {}
        	local hll_packets = {}
        	local hll_to_host = {}
        
        	local init_one = hll_init (hll_hosts , 10)
			local init_two = hll_init (hll_packets , 10)
			local init_three = hll_init (hll_to_host , 10)
		     
		    -- this is our tap
			local tap = Listener.new();
		    
			local function remove()
				-- this way we remove the listener that otherwise will remain running indefinitely
				tap:remove();
			end
				
			-- we tell the window to call the remove() function when closed
			window:set_atclose(remove)
				
			if (init_one and init_two and init_three) then	
				-- this function will be called once for each packet
				function tap.packet(pinfo,tvb)
					
					local src = tostring(pinfo.src)
					
					if src==ipv4_address then  
						--hll conta numero host contattati diversi da questo host
						local dst =tostring(pinfo.dst)	
						hll_add(hll_hosts,dst)
						--hll conta per ogni host contattato quanti pacchetti scambiati
						
						--hll conta quante volte ipv4 address compare come destinatario
					end
				end
					
				-- this function will be called once every few seconds to update our window
				function tap.draw(t)
					local message = string.format("Info about host: %s",ipv4_address);
			   		window:set(message);
					--window:clear()
					--for ip,num in pairs(ips) do
						--tw:append(ip .. "\t" .. num .. "\n");
					--end
				end
				
				-- this function will be called whenever a reset is needed
				-- e.g. when reloading the capture file
				function tap.reset()
					window:clear()
					--ips = {}
				end
					
				-- Ensure that all existing packets are processed.
				retap_packets()	
			end
        else
       		local message = string.format("ERROR: %s : please insert a valid ipv4 address!",ipv4_address);
        	window:set(message);
        end
        
    end

    new_dialog("Host Info",host_func,"Host address")
    	
end

-- Create the menu entry
register_menu("Host info/Host stats",host_info,MENU_TOOLS_UNSORTED)

-- Notify the user that the menu was created
-- code from https://www.wireshark.org/docs/wsdg_html_chunked/wslua_menu_example.html
if gui_enabled() then
   local splash = TextWindow.new("Hello!");
   splash:set("Wireshark has been enhanced with a new feature.\n")
   splash:append("Go to Tools -> Host info -> Host stats and check it out!")
end


--[[
This program will register a menu that will open a window with a count of occurrences
-- of every address in the capture

local function menuable_tap()
	-- Declare the window we will use
	local tw = TextWindow.new("Address Counter")

	-- This will contain a hash of counters of appearances of a certain address
	local ips = {}

	-- this is our tap
	local tap = Listener.new();

	local function remove()
		-- this way we remove the listener that otherwise will remain running indefinitely
		tap:remove();
	end

	-- we tell the window to call the remove() function when closed
	tw:set_atclose(remove)

	-- this function will be called once for each packet
	function tap.packet(pinfo,tvb)
		local src = ips[tostring(pinfo.src)] or 0
		local dst = ips[tostring(pinfo.dst)] or 0

		ips[tostring(pinfo.src)] = src + 1
		ips[tostring(pinfo.dst)] = dst + 1
	end

	-- this function will be called once every few seconds to update our window
	function tap.draw(t)
		tw:clear()
		for ip,num in pairs(ips) do
			tw:append(ip .. "\t" .. num .. "\n");
		end
	end

	-- this function will be called whenever a reset is needed
	-- e.g. when reloading the capture file
	function tap.reset()
		tw:clear()
		ips = {}
	end

	-- Ensure that all existing packets are processed.
	retap_packets()
end

-- using this function we register our function
-- to be called when the user selects the Tools->Test->Packets menu
register_menu("Test/Packets", menuable_tap, MENU_TOOLS_UNSORTED)]]--
