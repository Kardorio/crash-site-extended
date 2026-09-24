local crash_site_containers =
{
  ["crash-site-spaceship"] = 100,
  ["crash-site-spaceship-wreck-big-1"] = 50,
  ["crash-site-spaceship-wreck-big-2"] = 50,
  ["crash-site-spaceship-wreck-medium-1"] = 25,
  ["crash-site-spaceship-wreck-medium-2"] = 25,
  ["crash-site-spaceship-wreck-medium-3"] = 25
}

for prototype_name, inventory_size in pairs(crash_site_containers) do
  local container = data.raw.container[prototype_name]

  if not container then
    error("Crash Site Extended: vanilla prototype '" .. prototype_name .. "' was not found")
  end

  container.inventory_size = inventory_size
  container.inventory_type = "with_filters_and_bar"
  container.circuit_connector = circuit_connector_definitions.chest
  container.circuit_wire_max_distance = default_circuit_wire_max_distance
end

local crash_site_spaceship = data.raw.container["crash-site-spaceship"]
crash_site_spaceship.localised_name = {"entity-name.crash-site-extended"}
crash_site_spaceship.localised_description = {"entity-description.crash-site-extended"}
