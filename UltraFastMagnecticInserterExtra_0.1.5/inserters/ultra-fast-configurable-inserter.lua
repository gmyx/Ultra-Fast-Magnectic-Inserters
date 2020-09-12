data:extend(
{    
  {
    type = "inserter",
    name = "ultra-fast-configurable-inserter",
    icon = "__UltraFastMagnecticInserterExtra__/graphics/configurable-inserter.png",
    icon_size = 32,
    flags = {"placeable-neutral", "placeable-player", "player-creation"},
    stack = true,
    minable =
    {
      hardness = 0.2,
      mining_time = 0.5,
      result = "ultra-fast-configurable-inserter"
    },
    max_health = 160,
    corpse = "small-remnants",
    resistances =
    {
      {
        type = "fire",
        percent = 90
      }
    },
    collision_box = {{-0.15, -0.15}, {0.15, 0.15}},
    selection_box = {{-0.4, -0.35}, {0.4, 0.45}},
    pickup_position = {x=0, y=-2},
    insert_position = {x=0, y=2.2000000000000002},
    allow_custom_vectors = true,
    energy_per_movement = "151J",
    energy_per_rotation = "151J",
    energy_source = {
      drain = "2500W",
      type = "electric",
      usage_priority = "secondary-input"
    },
    extension_speed = 20,
    rotation_speed = 20,
    fast_replaceable_group = "inserter",
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    hand_base_picture = {
      filename = "__base__/graphics/entity/stack-filter-inserter/stack-filter-inserter-hand-base.png",
      height = 1,
      hr_version = {
        filename = "__base__/graphics/entity/stack-filter-inserter/hr-stack-filter-inserter-hand-base.png",
        height = 1,
        priority = "extra-high",
        scale = 0.25,
        width = 1,
      visible = false
      },
      priority = "extra-high",
      width = 1,
      visible = false
    },
    hand_base_shadow = {
      filename = "__base__/graphics/entity/stack-filter-inserter/stack-filter-inserter-hand-base.png",
      height = 1,
      hr_version = {
        filename = "__base__/graphics/entity/stack-filter-inserter/hr-stack-filter-inserter-hand-base.png",
        height = 1,
        priority = "extra-high",
        scale = 0.25,
        width = 1,
      visible = false
      },
      priority = "extra-high",
      width = 1,
      visible = false
    },
    hand_closed_picture = {
      filename = "__base__/graphics/entity/stack-filter-inserter/stack-filter-inserter-hand-base.png",
      height = 1,
      hr_version = {
        filename = "__base__/graphics/entity/stack-filter-inserter/hr-stack-filter-inserter-hand-base.png",
        height = 1,
        priority = "extra-high",
        scale = 0.25,
        width = 1,
      visible = false
      },
      priority = "extra-high",
      width = 1,
      visible = false
    },
    hand_closed_shadow = {
      filename = "__base__/graphics/entity/stack-filter-inserter/stack-filter-inserter-hand-base.png",
      height = 1,
      hr_version = {
        filename = "__base__/graphics/entity/stack-filter-inserter/hr-stack-filter-inserter-hand-base.png",
        height = 1,
        priority = "extra-high",
        scale = 0.25,
        width = 1,
      visible = false
      },
      priority = "extra-high",
      width = 1,
      visible = false
    },
    hand_open_picture = {
      filename = "__base__/graphics/entity/stack-filter-inserter/stack-filter-inserter-hand-base.png",
      height = 1,
      hr_version = {
        filename = "__base__/graphics/entity/stack-filter-inserter/hr-stack-filter-inserter-hand-base.png",
        height = 1,
        priority = "extra-high",
        scale = 0.25,
        width = 1,
      visible = false
      },
      priority = "extra-high",
      width = 1,
      visible = false
    },
    hand_open_shadow = {
      filename = "__base__/graphics/entity/stack-filter-inserter/stack-filter-inserter-hand-base.png",
      height = 1,
      hr_version = {
        filename = "__base__/graphics/entity/stack-filter-inserter/hr-stack-filter-inserter-hand-base.png",
        height = 1,
        priority = "extra-high",
        scale = 0.25,
        width = 1,
      visible = false
      },
      priority = "extra-high",
      width = 1,
      visible = false
    },
    platform_picture =
    {
      sheet =
      {
        filename = "__UltraFastMagnecticInserterExtra__/graphics/configurable-inserter-platform.png",
        height = 40,
        priority = "extra-high",
        shift = {
          0.03125,
          0.1875
        },
        width = 53
      }
    },
    circuit_wire_connection_points = circuit_connector_definitions["inserter"].points,
    circuit_connector_sprites = circuit_connector_definitions["inserter"].sprites,
    circuit_wire_max_distance = inserter_circuit_wire_max_distance,
    default_stack_control_input_signal = inserter_default_stack_control_input_signal
  }
})