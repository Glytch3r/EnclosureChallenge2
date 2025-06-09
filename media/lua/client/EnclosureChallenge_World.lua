
--[[
local mapAPI = ISWorldMap_instance.javaObject:getAPIv1()
print(round((mapAPI:getWidthInSquares()-1)/189)) -- this should be the max number of enclosure x
print(round((mapAPI:getHeightInSquares()-1)/189)) -- this should be the max number of enclosure y

local mapAPI = ISWorldMap_instance.javaObject:getAPIv1()
print(round((mapAPI:getWidthInSquares()-1)))  -- this should be the worlds width
print(round((mapAPI:getHeightInSquares()-1))) -- this should be the worlds height ]]
