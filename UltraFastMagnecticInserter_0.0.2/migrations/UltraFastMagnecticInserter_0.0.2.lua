
for index, force in pairs(game.forces) do
  local technologies = force.technologies
  local recipes = force.recipes

  if technologies["ultra-fast-inserter"].researched then
    recipes["ultra-fast-long-inserter"].enabled = true
    recipes["ultra-fast-filter-inserter"].enabled = true
    recipes["ultra-fast-long-filter-inserter"].enabled = true
  end
end