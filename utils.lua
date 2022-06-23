---checks if a string represents an ip address
-- @return true or false
function check_ipv4(ipv4_address)
	
  if type(ipv4_address) ~= "string" then return false end

  -- check for format 1.11.111.111 for ipv4
  local chunks = {ipv4_address:match("^(%d+)%.(%d+)%.(%d+)%.(%d+)$")}
  if #chunks == 4 then
    for _,v in pairs(chunks) do
      if tonumber(v) > 255 then return false end
    end
    return true
  end

end



