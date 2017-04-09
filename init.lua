


--extra stuff
local fuel_max = 3600

local function formspec_active (percent)
	local formspec = 
		"size[8,8.5]"..
		default.gui_bg..
		default.gui_bg_img..
		default.gui_slots..
		"list[current_name;fuel;2.75,1.5;1,1;]"..
		"image[3.75,1.5;1,1;default_furnace_fire_bg.png^[lowpart:"..
		(0+percent)..":default_furnace_fire_fg.png]"..
		"list[current_player;main;0,4.25;8,1;]"..
		"list[current_player;main;0,5.5;8,3;8]"..
		"listring[current_name;fuel]"..
		"listring[current_player;main]"..
		default.get_hotbar_bg(0, 4.25)
	return formspec
end

local formspec_inactive = 	
	"size[8,8.5]"..
	default.gui_bg..
	default.gui_bg_img..
	default.gui_slots..
	"list[current_name;fuel;2.75,1.5;1,1;]"..
	"image[3.75,1.5;1,1;default_furnace_fire_bg.png]"..
	"list[current_player;main;0,4.25;8,1;]"..
	"list[current_player;main;0,5.5;8,3;8]"..
	"listring[current_name;fuel]"..
	"listring[current_player;main]"..
	default.get_hotbar_bg(0, 4.25)

local function swap_node(pos, name)
	local node = minetest.get_node(pos)
	if node.name == name then
		return
	end
	node.name = name
	minetest.swap_node(pos, node)
end

local function pebble_timer_func(pos, elapsed)
	print("DEBUG: Pebble timer func")
    local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local stack = inv:get_stack("fuel", 1)
    local fuel_left = meta:get_int("fuel_left") or 0
    if fuel_left <= 0 then
		meta:set_int("fuel_left", 0)
		-- Pebble ran out, load new pebble if available
		if stack:get_count() > 0 then
			stack:take_item()
			inv:set_stack("fuel", 1, stack)
			meta:set_int("fuel_left", fuel_max)
			meta:set_string("formspec", formspec_active(fuel_left/fuel_max*100))
		else
			--no more fuel, remove heat
			meta:set_string("formspec", formspec_inactive)
			swap_node(pos, "pebblebed:reactor")
			return false
		end
	else
		fuel_left = fuel_left - 1
		meta:set_int("fuel_left", fuel_left)
		meta:set_string("formspec", formspec_active(fuel_left/fuel_max*100))
		--set heat
		swap_node(pos, "pebblebed:reactor_active")
    end
	return true
end



-- items:

minetest.register_craftitem("pebblebed:uranium_carbide_dust", {
	description = "Uranium Carbide Dust",
	inventory_image = "uranium_carbide.png",
})

minetest.register_craftitem("pebblebed:pebble_fuel", {
	description = "Pebblebed Fuel Pellet",
	inventory_image = "pebblebed_fuel.png",
})

-- recipes:

technic.register_alloy_recipe({
    input = {"technic:uranium35_dust", "technic:coal_dust"}, 
    output = "pebblebed:uranium_carbide_dust", 
    time = 6
  })

technic.register_compressor_recipe({input = {"pebblebed:uranium_carbide_dust"}, output = "pebblebed:pebble_fuel 10"})

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
  legacy_facedir_simple = true,
  connect_sides = {"front", "back", "left", "right"},
  tube=1,
  stack_max = 1,
  on_construct = function(pos)
    local meta = minetest.get_meta(pos)
    meta:set_int("fuel_left", 0)
    local inv = meta:get_inventory()
    inv:set_size('fuel', 1)
	meta:set_string("formspec", formspec_inactive)
  end,
  on_timer = pebble_timer_func,
  allow_metadata_inventory_put = function(pos, listname, index, stack, player)
    minetest.get_node_timer(pos):start(1.0)
    if stack:get_name() == "pebblebed:pebble_fuel" then
      return stack:get_count()
    end
    return 0
  end,
  allow_metadata_inventory_take = function(pos, listname, index, stack, player)
    minetest.get_node_timer(pos):start(1.0)
    return stack:get_count()
  end, 
  allow_metadata_inventory_move = function(pos, listname, index, stack, player)
    minetest.get_node_timer(pos):start(1.0)
    return stack:get_count()
  end
})


minetest.register_node("pebblebed:reactor_active", {
  description = "Pebblebed Reactor",
  tiles = {"reactor_side.png"},
  groups = {cracky=1, tubedevice=1, tubedevice_receiver=1, hot=50, igniter=2},
  legacy_facedir_simple = true,
  connect_sides = {"front", "back", "left", "right"},
  tube=1,
  drop = {items = {}},
  stack_max = 1,
  light_source = 14,
  on_timer = pebble_timer_func,
  allow_metadata_inventory_put = function(pos, listname, index, stack, player)
    minetest.get_node_timer(pos):start(1.0)
    if stack:get_name() == "pebblebed:pebble_fuel" then
      return stack:get_count()
    end
    return 0
  end,
  allow_metadata_inventory_take = function(pos, listname, index, stack, player)
    minetest.get_node_timer(pos):start(1.0)
    return stack:get_count()
  end, 
  allow_metadata_inventory_move = function(pos, listname, index, stack, player)
    minetest.get_node_timer(pos):start(1.0)
    return stack:get_count()
  end
})
