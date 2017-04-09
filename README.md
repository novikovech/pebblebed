# pebblebed
A pebblebed reactor for MineTest game

A single block reactor that produces heat, not electricity. To get electricity out of it, combine it with the steam turbine from technic_extras.

Technic's nuclear reactor produces 2.016 GEU power per 3.5% Uranium ingot of fuel. This reactor produces 50 heat for 10 hours. With steam turbine's conversion of 1 heat into 670 EU, that gives us 33,500 EU/s, 1.206 GEU per Uranium ingot. That's about 60% the efficiency of the large reactor with a much smaller capital investment and risk.

Digging an active reactor will not drop anything, wait for it to finish before moving it. Active reactor is a light source and an ignitor. It's hot enough to set flammable objects on fire within a 2 block radius, so be careful with placement.

Bug: digging the reactor restroys the fuel inside, I'll fix that when I can be bothered, in the mean time make sure to remove fuel from the reactor before digging it. (That shouldn't be an issue, since having fuel means it's active, and you shouldn't be digging active reactors.)

Construction:
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot'   , 'technic:stainless_steel_ingot'},
		{'technic:stainless_steel_ingot', ''                                , 'technic:stainless_steel_ingot'},
		{'technic:stainless_steel_ingot', 'technic:blast_resistant_concrete', 'technic:stainless_steel_ingot'},
	}
  
Fuel: 
First alloy some 3.5% uranium dust with coal dust to get Uranium Carbide dust, then compress that to get 10 fuel pellets. Each pellet will fuel the reactor for an hour.
