


-- items:

minetest.register_craftitem("pebblebed:uranium_carbide_dust", {
	description = "Uranium Carbide Dust",
	inventory_image = "uranium_carbide.png",
})

minetest.register_craftitem("pebblebed:pebble_fuel", {
	description = "Pebblebed Fuel Pellet",
	inventory_image = "pebble_fuel.png",
})

-- recipes:

technic.register_alloy_recipe({
    input = {"technic:uranium34_dust", "technic:coal_dust"}, 
    output = "pebblebed:uranium_carbide_dust", 
    time = 6
  })

technic.register_compressor_recipe({input = {"pebblebed:uranium_carbide_dust"}, output = "pebblebed:pebble_fuel"})

minetest.register_craft({
	output = 'pebblebed:reactor',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot'   , 'technic:stainless_steel_ingot'},
		{'technic:stainless_steel_ingot', ''                                , 'technic:stainless_steel_ingot'},
		{'technic:stainless_steel_ingot', 'technic:blast_resistant_concrete', 'technic:stainless_steel_ingot'},
	}
})

--the actual reactor node:

minetest.register_node("pebblebed:reactor", {
	description = "Pebblebed Reactor",
	tiles = {"reactor_side.png"},
	groups = {cracky=1, tubedevice=1, tubedevice_receiver=1},
	connect_sides = {"front", "back", "left", "right"},
  tube=1,
	stack_max = 1,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
    meta:set_int("fuel_left", 0)
		local inv = meta:get_inventory()
		inv:set_size("src", 1)
  
  on_timer = function(pos, node)
		local meta = minetest.get_meta(pos)
		local fuel_left = meta:get_int("fuel_left") or 0
		if fuel_left <= 0 then
			meta:set_int("fuel_left", 0)
			return false
		end
		fuel_left = fuel_left - 1
		meta:set_int("fuel_left", fuel_left)
		return true
	end,

  allow_metadata_inventory_put = function(pos, listname, index, stack, player)
    if stack.get_name() == "pebblebed:pebble_fuel" then
      return stack.get_count()
    end
    return 0
  end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
    return stack.get_count()
  end,
})
