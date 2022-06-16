--Questo codice richiede l'utilizzo di moduli esterni
--https://mozilla-services.github.io/lua_sandbox_extensions/

-- Define the menu entry's callback
require "hyperloglog"
local function host_info()
    
    local function host_func(ipv4_address)
        local window = TextWindow.new("Host Info");
        local message = string.format("Host: %s", ipv4_address);
        window:set(message);
    end

    new_dialog("Host Info",host_func,"Host address")
    
	-- this is our tap
	local tap = Listener.new();

	local function remove()
		-- this way we remove the listener that otherwise will remain running indefinitely
		tap:remove();
	end

	-- we tell the window to call the remove() function when closed
	--window:set_atclose(remove)
	
end

-- Create the menu entry
register_menu("Host/Host stats",host_info,MENU_TOOLS_UNSORTED)

-- Notify the user that the menu was created
--code from https://www.wireshark.org/docs/wsdg_html_chunked/wslua_menu_example.html
if gui_enabled() then
   local splash = TextWindow.new("Hello!");
   splash:set("Wireshark has been enhanced with a useless feature.\n")
   splash:append("Go to 'Tools -> Host -> Host stats' and check it out!")
end


