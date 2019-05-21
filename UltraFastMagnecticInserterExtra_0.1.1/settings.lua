--settings.lua
data:extend(
{
	{
		name = "ufi-override-stack-size",
		type = "bool-setting",
		setting_type = "runtime-per-user",
		default_value = true,
		per_user = true,
		order = "1"
	},
	{
		name = "ufi-override-stack-size-value",
		type = "int-setting",
		setting_type = "runtime-per-user",
		default_value = 1,
		minimum_value = 1,
		maximum_value=14,
		per_user = true,
		order = "2"
	}
})