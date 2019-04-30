--[[
addons/schedule/lua/autorun/client/schedule_hud.lua
--]]
surface.CreateFont("ClockFont", {
	font = "DJB Get Digital",
	extended = false,
	size = 48,
	weight = 500,
	blursize = 0,
})

local schedule = {
{{"6:00","6:30"}, "Зарядка"}, -- {{"начало", "конец"(БЕЗ НУЛЕЙ В НАЧАЛЕ!!! 9:00, а не 09:00!!!!!) }, "Название"},
{{"6:30","7:00"}, "Заправка кроватей и утренний туалет"},
{{"7:00","07:20"}, "Утренний осмотр внешнего вида военнослужащих"},
{{"7:20","8:00"}, "Завтрак"},
{{"8:00","9:00"}, "Собрание на плацу"},
{{"9:00","14:00"}, "Учебные занятия"},
{{"14:00","15:00"}, "Обед"},
{{"15:00","15:30"}, "Собрание на плацу"},
{{"15:30","18:00"}, "Личное время"},
{{"18:00","18:20"}, "Контрольная проверка"},
{{"18:20","19:00"}, "Ужин"},
{{"19:00","21:00"}, "Время личных потребностей"},
{{"21:00","21:15"}, "Поход в туалет"},
{{"21:15","21:35"}, "Вечерняя прогулка"},
{{"21:35","22:00"}, "Вечерняя проверка"},
{{"22:00","6:00"}, "Отбой"},
}

local key_1 = KEY_LALT -- первая клавиша. http://wiki.garrysmod.com/page/Enums/KEY
local key_2 = KEY_H -- вторая клавиша. http://wiki.garrysmod.com/page/Enums/KEY

for k,v in pairs(schedule) do
	schedule[k][1][1] = StormFox.StringToTime(v[1][1])
	schedule[k][1][2] = StormFox.StringToTime(v[1][2])
end


local function IsInside(f,till,ctime)
	return ctime >= f and ctime <= till
end

local clck = Material("schedmats/wtchs.png", "noclamp smooth")
local pper = Material("schedmats/sched_paper.png")

local clockpos = {ScrW() - 200,20}
local paperpos = {ScrW() - 600,10}
local pYcl = 460
local dock = 0
local ntime
local col = Color(0,0,0)
local opened = false
local function SchedPaint()
	dock = 0
	ntime = StormFox.GetTime()
	surface.SetDrawColor(255,255,255)
	surface.SetMaterial(clck)
	surface.DrawTexturedRect(clockpos[1],clockpos[2],200,200)
	draw.SimpleText(StormFox.GetRealTime(ntime, false), "ClockFont", clockpos[1] + 98,clockpos[2] + 81, Color(0,0,0),TEXT_ALIGN_CENTER)
	surface.SetDrawColor(255,255,255)
	surface.SetMaterial(pper)
	surface.DrawTexturedRect(paperpos[1],paperpos[2]-pYcl,1024/3,1460/3)
	if opened then
		pYcl = Lerp(0.1,pYcl,0)
		for k,v in pairs(schedule) do
			active = false
			if IsInside(v[1][1],v[1][2],ntime) then col = Color(255,0,0) else col = Color(0,0,0) end
			draw.SimpleText(StormFox.GetRealTime(v[1][1], false).."-"..StormFox.GetRealTime(v[1][2], false).." — "..v[2], "DermaDefault", paperpos[1]+12,paperpos[2]+75+dock-pYcl, col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			dock = dock + 25
		end
	else
	draw.SimpleText("Раскрыть - Alt + H", "DermaLarge", paperpos[1]+6,paperpos[2]+22, Color(196, 253, 255),TEXT_ALIGN_LEFT)
		pYcl = Lerp(0.1,pYcl,460)
	end
end

local function OpenToggle()
	if opened then opened = false else opened = true end
end

hook.Add("HUDPaint", "SchedMod_HUD", SchedPaint)

local tim = false

hook.Add("Think","SchedMod_KEYS", function() 
	if input.IsKeyDown(key_1) and input.IsKeyDown(key_2) and !tim then
		OpenToggle()
		tim = true
	elseif !input.IsKeyDown(key_1) and !input.IsKeyDown(key_2) then
		tim = false
	end
end)
--[[
	6:00 подъем
	6:00-6:30 зарядка
	6:30-07:00 — заправка кроватей и утренний туалет
	7:00-07:20 — утренний осмотр внешнего вида военнослужащих
	7:20-08:00 — завтрак
	8:00-09:00 — собрание на плацу
	9:00 — 14:00 — учебные занятия
	14:00-15:00 — обед
	15:00-15:30 — собрание на плацу
	15:30-18:00 — личное время
	18:00-18:20 — контрольная проверка
	18:20-19:00 — ужин
	19:00-21:00 — время личных потребностей
	21:00-21:15 — поход в туалет
	21:15-21:35 — вечерняя прогулка
	21:35-21:45 — вечерняя поверка
	22.00 — отбой
]]

