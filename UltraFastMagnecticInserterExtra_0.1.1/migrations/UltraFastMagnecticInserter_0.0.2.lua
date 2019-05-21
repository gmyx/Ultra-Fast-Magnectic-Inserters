
for index, force in pairs(game.forces) do
  local technologies = force.technologies
  local recipes = force.recipes

  if technologies["ultra-fast-inserter"].researched then
    recipes["ultra-fast-long-inserter"].enabled = true
    recipes["ultra-fast-filter-inserter"].enabled = true
    recipes["ultra-fast-long-filter-inserter"].enabled = true
    recipes["ultra-fast-long-configurable-inserter"].enabled = true
  end

  if technologies["ultra-fast-configurable-inserter"].researched then
  	recipes["ultra-fast-configurable-inserter"].enabled = true
    recipes["ultra-fast-configurable-filter-inserter"].enabled = true
  end

  --may need to migrate recipy count
end