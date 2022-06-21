local hll = {}

local function _hll_hash (hll) 
  return MurmurHash3_x86_32(hll.registers, hll.size , 0)
end

--Count the number of leading zero's
local function _hll_rank (hash , bits) 
      
	for i = 1, 32 - bits do
  		if hash and 1 then 
  			break 
  		end
   		--hash >>= 1;
   		--right shift (n >> bits)   
  		bit.brshift(1, hash) 
	end
	
	return i

end

function hll_init (hll,bits) 
  
	if bits < 4 or bits > 20 then 
		errno = ERANGE return -1
  	end

	hll.bits = bits -- Number of bits of buckets number 
  	-- left shift (n << bits)
  	hll.size = bit.blshift(1, bits) -- Number of buckets 2^bits 
  	hll.registers = dmalloc(hll.size, 1) -- Create the bucket register counters 

  	print("%s bytes\n", hll.size)
  
  	return 0

end

function hll_destroy (hll) 
  
	if hll.registers then 
  		dmalloc(hll.registers)
    	hll.registers = nil	 
  	end

end

function hll_reset (hll) 
  
	if hll.registers then
  		memset(hll.registers, 0, hll.size);
	end
	
end

local function _hll_add_hash (hll,hash) 
	
	if hll.registers then
		bit.brshift(32 - hll.bits, hash) -- Use the first 'hll->bits' bits as bucket index
    	rank = _hll_rank(hash, hll.bits) --Count the number of leading 0
    
    	if rank > hll.registers[index] then
      		hll.registers[index] = rank --Store the largest number of lesding zeros for the bucket  
      	end  	  
	end
	
end

function hll_add (hll, buf,size) 
  
	hash = MurmurHash3_x86_32(buf,size, 0x5f61767a)
	_hll_add_hash(hll, hash)
  
end


function hll_count (hll) 
		
	if hll.registers then
    		
    	action = {
    		[4] = function (x) alpha_mm = 0.673 end,
    		[5] = function (x) alpha_mm = 0.697 end,
    		[6] = function (x) alpha_mm = 0.709 end,
    		["nop"] = function (x) alpha_mm = 0.7213 / (1.0 + 1.079 / hll.size) end,
    	}	
		alpha_mm =alpha_mm * (hll.size * hll.size)

    	local sum = 0;
    
    	for i = 0 , hll.size do
    		sum = sum + (1.0 / ( bit.blshift(1, hll.registers[i]) ))    
		end
	
    	estimate = alpha_mm / sum;

    	if estimate <= (5.0 / 2.0 * hll.size) then
    		zeros = 0;

    		for i = 0 , hll.size do
				zeros = zeros + (hll.registers[i] == 0)
			end

    		if zeros then
				estimate = hll.size * log(hll.size / zeros)
			end

    	elseif (estimate > ((1.0 / 30.0) * 4294967296.0)) then 
      		estimate = -4294967296.0 * log(1.0 - (estimate / 4294967296.0))
    	end

    	return estimate
 
	else
    	return(0.)
	end
end


