data:extend({
  {
    type = "technology",
    name = "ultra-fast-inserter",
    icon = "__base__/graphics/technology/stack-inserter.png",
    icon_size = 128,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "ultra-fast-inserter"
      },
      {
        type = "unlock-recipe",
        recipe = "ultra-fast-long-inserter"
      },
      {
        type = "unlock-recipe",
        recipe = "ultra-fast-filter-inserter"
      },
      {
        type = "unlock-recipe",
        recipe = "ultra-fast-long-filter-inserter"
      }
    },
    prerequisites = {"stack-inserter"},
    unit =
    {
      count = 150,
      ingredients =
      {
        {"science-pack-1", 1},
        {"science-pack-2", 1}
      },
      time = 30
    },
    upgrade = true,
    order = "c-o-a",
  }
})