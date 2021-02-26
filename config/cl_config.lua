Config = {}
-- Config Variables (Barier)
Config.deleteBariers = true
--Config Variables (Blips)
Config.enableBlips = true
Config.enableBlipNames = false -- Set to false if you need to consolidate blips.
Config.enableRangedBlip = true -- Only show blip if you're in range.

Config.blipRange = 100 -- How far until the blip shows.
Config.blipColor = 1 -- https://docs.fivem.net/natives/?_0x03D7FB09E75D6B7E
Config.blipDisplay = 2 -- 2 = Map/Minimap, 3 = Only Map 5 = ONLY Minimap, 8 = Map/Minimap + Not selectable https://docs.fivem.net/natives/?_0x9029B2F3DA924928

-- Config Variables (Markers)
Config.markerRotate = true -- Faces the player

Config.markerRange = 25.0 -- Distance for creating the marker.
Config.markerType = 20 -- Type of marker https://docs.fivem.net/docs/game-references/markers/
Config.markerSize = {x = 1.0, y = 1.0, z = 1.0}
Config.markerColor = {r = 255, g = 0, b = 0, a = 100}

-- Config (Blips)
Config.blipLocations = {
[1] = {name = "Legion", x = 217.58685302734, y = -802.31695556641, z = 30.768518447876},
[2] = {name = "Pink Cage", x = 273.77542114258, y = -344.17346191406, z = 44.919834136963},
[3] = {name = "Mirror Park", x = 1036.2510986328, y = -763.19036865234, z = 57.992980957031},
[4] = {name = "Pillbox Hill", x = 44.58373260498, y = -843.09783935547, z = 31.123804092407},
[5] = {name = "Mission Row", x = 458.22341918945, y = -895.58660888672, z = 35.972236633301},
[6] = {name = "Alta Street", x = -280.97952270508, y = -887.98712158203, z = 31.318016052246},
[7] = {name = "Mission Row", x = 453.3307800293, y = -1146.189453125, z = 29.514123916626},
[8] = {name = "East Vinewood", x = 984.27691650391, y = -206.19375610352, z = 71.067764282227},
[9] = {name = "Underground Garage", x = 172.97850036621, y = -719.61022949219, z = 33.132614135742},
[10] = {name = "Davis", x = -54.269744873047, y = -1835.7490234375, z = 26.57292175293},
[11] = {name = "Banning", x = -36.026584625244, y = -2096.2746582031, z = 16.937074661255},
[12] = {name = "Davis", x = -73.317260742188, y = -2004.0352783203, z = 18.275274276733},
[13] = {name = "Vespuci Beach", x = -1183.9694824219, y = -1509.8865966797, z = 4.6493043899536},
[14] = {name = "Del Perro", x = -2030.9619140625, y = -465.92120361328, z = 11.603976249695},
[15] = {name = "West Vinewood", x = -554.99865722656, y = 331.64248657227, z = 84.370491027832},
[16] = {name = "West Vinewood", x = -340.53051757813, y = 266.64599609375, z = 85.679481506348},
[17] = {name = "Downtown Vinewood", x = 362.45098876953, y = 298.58694458008, z = 103.88379669189},
[18] = {name = "Downtown Vinewood", x = 638.73327636719, y = 206.56455993652, z = 97.604179382324}
}

-- Config (Markers)
Config.markerLocations = { -- Markers if we decide to use one
[1] = {name = "Legion", x = 213.43267822266, y = -809.05993652344, z = 31.014888763428},
[2] = {name = "Pink Cage", x = 275.32904052734, y = -344.58810424805, z = 45.173404693604},
[3] = {name = "Mirror Park", x = 1036.2510986328, y = -763.19036865234, z = 57.992980957031},
[4] = {name = "Pillbox Hill", x = 44.58373260498, y = -843.09783935547, z = 31.123804092407},
[5] = {name = "Mission Row", x = 458.22341918945, y = -895.58660888672, z = 35.972236633301},
[6] = {name = "Alta Street", x = -280.97952270508, y = -887.98712158203, z = 31.318016052246},
[7] = {name = "Mission Row", x = 453.3307800293, y = -1146.189453125, z = 29.514123916626}
}

Config.barierLocations = {
[1] = {model = "prop_sec_barier_02b", x = 266.09, y = -349.35, z = 44.74}, -- Pink Cage 1
[2] = {model = "prop_sec_barier_02a", x = 285.28, y = -355.78, z = 45.13}, -- Pink Cage 2
[3] = {model = "prop_sec_barrier_ld_01a", x = 206.52, y = -803.47, z = 30.95}, -- Legion 1
[4] = {model = "prop_sec_barrier_ld_01a",x = 230.96, y = -816.36, z = 30.32}, -- Legion 2
[5] = {model = "prop_sec_barier_02b", x = 1038.61, y = -763.18, z = 57.77}, -- Mirror Park 1
[6] = {model = "prop_sec_barier_02b", x = 1030.61, y = -758.09, z = 57.77}, -- Mirror Park 2 
[7] = {model = "prop_sec_barier_02b", x = 451.45919799805, y = -1144.5382080078, z = 29.356086044312}, -- Mission Row
}

--[[
-- Config (Parking Locations)
Config.parkingLocations = { -- location to park your vehicle.
[1] = {name = "Legion", x = 217.58685302734, y = -802.31695556641, z = 30.768518447876},
[2] = {name = "Pink Cage", x = 266.5002746582, y = -332.10998535156, z = 43.949834136963},
[3] = {name = "Mirror Park", x = 1036.2510986328, y = -763.19036865234, z = 57.992980957031},
[4] = {name = "Pillbox Hill", x = 44.58373260498, y = -843.09783935547, z = 31.123804092407},
[5] = {name = "Mission Row", x = 458.22341918945, y = -895.58660888672, z = 35.972236633301},
[6] = {name = "Alta Street", x = -280.97952270508, y = -887.98712158203, z = 31.318016052246},
[7] = {name = "Mission Row", x = 453.3307800293, y = -1146.189453125, z = 29.514123916626}
}
]]