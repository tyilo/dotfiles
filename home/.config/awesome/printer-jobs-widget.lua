local awful = require("awful")
local naughty = require("naughty")
local wibox = require("wibox")
local watch = require("awful.widget.watch")

local printer_jobs_widget = wibox.widget({
	text = "P",
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

function trim(s)
	-- from PiL2 20.4
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function parse_jobs(str)
	str = str .. "\n"
	local jobs = {}

	-- For some reason using \t doesn"t seem to work
	local pattern = [[(%S+)%s+(%S+)%s+(%S+)%s+(.-)
	Status:(.-)
	Alerts:(.-)
	queued for(.-)
]]

	local start_pos = 1
	while true do
		local i, j, job_name, user, job_id, timestamp, status, alerts, printer_name = str:find(pattern, start_pos)

		if i == nil then
			break
		end

		status = trim(status)
		alerts = trim(alerts)
		printer_name = trim(printer_name)

		local job = {
			job_name=job_name,
			user=user,
			job_id=job_id,
			timestamp=timestamp,
			status=status,
			alerts=alerts,
			printer_name=printer_name,
		}

		table.insert(jobs, job)

		start_pos = j + 1
	end

	return jobs
end

function display_string(jobs)
	local str = ""

	for i, job in ipairs(jobs) do
		if i ~= 1 then
			str = str .. "\n"
		end
		str = str .. job.job_name .. "\n"
		str = str .. job.timestamp .. "\n"
		str = str .. "Status: " .. job.status .. "\n"
	end

	return str
end

local last_jobs, notification

watch("lpstat -l", 1,
	function(widget, stdout, stderr, exitreason, exitcode)
		last_jobs = parse_jobs(stdout)
		widget.text = " " .. #last_jobs .. " "
	end,
	printer_jobs_widget
)

printer_jobs_widget:connect_signal("mouse::enter", function()
	if last_jobs ~= nil then
		notification = naughty.notify{
			text = display_string(last_jobs),
			title = "Printer jobs",
			timeout = -1, hover_timeout = 0.5,
		}
	end
end)
printer_jobs_widget:connect_signal("mouse::leave", function()
	naughty.destroy(notification)
end)

printer_jobs_widget:connect_signal("button::release", function(_, lx, ly, button)
	if button == 1 then
		awful.spawn.with_shell('xdg-open http://localhost:631/jobs/')
	end
end)

return printer_jobs_widget
