local CopyTable = {}

function CopyTable:CopyWithoutFunctions(Table)
	local TableNew = {}
		for key,value in next, Table do
			if type(value) == 'table' then
				value = CopyTable:CopyWithoutFunctions(value)
			end
			if type(value) == 'function' then
				continue -- скипает 
			end
			TableNew[key] = value
		end
	return TableNew
end

return CopyTable