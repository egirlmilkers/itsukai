local Util = {}


Util.Flags = {}

function Util.containsArabic(str: string): boolean
	-- utf8.codes iterates through the string, returning the byte offset and the Unicode codepoint
	for _, codepoint in utf8.codes(str) do
		-- Check if the codepoint falls within the specified Arabic Unicode blocks
		if  (codepoint >= 0x0600 and codepoint <= 0x06FF) or -- Arabic
			(codepoint >= 0x0750 and codepoint <= 0x077F) or -- Arabic Supplement
			(codepoint >= 0x08A0 and codepoint <= 0x08FF) then -- Arabic Extended-A
			return true
		end
	end
	
	return false
end

function Util.isOptionValid(str: string): boolean
	return if Util.Flags[str] then true else false
end


return Util