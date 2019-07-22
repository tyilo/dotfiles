--local awful = require('awful')

local ordered_mapping = {
	-- {class, tag name}
	{"Zeal", "Zeal"},
	{"Slack", "Slack"},
	{"discord", "Discord"},
	{"Caprine", "Messenger"},
	{"Thunderbird", "Mail"},
}

local tagnames = {}
for i=1, 10 do
	table.insert(tagnames, tostring(i == 10 and 0 or i))
end

-- Above is config

local mapping = {}
local primary_tagnames = {}
for i, name in ipairs(tagnames) do
	local j = #ordered_mapping - #tagnames + i
	if j >= 1 then
		local m = ordered_mapping[j]
		local class = m[1]
		local tagname = m[2]

		name = name .. " " .. tagname
		mapping[class] = name
	end
	primary_tagnames[i] = name
end

local function get_tag(c)
	return awful.tag.find_by_name(screen.primary, mapping[c.class])
end

local function get_tagnames(is_primary)
	if is_primary then
		return primary_tagnames
	else
		return tagnames
	end
end

local function get_rules()
	local rules = {}
	for i, class_tagname in ipairs(ordered_mapping) do
		rules[i] = {
			rule = { class = class_tagname[1] },
			properties = { screen = screen.primary.index, tag = mapping[class_tagname[1]] },
		}
	end
	return rules
end

return {
	get_tag = get_tag,
	get_tagnames = get_tagnames,
	get_rules = get_rules,
}
