script_name('helper-for-mia')
script_version(2)

require 'lib.moonloader'
require 'lib.sampfuncs'
local mad               = require 'MoonAdditions'
local KEY               = require 'vkeys'
local memory            = require 'memory'
local imgui             = require 'imgui'
--local pie               = require 'imgui_piemenu'
local encoding          = require 'encoding'
local color             = require "colorise"
local inicfg            = require 'inicfg'
local ffi               = require "ffi"
local getBonePosition   = ffi.cast("int (__thiscall*)(void*, float*, int, bool)", 0x5E4280)
lsampev, sampev         = pcall(require, 'lib.samp.events')
encoding.default        = 'CP1251'
u8                      = encoding.UTF8

local tCarsName = {"Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
	"Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BFInjection", "Hunter",
	"Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo",
	"RCBandit", "Romero","Packer", "Monster", "Admiral", "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed",
	"Yankee", "Caddy", "Solair", "Berkley'sRCVan", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RCBaron", "RCRaider", "Glendale", "Oceanic", "Sanchez", "Sparrow",
	"Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage",
	"Dozer", "Maverick", "NewsChopper", "Rancher", "FBIRancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "BlistaCompact", "PoliceMaverick",
	"Boxvillde", "Benson", "Mesa", "RCGoblin", "HotringRacerA", "HotringRacerB", "BloodringBanger", "Rancher", "SuperGT", "Elegant", "Journey", "Bike",
	"MountainBike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "hydra", "FCR-900", "NRG-500", "HPV1000",
	"CementTruck", "TowTruck", "Fortune", "Cadrona", "FBITruck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan", "Blade", "Freight",
	"Streak", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada",
	"Yosemite", "Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RCTiger", "Flash", "Tahoma", "Savanna", "Bandito",
	"FreightFlat", "StreakCarriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "NewsVan",
	"Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club", "FreightBox", "Trailer", "Andromada", "Dodo", "RCCam", "Launch", "PoliceCar", "PoliceCar",
	"PoliceCar", "PoliceRanger", "Picador", "SWAT", "Alpha", "Phoenix", "GlendaleShit", "SadlerShit", "Luggage A", "Luggage B", "Stairs", "Boxville", "Tiller",
	"UtilityTrailer"
}

local tCarsTypeName = {"Автомобиль", "Мотоцикл", "Вертолёт", "Самолёт", "Прицеп", "Лодка", "Другое", "Поезд", "Велосипед"}

local tCarsSpeed = {43, 40, 51, 30, 36, 45, 30, 41, 27, 43, 36, 61, 46, 30, 29, 53, 42, 30, 32, 41, 40, 42, 38, 27, 37,
	54, 48, 45, 43, 55, 51, 36, 26, 30, 46, 0, 41, 43, 39, 46, 37, 21, 38, 35, 30, 45, 60, 35, 30, 52, 0, 53, 43, 16, 33, 43,
	29, 26, 43, 37, 48, 43, 30, 29, 14, 13, 40, 39, 40, 34, 43, 30, 34, 29, 41, 48, 69, 51, 32, 38, 51, 20, 43, 34, 18, 27,
	17, 47, 40, 38, 43, 41, 39, 49, 59, 49, 45, 48, 29, 34, 39, 8, 58, 59, 48, 38, 49, 46, 29, 21, 27, 40, 36, 45, 33, 39, 43,
	43, 45, 75, 75, 43, 48, 41, 36, 44, 43, 41, 48, 41, 16, 19, 30, 46, 46, 43, 47, -1, -1, 27, 41, 56, 45, 41, 41, 40, 41,
	39, 37, 42, 40, 43, 33, 64, 39, 43, 30, 30, 43, 49, 46, 42, 49, 39, 24, 45, 44, 49, 40, -1, -1, 25, 22, 30, 30, 43, 43, 75,
	36, 43, 42, 42, 37, 23, 0, 42, 38, 45, 29, 45, 0, 0, 75, 52, 17, 32, 48, 48, 48, 44, 41, 30, 47, 47, 40, 41, 0, 0, 0, 29, 0, 0
}

local tCarsType = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1,
	3, 1, 1, 1, 1, 6, 1, 1, 1, 1, 5, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 6, 3, 2, 8, 5, 1, 6, 6, 6, 1,
	1, 1, 1, 1, 4, 2, 2, 2, 7, 7, 1, 1, 2, 3, 1, 7, 6, 6, 1, 1, 4, 1, 1, 1, 1, 9, 1, 1, 6, 1,
	1, 3, 3, 1, 1, 1, 1, 6, 1, 1, 1, 3, 1, 1, 1, 7, 1, 1, 1, 1, 1, 1, 1, 9, 9, 4, 4, 4, 1, 1, 1,
	1, 1, 4, 4, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 8, 8, 7, 1, 1, 1, 1, 1, 1, 1,
	1, 3, 1, 1, 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 8, 8, 7, 1, 1, 1, 1, 1, 4,
	1, 1, 1, 2, 1, 1, 5, 1, 2, 1, 1, 1, 7, 5, 4, 4, 7, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5, 5, 5, 1, 5, 5
}

local TypeWeapon = {1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1}

local InfoWeapon = {{'Щит', false, 'shit', 1},
	{'Дубинка', false, 'button', 1},
	{'Бронежилет', false, 'armour', 1},
	{'Маска', false, 'mask', 1},
	{'SD pistol', true, 'sd', 250},
	{'Desert Eagle', true, 'deagle', 250},
	{'MP5', true, 'mp5', 400},
	{'ShotGun', true, 'shotgun', 100},
	{'Дымовые шашки', true, 'smoke', 25},
	{'Sniper Rifle', true, 'sniper', 50},
	{'M4', true, 'm4', 350},
	{'AK-47', true, 'ak47', 350}
}

local commands = {
	'/admins | Открыть админ-список',
	'/r | Отправить сообщению в обычную рацию',
	'/rn | Отправить сообщение в nRP чат обычной рации',
	'/f | Отправить сообщение в общую волну',
	'/fn | Отправить сообщение в nRP чат общей волны',
	'/cuff | Надеть наручники на подозреваемого',
	'/uncuff | Снять наручники с подозреваемого',
	'/arrest | Отправить подозреваемого в департамент',
	'/pull | Вытащить подозреваемого из автомобиля',
	'/su | Объявить подозреваемого в розыск',
	'/skip | Выдать временный пропуск игроку',
	'/clear | Очистить уровень розыска для игрока',
	'/follow | Начать прослушивание',
	'/hold | Тащить игрока за собой',
	'/ticket | Выписать штраф нарушителю',
	'/takelic | Изъять или понизить уровень лицензии на вождение',
	'/putpl | Посадить подозреваемого в автомобиль',
	'/search | Обыскать подозреваемого',
	'/patrol | Отправить доклад о патруле',
	'/hack | Взломать дверь дома',
	'/invite | Принять игрока в организацию',
	'/uninvite | Уволить игрока из организации',
	'/rang | Изменить ранг игрока в большую или меньшию сторону',
	'/changeskin | Изменить организационную внешность игрока',
	'/ud | Показать удостоверение',
	'/pas | Запросить документы у игрока',
	'/ainfo | Открыть информационное меню',
	'/rkinfo | Получить информацию о RK',
	'/rep | Быстрая отправка сообщения в репорт',
	'/епк | Найти информацию о ЕПК по пункту или части пункта',
	'/устав | Найти информацию о УМВД по пункту или части пункта',
	'/sw | Изменить погоду',
	'/st | Изменить время',
	'/skin | Установить визуальный скин для игрока',
	'/hist | Окрыть историю изменения ников игрока по его ID',
	'/add_obj | Добавить объект',
	'/edit_obj | Изменить объект',
	'/del_obj | Удалить объект',
	'/add_text | Добавить 3D текст',
	'/edit_text | Изменить 3D текст',
	'/del_text | Удалить 3D текст',
	'/strobes | Включить стробоскопы',
	'NumPad3 | Открыть основное меню',
	'ПКМ + 1 | Съесть еду',
	'ПКМ + 2 | Открыть шлагбаум',
	'ПКМ + 3 | Потребовать автомобиль остановится',
	'ПКМ + 4 | Объявить игрока в розыск',
	'1 | Включить Sceletal WallHack',
	'Alt | Включить стробоскопы'
}

local frac = {
	name = {'mvd', 'prav', 'mm', 'mo', 'mz', 'lcn', 'rm', 'yak', 'grv', 'bal', 'vag', 'azt', 'rif', 'civ', 'mask', 'all'},
	fullname = {'Министерство внутренних дел', 'Правительство', 'Средства массовой информации', 'Министерство обороны', 'Министерство здравоохранения', 'La Cosa Nostra', 'Russian Mafia', 'Yakuza', 'Grove Street', 'The Ballas', 'Los Santos Vagos', 'Varios los Aztecas', 'The Rifa', 'Гражданские', 'В маске', 'Прочее'},
	color = {'{0000ff}', '{ccff00}', '{ff6600}', '{996633}', '{ff6666}', '{993366}', '{007575}', '{bb0000}', '{009900}', '{cc00ff}', '{ffcd00}', '{00ccff}', '{6666ff}', '{ffffff}', '{ffffff}', '{ffffff}'},
}

local ini = inicfg.load({
	info = {
		name                 = '',
		rang                 = '',
		frac                 = '',
		number               = '',
		male                 = true,
		female               = false,
		rteg                 = '',
		fteg                 = ''
	},
	set = {
		masktimer            = false,
		camera               = false,
		stopad               = false,
		strobes              = false,
		weapon               = false,
		radio                = false,
		autopass             = false,
		antifbi              = false,
		sniperpd             = false,
		upleader             = false,
		autoweapon           = false,
		doblebullet          = false
	},
	weapon = {
		shit                 = false,
		button               = false,
		armour               = false,
		mask                 = false,
		sd                   = false,
		deagle               = false,
		mp5                  = false,
		shotgun              = false,
		smoke                = false,
		sniper               = false,
		m4                   = false,
		ak47                 = false
	}
})

local color_red          = '{CD5C5C}'
local color_orange       = '{F4A460}'
local color_green        = '{00CD66}'
local skin_table         = {}
local lgov               = {}
local info_scene         = {}
local logchat            = {}
local logdmg             = {}
local dreason            = {}
local param_cmd          = 0
local suspect_id         = {}
local show_player        = ''
local showtimer          = false
local autopass           = false
local cActive            = false
local follow_state       = false
local show_menu          = imgui.ImBool(false)
local piemenu            = imgui.ImBool(false)
local show_help          = imgui.ImBool(false)
local show_info          = imgui.ImBool(false)
local show_epk           = imgui.ImBool(false)
local show_ustav         = imgui.ImBool(false)
local show_weapon        = imgui.ImBool(false)
local vfilt              = imgui.ImBool(false)
local show_item          = imgui.ImInt(0)
local pname              = imgui.ImBuffer(256)
local prang              = imgui.ImBuffer(256)
local pfrac              = imgui.ImBuffer(256)
local pnumber            = imgui.ImBuffer(256)
local rteg               = imgui.ImBuffer(256)
local fteg               = imgui.ImBuffer(256)
local name_cmd           = imgui.ImBuffer(256)
local search_place       = imgui.ImBuffer(1000)
local text_cmd           = imgui.ImBuffer(9999)
local admins             = imgui.ImBuffer(9999)
local male				 = imgui.ImBool(ini.info.male)
local female             = imgui.ImBool(ini.info.female)
local pcamera            = imgui.ImBool(ini.set.camera)
local pstopad            = imgui.ImBool(ini.set.stopad)
local pweapon            = imgui.ImBool(ini.set.weapon)
local pstrobes           = imgui.ImBool(ini.set.strobes)
local pradio             = imgui.ImBool(ini.set.radio)
local pautopass          = imgui.ImBool(ini.set.autopass)
local pantifbi           = imgui.ImBool(ini.set.antifbi)
local psniperpd          = imgui.ImBool(ini.set.sniperpd)
local pupleader          = imgui.ImBool(ini.set.upleader)
local pautoweapon        = imgui.ImBool(ini.set.autoweapon)
local pdoblebullet       = imgui.ImBool(ini.set.doblebullet)
local editor             = imgui.ImBool(false)

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	
	autoupdate('https://raw.githubusercontent.com/skezz-perry/project/master/version', 'https://raw.githubusercontent.com/skezz-perry/project/master/name') 
	
	sampRegisterChatCommand('admins', command_admins)
	sampRegisterChatCommand('r', command_r)
	sampRegisterChatCommand('rn', command_rn)
	sampRegisterChatCommand('f', command_f)
	sampRegisterChatCommand('fn', command_fn)
	sampRegisterChatCommand('cuff', command_cuff)
	sampRegisterChatCommand('uncuff', command_uncuff)
	sampRegisterChatCommand('arrest', command_arrest)
	sampRegisterChatCommand('pull', command_pull)
	sampRegisterChatCommand('su', command_su)
	sampRegisterChatCommand('skip', command_skip)
	sampRegisterChatCommand('clear', command_clear)
	sampRegisterChatCommand('hold', command_hold)
	sampRegisterChatCommand('ticket', command_ticket)
	sampRegisterChatCommand('takelic', command_takelic)
	sampRegisterChatCommand('putpl', command_putpl)
	sampRegisterChatCommand('search', command_search)
	sampRegisterChatCommand('patrol', command_patrol)
	sampRegisterChatCommand('follow', command_follow)
	sampRegisterChatCommand('hack', command_hack)
	sampRegisterChatCommand('invite', command_invite)
	sampRegisterChatCommand('uninvite', command_uninvite)
	sampRegisterChatCommand('rang', command_rang)
	sampRegisterChatCommand('changeskin', command_changeskin)
	sampRegisterChatCommand('ud', command_ud)
	sampRegisterChatCommand('pas', command_pas)
	sampRegisterChatCommand('rep', command_report)
	sampRegisterChatCommand('епк', command_epk)
	sampRegisterChatCommand('устав', command_ustav)
	sampRegisterChatCommand('sw', command_setweather)
	sampRegisterChatCommand('st', command_settime)
	sampRegisterChatCommand('skin', command_setskin)
	sampRegisterChatCommand('hist', command_history) 

	sampRegisterChatCommand('nhold', function(param)
		if not param:match('(%d+)') then SCM('Используйте команду /nhold [ид игрока]') else sampSendChat('/hold '..param) end
	end)
	
	sampRegisterChatCommand('nfollow', function() 
		sampSendChat('/follow')
	end)
	
	sampRegisterChatCommand('ncuff', function(param) 
		if not param:match('(%d+)') then SCM('Используйте команду /ncuff [ид игрока]') else sampSendChat('/cuff '..param) end 
	end)
	sampRegisterChatCommand('nuncuff', function(param) 
		if not param:match('(%d+)') then SCM('Используйте команду /nuncuff [ид игрока]') else sampSendChat('/uncuff '..param) end 
	end)
	sampRegisterChatCommand('nputpl', function(param) 
		if not param:match('(%d+)') then SCM('Используйте команду /nputpl [ид игрока]') else sampSendChat('/putpl '..param) end 
	end)
	sampRegisterChatCommand('narrest', function(param) 
		if not param:match('(%d+)') then SCM('Используйте команду /narrest [ид игрока]') else sampSendChat('/arrest '..param) end 
	end)
	sampRegisterChatCommand('nsearch', function(param) 
		if not param:match('(%d+)') then SCM('Используйте команду /nsearch [ид игрока]') else sampSendChat('/search '..param) end 
	end)
	sampRegisterChatCommand('nskip', function(param) 
		if not param:match('(%d+)') then SCM('Используйте команду /nskip [ид игрока]') else sampSendChat('/skip '..param) end 
	end)
	sampRegisterChatCommand('ninvite', function(param) 
		if not param:match('(%d+)') then SCM('Используйте команду /ninvite [ид игрока]') else sampSendChat('/invite '..param) end 
	end)
	sampRegisterChatCommand('nuninvite', function(param) 
		if not param:match('(%d+) (%S+)') then SCM('Используйте команду /nuninvite [ид игрока] [причина]') else sampSendChat('/uninvite '..param) end 
	end)
	sampRegisterChatCommand('nsu', function(param) 
		if not param:match('(%d+) (%d+) (%S+)') then SCM('Используйте команду /nsu [ид игрока] [кол-во звёзд] [причина]') else sampSendChat('/su '..param) end 
	end)
	sampRegisterChatCommand('nticket', function(param) 
		if not param:match('(%d+) (%d+) (%S+)') then SCM('Используйте команду /nticket [ид игрока] [сумма] [причина]') else sampSendChat('/ticket '..param) 	end 
	end)
	sampRegisterChatCommand('ntakelic', function(param) 
		if not param:match('(%d+) (%S+)') then SCM('Используйте команду /ntakelic [ид игрока] [причина]') else sampSendChat('/takelic '..param) end 
	end)
	sampRegisterChatCommand('nclear', function(param) 
		if not param:match('(%d+)') then SCM('Используйте команду /nclear [ид игрока]') else sampSendChat('/clear '..param) end 
	end)
	sampRegisterChatCommand('nrang', function(param) 
		if not param:match('(%d+) [+?-]') then SCM('Используйте команду /nrang [ид игрока] [+ / -]') else sampSendChat('/rang '..param) end 
	end)
	sampRegisterChatCommand('nchangeskin', function(param) 
		if not param:match('(%d+)') then SCM('Используйте команду /nchangeskin [ид игрока]') else sampSendChat('/changeskin '..param) end 
	end)

	sampRegisterChatCommand('add_obj', command_cobject)
	sampRegisterChatCommand('del_obj', command_dobject)
	sampRegisterChatCommand('edit_obj', command_eobject)
	sampRegisterChatCommand('add_text', command_ctext)
	sampRegisterChatCommand('del_text', command_dtext)
	sampRegisterChatCommand('edit_text', command_etext)
	
	sampRegisterChatCommand('rkinfo', function()
		if dreason[1] ~= nil then
			local timed = getTimeByPeriod(tonumber(dreason[2]), tonumber(dreason[3]), tonumber(dreason[4]), 10)
			SCM(string.format('Вы можете вернутся в район %s в %d ч. %d мин. %d сек.', dreason[1], timed[1], timed[2], timed[3]))
			if sampGetPassedTimeByPeriod(tonumber(dreason[2]), tonumber(dreason[3]), tonumber(dreason[4]), 10) then
				SCM(string.format('Время вышло и вы уже {00cc99}можете{ffffff} вернутся в район %s.', dreason[1]))
			else
				SCM(string.format('В данный момент Вы {ff5c33}не можете{ffffff} вернутся в район %s.', dreason[1]))
				if tostring(calculateZone()) == tostring(dreason[1]) then
					SCM(string.format(' {ff5c33}[ПРЕДУПРЕЖДЕНИЕ] {ffffff}Вы находитесь в запрещённом для Вас районе %s.', dreason[1]))
				end
			end
		else
			SCM('Вы не умирали.')
		end
	end)
	
	sampRegisterChatCommand('ainfo', function()
		show_info.v = not show_info.v
	end)
	
	sampRegisterChatCommand('strobes', function()
		if isCharInAnyCar(PLAYER_PED) and ini.set.strobes  then
			local car = storeCarCharIsInNoSave(PLAYER_PED)
			local driverPed = getDriverOfCar(car)

			if PLAYER_PED == driverPed then
				local state = not isCarSirenOn(car)
				switchCarSiren(car, state)
			end
		end
	end)
	lua_thread.create(strobe)

	apply_custom_style()

	while true do
		wait(0)

		if wasKeyPressed(KEY.VK_NUMPAD3) then 
			show_menu.v = not show_menu.v
		end
		
		if wasKeyPressed(KEY.VK_1) and isKeyDown(VK_RBUTTON) then sampSendChat('/eat') end

		if wasKeyPressed(KEY.VK_2) and isKeyDown(VK_RBUTTON) then sampSendChat('/open') end

		if wasKeyPressed(KEY.VK_4) and isKeyDown(VK_RBUTTON) then
			if suspect_id[1] ~= nil then
				if IPC(suspect_id[1]) then 
					command_su(string.format('%d %d %s', suspect_id[1], suspect_id[2], suspect_id[3])) 
				end
			end
		end
		
		if show_menu.v or piemenu.v or show_info.v or show_epk.v or show_ustav.v then
			imgui.Process = true
		else
			imgui.Process = false
		end
		
		if wasKeyPressed(KEY.VK_F12) then
			if ini.set.camera then
				if cActive then
					sampSendChat('/do На плечевой стропе установлена камера видеофиксации, камера не активна.')
				else
					sampSendChat('/do На плечевой стропе установлена камера видеофиксации, камера активна.')
				end
				cActive = not cActive
			end
		end
		
		if edit_obj ~= nil and not sampIsChatInputActive() and not sampIsDialogActive() and text_id == nil then
			-- вращение
			if isKeyDown(VK_NUMPAD8) and isKeyDown(VK_CONTROL) then
				obj_qx = obj_qx + obj_srotate
				setObjectRotation(edit_obj, obj_qx, obj_qy, obj_qz)
			elseif isKeyDown(VK_NUMPAD2) and isKeyDown(VK_CONTROL) then
				obj_qx = obj_qx - obj_srotate
				setObjectRotation(edit_obj, obj_qx, obj_qy, obj_qz)
			elseif isKeyDown(VK_NUMPAD4) and isKeyDown(VK_CONTROL) then
				obj_qy = obj_qy + obj_srotate
				setObjectRotation(edit_obj, obj_qx, obj_qy, obj_qz)
			elseif isKeyDown(VK_NUMPAD6) and isKeyDown(VK_CONTROL) then
				obj_qy = obj_qy - obj_srotate
				setObjectRotation(edit_obj, obj_qx, obj_qy, obj_qz)
			elseif isKeyDown(VK_NUMPAD7) and isKeyDown(VK_CONTROL) then
				obj_qz = obj_qz + obj_srotate
				setObjectRotation(edit_obj, obj_qx, obj_qy, obj_qz)
			elseif isKeyDown(VK_NUMPAD9) and isKeyDown(VK_CONTROL) then
				obj_qz = obj_qz - obj_srotate
				setObjectRotation(edit_obj, obj_qx, obj_qy, obj_qz)
			-- движение (в стороны)
			elseif isKeyDown(VK_NUMPAD8) then
				obj_y = obj_y + obj_smove
				setObjectCoordinates(edit_obj, obj_x, obj_y, obj_z)
			elseif isKeyDown(VK_NUMPAD2) then
				obj_y = obj_y - obj_smove
				setObjectCoordinates(edit_obj, obj_x, obj_y, obj_z)
			elseif isKeyDown(VK_NUMPAD4) then
				obj_x = obj_x - obj_smove
				setObjectCoordinates(edit_obj, obj_x, obj_y, obj_z)
			elseif isKeyDown(VK_NUMPAD6) then
				obj_x = obj_x + obj_smove
				setObjectCoordinates(edit_obj, obj_x, obj_y, obj_z)
			-- движение (верх вниз)
			elseif isKeyDown(VK_SPACE) then
				obj_z = obj_z + obj_smove
				setObjectCoordinates(edit_obj, obj_x, obj_y, obj_z)
			elseif isKeyDown(VK_MENU) then
				obj_z = obj_z - obj_smove
				setObjectCoordinates(edit_obj, obj_x, obj_y, obj_z)
			-- сохранение
			elseif isKeyDown(VK_RETURN) then
				SCM('Вы закончили редактирование объекта с хендлом {FFCD00}' .. edit_obj .. '{ffffff}.')
				edit_obj = nil
			end
		end
		
		if text_id ~= nil and not sampIsChatInputActive() and not sampIsDialogActive() and edit_obj == nil then
			-- движение
			if isKeyDown(VK_NUMPAD8) then
				text_y = text_y + 0.04
				sampCreate3dTextEx(text_id, text_text, text_color, text_x, text_y, text_z, text_distance, false, -1, -1)
			elseif isKeyDown(VK_NUMPAD2) then
				text_y = text_y - 0.04
				sampCreate3dTextEx(text_id, text_text, text_color, text_x, text_y, text_z, text_distance, false, -1, -1)
			elseif isKeyDown(VK_NUMPAD4) then
				text_x = text_x - 0.04
				sampCreate3dTextEx(text_id, text_text, text_color, text_x, text_y, text_z, text_distance, false, -1, -1)
			elseif isKeyDown(VK_NUMPAD6) then
				text_x = text_x + 0.04
				sampCreate3dTextEx(text_id, text_text, text_color, text_x, text_y, text_z, text_distance, false, -1, -1)
			elseif isKeyDown(VK_SPACE) then
				text_z = text_z + 0.04
				sampCreate3dTextEx(text_id, text_text, text_color, text_x, text_y, text_z, text_distance, false, -1, -1)
			elseif isKeyDown(VK_MENU) then
				text_z = text_z - 0.04
				sampCreate3dTextEx(text_id, text_text, text_color, text_x, text_y, text_z, text_distance, false, -1, -1)
			-- сохранение
			elseif isKeyDown(VK_RETURN) then
				SCM('Вы закончили редактирование 3D текста с ID {FFCD00}' .. text_id .. '{ffffff}.')
				text_id = nil
			end 
		end
		
		--[[if wasKeyPressed(KEY.VK_Z) then
			res, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
			if res then
				_, targetid = sampGetPlayerIdByCharHandle(ped)
				piemenu.v = not piemenu.v
			elseif piemenu.v then
				piemenu.v = false
			end
        end--]]

		if isCharInAnyCar(PLAYER_PED) and ini.set.strobes then

			local car = storeCarCharIsInNoSave(PLAYER_PED)
			local driverPed = getDriverOfCar(car)

			if isKeyDown(VK_LMENU) and isKeyCheckAvailable() and driverPed == PLAYER_PED then
				local state = true

				for i = 1, 10 do
					wait(100)
					if not isKeyDown(VK_LMENU) then state = false end
				end

				if isKeyDown(VK_LMENU) and state then

					local state = not isCarSirenOn(car)
					switchCarSiren(car, state)

					while isKeyDown(VK_LMENU) do wait(0) end

				end

			end

		end

		if wasKeyPressed(KEY.VK_3) and isKeyDown(VK_RBUTTON) then
			itsok = false
			if isCharInAnyCar(playerPed) then
				peds = getAllChars()
				if peds ~= nil then
					for _, hm in pairs(peds) do
						if itsok == false and hm ~= nil then
							local _ , id = sampGetPlayerIdByCharHandle(hm)
							local _ , m = sampGetPlayerIdByCharHandle(PLAYER_PED)
							if id ~= -1 and id ~= m and doesCharExist(hm) and sampIsPlayerConnected(id) then
								local  _ , idofplayercar = sampGetPlayerIdByCharHandle(hm)
								if IPC(idofplayercar) then
									if sampGetDistance(PLAYER_PED, idofplayercar) <= 55 then
										 if isCharInAnyCar(hm) then
											if storeCarCharIsInNoSave(hm) ~= storeCarCharIsInNoSave(playerPed) then
												local carh = storeCarCharIsInNoSave(hm)
												if getDriverOfCar(carh) == hm then
													sampSendChat('/m Внимание! Водитель ' .. tCarsName[getCarModel(carh) - 399] .. ' с номером ' .. idofplayercar .. '!')
													wait(1500)
													sampSendChat("/m Немедленно остановите транспортное средство и прижмитесь к обочине!")
													wait(1000)
													sampSendChat('/r ' .. ini.info.rteg .. ' 10-57 VICTOR за ' .. tCarsName[getCarModel(carh) - 399] .. ' с номером ' .. idofplayercar .. ' по ' .. calculateZone() .. ' (' .. kvadrat() .. ').')
													itsok = true 
												end
											end
										 end
									end
								end
							end
						end
					end
				end
			end
		end
		
		if wasKeyPressed(KEY.VK_1) and not sampIsChatInputActive() and not sampIsDialogActive() and not cActive then
			if defaultState then
				defaultState = false; 
				nameTagOff(); 
				while isKeyDown(KEY.VK_1) do wait(100) end 
			else
				defaultState = true;
				if whVisible ~= "bones" and not nameTag then nameTagOn() end
				while isKeyDown(KEY.VK_1) do wait(100) end 
			end 
		end
		
		if defaultState and whVisible ~= "names" then
			if not isPauseMenuActive() and not isKeyDown(VK_F8) then
				for i = 0, sampGetMaxPlayerId() do
				if sampIsPlayerConnected(i) then
					local result, cped = sampGetCharHandleBySampPlayerId(i)
					local color = sampGetPlayerColor(i)
					local aa, rr, gg, bb = explode_argb(color)
					local color = join_argb(255, rr, gg, bb)
					if result then
						if doesCharExist(cped) and isCharOnScreen(cped) then
							local t = {3, 4, 5, 51, 52, 41, 42, 31, 32, 33, 21, 22, 23, 2}
							for v = 1, #t do
								pos1X, pos1Y, pos1Z = getBodyPartCoordinates(t[v], cped)
								pos2X, pos2Y, pos2Z = getBodyPartCoordinates(t[v] + 1, cped)
								pos1, pos2 = convert3DCoordsToScreen(pos1X, pos1Y, pos1Z)
								pos3, pos4 = convert3DCoordsToScreen(pos2X, pos2Y, pos2Z)
								renderDrawLine(pos1, pos2, pos3, pos4, 1, color)
							end
							for v = 4, 5 do
								pos2X, pos2Y, pos2Z = getBodyPartCoordinates(v * 10 + 1, cped)
								pos3, pos4 = convert3DCoordsToScreen(pos2X, pos2Y, pos2Z)
								renderDrawLine(pos1, pos2, pos3, pos4, 1, color)
							end
							local t = {53, 43, 24, 34, 6}
							for v = 1, #t do
								posX, posY, posZ = getBodyPartCoordinates(t[v], cped)
								pos1, pos2 = convert3DCoordsToScreen(posX, posY, posZ)
							end
						end
					end
				end
			end
			else
				nameTagOff()
				while isPauseMenuActive() or isKeyDown(VK_F8) do wait(0) end
				nameTagOn()
			end
		end
	end
end

function command_r(text)
	if not string.match(text, '(.+)') then SCM('Используйте команду /r [текст]') else sampSendChat('/r ' .. ini.info.rteg .. ' ' .. text) end
end

function command_rn(text) 
	if not string.match(text, '(.+)') then SCM('Используйте команду /rn [текст]') else sampSendChat('/r (( ' .. text .. ' ))') end
end

function command_f(text)
	if not string.match(text, '(.+)') then SCM('Используйте команду /f [текст]') else sampSendChat('/f ' .. ini.info.fteg .. ' ' .. text) end
end

function command_fn(text)
	if not string.match(text, '(.+)') then SCM('Используйте команду /fn [текст]') else sampSendChat('/f (( ' .. text .. ' ))') end
end

function command_report(text)
	if not string.match(text, '(.+)') then
		SCM('Используйте команду /rep [текст].')
	else
		report = text
		act = true
		sampSendChat('/mn')
	end
end

function command_cobject(id)
	if string.match(id, '(%d+) (.+) (.+)') then
		id, smove, srotate = string.match(id, '(%d+) (.+) (.+)')
		x, y, z = getCharCoordinates(PLAYER_PED)
		object = createObject(id, x, y, z)
		if doesObjectExist(object) and edit_obj == nil then
			setObjectCollision(object, false)
			SCM('Был создан объект {FFCD00}' .. id .. '{ffffff} с хендлом {FFCD00}' .. object .. '{ffffff}.')
			SCM('Для редактирование объекта используйте стрелки на NumPad, Space (поднять), Alt (опустить), Ctrl + стрелки NumPad (вращение).')
			SCM('Чтобы сохранить нажмите {FFCD00}ENTER{ffffff}, для удаления используйте команду /del_obj [хендл объекта].')
			obj_x = x; obj_y = y; obj_z = z
			obj_qx = 0; obj_qy = 0; obj_qz = 0 
			edit_obj = object
			obj_smove = tonumber(smove); obj_srotate = tonumber(srotate)
		else
			SCM('Произошла ошибка при создании объекта.')
		end
	else
		SCM('Используйте команду /add_obj [ид объекта] [шаг движения (рек. 0.04)] [шаг врашения (рек. 1.0)].')
	end
end

function command_eobject(id)
	if string.match(id, '(%d+) (.+) (.+)') then
		id, smove, srotate = string.match(id, '(%d+) (.+) (.+)')
		if doesObjectExist(id) and edit_obj == nil then
			SCM('Вы начали редактировать объект с хендлом {FFCD00}' .. id .. '{ffffff}.')
			SCM('Для редактирование объекта используйте стрелки на NumPad, Space (поднять), Alt (опустить), Ctrl + NumPad (вращение).')
			SCM('Чтобы сохранить нажмите {FFCD00}ENTER{ffffff}, для удаления используйте команду /del_obj [хендл объекта].')
			_, obj_x, obj_y, obj_z = getObjectCoordinates(id)
			obj_qx = 0; obj_qy = 0; obj_qz = 0 
			edit_obj = id
			obj_smove = tonumber(smove); obj_srotate = tonumber(srotate)
		else
			SCM('Произошла ошибка при начале редактирования объекта.')
		end
	else
		SCM('Используйте команду /edit_obj [хендл объекта] [шаг движения] [шаг врашения].')
	end
end

function command_dobject(id)
	if string.match(id, '(%d+)') then
		if doesObjectExist(id) and edit_obj == nil then
			deleteObject(id)
			SCM('Вы успешно удалили объект с хендлом {FFCD00}' .. id .. '{ffffff}.')
		else
			SCM('Произошла ошибка при удалении объекта.')
		end
	else
		SCM('Используйте команду /del_obj [хендл объекта].')
	end
end

function command_ctext(param)
	if string.match(param, '(%S+) (%d+) (.+)') then
		local text, distance, color = string.match(param, '(.+) (%d+) (.+)')
		x, y, z = getCharCoordinates(PLAYER_PED)
		id = sampCreate3dText(text, color, x, y, z, distance, false, -1, -1)
		if sampIs3dTextDefined(id) and text_id == nil then
			SCM('Был создан 3D текст с ID {FFCD00}' ..id .. '{ffffff}.')
			SCM('Для редактирование 3D текста используйте стрелки на NumPad, Space (поднять), Alt (опустить).')
			SCM('Чтобы сохранить нажмите {FFCD00}ENTER{ffffff}, для удаления используйте команду /del_text [ид 3D текста].')
			text_x = x; text_y = y; text_z = z; text_distance = distance; text_color = color; text_text = text
			text_id = id
		else
			SCM('Произошла ошибка при создании 3D текста.')
		end
	else
		SCM('Используйте команду /add_text [текст] [дистанция] [цвет]')
	end
end

function command_etext(id)
	if string.match(id, '(%d+)') then
		if sampIs3dTextDefined(id) and text_id == nil then
			SCM('Вы начали редактировать #d текст с ID {FFCD00}' .. id .. '{ffffff}.')
			SCM('Для редактирование 3D текста используйте стрелки на NumPad, Space (поднять), Alt (опустить).')
			SCM('Чтобы сохранить нажмите {FFCD00}ENTER{ffffff}, для удаления используйте команду /del_text [ид 3D текста].')
			text, color, x, y, z, distance, _1, _2, _3 = sampGet3dTextInfoById(id)
			text_x = x; text_y = y; text_z = z; text_distance = distance; text_color = color; text_text = text
			text_id = id
		else
			SCM('Произошла ошибка при создании 3D текста.')
		end
	else
		SCM('Используйте команду /edit_text [ид 3D текста]')
	end
end

function command_dtext(id)
	if string.match(id, '(%d+)') then
		if sampIs3dTextDefined(id) and text_id == nil then
			sampDestroy3dText(id)
			SCM('Вы успешно удалили 3D текст с ID {FFCD00}' .. id .. '{ffffff}.')
		else
			SCM('Произошла ошибка при удалении 3D текста.')
		end
	else
		SCM('Используйте команду /del_text [ид 3D текста]')
	end
end

function command_setskin(param)
	if string.match(param, '(%d+) (%d+)') then
		id, skin = string.match(param, '(%d+) (%d+)')
		if IPC(id) then
			if sampGetDistance(PLAYER_PED, id) < 200 then
				local BS = raknetNewBitStream()
				raknetBitStreamWriteInt32(BS, id)
				raknetBitStreamWriteInt32(BS, skin)
				raknetEmulRpcReceiveBitStream(153, BS)
				raknetDeleteBitStream(BS)
				SCM('Вы установили визуальный скин ({FFCD00}' .. skin .. '{ffffff}) для игрока ' .. string.gsub(sampGetPlayerNickname(id),'_',' ') .. '[' .. id .. ']')
			else
				SCM('Данный игрок находится слишком далеко от Вас.')
			end
		else
			SCM('Данный игрок не подключён к серверу. Проверьте правильность введёного ID.')
		end
	else
		SCM('Используйте команду /skin [ид игрока] [ид скина].')
	end
end

function command_history(id)
	if string.match(id, '(%d+)') then
		if IPC(id) then
			sampSendChat('/history ' .. sampGetPlayerNickname(id))
		else
			SCM('Данный игрок не подключён к серверу. Проверьте правильность введёного ID.')
		end
	else
		SCM('Используйте команду /hist [ид игрока].')
	end
end

function command_setweather(id)
	if string.match(id, '(%d+)') then
		if tonumber(id) > 0 and tonumber(id) <= 45 then
			forceWeatherNow(id)
			SCM('Вы установили ID погоды {FFCD00}' .. id)
		else
			SCM('ID погоды не должен быть больше 45 и меньше 1.')
		end
	else
		SCM('Используйте команду /sw [ид погоды].')
	end
end

function command_settime(param)
	if string.match(param, '(%d+) (%d+)') then
		local hour, min = string.match(param, '(%d+) (%d+)')
		if tonumber(hour) >= 0 and tonumber(hour) <= 23 and tonumber(min) >= 0 and tonumber(min) < 60 then
			patch_samp_time_set(true)
			setTimeOfDay(hour, min)
			SCM('Вы установили время {FFCD00}' .. hour .. '{ffffff} часов, {FFCD00}' .. min .. '{ffffff} минут')
		else
			SCM('Часы не должны быть больше 23 и меньше 0. Минуты не должны быть больше 59 и меньше 0.')
		end
	else
		SCM('Используйте команду /st [часы] [минуты].')
	end
end

function command_ud()
	lua_thread.create(function()
		if ini.info.male then
			sampSendChat('/me достал удостоверение, открыл его и показал человеку напротив')
			wait(1500); sampSendChat('/do В удостоверение: ' .. ini.info.frac .. ', ' .. ini.info.rang .. ', ' .. ini.info.name .. '.')
			wait(1000); sampSendChat('/me закрыл удостоверение и убрал его обратно')

		else
			sampSendChat('/me достала удостоверение, открыла его и показала человеку напротив')
			wait(1500); sampSendChat('/do В удостоверение: ' .. ini.info.frac .. ', ' .. ini.info.rang .. ', ' .. ini.info.name .. '.')
			wait(1000); sampSendChat('/me закрыла удостоверение и убрала его обратно')
		end
	end)
end

function command_patrol(id)
	if string.match(id, '(%d+)') then
		local _, pid = sampGetPlayerIdByCharHandle(PLAYER_PED)
		local res, state, _ = sampGetPatrolState()
		if res then
			if tonumber(id) == 1 then
				sampSendChat('/r ' .. ini.info.rteg .. ' ' .. state .. '-' .. pid .. ' to DISP, начинаю патруль, 10-20 ' .. calculateZone() .. ' (' .. kvadrat() .. '), RFR.')
			elseif tonumber(id) == 2 then
				sampSendChat('/r ' .. ini.info.rteg .. ' ' .. state .. '-' .. pid .. ' to DISP, продолжаю патрулирование, 10-20 ' .. calculateZone() .. ' (' .. kvadrat() .. '), RFR.')
			elseif tonumber(id) == 3 then
				sampSendChat('/r ' .. ini.info.rteg .. ' ' .. state .. '-' .. pid .. ' to DISP, заканчиваю патруль, 10-20 ' .. calculateZone() .. ' (' .. kvadrat() .. '), nRFR.')
			else
				SCM('Данный ID состояние патруля неизвестен.')
			end
		else
			SCM('Вы не находитесь в патрульном автомобиле.')
		end
	else
		SCM('Используйте команду /patrol [ид патруля].')
	end
end

function command_pas(id)
	if string.match(id, '(%d+)') then
		if IPC(id) then
			if sampGetDistance(PLAYER_PED, id) < 5 then
				lua_thread.create(function()
					sampSendChat(sampGetHelloByTime() .. ', я ' .. ini.info.rang .. ' ' .. ini.info.name .. '.')
					wait(1000); sampSendChat('/do На груди висит значок с личным номером №000' .. ini.info.number .. '.')
					wait(1500); sampSendChat('Будьте любезны, предъявите документы, удостоверяющие вашу личность.')
					if ini.set.autopass then autopass = true end
				end)
			else
				SCM('Данный игрок находится слишком далеко от Вас.')
			end
		else
			SCM('Данный игрок не подключён к серверу. Проверьте правильность введёного ID.')
		end
	else
		SCM('Используйте команду /pas [ид игрока].')
	end
end

function command_search(id)
	if string.match(id, '(%d+)') then
		if IPC(id) then
			if sampGetDistance(PLAYER_PED, id) < 5 then
				lua_thread.create(function()
					if ini.info.male then
						sampSendChat('/me из внутреннего кармана достал белые, латекстные перчатки и одел их на руки')
					else
						sampSendChat('/me из внутреннего кармана достала белые, латекстные перчатки и одела их на руки')
					end
					wait(1500); sampSendChat('/me осмотривает все карманы, возможные места хранение запрещённых веществ и предметов')
					wait(1000); sampSendChat('/search ' .. id)
					idsearch = id
				end)
			else
				SCM('Данный игрок находится слишком далеко от Вас.')
			end
		else
			SCM('Данный игрок не подключён к серверу. Проверьте правильность введёного ID.')
		end
	else
		SCM('Используйте команду /search [ид игрока].')
	end
end

function command_epk(text)
	if not string.match(text, '(.+)') then SCM('Используйте команду /епк [текст]')
	else
		if text == 'list' then
			show_epk.v = not show_epk.v
		else
			fepk = 'moonloader\\helper\\epk.txt'
			for line in io.lines(fepk) do
				if line:find(text) then
					if string.len(line) < 115 then
						SCM(' ' .. string.sub(line, 0, 115))
						break
					end

					if string.len(line) >= 115 and string.len(line) < 230 then
						SCM(' ' .. string.sub(line, 0, 115) .. '..')
						SCM('.. ' .. string.sub(line, 115, 230))
						break
					end

					if string.len(line) >= 230 and string.len(line) < 345 then
						SCM(' ' .. string.sub(line, 0, 115) .. '..')
						SCM('.. ' .. string.sub(line, 115, 230) .. '..')
						SCM('.. ' .. string.sub(line, 230, 345))
						break
					end

					if string.len(line) > 345 then
						SCM(' ' .. string.sub(line, 0, 115) .. '..')
						SCM('.. ' .. string.sub(line, 115, 230) .. '..')
						SCM('.. ' .. string.sub(line, 230, 345))
						SCM('.. ' .. string.sub(line, 345, string.len(line)))
						break
					end
				end
			end
		end
	end
end

function command_ustav(text)
	if not string.match(text, '(.+)') then SCM('Используйте команду /устав [текст]')
	else
		if text == 'list' then
			show_ustav.v = not show_ustav.v
		else
			fepk = 'moonloader\\helper\\ustav.txt'
			for line in io.lines(fepk) do
				if line:find(text) then
					if string.len(line) < 115 then
						SCM(' ' .. string.sub(line, 0, 115))
						break
					end

					if string.len(line) >= 115 and string.len(line) < 230 then
						SCM(' ' .. string.sub(line, 0, 115) .. '..')
						SCM('.. ' .. string.sub(line, 115, 230))
						break
					end

					if string.len(line) >= 230 and string.len(line) < 345 then
						SCM(' ' .. string.sub(line, 0, 115) .. '..')
						SCM('.. ' .. string.sub(line, 115, 230) .. '..')
						SCM('.. ' .. string.sub(line, 230, 345))
						break
					end

					if string.len(line) > 345 then
						SCM(' ' .. string.sub(line, 0, 115) .. '..')
						SCM('.. ' .. string.sub(line, 115, 230) .. '..')
						SCM('.. ' .. string.sub(line, 230, 345))
						SCM('.. ' .. string.sub(line, 345, string.len(line)))
						break
					end
				end
			end
		end
	end
end

function command_hack(id)
	if string.match(id, '(%d+)') then
		lua_thread.create(function()
			if ini.info.male then
				sampSendChat('/do На плечах висит рюкзак в котором лежит балончик с заморозкой.')
				wait(1500); sampSendChat('/me скинув рюкзак с плеч, открыл его и достал балончик')
				wait(1500); sampSendChat('/me закрыл рюкзак и повесил его на плечи')
				wait(1500); sampSendChat('/me встряхнув балончик, распылил содержимое на дверной замок')
				wait(1500); sampSendChat('/do Под действием содержимого балончика замок промёрз и стал хрупок.')
				wait(1500); sampSendChat('/me снял дубинку с поясного держателя и, размахнувшись, ударил тыльной частью по замку')
			else
				sampSendChat('/do На плечах висит рюкзак в котором лежит балончик с заморозкой.')
				wait(1500); sampSendChat('/me скинув рюкзак с плеч, открыла его и достала балончик')
				wait(1500); sampSendChat('/me закрыла рюкзак и повесила его на плечи')
				wait(1500); sampSendChat('/me встряхнув балончик, распылила содержимое на дверной замок')
				wait(1500); sampSendChat('/do Под действием содержимого балончика замок промёрз и стал хрупок.')
				wait(1500); sampSendChat('/me сняла дубинку с поясного держателя и, размахнувшись, ударила тыльной частью по замку')
			end
			wait(1000); sampSendChat('/hack ' .. id)
		end)
	else
		SCM('Используйте команду /hack [ид дома]')
	end
end

function command_invite(param)
	if string.match(param, '(%d+) (%d+)') then
		inv_id, inv_rang = string.match(param, '(%d+) (%d+)')
		if IPC(id) then
			if sampGetDistance(PLAYER_PED, inv_id) < 3 then
				lua_thread.create(function()
					if ini.info.male then
						sampSendChat('/me из внутреннего кармана достал планшет и включил его')
						wait(1500); sampSendChat('/me зайдя в базу данных МВД, добавил новое личное дело ' .. string.gsub(sampGetPlayerNickname(inv_id),'_',' ') .. '')
						wait(1500); sampSendChat('/me потушил экран планшета и убрал его обратно')
						wait(1500); sampSendChat('/me достал ключ от шкафчика под номером ' .. inv_id .. ' и передал его ' .. string.gsub(sampGetPlayerNickname(inv_id),'_',' '))
					else
						sampSendChat('/me из внутреннего кармана достала планшет и включила его')
						wait(1500); sampSendChat('/me зайдя в базу данных МВД, добавила новое личное дело ' .. string.gsub(sampGetPlayerNickname(inv_id),'_',' ') .. '')
						wait(1500); sampSendChat('/me потушила экран планшета и убрала его обратно')
						wait(1500); sampSendChat('/me достала ключ от шкафчика под номером ' .. inv_id .. ' и передала его ' .. string.gsub(sampGetPlayerNickname(inv_id),'_',' '))
					end
					wait(1000); sampSendChat('/invite ' .. inv_id)
				end)
			else
				SCM('Данный игрок находится слишком далеко от Вас.')
			end
		else
			SCM('Данный игрок не подключён к серверу. Проверьте правильность введёного ID.')
		end
	else
		SCM('Используйте команду /invite [ид игрока] [ранг].')
	end
end

function command_uninvite(param)
	if string.match(param, '(%d+) (%S+)') then
		local id, reason = string.match(param, '(%d+) (.+)')
		if IPC(id) then
			lua_thread.create(function()
				if ini.info.male then
					sampSendChat('/me из внутреннего кармана достал планшет и включил его')
					wait(1500); sampSendChat('/me зайдя в базу данных МВД, удалил личное дело ' .. string.gsub(sampGetPlayerNickname(id),'_',' ') .. '')
					wait(1000); sampSendChat('/uninvite ' .. id .. ' ' .. reason)
					wait(1500); sampSendChat('/me потушил экран планшета и убрал его обратно')
				else
					sampSendChat('/me из внутреннего кармана достала планшет и включила его')
					wait(1500); sampSendChat('/me зайдя в базу данных МВД, удалила личное дело ' .. string.gsub(sampGetPlayerNickname(id),'_',' ') .. '')
					wait(1000); sampSendChat('/uninvite ' .. id .. ' ' .. reason)
					wait(1500); sampSendChat('/me потушила экран планшета и убрала его обратно')
				end
				wait(1000); sampSendChat('/r ' .. ini.info.rteg .. ' Сотрудник ' .. string.gsub(sampGetPlayerNickname(id),'_',' ') .. ' уволен по причине: ' .. reason)
			end)
		else
			SCM('Данный игрок не подключён к серверу. Проверьте правильность введёного ID.')
		end
	else
		SCM('Используйте команду /uninvite [ид игрока] [причина].')
	end
end

function command_follow()
	lua_thread.create(function()
		if follow_state then
			if ini.info.male then
				sampSendChat('/me достал планшет, перешёл в базу данных и выбрал пункт с настройкой радио-канала')
				wait(1000); sampSendChat('/follow')
				wait(1500); sampSendChat('/me отключился от внутреннего радио-канала, снял наушники и убрал их')
				wait(1500); sampSendChat('/me потушил экран планшета, убрал его обратно')
			else
				sampSendChat('/me достала планшет, перешла в базу данных и выбрала пункт с настройкой радио-канала')
				wait(1000); sampSendChat('/follow')
				wait(1500); sampSendChat('/me отключилась от внутреннего радио-канала, сняла наушники и убрала их')
				wait(1500); sampSendChat('/me потушила экран планшета, убрала его обратно')
			end
		else
			if ini.info.male then
				sampSendChat('/me достал планшет, перешёл в базу данных МВД и выбрал пункт с настройкой радио-канала')
				wait(1500); sampSendChat('/me ввёл необходимые параметры для подключенния к внутреннему радио-каналу')
				wait(1500); sampSendChat('/me достал наушники, параллельно заполнив нужную форму получения радио-сигналов')
				wait(1000); sampSendChat('/follow')
				wait(1500); sampSendChat('/me одел наушники, проверил звук, потушил экран планшета и убрал его')
			else
				sampSendChat('/me достала планшет, перешла в базу данных МВД и выбрала пункт с настройкой радио-канала')
				wait(1500); sampSendChat('/me ввела необходимые параметры для подключенния к внутреннему радио-каналу')
				wait(1500); sampSendChat('/me достала наушники, параллельно заполнив нужную форму получения радио-сигналов')
				wait(1000); sampSendChat('/follow')
				wait(1500); sampSendChat('/me одела наушники, проверила звук, потушила экран планшета и убрала его')
			end
		end
	end)
	follow_state = not follow_state
end

function command_rang(param)
	if string.match(param, '(%d+) [+?-]') then
		local id, rang = string.match(param, '(%d+) (.+)')
		if IPC(id) then
			if sampGetDistance(PLAYER_PED, id) < 3 then
				lua_thread.create(function()
					if ini.info.male then
						sampSendChat('/me из внутреннего кармана достал планшет и включил его')
						wait(1500); sampSendChat('/me зайдя в базу данных МВД, изменил должность ' .. string.gsub(sampGetPlayerNickname(id),'_',' ') .. '')
						wait(1000); sampSendChat('/rang ' .. id .. ' ' .. rang)
						wait(1500); sampSendChat('/me потушил экран планшета и убрал его обратно')
					else
						sampSendChat('/me из внутреннего кармана достала планшет и включила его')
						wait(1500); sampSendChat('/me зайдя в базу данных МВД, изменила должность ' .. string.gsub(sampGetPlayerNickname(id),'_',' ') .. '')
						wait(1000); sampSendChat('/rang ' .. id .. ' ' .. rang)
						wait(1500); sampSendChat('/me потушила экран планшета и убрала его обратно')
					end
				end)
			else
				SCM('Данный игрок находится слишком далеко от Вас.')
			end
		else
			SCM('Данный игрок не подключён к серверу. Проверьте правильность введёного ID.')
		end
	else
		SCM('Используйте команду /rang [ид игрока] [+ или -].')
	end
end

function command_changeskin(id)
	if string.match(id, '(%d+)') then
		if IPC(id) then
			if sampGetDistance(PLAYER_PED, id) < 3 then
				lua_thread.create(function()
					if ini.info.male then
						sampSendChat('/me достал ключ от шкафчика под номером ' .. id .. ' и передал его ' .. string.gsub(sampGetPlayerNickname(id),'_',' '))
					else
						sampSendChat('/me достала ключ от шкафчика под номером ' .. id .. ' и передала его ' .. string.gsub(sampGetPlayerNickname(id),'_',' '))
					end
					wait(1000); sampSendChat('/changeskin ' .. id)
				end)
			else
				SCM('Данный игрок находится слишком далеко от Вас.')
			end
		else
			SCM('Данный игрок не подключён к серверу. Проверьте правильность введёного ID.')
		end
	else
		SCM('Используйте команду /changeskin [ид игрока].')
	end
end

function command_cuff(id)
	if string.match(id, '(%d+)') then
		if IPC(id) then
			if sampGetDistance(PLAYER_PED, id) < 3 then
				lua_thread.create(function()
					if ini.info.male then
						sampSendChat('/me завёл руки нарушителя за спину, после чего растягнул чехол для наручников'); wait(1500)
						sampSendChat('/me достав наручники из чехла, застегнул их на запястьях преступника')
					else
						sampSendChat('/me завела руки нарушителя за спину, после чего растягнула чехол для наручников'); wait(1500)
						sampSendChat('/me достав наручники из чехла, застегнула их на запястьях преступника')
					end
					wait(1000); sampSendChat('/cuff ' .. id)
				end)
			else
				SCM('Данный игрок находится слишком далеко от Вас.')
			end
		else
			SCM('Данный игрок не подключён к серверу. Проверьте правильность введёного ID.')
		end
	else
		SCM('Используйте команду /cuff [ид игрока].')
	end
end

function command_uncuff(id)
	if string.match(id, '(%d+)') then
		if IPC(id) then
			if sampGetDistance(PLAYER_PED, id) < 3 then
				lua_thread.create(function()
					sampSendChat('/do На запястьях ' .. string.gsub(sampGetPlayerNickname(id),'_',' ') .. ' находятся наручники.'); wait(1500)
					if ini.info.male then
						sampSendChat('/me сняв с пояса связку ключей, провернул один из них в замке наручников'); wait(1000)
						sampSendChat('/uncuff ' .. id); wait(1500)
						sampSendChat('/me убрав наручники в чехол, повесил связку ключей на пояс')
					else
						sampSendChat('/me сняв с пояса связку ключей, провернула один из них в замке наручников'); wait(1000)
						sampSendChat('/uncuff ' .. id); wait(1500)
						sampSendChat('/me убрав наручники в чехол, повесила связку ключей на пояс')
					end
				end)
			else
				SCM('Данный игрок находится слишком далеко от Вас.')
			end
		else
			SCM('Данный игрок не подключён к серверу. Проверьте правильность введёного ID.')
		end
	else
		SCM('Используйте команду /uncuff [ид игрока].')
	end
end

function command_skip(id)
	if string.match(id, '(%d+)') then
		if IPC(id) then
			if sampGetDistance(PLAYER_PED, id) < 5 then
				lua_thread.create(function()
					if ini.info.male then
						sampSendChat('/me из внутреннего кармана достал планшет и включил его')
						wait(1500); sampSendChat('/me зайдя в базу данных МВД, оформил временный пропуск на имя ' .. string.gsub(sampGetPlayerNickname(id),'_',' ') .. '')
						wait(1000); sampSendChat('/skip ' .. id)
						wait(1500); sampSendChat('/me потушил экран планшета и убрал его обратно')
						wait(1000); sampSendChat('/r ' .. ini.info.rteg .. ' Оформил временный пропуск на имя ' .. string.gsub(sampGetPlayerNickname(id),'_',' ') .. '.')
					else
						sampSendChat('/me из внутреннего кармана достала планшет и включила его')
						wait(1500); sampSendChat('/me зайдя в базу данных МВД, оформила временный пропуск на имя ' .. string.gsub(sampGetPlayerNickname(id),'_',' ') .. '')
						wait(1000); sampSendChat('/skip ' .. id)
						wait(1500); sampSendChat('/me потушила экран планшета и убрала его обратно')
						wait(1000); sampSendChat('/r ' .. ini.info.rteg .. ' Оформила временный пропуск на имя ' .. string.gsub(sampGetPlayerNickname(id),'_',' ') .. '.')
					end
				end)
			else
				SCM('Данный игрок находится слишком далеко от Вас.')
			end
		else
			SCM('Данный игрок не подключён к серверу. Проверьте правильность введёного ID.')
		end
	else
		SCM('Используйте команду /skip [ид игрока].')
	end
end

function command_clear(param)
	if string.match(param, '(%d+) (%S+)') then
		local id, reason = string.match(param, '(%d+) (.+)')
		if IPC(id) then
			if sampGetDistance(PLAYER_PED, id) < 10 then
				lua_thread.create(function()
					if ini.info.male then
						sampSendChat('/me достав планшет, зашёл в базу данных МВД и нашёл нужное дело')
						wait(1500); sampSendChat('/me пролистав страницу в самый низ, выбрал пункт с закрытием дела')
						wait(1000); sampSendChat('/clear ' .. id)
						wait(1500); sampSendChat('/f ' .. ini.info.fteg .. ' Дело №' .. id .. ' (' .. string.gsub(sampGetPlayerNickname(id),'_',' ') .. ') закрыто. Причина: ' .. reason .. '')
						wait(1500); sampSendChat('/me потушил экран планшета и убрал его обратно')
					else
						sampSendChat('/me достав планшет, зашла в базу данных МВД и нашла нужное дело')
						wait(1500); sampSendChat('/me пролистав страницу в самый низ, выбрала пункт с закрытием дела')
						wait(1000); sampSendChat('/clear ' .. id)
						wait(1500); sampSendChat('/f ' .. ini.info.fteg .. ' Дело №' .. id .. ' (' .. string.gsub(sampGetPlayerNickname(id),'_',' ') .. ') закрыто. Причина: ' .. reason .. '')
						wait(1500); sampSendChat('/me потушила экран планшета и убрала его обратно')
					end
				end)
			else
				SCM('Данный игрок находится слишком далеко от Вас.')
			end
		else
			SCM('Данный игрок не подключён к серверу. Проверьте правильность введёного ID.')
		end
	else
		SCM('Используйте команду /clear [ид игрока] [причина].')
	end
end

function command_putpl(id)
	if string.match(id, '(%d+)') then
		if IPC(id) then
			if sampGetDistance(PLAYER_PED, id) < 4 then
				lua_thread.create(function()
					if ini.info.male then
						sampSendChat('/me подведя подозреваемого к автомобилю, открыл дверь и посадил его туда')
					else
						sampSendChat('/me подведя подозреваемого к автомобилю, открыла дверь и посадила его туда')
					end
					wait(1000); sampSendChat('/putpl ' .. id)
				end)
			else
				SCM('Данный игрок находится слишком далеко от Вас.')
			end
		else
			SCM('Данный игрок не подключён к серверу. Проверьте правильность введёного ID.')
		end
	else
		SCM('Используйте команду /putpl [ид игрока].')
	end
end

function command_hold(id)
	if string.match(id, '(%d+)') then
		if IPC(id) then
			if sampGetDistance(PLAYER_PED, id) < 3 then
				lua_thread.create(function()
					if ini.info.male then
						sampSendChat('/me заломав руку подозреваемого, повёл его за собой')
					else
						sampSendChat('/me заломав руку подозреваемого, повела его за собой')
					end
					wait(1000); sampSendChat('/hold ' .. id)
					wait(1000); sampSendChat('/n При багоюзе (нажатие G) тебя кикнет и ты попадёшь в КПЗ.')
				end)
			else
				SCM('Данный игрок находится слишком далеко от Вас.')
			end
		else
			SCM('Данный игрок не подключён к серверу. Проверьте правильность введёного ID.')
		end
	else
		SCM('Используйте команду /hold [ид игрока].')
	end
end

function command_ticket(param)
	if string.match(param, '(%d+) (%d+) (%S+)') then
		local id, money, reason = string.match(param, '(%d+) (%d+) (.+)')
		if IPC(id) then
			if sampGetDistance(PLAYER_PED, id) < 5 then
				lua_thread.create(function()
					if ini.info.male then
						sampSendChat('/me достал блокнот, ручку и начал записывать информацию о нарушении')
						wait(1500); sampSendChat('/me заполнив всю информацию о нарушении, передал бланк нарушителю')
						wait(1000); sampSendChat('/ticket ' .. id .. ' ' .. money .. ' ' .. reason)
						wait(1500); sampSendChat('/me убрал блокнот и ручку обратно во внутренний карман')
					else
						sampSendChat('/me достала блокнот, ручку и начала записывать информацию о нарушении')
						wait(1500); sampSendChat('/me заполнив всю информацию о нарушении, передала бланк нарушителю')
						wait(1000); sampSendChat('/ticket ' .. id .. ' ' .. money .. ' ' .. reason)
						wait(1500); sampSendChat('/me убрала блокнот и ручку обратно во внутренний карман')
					end
				end)
			else
				SCM('Данный игрок находится слишком далеко от Вас.')
			end
		else
			SCM('Вы ввели неверный ид игрока (игрок не авторизован)')
		end
	else
		SCM('Используйте команду /ticket [ид игрока] [сумма] [причина]')
	end
end

function command_takelic(param)
	if string.match(param, '(%d+) (%S+)') then
		local id, reason = string.match(param, '(%d+) (.+)')
		if IPC(id) then
			if sampGetDistance(PLAYER_PED, id) < 15 then
				lua_thread.create(function()
					if ini.info.male then
						sampSendChat('/me достал планшет, зашёл в базу данных МВД и ввёл номер Т/С')
						wait(1500); sampSendChat('/me получив информацию о водителе, изъял его лицензию на вождение')
					else
						sampSendChat('/me достала планшет, зашла в базу данных МВД и ввела номер Т/С')
						wait(1500); sampSendChat('/me получив информацию о водителе, изъяла его лицензию на вождение')
					end
					wait(1000); sampSendChat('/takelic ' .. id .. ' ' .. reason)
				end)
			else
				SCM('Данный игрок находится слишком далеко от Вас.')
			end
		else
			SCM('Вы ввели неверный ид игрока (игрок не авторизован)')
		end
	else
		SCM('Используйте команду /takelic [ид игрока] [причина]')
	end
end

function command_pull(id)
	if string.match(id, '(%d+)') then
		if IPC(id) then
			if sampGetDistance(PLAYER_PED, id) < 3 then
				res, vid = sampIsPlayerCar(id)
				if res then
					lua_thread.create(function()
						if tCarsType[vid - 399] == 2 or tCarsType[vid - 399] == 9 then
							if ini.info.male then
								sampSendChat('/me подойдя к подозреваемому, толкнул его, тем самым скинул его с байка')
								wait(1000); sampSendChat('/pull ' .. id)
							else
								sampSendChat('/me подойдя к подозреваемому, толкнула его, тем самым скинула его с байка')
								wait(1000); sampSendChat('/pull ' .. id)
							end
						else
							if ini.info.male then
								sampSendChat('/me сняв дубинку с пояса, ударил её тыльную частью по стеклу')
								wait(1500); sampSendChat('/me повесив дубинку на пояс, просунул руку в стекло и открыл дверь')
								wait(1500); sampSendChat('/me взявшись за подозреваемого, вытащил его из машины')
								wait(1000); sampSendChat('/pull ' .. id)
							else
								sampSendChat('/me сняв дубинку с пояса, ударила её тыльную частью по стеклу')
								wait(1500); sampSendChat('/me повесив дубинку на пояс, просунула руку в стекло и открыла дверь')
								wait(1500); sampSendChat('/me взявшись за подозреваемого, вытащила его из машины')
								wait(1000); sampSendChat('/pull ' .. id)
							end
						end
					end)
				else
					SCM('Данный игрок не находится в автомобиле.')
				end
			else
				SCM('Данный игрок находится слишком далеко от Вас.')
			end
		else
			SCM('Данный игрок не подключён к серверу. Проверьте правильность введёного ID.')
		end
	else
		SCM('Используйте команду /pull [ид игрока].')
	end
end

function command_arrest(id)
	if string.match(id, '(%d+)') then
		if IPC(id) then
			if sampGetDistance(PLAYER_PED, id) < 5 then
				if sampIsPlayerCarHaveSuspect(id) then
					lua_thread.create(function()
						if ini.info.male then
							sampSendChat('/me включил бортовой компьютер и заполнил информацию о нарушителе'); wait(1500)
							sampSendChat('/me снял рацию с плеча, поднёс её ко рту и что-то произнёс'); wait(1000)
							sampSendChat('/r ' .. ini.info.rteg .. ' Подозреваемый по делу №' .. id .. ' (' .. string.gsub(sampGetPlayerNickname(id),'_',' ') .. ') передан в департамент.'); wait(1000)
							sampSendChat('/arrest ' .. id); wait(1500)
							sampSendChat('/do Из департамента вышли два офицера и увели подозреваемого с собой.')
						else
							sampSendChat('/me включила бортовой компьютер и заполнила информацию о нарушителе'); wait(1500)
							sampSendChat('/me сняла рацию с плеча, поднесла её ко рту и что-то произнесла'); wait(1000)
							sampSendChat('/r ' .. ini.info.rteg .. ' Подозреваемый по делу №' .. id .. ' (' .. string.gsub(sampGetPlayerNickname(id),'_',' ') .. ') передан в департамент.'); wait(1000)
							sampSendChat('/arrest ' .. id); wait(1500)
							sampSendChat('/do Из департамента вышли два офицера и увели подозреваемого с собой.')
						end
					end)
				else
					SCM('В вашей машине не находится данный игрок.')
				end
			else
				SCM('Данный игрок находится слишком далеко от Вас.')
			end
		else
			SCM('Данный игрок не подключён к серверу. Проверьте правильность введёного ID.')
		end
	else
		SCM('Используйте команду /arrest [ид игрока].')
	end
end

function command_su(param)
	if string.match(param, '(%d+) (%d+) (%S+)') then
		local id, stars, reason = string.match(param, '(%d+) (%d+) (.+)')
		if IPC(id) then
			if sampGetDistance(PLAYER_PED, id) < 70 then
				lua_thread.create(function()
					if ini.info.male then
						sampSendChat('/me сняв рацию с плеча, передал диспетчеру информацию о подозреваемом')
						wait(1000)
					else
						sampSendChat('/me сняв рацию с плеча, передала диспетчеру информацию о подозреваемом')
						wait(1000)
					end
					sampSendChat('/su ' .. id .. ' ' .. stars .. ' ' .. reason)
					wait(1500)
					sampSendChat('/do ' .. string.gsub(sampGetPlayerNickname(id),'_',' ') .. ' был объявлен в розыск по причине: ' .. reason .. '.')
				end)
			else
				SCM('Данный игрок находится слишком далеко от Вас.')
			end
		else
			SCM('Вы ввели неверный ид игрока (игрок не авторизован)')
		end
	else
		SCM('Используйте команду /su [ид игрока] [кол-во звёзд] [причина]')
	end
end

function command_admins()
	dline = 'Имя\tДолжность\tДополнительно\n'
	local all = 0
	local online = 0
	
	for line in io.lines('moonloader\\helper\\Admins.txt') do
		all = all + 1
		local name, rang, nrang = string.match(line, '(.+) | (.+) | (.+)')
		local id = sampGetPlayerIdByNickname(name)
		if id == 'offline' then
			dline = string.format('%s{696969}%s\t{696969}%s ранг. %s\t{ff5c33}Оффлайн\n', dline, name, nrang, rang)
		else
			res, ped = sampGetCharHandleBySampPlayerId(id)
			online = online + 1
			if res then
				dist = math.floor(sampGetDistance(PLAYER_PED, id))
				if sampIsPlayerPaused(id) then
					dline = string.format('%s{%s}%s[%d]\t%s ранг. %s\t{ff5c33}Дист: %d м\n', dline, sampGetColor(id), name, id, nrang, rang, dist)
				else
					dline = string.format('%s{%s}%s[%d]\t%s ранг. %s\t{00cc99}Дист: %d м\n', dline, sampGetColor(id), name, id, nrang, rang, dist)
				end
			else
				dline = string.format('%s{%s}%s[%d]\t%s ранг. %s\t{00cc99}Онлайн\n', dline, sampGetColor(id), name, id, nrang, rang)
			end
		end
	end
	caption = string.format('{ffffff}Всего администраторов {FFCD00}%d чел. {00CC66}(онлайн %d)', all, online)
	sampShowDialog(1000, caption, dline, 'Закрыть', '', 5)
end

function imgui.OnDrawFrame()
	if show_menu.v then
		imgui.SetNextWindowSize(imgui.ImVec2(600, 500))
		imgui.Begin(u8'ОСНОВНОЕ МЕНЮ | HELPER FOR MIA', nil, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			if imgui.Button(u8'Настройки', imgui.ImVec2(140, 20)) then show_item.v = 0 end
			imgui.SameLine()
			if imgui.Button(u8'Администрация', imgui.ImVec2(145, 20)) then show_item.v = 1 end
			imgui.SameLine()
			if imgui.Button(u8'Информация', imgui.ImVec2(145, 20)) then show_item.v = 2 end
			imgui.SameLine()
			if imgui.Button(u8'Доп.команды', imgui.ImVec2(140, 20)) then show_item.v = 3 end

			imgui.Text('')

			if show_item.v == 0 then
				imgui.BeginChild('##information_rp', imgui.ImVec2(290, 410), true, imgui.WindowFlags.VerticalScrollbar)
					imgui.PushItemWidth(140)
					imgui.Text(u8'        Имя и фамилия             Личный номер')
					if imgui.InputText('##set_name', pname) then ini.info.name = u8:decode(pname.v); inicfg.save(ini) end
					ItemActive('Текущее значение вашего имени и фамилии: ' .. ini.info.name)
					imgui.SameLine()
					if imgui.InputText('##set_number', pnumber) then ini.info.number = u8:decode(pnumber.v); inicfg.save(ini) end
					ItemActive('Текущее значение вашего личного номера: №000' .. ini.info.number)

					imgui.Text(u8'           Должность                 Подразделение')
					if imgui.InputText('##set_rang', prang) then ini.info.rang = u8:decode(prang.v); inicfg.save(ini) end
					ItemActive('Текущее значение вашей должности: ' .. ini.info.rang)
					imgui.SameLine()
					if imgui.InputText('##set_frac', pfrac) then ini.info.frac = u8:decode(pfrac.v); inicfg.save(ini) end
					ItemActive('Текущее значение вашего подразделения: ' .. ini.info.frac)

					imgui.Text(u8'       Префикс рации               Доп. префикс')
					if imgui.InputText('##set_rteg', rteg) then ini.info.rteg = u8:decode(rteg.v); inicfg.save(ini) end
					ItemActive('Текущее значение вашего префикса в рацию: ' .. ini.info.rteg)
					imgui.SameLine()
					if imgui.InputText('##set_fteg', fteg) then ini.info.fteg = u8:decode(fteg.v); inicfg.save(ini) end
					ItemActive('Текущее значение вашего префикса в общую волну: ' .. ini.info.fteg)
					imgui.Text('')
					if imgui.Checkbox(u8'Мужской', male) then
						if male.v then female.v = false else female.v = true end
						ini.info.male = male.v
						ini.info.female = female.v
						inicfg.save(ini)
					end
					imgui.SameLine()
					if imgui.Checkbox(u8'Женский', female) then
						if female.v then male.v = false else male.v = true end
						ini.info.male = male.v
						ini.info.female = female.v
						inicfg.save(ini)
					end
				imgui.EndChild()

				imgui.SameLine()

				imgui.BeginChild('##information_another', imgui.ImVec2(290, 410), true, imgui.WindowFlags.VerticalScrollbar)
					if imgui.Checkbox(u8'Объявления от СМИ', pstopad) then ini.set.stopad = pstopad.v; inicfg.save(ini) end
					if imgui.Checkbox(u8'Стробоскопы', pstrobes) then ini.set.strobes = pstrobes.v; inicfg.save(ini) end
					if imgui.Checkbox(u8'Изменённая рация', pradio) then ini.set.radio = pradio.v; inicfg.save(ini) end
					if imgui.Checkbox(u8'Авто-проверка паспорта', pautopass) then ini.set.autopass = pautopass.v; inicfg.save(ini) end
					if imgui.Checkbox(u8'Анти-взлом дома FBI', pantifbi) then ini.set.antifbi = pantifbi.v; inicfg.save(ini) end
					if imgui.Checkbox(u8'Авто-взятие оружия', pautoweapon) then ini.set.autoweapon = pautoweapon.v; inicfg.save(ini) end
					if pautoweapon.v then
						if imgui.Button(u8'Настроить авто-взятие оружия') then
							show_weapon.v = not show_weapon.v
						end
					end
					if imgui.Checkbox(u8'Снайперская винтовка в PD', psniperpd) then ini.set.sniperpd = psniperpd.v; inicfg.save(ini) end
					if imgui.Checkbox(u8'Улучшенный список лидеров', pupleader) then ini.set.upleader = pupleader.v; inicfg.save(ini) end
					if imgui.Checkbox(u8'Отыгровки оружия', pweapon) then ini.set.weapon = pweapon.v; inicfg.save(ini) end
					if imgui.Checkbox(u8'Отыгровка камеры', pcamera) then ini.set.camera = pcamera.v; inicfg.save(ini) end
				imgui.EndChild()
			elseif show_item.v == 1 then
				imgui.BeginChild('##admin_settings', imgui.ImVec2(380, 410), true, imgui.WindowFlags.VerticalScrollbar)
					if editor.v then
						imgui.PushItemWidth(385)
						imgui.InputTextMultiline('##admins', admins, imgui.ImVec2(-1, imgui.GetTextLineHeight() * 28))
					else
						imgui.Text(admins.v)
					end
				imgui.EndChild()

				imgui.SameLine()

				imgui.BeginChild('##admin_button', imgui.ImVec2(200, 410), true, imgui.WindowFlags.VerticalScrollbar)
					if imgui.Button(u8'Подгрузить', imgui.ImVec2(190, 20)) then
						d = ''
						for i in io.lines('moonloader//helper//Admins.txt') do d = d .. i .. '\n' end
						admins.v = u8(d)
					end
				  if imgui.Button(u8'Редактировать', imgui.ImVec2(190, 20)) then editor.v = not editor.v end
					if imgui.Button(u8'Сохранить', imgui.ImVec2(190, 20)) then
						local filew = io.open('moonloader//helper//Admins.txt', 'w')
						filew:write(u8:decode(admins.v))
						filew:close()
					end
				imgui.EndChild()
				
			elseif show_item.v == 2 then
				imgui.BeginChild('##command_info', imgui.ImVec2(585, 410), true, imgui.WindowFlags.VerticalScrollbar)
					imgui.Columns(2)
					imgui.SetColumnWidth(-1, 150)
					imgui.Text(u8'КОМАНДА') 
					imgui.NextColumn()
					imgui.SetColumnWidth(-1, 400)
					imgui.Text(u8'ОПИСАНИЕ')
					imgui.Separator()
					for i, val in pairs(commands) do
						local cmd, info = string.match(val, '(.+) | (.+)')
						imgui.NextColumn()
						imgui.Text(string.format('%s', u8(cmd)))
						imgui.NextColumn()
						imgui.Text(string.format('%s', u8(info)))
						imgui.Separator()
					end
				imgui.EndChild()
				
			elseif show_item.v == 3 then
				imgui.BeginChild('##command_settings', imgui.ImVec2(585, 410), true, imgui.WindowFlags.VerticalScrollbar)
					imgui.Text(u8'Команда: /')
					imgui.SameLine()
					imgui.PushItemWidth(130)
					imgui.InputText('', name_cmd)
					imgui.SameLine()
					if imgui.Button(u8'+', imgui.ImVec2(20, 20)) then
						if param_cmd < 1 then param_cmd = param_cmd + 1 end
					end
					ItemActive('Кол-во параметров в команде ' .. param_cmd .. '/1')
					imgui.SameLine()
					if imgui.Button(u8'-', imgui.ImVec2(20, 20)) then
						if param_cmd > 0 then param_cmd = param_cmd - 1 end
					end
					ItemActive('Кол-во параметров в команде ' .. param_cmd .. '/1')
					imgui.SameLine()
					if imgui.Button(u8'Найти') then
						if name_cmd.v ~= '' then
							if io.open('moonloader//helper//commands//' .. name_cmd.v .. '.txt') then
								cmd_text = ''
								for line in io.lines('moonloader//helper//commands//' .. name_cmd.v .. '.txt') do
									if string.match(line, '{param = (%d+)}') then
										param_cmd = tonumber(string.match(line, '{param = (%d+)}'))
									else
										cmd_text = cmd_text .. u8(line) .. '\n'
									end
								end
								text_cmd.v = cmd_text
							end
						end
					end
					imgui.SameLine()
					if imgui.Button(u8'Создать') then
						if name_cmd.v ~= '' and not string.match(name_cmd.v, '[(%s+)]') then
							if not io.open('moonloader//helper//commands//' .. name_cmd.v .. '.txt') then
								local file = 'moonloader//helper//commands//' .. name_cmd.v .. '.txt'
								local filew = io.open(file, 'w')
								filew:write('Файл создан')
								filew:close()
								cmd_text = ''
								for line in io.lines('moonloader//helper//commands//' .. name_cmd.v .. '.txt') do
									if string.match(line, '{param = (%d+)}') then
										param_cmd = tonumber(string.match(line, '{param = (%d+)}'))
									else
										cmd_text = cmd_text .. u8(line) .. '\n'
									end
								end
								text_cmd.v = cmd_text
							end
						end
					end
					imgui.SameLine()
					if imgui.Button(u8'Сохранить') then
						if name_cmd.v ~= '' and not string.match(name_cmd.v, '[(%s+)]') then
							if io.open('moonloader//helper//commands//' .. name_cmd.v .. '.txt') then
								local file = 'moonloader//helper//commands//' .. name_cmd.v .. '.txt'
								local filew = io.open(file, 'w')
								local save_text = '{param = ' .. param_cmd .. '}\n' .. text_cmd.v
								filew:write(u8:decode(save_text))
								filew:close()
							end
						end
					end
					imgui.SameLine()
					if imgui.Button(u8'Функции') then
						show_help.v = not show_help.v
					end
					imgui.SameLine()
					if imgui.Button(u8'Очистить') then
						text_cmd.v = ''
						name_cmd.v = ''
						param_cmd = 0
					end
					imgui.InputTextMultiline('##TextForCmd', text_cmd, imgui.ImVec2(-1, imgui.GetTextLineHeight() * 14))
					if imgui.Button(u8'Пример #1') then
						name_cmd.v = 'show1'
						param_cmd = 1
						text_cmd.v = u8'text: {hello}, {name_id}, вы находитесь в федеральном розыске!'
					end
					imgui.SameLine()
					if imgui.Button(u8'Пример #2') then
						name_cmd.v = 'show2'
						param_cmd = 0
						text_cmd.v = u8'text: /r [Оповещение] {rang} находится в опасности! 10-20 {area} ({kvadrat}).\nsleep: 1000\ntext: /su {myid} 1 GPS-on'
					end
					imgui.SameLine()
					if imgui.Button(u8'Пример #3') then
						name_cmd.v = 'show3'
						param_cmd = 0
						text_cmd.v = u8'send: Текущее время: {time}\nsend: Текущая дата: {date}\nsend: Как бы да, всё...'
					end
					imgui.SameLine()
					if imgui.Button(u8'HARD-Пример #4') then
						name_cmd.v = 'show4'
						param_cmd = 1
						text_cmd.v = u8'text: /me взявшись за маску, стянул её с лица {name_id}\nsleep: 1000\ntext: /n {name_id}, пропиши /unmask.\nsleep: 150\nsend: Если етот мистер {color_id}{name_id}{ffffff} не снимит маску, то используй команду /rep {id} nRP!'
					end
					imgui.Text('')
					imgui.Separator()
					imgui.CenterTextColoredRGB('Результат')
					local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
					local resultext = text_cmd.v
					local resultext = resultext:gsub('{param=(%d+)}', '')
					local resultext = resultext:gsub('{name}', u8(ini.info.name))
					local resultext = resultext:gsub('{rTeg}', u8(ini.info.rteg))
					local resultext = resultext:gsub('{fTeg}', u8(ini.info.fteg))
					local resultext = resultext:gsub('{frac}', u8(ini.info.frac))
					local resultext = resultext:gsub('{num}', u8('№000' .. ini.info.number))
					local resultext = resultext:gsub('{rang}', u8(ini.info.rang))
					local resultext = resultext:gsub('{hello}', u8(sampGetHelloByTime()))
					local resultext = resultext:gsub('{area}', u8(calculateZone()))
					local resultext = resultext:gsub('{kvadrat}', u8(kvadrat()))
					local resultext = resultext:gsub('{time}', os.date('%X'))
					local resultext = resultext:gsub('{date}', os.date('%x'))
					local resultext = resultext:gsub('{myid}', id)
					local resultext = resultext:gsub('{id}', u8('<Ид игрока>'))
					local resultext = resultext:gsub('{name_id}', u8('<Имя игрока>'))
					local resultext = resultext:gsub('{color_id}', u8('<Клист игрока>'))
					local resultext = resultext:gsub('{ping_id}', u8('<Пинг игрока>'))
					local resultext = resultext:gsub('{score_id}', u8('<Счёт игрока>'))
					local resultext = resultext:gsub('{frac_id}', u8('<Фракция игрока>'))
					local resultext = resultext:gsub('sleep: ', u8('Задержка (в мс)	 '))
					local resultext = resultext:gsub('text: ', u8('Сообщение в чат	'))
					local resultext = resultext:gsub('send: ', u8('Серв. сообщение	'))
					imgui.Text(resultext)
				imgui.EndChild()
			end
			imgui.CenterTextColoredRGB('All rights reserved © 2019')
		imgui.End()
		
		if show_help.v then
			local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
			local info_function = {'{name} | Имя и фамилия | ' .. ini.info.name,
				'{rang} | Должность | ' .. ini.info.rang,
				'{frac} | Подразделение | ' .. ini.info.frac,
				'{number} | Личный номер | №000' .. ini.info.number,
				'{rteg} | Префикс в рацию | ' .. ini.info.rteg,
				'{fteg} | Префикс в общую волну | ' .. ini.info.fteg,
				'{myid} | Ваш ID | ' .. id,
				'{id} | ID игрока | <ID игрока>',
				'{hello} | Приветствие | ' .. sampGetHelloByTime(),
				'{area} | Район | '.. calculateZone(),
				'{kvadrat} | Квадрат на карте | ' .. kvadrat(),
				'{time} | Текущее время | ' .. os.date('%X'),
				'{date} | Текущая дата | ' .. os.date('%x'),
				'{frac_id} | Организация игрока | <Организация игрока>',
				'{color_id} | Цвет клиста игрока | <Цвет клиста игрока>}',
				'{name_id} | Имя игрока | <Имя игрока>',
				'{ping_id} | Пинг игрока | <Пинг игрока>',
				'{score_id} | Уровень игрока | <Уровень игрока>',
				'text: | Сообщение в обычный чат | <Сообщение>',
				'send: | Серв. сообщение | <Сообщение>',
				'sleep: | Задержка | <Задержка>'
			}
			
			imgui.SetNextWindowSize(imgui.ImVec2(550, 430))
			imgui.Begin(u8'ФУНКЦИИ | HELPER FOR MIA', nil, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
				imgui.Separator()
				imgui.Columns(3)
				imgui.SetColumnWidth(-1, 150)
				imgui.Text(u8'ФУНКЦИЯ') 
				imgui.NextColumn()
				imgui.SetColumnWidth(-1, 200)
				imgui.Text(u8'ОПИСАНИЕ')
				imgui.NextColumn()
				imgui.Text(u8'РЕЗУЛЬТАТ')
				imgui.Separator()
				for i, val in pairs(info_function) do
					local f, i, r = string.match(val, '(.+) | (.+) | (.+)')
					if f == nil then f = 'nil' end
					if i == nil then i = 'nil' end
					if r == nil then r = 'nil' end
					imgui.NextColumn()
					imgui.Text(string.format('%s', u8(f)))
					imgui.NextColumn()
					imgui.Text(string.format('%s', u8(i)))
					imgui.NextColumn() 
					imgui.Text(string.format('%s', u8(r)))
					imgui.Separator()
				end
			imgui.End()
		end
		
		if show_weapon.v then
			imgui.SetNextWindowSize(imgui.ImVec2(400, 440))
			imgui.Begin(u8'ОРУЖИЕ | HELPER FOR MIA', nil, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
				for i, val in pairs(InfoWeapon) do
					imgui.BeginChild('##name' .. val[3], imgui.ImVec2(385, 30), true)
						imgui.Text(u8(string.format('%s', val[1])))
						
						imgui.SameLine()
						
						if ini.weapon[val[3]] then
							if imgui.Button(u8'Убрать ##' .. val[3], imgui.ImVec2(100, 20)) then
								ini.weapon[val[3]] = not ini.weapon[val[3]]
								inicfg.save(ini)
							end
						else
							if imgui.Button(u8'Добавить ##' .. val[3], imgui.ImVec2(100, 20)) then
								ini.weapon[val[3]] = not ini.weapon[val[3]]
								inicfg.save(ini)
							end
						end
						
						if val[2] and work then
							imgui.SameLine()
							imgui.PushItemWidth(130)
							imgui.SliderInt('##' .. val[3], imgui.ImInt(0), 0, 5)
						end
						
					imgui.EndChild()
				end
			imgui.End()
		end
	end
	
	if show_info.v then
		imgui.SetNextWindowSize(imgui.ImVec2(900, 460))
		imgui.Begin(u8'All info', nil, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			imgui.BeginChild('##enter_info', imgui.ImVec2(150, 420), true, imgui.WindowFlags.VerticalScrollbar)
				if imgui.Button('Players', imgui.ImVec2(130, 20)) then show_item.v = 0 end
				if imgui.Button('Vehicles', imgui.ImVec2(130, 20)) then show_item.v = 1 end
				if imgui.Button('Fraction', imgui.ImVec2(130, 20)) then show_item.v = 2 end
				if imgui.Button('Chat', imgui.ImVec2(130, 20)) then show_item.v = 3 end
				if imgui.Button('Damage', imgui.ImVec2(130, 20)) then show_item.v = 4 end
			imgui.EndChild()
			imgui.SameLine()

			if show_item.v == 0 then
				imgui.BeginChild('##info_stream', imgui.ImVec2(730, 420), true, imgui.WindowFlags.VerticalScrollbar)
				imgui.CenterTextColoredRGB(sampGetPlayerCount(true) .. ' of ' .. sampGetPlayerCount(false) .. ' players on a stream')
				for i, val in pairs(getAllChars()) do
					if doesCharExist(val) then
						res , id = sampGetPlayerIdByCharHandle(val)
						if res then
							imgui.BeginChild('##info_player' .. i, imgui.ImVec2(710, 30), true, imgui.WindowFlags.VerticalScrollbar)
								if sampIsPlayerPaused(id) then afk = '{ff0000}* ' else afk = '{00ff00}* ' end
								imgui.TextColoredRGB(afk .. '{' .. sampGetColor(id) .. '}' .. sampGetPlayerNickname(id) .. '{FFFFFF}[' .. id .. ']' .. ' HP[{FA8072}' .. sampGetPlayerHealth(id) .. '{FFFFFF}] ARM[{8B7E66}' .. sampGetPlayerArmor(id) .. '{FFFFFF}] WEAP[{6495ED}' .. getCurrentCharWeapon(val) .. '{FFFFFF}] DIST[{4876FF}' .. math.floor(sampGetDistance(PLAYER_PED, id)) .. '{FFFFFF}] SPEED[{6495ED}' .. math.floor(getCharSpeed(val) * 2.02) .. '{FFFFFF}] CAR[{6495ED}' .. isPlayerCar(val) .. '{FFFFFF}] PING[{9ACD32}' .. sampGetPlayerPing(id) ..'{FFFFFF}] SCORE[{FFD700}' .. sampGetPlayerScore(id) .. '{FFFFFF}] ANIM[' .. sampGetPlayerAnimationId(id) .. ']')
							imgui.EndChild()
						end
					end
				end
				imgui.EndChild()
			end

			if show_item.v == 1 then
				imgui.BeginChild('##info_stream', imgui.ImVec2(730, 420), true, imgui.WindowFlags.VerticalScrollbar)
					imgui.ToggleButton('##cars', vfilt); imgui.SameLine(); imgui.Text('Filter out the empty car')
					for i, val in pairs(getAllVehicles()) do
						if doesVehicleExist(val) then
							id = getCarModel(val)
							if id ~= nil then
									ped = getDriverOfCar(val)
									local res, pid = sampGetPlayerIdByCharHandle(ped)
									local _, sid = sampGetVehicleIdByCarHandle(val)
									if sampIsPlayerPaused(pid) then afk = '{ff0000}* ' else afk = '{00ff00}* ' end
									if vfilt.v then
										if ped ~= nil and res then
											imgui.BeginChild('##info_cars' .. i, imgui.ImVec2(710, 30), true, imgui.WindowFlags.VerticalScrollbar)
												imgui.TextColoredRGB('{FFFFFF}' .. getNameOfVehicleModel(id) .. '[' .. id .. '][' .. sid .. '] HP[{FA8072}' .. getCarHealth(val) .. '{FFFFFF}] SPEED[{6495ED}' .. math.floor(getCarSpeed(val) * 2.02) .. '{FFFFFF}] • {' .. sampGetColor(pid) .. '}' .. sampGetPlayerNickname(pid) .. '[' .. pid .. ']{ffffff} ' .. afk)
											imgui.EndChild()
										end
									else
										if ped ~= nil and res then drv = '{' .. sampGetColor(pid) .. '}' .. sampGetPlayerNickname(pid) .. '[' .. pid .. ']{ffffff}' else drv = 'No driver' end
										imgui.BeginChild('##info_cars' .. i, imgui.ImVec2(710, 30), true, imgui.WindowFlags.VerticalScrollbar)
											imgui.TextColoredRGB('{FFFFFF}' .. getNameOfVehicleModel(id) .. '[' .. id .. '][' .. sid .. '] HP[{FA8072}' .. getCarHealth(val) .. '{FFFFFF}] SPEED[{6495ED}' .. math.floor(getCarSpeed(val) * 2.02) .. '{FFFFFF}] • ' .. drv)
										imgui.EndChild()
									end
							end
						end
					end
				imgui.EndChild()
			end

			if show_item.v == 2 then
				imgui.BeginChild('##info_stream', imgui.ImVec2(250, 420), true, imgui.WindowFlags.VerticalScrollbar)
					local online = sampGetOnlineInFraction()
					for i, val in pairs(frac.name) do
						if imgui.Button(u8(frac.fullname[i] .. ' [' .. online[val].all .. ']'), imgui.ImVec2(230, 20)) then
							show_player = 'Список игроков: '
							for i, val in pairs(online[val].player) do
								show_player = string.format('%s\n%d. %s[%d]', show_player, i, sampGetPlayerNickname(val), val)
							end
						end
					end
				imgui.EndChild()
				
				imgui.SameLine()
				
				imgui.BeginChild('##info_player', imgui.ImVec2(475, 420), true, imgui.WindowFlags.VerticalScrollbar)
					imgui.TextColoredRGB(show_player)
				imgui.EndChild()
			end
			
			if show_item.v == 3 then
				imgui.BeginChild('##info_logs', imgui.ImVec2(730, 420), true, imgui.WindowFlags.VerticalScrollbar)
					if imgui.Button(u8'Очистить') then logchat = nil; logchat = {} end
					for i, val in pairs(logchat) do
						imgui.TextColoredRGB(val)
					end
				imgui.EndChild()
			end
			
			if show_item.v == 4 then
				imgui.BeginChild('##info_logs', imgui.ImVec2(730, 420), true, imgui.WindowFlags.VerticalScrollbar)
					if imgui.Button(u8'Очистить') then logdmg = nil; logdmg = {} end
					for i, val in pairs(logdmg) do
						imgui.TextColoredRGB(val)
					end
				imgui.EndChild()
			end
		imgui.End()
	end
	
	if show_epk.v then
		imgui.SetNextWindowSize(imgui.ImVec2(900, 460))
		imgui.Begin(u8'ЕПК | HELPER FOR MIA', nil, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.HorizontalScrollbar)
			imgui.PushItemWidth(200)
			imgui.InputText(u8'Введите часть статьи или её номер', search_place)
			for val in io.lines('moonloader//helper//epk.txt') do
				if search_place.v ~= nil then
					if u8(val):find(search_place.v) then
						imgui.Text(u8(val))
					end
				end
			end
		imgui.End()
	end
	
	if show_ustav.v then
		imgui.SetNextWindowSize(imgui.ImVec2(900, 460))
		imgui.Begin(u8'Устав МВД | HELPER FOR MIA', nil, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.HorizontalScrollbar)
			imgui.PushItemWidth(200)
			imgui.InputText(u8'Введите часть статьи или её номер', search_place)
			for val in io.lines('moonloader//helper//ustav.txt') do
				if search_place.v ~= nil then
					if u8(val):find(search_place.v) then
						imgui.Text(u8(val))
					end
				end
			end
		imgui.End()
	end
	
	if piemenu.v then
        imgui.OpenPopup('PieMenu')
        if pie.BeginPiePopup('PieMenu', 0) then
			if pie.PieMenuItem(u8'cuff') then
				command_cuff(targetid)
			end

			if pie.PieMenuItem(u8'putpl') then
				command_putpl(targetid)
			end

			if pie.PieMenuItem(u8'hold') then
				command_hold(targetid)
			end

			if pie.PieMenuItem(u8'skip') then
				command_skip(targetid)
			end

			if pie.PieMenuItem(u8'search') then
				command_search(targetid)
			end
        pie.EndPiePopup()
        end
    end
end

function patch_samp_time_set(enable)
	if enable and default == nil then
		default = readMemory(sampGetBase() + 0x9C0A0, 4, true)
		writeMemory(sampGetBase() + 0x9C0A0, 4, 0x000008C2, true)
	elseif enable == false and default ~= nil then
		writeMemory(sampGetBase() + 0x9C0A0, 4, default, true)
		default = nil
	end
end

function isPlayerCar(ped)
	if isCharInAnyCar(ped) then
		carid = getCarModel(storeCarCharIsInNoSave(ped))
		return carid
	else
		return 0
	end
end

function sampIsPlayerCarHaveSuspect(id)
	if IPC(id) then
		res, ped = sampGetCharHandleBySampPlayerId(id)
		if res then
			vehicle = getCarCharIsUsing(ped)
			myvehicle = getCarCharIsUsing(PLAYER_PED)
			if vehicle == myvehicle then
				return true
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
end

function sampIsPlayerCar(id)
	if IPC(id) then
		res, ped = sampGetCharHandleBySampPlayerId(id)
		if res then
			vehicle = getCarCharIsUsing(ped)
			vid = getCarModel(vehicle)
			return true, vid
		else
			return false, -1
		end
	else
		return false, -1
	end
end

function sampGetHelloByTime()
	hour = tonumber(os.date('%H'))

	if hour > 3 and hour <= 12 then return 'Доброе утро'
	elseif hour > 12 and hour <= 18 then return 'Добрый день'
	elseif hour > 18 and hour <= 22 then return 'Добрый вечер'
	elseif hour > 22 and hour <= 3 then return 'Доброй ночи'
	else
		return 'Здравствуйте'
	end
end

function sampGetDistance(ped1, id)
	res, pid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	if tonumber(id) == tonumber(pid) then
		return 0
	else
		res, ped2 = sampGetCharHandleBySampPlayerId(id)
		if res then
			x1, y1, z1 = getCharCoordinates(ped1)
			x2, y2, z2 = getCharCoordinates(ped2)

			return getDistanceBetweenCoords3d(x1, y1, z1, x2, y2, z2)
		else
			return 5000
		end
	end
end

function getTimeLast(time)
	lget = {}

	lget[2] = 60 + (time[3] - os.date('%S'))
	lget[1] = time[2] - os.date('%M') - 1

	return lget
end

function sampGetPassedTimeByPeriod(hour, minute, secund, period)
	local time = getTimeByPeriod(hour, minute, secund, period)
	
	if tonumber(os.date('%H')) > time[1] then
		return true
	elseif tonumber(os.date('%M')) == time[2] and tonumber(os.date('%S')) >= time[3] then
		return true
	elseif tonumber(os.date('%M')) > time[2] then
		return true
	else
		return false
	end
end

function getTimeByPeriod(hour, minute, secund, period)
	if period < 60 then
		get = {}
		if minute + period >= 60 then
			hour = hour + 1
			if hour > 23 then hour = 00 end
			minute = period - (60 - minute)
		else
			minute = minute + period
		end
		get[1] = hour
		get[2] = minute
		get[3] = secund
		return get
	end
end

function IPC(id)
	local getptest, getpid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	if getptest then
		if sampIsPlayerConnected(id) or tonumber(id) == tonumber(getpid) then
			return true
		else
			return false
		end
	else 
		return false
	end
end

function sampGetPlayerFractionByid(id)
	if id ~= nil then
		if IPC(id) then
			if sampGetPlayerColor(id) == 4278190335 		then PlayerColor = 'МВД'; return PlayerColor
			elseif sampGetPlayerColor(id) == 4291624704 	then PlayerColor = 'Правительство'; return PlayerColor
			elseif sampGetPlayerColor(id) == 4294927872		then PlayerColor = 'ТВ-Радио'; return PlayerColor
			elseif sampGetPlayerColor(id) == 301989887 		then PlayerColor = 'Гражданские'; return PlayerColor
			elseif sampGetPlayerColor(id) == 4278220149 	then PlayerColor = 'Russian Mafia'; return PlayerColor
			elseif sampGetPlayerColor(id) == 4288230246 	then PlayerColor = 'La Cosa Nostra'; return PlayerColor
			elseif sampGetPlayerColor(id) == 4278229248 	then PlayerColor = 'Grove Street'; return PlayerColor
			elseif sampGetPlayerColor(id) == 4291559679 	then PlayerColor = 'The Ballas'; return PlayerColor
			elseif sampGetPlayerColor(id) == 4284901119 	then PlayerColor = 'The Rifa'; return PlayerColor
			elseif sampGetPlayerColor(id) == 4294927974 	then PlayerColor = 'Мин. здравоохранения'; return PlayerColor
			elseif sampGetPlayerColor(id) == 4288243251 	then PlayerColor = 'Мин. обороны'; return PlayerColor
			elseif sampGetPlayerColor(id) == 4290445312 	then PlayerColor = 'Yakuza'; return PlayerColor
			elseif sampGetPlayerColor(id) == 4278242559 	then PlayerColor = 'Varios Los Aztecas'; return PlayerColor
			elseif sampGetPlayerColor(id) == 4294954240 	then PlayerColor = 'Los Santos Vagos'; return PlayerColor
			else PlayerColor = 'Неизвестно'; return PlayerColor
			end
		end
	end
end

function sampGetOnlineInFraction()
	local online = {mvd = {all = 0, player = {}},
		prav = {all = 0, player = {}},
		mm = {all = 0, player = {}},
		mz = {all = 0, player = {}},
		mo = {all = 0, player = {}},
		civ = {all = 0, player = {}},
		rm = {all = 0, player = {}},
		lcn = {all = 0, player = {}},
		yak = {all = 0, player = {}},
		grv = {all = 0, player = {}},
		bal = {all = 0, player = {}},
		rif = {all = 0, player = {}},
		vag = {all = 0, player = {}},
		azt = {all = 0, player = {}},
		mask = {all = 0, player = {}},
		all = {all = 0, player = {}}
	}
	for id = 0, 1000 do 
		if IPC(id) then
			if sampGetPlayerColor(id) == 4278190335 		then online.mvd.all = online.mvd.all + 1; online.mvd.player[online.mvd.all] = id
			elseif sampGetPlayerColor(id) == 4291624704 	then online.prav.all = online.prav.all + 1; online.prav.player[online.prav.all] = id
			elseif sampGetPlayerColor(id) == 4294927872		then online.mm.all = online.mm.all + 1; online.mm.player[online.mm.all] = id
			elseif sampGetPlayerColor(id) == 301989887 		then online.civ.all = online.civ.all + 1; online.civ.player[online.civ.all] = id
			elseif sampGetPlayerColor(id) == 4278220149 	then online.rm.all = online.rm.all + 1; online.rm.player[online.rm.all] = id
			elseif sampGetPlayerColor(id) == 4288230246 	then online.lcn.all = online.lcn.all + 1; online.lcn.player[online.lcn.all] = id
			elseif sampGetPlayerColor(id) == 4278229248 	then online.grv.all = online.grv.all + 1; online.grv.player[online.grv.all] = id
			elseif sampGetPlayerColor(id) == 4291559679 	then online.bal.all = online.bal.all + 1; online.bal.player[online.bal.all] = id
			elseif sampGetPlayerColor(id) == 4284901119 	then online.rif.all = online.rif.all + 1; online.rif.player[online.rif.all] = id
			elseif sampGetPlayerColor(id) == 4294927974 	then online.mz.all = online.mz.all + 1; online.mz.player[online.mz.all] = id
			elseif sampGetPlayerColor(id) == 4288243251 	then online.mo.all = online.mo.all + 1; online.mo.player[online.mo.all] = id
			elseif sampGetPlayerColor(id) == 4290445312 	then online.yak.all = online.yak.all + 1; online.yak.player[online.yak.all] = id
			elseif sampGetPlayerColor(id) == 4278242559 	then online.azt.all = online.azt.all + 1; online.azt.player[online.azt.all] = id
			elseif sampGetPlayerColor(id) == 4294954240 	then online.vag.all = online.vag.all + 1; online.vag.player[online.vag.all] = id
			elseif sampGetPlayerColor(id) == 2236962        then online.mask.all = online.mask.all + 1; online.mask.player[online.mask.all] = id
			else online.all.all = online.all.all + 1; online.all.player[online.all.all] = id
			end
		end
	end
	return online
end

function kvadrat()
    local KV = {
        [1] = "А",
        [2] = "Б",
        [3] = "В",
        [4] = "Г",
        [5] = "Д",
        [6] = "Ж",
        [7] = "З",
        [8] = "И",
        [9] = "К",
        [10] = "Л",
        [11] = "М",
        [12] = "Н",
        [13] = "О",
        [14] = "П",
        [15] = "Р",
        [16] = "С",
        [17] = "Т",
        [18] = "У",
        [19] = "Ф",
        [20] = "Х",
        [21] = "Ц",
        [22] = "Ч",
        [23] = "Ш",
        [24] = "Я",
    }
    local X, Y, Z = getCharCoordinates(playerPed)
    X = math.ceil((X + 3000) / 250)
    Y = math.ceil((Y * - 1 + 3000) / 250)
    Y = KV[Y]
    local KVX = (Y.."-"..X)
    return KVX
end

function sampGetBodyPart(id)
	if id == 0 then body = 'unknown'
	elseif id == 1 then body = 'Спина'
	elseif id == 2 then body = 'Голова'
	elseif id == 3 then body = 'Плечо левой руки'
	elseif id == 4 then body = 'Плечо правой руки'
	elseif id == 5 then body = 'Левая рука'
	elseif id == 6 then body = 'Правая рука'
	elseif id == 7 then body = 'Левое бедро'
	elseif id == 8 then body = 'Правое бедро'
	elseif id == 9 then body = 'Левая нога'
	elseif id == 10 then body = 'Правая нога'
	elseif id == 11 then body = 'Правая голень'
	elseif id == 12 then body = 'Левая голень'
	elseif id == 13 then body = 'Левое предплечие'
	elseif id == 14 then body = 'Правое предплечие'
	elseif id == 15 then body = 'Левая ключица'
	elseif id == 16 then body = 'Правая ключица'
	elseif id == 17 then body = 'Шея'
	elseif id == 18 then body = 'Челюсть'
	else body = 'Неизвестно'
	end

	return body
end

function sampGetWeaponName(id)
	if id == 0 then weap = 'Fist'
	elseif id == 1 then weap = 'Knuckle'
	elseif id == 2 then weap = 'Golf club'
	elseif id == 3 then weap = 'Police baton'
	elseif id == 4 then weap = 'Knife'
	elseif id == 5 then weap = 'Baseball bat'
	elseif id == 6 then weap = 'Shovel'
	elseif id == 7 then weap = 'Cue'
	elseif id == 8 then weap = 'Katana'
	elseif id == 9 then weap = 'Chainsaw'
	elseif id == 10 then weap = 'Double sided Dildo'
	elseif id == 11 then weap = 'Dildo'
	elseif id == 12 then weap = 'Vibrator'
	elseif id == 13 then weap = 'Silver vibrator'
	elseif id == 14 then weap = 'Flower'
	elseif id == 15 then weap = 'Stick'
	elseif id == 16 then weap = 'Grenade'
	elseif id == 17 then weap = 'Tear Gas'
	elseif id == 18 then weap = 'Cocktail of Molotov'
	elseif id == 22 then weap = 'Gun of 9mm'
	elseif id == 23 then weap = 'SD pistol 9mm'
	elseif id == 24 then weap = 'Desert Eagle'
	elseif id == 25 then weap = 'ShotGun'
	elseif id == 26 then weap = 'Edge ShotGun'
	elseif id == 27 then weap = 'Combat ShotGun'
	elseif id == 28 then weap = 'Usi'
	elseif id == 29 then weap = 'MP-5'
	elseif id == 30 then weap = 'AK-47'
	elseif id == 31 then weap = 'M4'
	elseif id == 32 then weap = 'Tec-9'
	elseif id == 33 then weap = 'Rifle'
	elseif id == 34 then weap = 'Sniper Rifle'
	elseif id == 35 then weap = 'RPG-7'
	elseif id == 36 then weap = 'Rocket Launcher'
	elseif id == 37 then weap = 'Flamer'
	elseif id == 38 then weap = 'Minigun'
	elseif id == 39 then weap = 'Bag of C4'
	elseif id == 40 then weap = 'Detonator for C4'
	elseif id == 41 then weap = 'Spray'
	elseif id == 42 then weap = 'Огнетушитель'
	elseif id == 43 then weap = 'Photo Camera'
	elseif id == 44 then weap = 'Night Vision'
	elseif id == 45 then weap = 'Hot Vision'
	elseif id == 46 then weap = 'Parachute'
	elseif id == 49 then weap = 'Vehicle'
	else weap = 'Неизвестно'
	end

	return weap
end

function calculateZone()
	x, y, z = getCharCoordinates(playerPed)
    local streets = {{"Avispa Country Club", -2667.810, -302.135, -28.831, -2646.400, -262.320, 71.169},
    {"Easter Bay Airport", -1315.420, -405.388, 15.406, -1264.400, -209.543, 25.406},
    {"Avispa Country Club", -2550.040, -355.493, 0.000, -2470.040, -318.493, 39.700},
    {"Easter Bay Airport", -1490.330, -209.543, 15.406, -1264.400, -148.388, 25.406},
    {"Garcia", -2395.140, -222.589, -5.3, -2354.090, -204.792, 200.000},
    {"Shady Cabin", -1632.830, -2263.440, -3.0, -1601.330, -2231.790, 200.000},
    {"East Los Santos", 2381.680, -1494.030, -89.084, 2421.030, -1454.350, 110.916},
    {"LVA Freight Depot", 1236.630, 1163.410, -89.084, 1277.050, 1203.280, 110.916},
    {"Blackfield Intersection", 1277.050, 1044.690, -89.084, 1315.350, 1087.630, 110.916},
    {"Avispa Country Club", -2470.040, -355.493, 0.000, -2270.040, -318.493, 46.100},
    {"Temple", 1252.330, -926.999, -89.084, 1357.000, -910.170, 110.916},
    {"Unity Station", 1692.620, -1971.800, -20.492, 1812.620, -1932.800, 79.508},
    {"LVA Freight Depot", 1315.350, 1044.690, -89.084, 1375.600, 1087.630, 110.916},
    {"Los Flores", 2581.730, -1454.350, -89.084, 2632.830, -1393.420, 110.916},
    {"Starfish Casino", 2437.390, 1858.100, -39.084, 2495.090, 1970.850, 60.916},
    {"Easter Bay Chemicals", -1132.820, -787.391, 0.000, -956.476, -768.027, 200.000},
    {"Downtown Los Santos", 1370.850, -1170.870, -89.084, 1463.900, -1130.850, 110.916},
    {"Esplanade East", -1620.300, 1176.520, -4.5, -1580.010, 1274.260, 200.000},
    {"Market Station", 787.461, -1410.930, -34.126, 866.009, -1310.210, 65.874},
    {"Linden Station", 2811.250, 1229.590, -39.594, 2861.250, 1407.590, 60.406},
    {"Montgomery Intersection", 1582.440, 347.457, 0.000, 1664.620, 401.750, 200.000},
    {"Frederick Bridge", 2759.250, 296.501, 0.000, 2774.250, 594.757, 200.000},
    {"Yellow Bell Station", 1377.480, 2600.430, -21.926, 1492.450, 2687.360, 78.074},
    {"Downtown Los Santos", 1507.510, -1385.210, 110.916, 1582.550, -1325.310, 335.916},
    {"Jefferson", 2185.330, -1210.740, -89.084, 2281.450, -1154.590, 110.916},
    {"Mulholland", 1318.130, -910.170, -89.084, 1357.000, -768.027, 110.916},
    {"Avispa Country Club", -2361.510, -417.199, 0.000, -2270.040, -355.493, 200.000},
    {"Jefferson", 1996.910, -1449.670, -89.084, 2056.860, -1350.720, 110.916},
    {"Julius Thruway West", 1236.630, 2142.860, -89.084, 1297.470, 2243.230, 110.916},
    {"Jefferson", 2124.660, -1494.030, -89.084, 2266.210, -1449.670, 110.916},
    {"Julius Thruway North", 1848.400, 2478.490, -89.084, 1938.800, 2553.490, 110.916},
    {"Rodeo", 422.680, -1570.200, -89.084, 466.223, -1406.050, 110.916},
    {"Cranberry Station", -2007.830, 56.306, 0.000, -1922.000, 224.782, 100.000},
    {"Downtown Los Santos", 1391.050, -1026.330, -89.084, 1463.900, -926.999, 110.916},
    {"Redsands West", 1704.590, 2243.230, -89.084, 1777.390, 2342.830, 110.916},
    {"Little Mexico", 1758.900, -1722.260, -89.084, 1812.620, -1577.590, 110.916},
    {"Blackfield Intersection", 1375.600, 823.228, -89.084, 1457.390, 919.447, 110.916},
    {"Los Santos International", 1974.630, -2394.330, -39.084, 2089.000, -2256.590, 60.916},
    {"Beacon Hill", -399.633, -1075.520, -1.489, -319.033, -977.516, 198.511},
    {"Rodeo", 334.503, -1501.950, -89.084, 422.680, -1406.050, 110.916},
    {"Richman", 225.165, -1369.620, -89.084, 334.503, -1292.070, 110.916},
    {"Downtown Los Santos", 1724.760, -1250.900, -89.084, 1812.620, -1150.870, 110.916},
    {"The Strip", 2027.400, 1703.230, -89.084, 2137.400, 1783.230, 110.916},
    {"Downtown Los Santos", 1378.330, -1130.850, -89.084, 1463.900, -1026.330, 110.916},
    {"Blackfield Intersection", 1197.390, 1044.690, -89.084, 1277.050, 1163.390, 110.916},
    {"Conference Center", 1073.220, -1842.270, -89.084, 1323.900, -1804.210, 110.916},
    {"Montgomery", 1451.400, 347.457, -6.1, 1582.440, 420.802, 200.000},
    {"Foster Valley", -2270.040, -430.276, -1.2, -2178.690, -324.114, 200.000},
    {"Blackfield Chapel", 1325.600, 596.349, -89.084, 1375.600, 795.010, 110.916},
    {"Los Santos International", 2051.630, -2597.260, -39.084, 2152.450, -2394.330, 60.916},
    {"Mulholland", 1096.470, -910.170, -89.084, 1169.130, -768.027, 110.916},
    {"Yellow Bell Gol Course", 1457.460, 2723.230, -89.084, 1534.560, 2863.230, 110.916},
    {"The Strip", 2027.400, 1783.230, -89.084, 2162.390, 1863.230, 110.916},
    {"Jefferson", 2056.860, -1210.740, -89.084, 2185.330, -1126.320, 110.916},
    {"Mulholland", 952.604, -937.184, -89.084, 1096.470, -860.619, 110.916},
    {"Aldea Malvada", -1372.140, 2498.520, 0.000, -1277.590, 2615.350, 200.000},
    {"Las Colinas", 2126.860, -1126.320, -89.084, 2185.330, -934.489, 110.916},
    {"Las Colinas", 1994.330, -1100.820, -89.084, 2056.860, -920.815, 110.916},
    {"Richman", 647.557, -954.662, -89.084, 768.694, -860.619, 110.916},
    {"LVA Freight Depot", 1277.050, 1087.630, -89.084, 1375.600, 1203.280, 110.916},
    {"Julius Thruway North", 1377.390, 2433.230, -89.084, 1534.560, 2507.230, 110.916},
    {"Willowfield", 2201.820, -2095.000, -89.084, 2324.000, -1989.900, 110.916},
    {"Julius Thruway North", 1704.590, 2342.830, -89.084, 1848.400, 2433.230, 110.916},
    {"Temple", 1252.330, -1130.850, -89.084, 1378.330, -1026.330, 110.916},
    {"Little Mexico", 1701.900, -1842.270, -89.084, 1812.620, -1722.260, 110.916},
    {"Queens", -2411.220, 373.539, 0.000, -2253.540, 458.411, 200.000},
    {"Las Venturas Airport", 1515.810, 1586.400, -12.500, 1729.950, 1714.560, 87.500},
    {"Richman", 225.165, -1292.070, -89.084, 466.223, -1235.070, 110.916},
    {"Temple", 1252.330, -1026.330, -89.084, 1391.050, -926.999, 110.916},
    {"East Los Santos", 2266.260, -1494.030, -89.084, 2381.680, -1372.040, 110.916},
    {"Julius Thruway East", 2623.180, 943.235, -89.084, 2749.900, 1055.960, 110.916},
    {"Willowfield", 2541.700, -1941.400, -89.084, 2703.580, -1852.870, 110.916},
    {"Las Colinas", 2056.860, -1126.320, -89.084, 2126.860, -920.815, 110.916},
    {"Julius Thruway East", 2625.160, 2202.760, -89.084, 2685.160, 2442.550, 110.916},
    {"Rodeo", 225.165, -1501.950, -89.084, 334.503, -1369.620, 110.916},
    {"Las Brujas", -365.167, 2123.010, -3.0, -208.570, 2217.680, 200.000},
    {"Julius Thruway East", 2536.430, 2442.550, -89.084, 2685.160, 2542.550, 110.916},
    {"Rodeo", 334.503, -1406.050, -89.084, 466.223, -1292.070, 110.916},
    {"Vinewood", 647.557, -1227.280, -89.084, 787.461, -1118.280, 110.916},
    {"Rodeo", 422.680, -1684.650, -89.084, 558.099, -1570.200, 110.916},
    {"Julius Thruway North", 2498.210, 2542.550, -89.084, 2685.160, 2626.550, 110.916},
    {"Downtown Los Santos", 1724.760, -1430.870, -89.084, 1812.620, -1250.900, 110.916},
    {"Rodeo", 225.165, -1684.650, -89.084, 312.803, -1501.950, 110.916},
    {"Jefferson", 2056.860, -1449.670, -89.084, 2266.210, -1372.040, 110.916},
    {"Hampton Barns", 603.035, 264.312, 0.000, 761.994, 366.572, 200.000},
    {"Temple", 1096.470, -1130.840, -89.084, 1252.330, -1026.330, 110.916},
    {"Kincaid Bridge", -1087.930, 855.370, -89.084, -961.950, 986.281, 110.916},
    {"Verona Beach", 1046.150, -1722.260, -89.084, 1161.520, -1577.590, 110.916},
    {"Commerce", 1323.900, -1722.260, -89.084, 1440.900, -1577.590, 110.916},
    {"Mulholland", 1357.000, -926.999, -89.084, 1463.900, -768.027, 110.916},
    {"Rodeo", 466.223, -1570.200, -89.084, 558.099, -1385.070, 110.916},
    {"Mulholland", 911.802, -860.619, -89.084, 1096.470, -768.027, 110.916},
    {"Mulholland", 768.694, -954.662, -89.084, 952.604, -860.619, 110.916},
    {"Julius Thruway South", 2377.390, 788.894, -89.084, 2537.390, 897.901, 110.916},
    {"Idlewood", 1812.620, -1852.870, -89.084, 1971.660, -1742.310, 110.916},
    {"Ocean Docks", 2089.000, -2394.330, -89.084, 2201.820, -2235.840, 110.916},
    {"Commerce", 1370.850, -1577.590, -89.084, 1463.900, -1384.950, 110.916},
    {"Julius Thruway North", 2121.400, 2508.230, -89.084, 2237.400, 2663.170, 110.916},
    {"Temple", 1096.470, -1026.330, -89.084, 1252.330, -910.170, 110.916},
    {"Glen Park", 1812.620, -1449.670, -89.084, 1996.910, -1350.720, 110.916},
    {"Easter Bay Airport", -1242.980, -50.096, 0.000, -1213.910, 578.396, 200.000},
    {"Martin Bridge", -222.179, 293.324, 0.000, -122.126, 476.465, 200.000},
    {"The Strip", 2106.700, 1863.230, -89.084, 2162.390, 2202.760, 110.916},
    {"Willowfield", 2541.700, -2059.230, -89.084, 2703.580, -1941.400, 110.916},
    {"Marina", 807.922, -1577.590, -89.084, 926.922, -1416.250, 110.916},
    {"Las Venturas Airport", 1457.370, 1143.210, -89.084, 1777.400, 1203.280, 110.916},
    {"Idlewood", 1812.620, -1742.310, -89.084, 1951.660, -1602.310, 110.916},
    {"Esplanade East", -1580.010, 1025.980, -6.1, -1499.890, 1274.260, 200.000},
    {"Downtown Los Santos", 1370.850, -1384.950, -89.084, 1463.900, -1170.870, 110.916},
    {"The Mako Span", 1664.620, 401.750, 0.000, 1785.140, 567.203, 200.000},
    {"Rodeo", 312.803, -1684.650, -89.084, 422.680, -1501.950, 110.916},
    {"Pershing Square", 1440.900, -1722.260, -89.084, 1583.500, -1577.590, 110.916},
    {"Mulholland", 687.802, -860.619, -89.084, 911.802, -768.027, 110.916},
    {"Gant Bridge", -2741.070, 1490.470, -6.1, -2616.400, 1659.680, 200.000},
    {"Las Colinas", 2185.330, -1154.590, -89.084, 2281.450, -934.489, 110.916},
    {"Mulholland", 1169.130, -910.170, -89.084, 1318.130, -768.027, 110.916},
    {"Julius Thruway North", 1938.800, 2508.230, -89.084, 2121.400, 2624.230, 110.916},
    {"Commerce", 1667.960, -1577.590, -89.084, 1812.620, -1430.870, 110.916},
    {"Rodeo", 72.648, -1544.170, -89.084, 225.165, -1404.970, 110.916},
    {"Roca Escalante", 2536.430, 2202.760, -89.084, 2625.160, 2442.550, 110.916},
    {"Rodeo", 72.648, -1684.650, -89.084, 225.165, -1544.170, 110.916},
    {"Market", 952.663, -1310.210, -89.084, 1072.660, -1130.850, 110.916},
    {"Las Colinas", 2632.740, -1135.040, -89.084, 2747.740, -945.035, 110.916},
    {"Mulholland", 861.085, -674.885, -89.084, 1156.550, -600.896, 110.916},
    {"King's", -2253.540, 373.539, -9.1, -1993.280, 458.411, 200.000},
    {"Redsands East", 1848.400, 2342.830, -89.084, 2011.940, 2478.490, 110.916},
    {"Downtown", -1580.010, 744.267, -6.1, -1499.890, 1025.980, 200.000},
    {"Conference Center", 1046.150, -1804.210, -89.084, 1323.900, -1722.260, 110.916},
    {"Richman", 647.557, -1118.280, -89.084, 787.461, -954.662, 110.916},
    {"Ocean Flats", -2994.490, 277.411, -9.1, -2867.850, 458.411, 200.000},
    {"Greenglass College", 964.391, 930.890, -89.084, 1166.530, 1044.690, 110.916},
    {"Glen Park", 1812.620, -1100.820, -89.084, 1994.330, -973.380, 110.916},
    {"LVA Freight Depot", 1375.600, 919.447, -89.084, 1457.370, 1203.280, 110.916},
    {"Regular Tom", -405.770, 1712.860, -3.0, -276.719, 1892.750, 200.000},
    {"Verona Beach", 1161.520, -1722.260, -89.084, 1323.900, -1577.590, 110.916},
    {"East Los Santos", 2281.450, -1372.040, -89.084, 2381.680, -1135.040, 110.916},
    {"Caligula's Palace", 2137.400, 1703.230, -89.084, 2437.390, 1783.230, 110.916},
    {"Idlewood", 1951.660, -1742.310, -89.084, 2124.660, -1602.310, 110.916},
    {"Pilgrim", 2624.400, 1383.230, -89.084, 2685.160, 1783.230, 110.916},
    {"Idlewood", 2124.660, -1742.310, -89.084, 2222.560, -1494.030, 110.916},
    {"Queens", -2533.040, 458.411, 0.000, -2329.310, 578.396, 200.000},
    {"Downtown", -1871.720, 1176.420, -4.5, -1620.300, 1274.260, 200.000},
    {"Commerce", 1583.500, -1722.260, -89.084, 1758.900, -1577.590, 110.916},
    {"East Los Santos", 2381.680, -1454.350, -89.084, 2462.130, -1135.040, 110.916},
    {"Marina", 647.712, -1577.590, -89.084, 807.922, -1416.250, 110.916},
    {"Richman", 72.648, -1404.970, -89.084, 225.165, -1235.070, 110.916},
    {"Vinewood", 647.712, -1416.250, -89.084, 787.461, -1227.280, 110.916},
    {"East Los Santos", 2222.560, -1628.530, -89.084, 2421.030, -1494.030, 110.916},
    {"Rodeo", 558.099, -1684.650, -89.084, 647.522, -1384.930, 110.916},
    {"Easter Tunnel", -1709.710, -833.034, -1.5, -1446.010, -730.118, 200.000},
    {"Rodeo", 466.223, -1385.070, -89.084, 647.522, -1235.070, 110.916},
    {"Redsands East", 1817.390, 2202.760, -89.084, 2011.940, 2342.830, 110.916},
    {"The Clown's Pocket", 2162.390, 1783.230, -89.084, 2437.390, 1883.230, 110.916},
    {"Idlewood", 1971.660, -1852.870, -89.084, 2222.560, -1742.310, 110.916},
    {"Montgomery Intersection", 1546.650, 208.164, 0.000, 1745.830, 347.457, 200.000},
    {"Willowfield", 2089.000, -2235.840, -89.084, 2201.820, -1989.900, 110.916},
    {"Temple", 952.663, -1130.840, -89.084, 1096.470, -937.184, 110.916},
    {"Prickle Pine", 1848.400, 2553.490, -89.084, 1938.800, 2863.230, 110.916},
    {"Los Santos International", 1400.970, -2669.260, -39.084, 2189.820, -2597.260, 60.916},
    {"Garver Bridge", -1213.910, 950.022, -89.084, -1087.930, 1178.930, 110.916},
    {"Garver Bridge", -1339.890, 828.129, -89.084, -1213.910, 1057.040, 110.916},
    {"Kincaid Bridge", -1339.890, 599.218, -89.084, -1213.910, 828.129, 110.916},
    {"Kincaid Bridge", -1213.910, 721.111, -89.084, -1087.930, 950.022, 110.916},
    {"Verona Beach", 930.221, -2006.780, -89.084, 1073.220, -1804.210, 110.916},
    {"Verdant Bluffs", 1073.220, -2006.780, -89.084, 1249.620, -1842.270, 110.916},
    {"Vinewood", 787.461, -1130.840, -89.084, 952.604, -954.662, 110.916},
    {"Vinewood", 787.461, -1310.210, -89.084, 952.663, -1130.840, 110.916},
    {"Commerce", 1463.900, -1577.590, -89.084, 1667.960, -1430.870, 110.916},
    {"Market", 787.461, -1416.250, -89.084, 1072.660, -1310.210, 110.916},
    {"Rockshore West", 2377.390, 596.349, -89.084, 2537.390, 788.894, 110.916},
    {"Julius Thruway North", 2237.400, 2542.550, -89.084, 2498.210, 2663.170, 110.916},
    {"East Beach", 2632.830, -1668.130, -89.084, 2747.740, -1393.420, 110.916},
    {"Fallow Bridge", 434.341, 366.572, 0.000, 603.035, 555.680, 200.000},
    {"Willowfield", 2089.000, -1989.900, -89.084, 2324.000, -1852.870, 110.916},
    {"Chinatown", -2274.170, 578.396, -7.6, -2078.670, 744.170, 200.000},
    {"El Castillo del Diablo", -208.570, 2337.180, 0.000, 8.430, 2487.180, 200.000},
    {"Ocean Docks", 2324.000, -2145.100, -89.084, 2703.580, -2059.230, 110.916},
    {"Easter Bay Chemicals", -1132.820, -768.027, 0.000, -956.476, -578.118, 200.000},
    {"The Visage", 1817.390, 1703.230, -89.084, 2027.400, 1863.230, 110.916},
    {"Ocean Flats", -2994.490, -430.276, -1.2, -2831.890, -222.589, 200.000},
    {"Richman", 321.356, -860.619, -89.084, 687.802, -768.027, 110.916},
    {"Green Palms", 176.581, 1305.450, -3.0, 338.658, 1520.720, 200.000},
    {"Richman", 321.356, -768.027, -89.084, 700.794, -674.885, 110.916},
    {"Starfish Casino", 2162.390, 1883.230, -89.084, 2437.390, 2012.180, 110.916},
    {"East Beach", 2747.740, -1668.130, -89.084, 2959.350, -1498.620, 110.916},
    {"Jefferson", 2056.860, -1372.040, -89.084, 2281.450, -1210.740, 110.916},
    {"Downtown Los Santos", 1463.900, -1290.870, -89.084, 1724.760, -1150.870, 110.916},
    {"Downtown Los Santos", 1463.900, -1430.870, -89.084, 1724.760, -1290.870, 110.916},
    {"Garver Bridge", -1499.890, 696.442, -179.615, -1339.890, 925.353, 20.385},
    {"Julius Thruway South", 1457.390, 823.228, -89.084, 2377.390, 863.229, 110.916},
    {"East Los Santos", 2421.030, -1628.530, -89.084, 2632.830, -1454.350, 110.916},
    {"Greenglass College", 964.391, 1044.690, -89.084, 1197.390, 1203.220, 110.916},
    {"Las Colinas", 2747.740, -1120.040, -89.084, 2959.350, -945.035, 110.916},
    {"Mulholland", 737.573, -768.027, -89.084, 1142.290, -674.885, 110.916},
    {"Ocean Docks", 2201.820, -2730.880, -89.084, 2324.000, -2418.330, 110.916},
    {"East Los Santos", 2462.130, -1454.350, -89.084, 2581.730, -1135.040, 110.916},
    {"Ganton", 2222.560, -1722.330, -89.084, 2632.830, -1628.530, 110.916},
    {"Avispa Country Club", -2831.890, -430.276, -6.1, -2646.400, -222.589, 200.000},
    {"Willowfield", 1970.620, -2179.250, -89.084, 2089.000, -1852.870, 110.916},
    {"Esplanade North", -1982.320, 1274.260, -4.5, -1524.240, 1358.900, 200.000},
    {"The High Roller", 1817.390, 1283.230, -89.084, 2027.390, 1469.230, 110.916},
    {"Ocean Docks", 2201.820, -2418.330, -89.084, 2324.000, -2095.000, 110.916},
    {"Last Dime Motel", 1823.080, 596.349, -89.084, 1997.220, 823.228, 110.916},
    {"Bayside Marina", -2353.170, 2275.790, 0.000, -2153.170, 2475.790, 200.000},
    {"King's", -2329.310, 458.411, -7.6, -1993.280, 578.396, 200.000},
    {"El Corona", 1692.620, -2179.250, -89.084, 1812.620, -1842.270, 110.916},
    {"Blackfield Chapel", 1375.600, 596.349, -89.084, 1558.090, 823.228, 110.916},
    {"The Pink Swan", 1817.390, 1083.230, -89.084, 2027.390, 1283.230, 110.916},
    {"Julius Thruway West", 1197.390, 1163.390, -89.084, 1236.630, 2243.230, 110.916},
    {"Los Flores", 2581.730, -1393.420, -89.084, 2747.740, -1135.040, 110.916},
    {"The Visage", 1817.390, 1863.230, -89.084, 2106.700, 2011.830, 110.916},
    {"Prickle Pine", 1938.800, 2624.230, -89.084, 2121.400, 2861.550, 110.916},
    {"Verona Beach", 851.449, -1804.210, -89.084, 1046.150, -1577.590, 110.916},
    {"Robada Intersection", -1119.010, 1178.930, -89.084, -862.025, 1351.450, 110.916},
    {"Linden Side", 2749.900, 943.235, -89.084, 2923.390, 1198.990, 110.916},
    {"Ocean Docks", 2703.580, -2302.330, -89.084, 2959.350, -2126.900, 110.916},
    {"Willowfield", 2324.000, -2059.230, -89.084, 2541.700, -1852.870, 110.916},
    {"King's", -2411.220, 265.243, -9.1, -1993.280, 373.539, 200.000},
    {"Commerce", 1323.900, -1842.270, -89.084, 1701.900, -1722.260, 110.916},
    {"Mulholland", 1269.130, -768.027, -89.084, 1414.070, -452.425, 110.916},
    {"Marina", 647.712, -1804.210, -89.084, 851.449, -1577.590, 110.916},
    {"Battery Point", -2741.070, 1268.410, -4.5, -2533.040, 1490.470, 200.000},
    {"The Four Dragons Casino", 1817.390, 863.232, -89.084, 2027.390, 1083.230, 110.916},
    {"Blackfield", 964.391, 1203.220, -89.084, 1197.390, 1403.220, 110.916},
    {"Julius Thruway North", 1534.560, 2433.230, -89.084, 1848.400, 2583.230, 110.916},
    {"Yellow Bell Gol Course", 1117.400, 2723.230, -89.084, 1457.460, 2863.230, 110.916},
    {"Idlewood", 1812.620, -1602.310, -89.084, 2124.660, -1449.670, 110.916},
    {"Redsands West", 1297.470, 2142.860, -89.084, 1777.390, 2243.230, 110.916},
    {"Doherty", -2270.040, -324.114, -1.2, -1794.920, -222.589, 200.000},
    {"Hilltop Farm", 967.383, -450.390, -3.0, 1176.780, -217.900, 200.000},
    {"Las Barrancas", -926.130, 1398.730, -3.0, -719.234, 1634.690, 200.000},
    {"Pirates in Men's Pants", 1817.390, 1469.230, -89.084, 2027.400, 1703.230, 110.916},
    {"City Hall", -2867.850, 277.411, -9.1, -2593.440, 458.411, 200.000},
    {"Avispa Country Club", -2646.400, -355.493, 0.000, -2270.040, -222.589, 200.000},
    {"The Strip", 2027.400, 863.229, -89.084, 2087.390, 1703.230, 110.916},
    {"Hashbury", -2593.440, -222.589, -1.0, -2411.220, 54.722, 200.000},
    {"Los Santos International", 1852.000, -2394.330, -89.084, 2089.000, -2179.250, 110.916},
    {"Whitewood Estates", 1098.310, 1726.220, -89.084, 1197.390, 2243.230, 110.916},
    {"Sherman Reservoir", -789.737, 1659.680, -89.084, -599.505, 1929.410, 110.916},
    {"El Corona", 1812.620, -2179.250, -89.084, 1970.620, -1852.870, 110.916},
    {"Downtown", -1700.010, 744.267, -6.1, -1580.010, 1176.520, 200.000},
    {"Foster Valley", -2178.690, -1250.970, 0.000, -1794.920, -1115.580, 200.000},
    {"Las Payasadas", -354.332, 2580.360, 2.0, -133.625, 2816.820, 200.000},
    {"Valle Ocultado", -936.668, 2611.440, 2.0, -715.961, 2847.900, 200.000},
    {"Blackfield Intersection", 1166.530, 795.010, -89.084, 1375.600, 1044.690, 110.916},
    {"Ganton", 2222.560, -1852.870, -89.084, 2632.830, -1722.330, 110.916},
    {"Easter Bay Airport", -1213.910, -730.118, 0.000, -1132.820, -50.096, 200.000},
    {"Redsands East", 1817.390, 2011.830, -89.084, 2106.700, 2202.760, 110.916},
    {"Esplanade East", -1499.890, 578.396, -79.615, -1339.890, 1274.260, 20.385},
    {"Caligula's Palace", 2087.390, 1543.230, -89.084, 2437.390, 1703.230, 110.916},
    {"Royal Casino", 2087.390, 1383.230, -89.084, 2437.390, 1543.230, 110.916},
    {"Richman", 72.648, -1235.070, -89.084, 321.356, -1008.150, 110.916},
    {"Starfish Casino", 2437.390, 1783.230, -89.084, 2685.160, 2012.180, 110.916},
    {"Mulholland", 1281.130, -452.425, -89.084, 1641.130, -290.913, 110.916},
    {"Downtown", -1982.320, 744.170, -6.1, -1871.720, 1274.260, 200.000},
    {"Hankypanky Point", 2576.920, 62.158, 0.000, 2759.250, 385.503, 200.000},
    {"K.A.C.C. Military Fuels", 2498.210, 2626.550, -89.084, 2749.900, 2861.550, 110.916},
    {"Harry Gold Parkway", 1777.390, 863.232, -89.084, 1817.390, 2342.830, 110.916},
    {"Bayside Tunnel", -2290.190, 2548.290, -89.084, -1950.190, 2723.290, 110.916},
    {"Ocean Docks", 2324.000, -2302.330, -89.084, 2703.580, -2145.100, 110.916},
    {"Richman", 321.356, -1044.070, -89.084, 647.557, -860.619, 110.916},
    {"Randolph Industrial Estate", 1558.090, 596.349, -89.084, 1823.080, 823.235, 110.916},
    {"East Beach", 2632.830, -1852.870, -89.084, 2959.350, -1668.130, 110.916},
    {"Flint Water", -314.426, -753.874, -89.084, -106.339, -463.073, 110.916},
    {"Blueberry", 19.607, -404.136, 3.8, 349.607, -220.137, 200.000},
    {"Linden Station", 2749.900, 1198.990, -89.084, 2923.390, 1548.990, 110.916},
    {"Glen Park", 1812.620, -1350.720, -89.084, 2056.860, -1100.820, 110.916},
    {"Downtown", -1993.280, 265.243, -9.1, -1794.920, 578.396, 200.000},
    {"Redsands West", 1377.390, 2243.230, -89.084, 1704.590, 2433.230, 110.916},
    {"Richman", 321.356, -1235.070, -89.084, 647.522, -1044.070, 110.916},
    {"Gant Bridge", -2741.450, 1659.680, -6.1, -2616.400, 2175.150, 200.000},
    {"Lil' Probe Inn", -90.218, 1286.850, -3.0, 153.859, 1554.120, 200.000},
    {"Flint Intersection", -187.700, -1596.760, -89.084, 17.063, -1276.600, 110.916},
    {"Las Colinas", 2281.450, -1135.040, -89.084, 2632.740, -945.035, 110.916},
    {"Sobell Rail Yards", 2749.900, 1548.990, -89.084, 2923.390, 1937.250, 110.916},
    {"The Emerald Isle", 2011.940, 2202.760, -89.084, 2237.400, 2508.230, 110.916},
    {"El Castillo del Diablo", -208.570, 2123.010, -7.6, 114.033, 2337.180, 200.000},
    {"Santa Flora", -2741.070, 458.411, -7.6, -2533.040, 793.411, 200.000},
    {"Playa del Seville", 2703.580, -2126.900, -89.084, 2959.350, -1852.870, 110.916},
    {"Market", 926.922, -1577.590, -89.084, 1370.850, -1416.250, 110.916},
    {"Queens", -2593.440, 54.722, 0.000, -2411.220, 458.411, 200.000},
    {"Pilson Intersection", 1098.390, 2243.230, -89.084, 1377.390, 2507.230, 110.916},
    {"Spinybed", 2121.400, 2663.170, -89.084, 2498.210, 2861.550, 110.916},
    {"Pilgrim", 2437.390, 1383.230, -89.084, 2624.400, 1783.230, 110.916},
    {"Blackfield", 964.391, 1403.220, -89.084, 1197.390, 1726.220, 110.916},
    {"'The Big Ear'", -410.020, 1403.340, -3.0, -137.969, 1681.230, 200.000},
    {"Dillimore", 580.794, -674.885, -9.5, 861.085, -404.790, 200.000},
    {"El Quebrados", -1645.230, 2498.520, 0.000, -1372.140, 2777.850, 200.000},
    {"Esplanade North", -2533.040, 1358.900, -4.5, -1996.660, 1501.210, 200.000},
    {"Easter Bay Airport", -1499.890, -50.096, -1.0, -1242.980, 249.904, 200.000},
    {"Fisher's Lagoon", 1916.990, -233.323, -100.000, 2131.720, 13.800, 200.000},
    {"Mulholland", 1414.070, -768.027, -89.084, 1667.610, -452.425, 110.916},
    {"East Beach", 2747.740, -1498.620, -89.084, 2959.350, -1120.040, 110.916},
    {"San Andreas Sound", 2450.390, 385.503, -100.000, 2759.250, 562.349, 200.000},
    {"Shady Creeks", -2030.120, -2174.890, -6.1, -1820.640, -1771.660, 200.000},
    {"Market", 1072.660, -1416.250, -89.084, 1370.850, -1130.850, 110.916},
    {"Rockshore West", 1997.220, 596.349, -89.084, 2377.390, 823.228, 110.916},
    {"Prickle Pine", 1534.560, 2583.230, -89.084, 1848.400, 2863.230, 110.916},
    {"Easter Basin", -1794.920, -50.096, -1.04, -1499.890, 249.904, 200.000},
    {"Leafy Hollow", -1166.970, -1856.030, 0.000, -815.624, -1602.070, 200.000},
    {"LVA Freight Depot", 1457.390, 863.229, -89.084, 1777.400, 1143.210, 110.916},
    {"Prickle Pine", 1117.400, 2507.230, -89.084, 1534.560, 2723.230, 110.916},
    {"Blueberry", 104.534, -220.137, 2.3, 349.607, 152.236, 200.000},
    {"El Castillo del Diablo", -464.515, 2217.680, 0.000, -208.570, 2580.360, 200.000},
    {"Downtown", -2078.670, 578.396, -7.6, -1499.890, 744.267, 200.000},
    {"Rockshore East", 2537.390, 676.549, -89.084, 2902.350, 943.235, 110.916},
    {"San Fierro Bay", -2616.400, 1501.210, -3.0, -1996.660, 1659.680, 200.000},
    {"Paradiso", -2741.070, 793.411, -6.1, -2533.040, 1268.410, 200.000},
    {"The Camel's Toe", 2087.390, 1203.230, -89.084, 2640.400, 1383.230, 110.916},
    {"Old Venturas Strip", 2162.390, 2012.180, -89.084, 2685.160, 2202.760, 110.916},
    {"Juniper Hill", -2533.040, 578.396, -7.6, -2274.170, 968.369, 200.000},
    {"Juniper Hollow", -2533.040, 968.369, -6.1, -2274.170, 1358.900, 200.000},
    {"Roca Escalante", 2237.400, 2202.760, -89.084, 2536.430, 2542.550, 110.916},
    {"Julius Thruway East", 2685.160, 1055.960, -89.084, 2749.900, 2626.550, 110.916},
    {"Verona Beach", 647.712, -2173.290, -89.084, 930.221, -1804.210, 110.916},
    {"Foster Valley", -2178.690, -599.884, -1.2, -1794.920, -324.114, 200.000},
    {"Arco del Oeste", -901.129, 2221.860, 0.000, -592.090, 2571.970, 200.000},
    {"Fallen Tree", -792.254, -698.555, -5.3, -452.404, -380.043, 200.000},
    {"The Farm", -1209.670, -1317.100, 114.981, -908.161, -787.391, 251.981},
    {"The Sherman Dam", -968.772, 1929.410, -3.0, -481.126, 2155.260, 200.000},
    {"Esplanade North", -1996.660, 1358.900, -4.5, -1524.240, 1592.510, 200.000},
    {"Financial", -1871.720, 744.170, -6.1, -1701.300, 1176.420, 300.000},
    {"Garcia", -2411.220, -222.589, -1.14, -2173.040, 265.243, 200.000},
    {"Montgomery", 1119.510, 119.526, -3.0, 1451.400, 493.323, 200.000},
    {"Creek", 2749.900, 1937.250, -89.084, 2921.620, 2669.790, 110.916},
    {"Los Santos International", 1249.620, -2394.330, -89.084, 1852.000, -2179.250, 110.916},
    {"Santa Maria Beach", 72.648, -2173.290, -89.084, 342.648, -1684.650, 110.916},
    {"Mulholland Intersection", 1463.900, -1150.870, -89.084, 1812.620, -768.027, 110.916},
    {"Angel Pine", -2324.940, -2584.290, -6.1, -1964.220, -2212.110, 200.000},
    {"Verdant Meadows", 37.032, 2337.180, -3.0, 435.988, 2677.900, 200.000},
    {"Octane Springs", 338.658, 1228.510, 0.000, 664.308, 1655.050, 200.000},
    {"Come-A-Lot", 2087.390, 943.235, -89.084, 2623.180, 1203.230, 110.916},
    {"Redsands West", 1236.630, 1883.110, -89.084, 1777.390, 2142.860, 110.916},
    {"Santa Maria Beach", 342.648, -2173.290, -89.084, 647.712, -1684.650, 110.916},
    {"Verdant Bluffs", 1249.620, -2179.250, -89.084, 1692.620, -1842.270, 110.916},
    {"Las Venturas Airport", 1236.630, 1203.280, -89.084, 1457.370, 1883.110, 110.916},
    {"Flint Range", -594.191, -1648.550, 0.000, -187.700, -1276.600, 200.000},
    {"Verdant Bluffs", 930.221, -2488.420, -89.084, 1249.620, -2006.780, 110.916},
    {"Palomino Creek", 2160.220, -149.004, 0.000, 2576.920, 228.322, 200.000},
    {"Ocean Docks", 2373.770, -2697.090, -89.084, 2809.220, -2330.460, 110.916},
    {"Easter Bay Airport", -1213.910, -50.096, -4.5, -947.980, 578.396, 200.000},
    {"Whitewood Estates", 883.308, 1726.220, -89.084, 1098.310, 2507.230, 110.916},
    {"Calton Heights", -2274.170, 744.170, -6.1, -1982.320, 1358.900, 200.000},
    {"Easter Basin", -1794.920, 249.904, -9.1, -1242.980, 578.396, 200.000},
    {"Los Santos Inlet", -321.744, -2224.430, -89.084, 44.615, -1724.430, 110.916},
    {"Doherty", -2173.040, -222.589, -1.0, -1794.920, 265.243, 200.000},
    {"Mount Chiliad", -2178.690, -2189.910, -47.917, -2030.120, -1771.660, 576.083},
    {"Fort Carson", -376.233, 826.326, -3.0, 123.717, 1220.440, 200.000},
    {"Foster Valley", -2178.690, -1115.580, 0.000, -1794.920, -599.884, 200.000},
    {"Ocean Flats", -2994.490, -222.589, -1.0, -2593.440, 277.411, 200.000},
    {"Fern Ridge", 508.189, -139.259, 0.000, 1306.660, 119.526, 200.000},
    {"Bayside", -2741.070, 2175.150, 0.000, -2353.170, 2722.790, 200.000},
    {"Las Venturas Airport", 1457.370, 1203.280, -89.084, 1777.390, 1883.110, 110.916},
    {"Blueberry Acres", -319.676, -220.137, 0.000, 104.534, 293.324, 200.000},
    {"Palisades", -2994.490, 458.411, -6.1, -2741.070, 1339.610, 200.000},
    {"North Rock", 2285.370, -768.027, 0.000, 2770.590, -269.740, 200.000},
    {"Hunter Quarry", 337.244, 710.840, -115.239, 860.554, 1031.710, 203.761},
    {"Los Santos International", 1382.730, -2730.880, -89.084, 2201.820, -2394.330, 110.916},
    {"Missionary Hill", -2994.490, -811.276, 0.000, -2178.690, -430.276, 200.000},
    {"San Fierro Bay", -2616.400, 1659.680, -3.0, -1996.660, 2175.150, 200.000},
    {"Restricted Area", -91.586, 1655.050, -50.000, 421.234, 2123.010, 250.000},
    {"Mount Chiliad", -2997.470, -1115.580, -47.917, -2178.690, -971.913, 576.083},
    {"Mount Chiliad", -2178.690, -1771.660, -47.917, -1936.120, -1250.970, 576.083},
    {"Easter Bay Airport", -1794.920, -730.118, -3.0, -1213.910, -50.096, 200.000},
    {"The Panopticon", -947.980, -304.320, -1.1, -319.676, 327.071, 200.000},
    {"Shady Creeks", -1820.640, -2643.680, -8.0, -1226.780, -1771.660, 200.000},
    {"Back o Beyond", -1166.970, -2641.190, 0.000, -321.744, -1856.030, 200.000},
    {"Mount Chiliad", -2994.490, -2189.910, -47.917, -2178.690, -1115.580, 576.083},
    {"Tierra Robada", -1213.910, 596.349, -242.990, -480.539, 1659.680, 900.000},
    {"Flint County", -1213.910, -2892.970, -242.990, 44.615, -768.027, 900.000},
    {"Whetstone", -2997.470, -2892.970, -242.990, -1213.910, -1115.580, 900.000},
    {"Bone County", -480.539, 596.349, -242.990, 869.461, 2993.870, 900.000},
    {"Tierra Robada", -2997.470, 1659.680, -242.990, -480.539, 2993.870, 900.000},
    {"San Fierro", -2997.470, -1115.580, -242.990, -1213.910, 1659.680, 900.000},
    {"Las Venturas", 869.461, 596.349, -242.990, 2997.060, 2993.870, 900.000},
    {"Red County", -1213.910, -768.027, -242.990, 2997.060, 596.349, 900.000},
    {"Los Santos", 44.615, -2892.970, -242.990, 2997.060, -768.027, 900.000}}
    for i, v in ipairs(streets) do
        if (x >= v[2]) and (y >= v[3]) and (z >= v[4]) and (x <= v[5]) and (y <= v[6]) and (z <= v[7]) then
            return v[1]
        end
    end
    return "Unknown"
end

function sampGetColor(id)
	a, r, g, b = explode_argb(sampGetPlayerColor(id))
	rgb = {r, g, b}
	local hexadecimal = ''

	for key, value in pairs(rgb) do
		local hex = ''

		while(value > 0)do
			local index = math.fmod(value, 16) + 1
			value = math.floor(value / 16)
			hex = string.sub('0123456789ABCDEF', index, index) .. hex
		end

		if(string.len(hex) == 0)then
			hex = '00'

		elseif(string.len(hex) == 1)then
			hex = '0' .. hex
		end

		hexadecimal = hexadecimal .. hex
	end

	return hexadecimal
end

function explode_argb(argb)
  local a = bit.band(bit.rshift(argb, 24), 0xFF)
  local r = bit.band(bit.rshift(argb, 16), 0xFF)
  local g = bit.band(bit.rshift(argb, 8), 0xFF)
  local b = bit.band(argb, 0xFF)
  return a, r, g, b
end

function getBodyPartCoordinates(id, handle)
  local pedptr = getCharPointer(handle)
  local vec = ffi.new("float[3]")
  getBonePosition(ffi.cast("void*", pedptr), vec, id, true)
  return vec[0], vec[1], vec[2]
end

function nameTagOn()
	local pStSet = sampGetServerSettingsPtr();
	NTdist = memory.getfloat(pStSet + 39)
	NTwalls = memory.getint8(pStSet + 47)
	NTshow = memory.getint8(pStSet + 56)
	memory.setfloat(pStSet + 39, 1488.0)
	memory.setint8(pStSet + 47, 0)
	memory.setint8(pStSet + 56, 1)
	nameTag = true
end

function nameTagOff()
	local pStSet = sampGetServerSettingsPtr();
	memory.setfloat(pStSet + 39, NTdist)
	memory.setint8(pStSet + 47, NTwalls)
	memory.setint8(pStSet + 56, NTshow)
	nameTag = false
end

function join_argb(a, r, g, b)
  local argb = b  -- b
  argb = bit.bor(argb, bit.lshift(g, 8))  -- g
  argb = bit.bor(argb, bit.lshift(r, 16)) -- r
  argb = bit.bor(argb, bit.lshift(a, 24)) -- a
  return argb
end

function isCharInAnyCar(ped)
	local vehicles = {602, 545, 496, 517, 401, 410, 518, 600, 527, 436, 589, 580, 419, 439, 533, 549, 526, 491, 474, 445, 467, 604, 426, 507, 547, 585, 405, 587, 409, 466, 550, 492, 566, 546, 540, 551, 421, 516, 529, 485, 552, 431, 438, 437, 574, 420, 525, 408, 416, 596, 433, 597, 427, 599, 490, 528, 601, 407, 428, 544, 470, 598, 499, 588, 609, 403, 498, 514, 524, 423, 532, 414, 578, 443, 486, 515, 406, 531, 573, 456, 455, 459, 543, 422, 583, 482, 478, 605, 554, 530, 418, 572, 582, 413, 440, 536, 575, 534, 567, 535, 576, 412, 402, 542, 603, 475, 568, 557, 424, 471, 504, 495, 457, 483, 508, 500, 444, 556, 429, 411, 541, 559, 415, 561, 480, 560, 562, 506, 565, 451, 434, 558, 494, 555, 502, 477, 503, 579, 400, 404, 489, 505, 479, 442, 458}
	for i, v in ipairs(vehicles) do
		if isCharInModel(ped, v) then return true end
	end
	return false
end

function stroboscopes(adress, ptr, _1, _2, _3, _4)
	if not isCharInAnyCar(PLAYER_PED) then return end

	if not isCarSirenOn(storeCarCharIsInNoSave(PLAYER_PED)) then
		forceCarLights(storeCarCharIsInNoSave(PLAYER_PED), 0)
		callMethod(7086336, ptr, 2, 0, 1, 3)
		callMethod(7086336, ptr, 2, 0, 0, 0)
		callMethod(7086336, ptr, 2, 0, 1, 0)
		markCarAsNoLongerNeeded(storeCarCharIsInNoSave(PLAYER_PED))
		return
	end

	callMethod(adress, ptr, _1, _2, _3, _4)
end

function strobe()
	while true do
		wait(0)

		if isCharInAnyCar(PLAYER_PED) and ini.set.strobes then

			local car = storeCarCharIsInNoSave(PLAYER_PED)
			local driverPed = getDriverOfCar(car)

			if isCarSirenOn(car) and PLAYER_PED == driverPed then

				local ptr = getCarPointer(car) + 1440
				forceCarLights(car, 2)
				wait(50)
				stroboscopes(7086336, ptr, 2, 0, 1, 3)

				while isCarSirenOn(car) do
					wait(0)
					for i = 1, 12 do
						wait(100)
						stroboscopes(7086336, ptr, 2, 0, 1, 0)
						wait(100)
						stroboscopes(7086336, ptr, 2, 0, 0, 0)
						stroboscopes(7086336, ptr, 2, 0, 1, 1)
						wait(100)
						stroboscopes(7086336, ptr, 2, 0, 0, 1)
						stroboscopes(7086336, ptr, 2, 0, 1, 0)
						wait(100)
						stroboscopes(7086336, ptr, 2, 0, 1, 0)
						stroboscopes(7086336, ptr, 2, 0, 1, 1)
						if not isCarSirenOn(car) or not isCharInAnyCar(PLAYER_PED) then break end
					end

					if not isCarSirenOn(car) or not isCharInAnyCar(PLAYER_PED) then break end

					for i = 1, 6 do
						wait(80)
						stroboscopes(7086336, ptr, 2, 0, 1, 3)
						stroboscopes(7086336, ptr, 2, 0, 0, 0)
						wait(80)
						stroboscopes(7086336, ptr, 2, 0, 1, 0)
						wait(80)
						stroboscopes(7086336, ptr, 2, 0, 0, 0)
						wait(80)
						stroboscopes(7086336, ptr, 2, 0, 1, 0)
						if not isCarSirenOn(car) or not isCharInAnyCar(PLAYER_PED) then break end
						wait(300)
						stroboscopes(7086336, ptr, 2, 0, 0, 1)
						wait(80)
						stroboscopes(7086336, ptr, 2, 0, 1, 1)
						wait(80)
						stroboscopes(7086336, ptr, 2, 0, 0, 1)
						wait(80)
						stroboscopes(7086336, ptr, 2, 0, 1, 1)
						if not isCarSirenOn(car) or not isCharInAnyCar(PLAYER_PED) then break end
					end

					if not isCarSirenOn(car) or not isCharInAnyCar(PLAYER_PED) then break end

					for i = 1, 3 do
						wait(60)
						stroboscopes(7086336, ptr, 2, 0, 1, 3)
						stroboscopes(7086336, ptr, 2, 0, 1, 0)
						stroboscopes(7086336, ptr, 2, 0, 0, 1)
						wait(60)
						stroboscopes(7086336, ptr, 2, 0, 1, 1)
						wait(60)
						stroboscopes(7086336, ptr, 2, 0, 0, 1)
						wait(60)
						stroboscopes(7086336, ptr, 2, 0, 1, 1)
						wait(60)
						stroboscopes(7086336, ptr, 2, 0, 0, 1)
						wait(60)
						stroboscopes(7086336, ptr, 2, 0, 1, 1)
						wait(60)
						stroboscopes(7086336, ptr, 2, 0, 0, 0)
						wait(60)
						if not isCarSirenOn(car) or not isCharInAnyCar(PLAYER_PED) then break end
						stroboscopes(7086336, ptr, 2, 0, 1, 0)
						wait(60)
						stroboscopes(7086336, ptr, 2, 0, 0, 0)
						wait(350)
						stroboscopes(7086336, ptr, 2, 0, 1, 0)
						stroboscopes(7086336, ptr, 2, 0, 0, 1)
						wait(60)
						if not isCarSirenOn(car) or not isCharInAnyCar(PLAYER_PED) then break end
						stroboscopes(7086336, ptr, 2, 0, 1, 1)
						stroboscopes(7086336, ptr, 2, 0, 0, 0)
						wait(50)
						stroboscopes(7086336, ptr, 2, 0, 1, 0)
						stroboscopes(7086336, ptr, 2, 0, 0, 1)
						wait(50)
						stroboscopes(7086336, ptr, 2, 0, 1, 1)
						stroboscopes(7086336, ptr, 2, 0, 0, 0)
						wait(100)
						stroboscopes(7086336, ptr, 2, 0, 1, 1)
						stroboscopes(7086336, ptr, 2, 0, 1, 1)
						wait(80)
						stroboscopes(7086336, ptr, 2, 0, 0, 1)
						stroboscopes(7086336, ptr, 2, 0, 0, 0)
						wait(100)
						if not isCarSirenOn(car) or not isCharInAnyCar(PLAYER_PED) then break end
						stroboscopes(7086336, ptr, 2, 0, 1, 1)
						stroboscopes(7086336, ptr, 2, 0, 1, 0)
						wait(80)
						stroboscopes(7086336, ptr, 2, 0, 0, 1)
						stroboscopes(7086336, ptr, 2, 0, 0, 0)
						wait(100)
						stroboscopes(7086336, ptr, 2, 0, 0, 1)
						stroboscopes(7086336, ptr, 2, 0, 1, 0)
						wait(80)
						stroboscopes(7086336, ptr, 2, 0, 1, 1)
						stroboscopes(7086336, ptr, 2, 0, 0, 0)
						if not isCarSirenOn(car) or not isCharInAnyCar(PLAYER_PED) then break end
					end

					if not isCarSirenOn(car) or not isCharInAnyCar(PLAYER_PED) then break end
				end
			end
		end
	end
end

function isKeyCheckAvailable()
  if not isSampfuncsLoaded() then
    return not isPauseMenuActive()
  end
  local result = not isSampfuncsConsoleActive() and not isPauseMenuActive()
  if isSampLoaded() and isSampAvailable() then
    result = result and not sampIsChatInputActive() and not sampIsDialogActive()
  end
  return result
end

function sampGetPlayerIdByNickname(nick)
	local successid = nil
    if type(nick) == ('string') then
        for id = 0, 1000 do
            local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
            if sampIsPlayerConnected(id) or id == myid then
                local name = sampGetPlayerNickname(id)
                if nick == name then
					local successid = id
                    return id
                end
            end
        end
		if not successid then return 'offline' end
    else
		return 'offline'
	end
end

function SCM(text)
	if text ~= nil then sampAddChatMessage('Helper for MIA • {FFFFFF}' .. text, 0xFF4169E1) end
end

function sampGetPatrolState()
	if isCharInModel(PLAYER_PED, 523) then
		return true, 'M', 'MARY'
	elseif isCharInModel(PLAYER_PED, 596) then
		return true, 'L', 'LINCOLN'
	elseif isCharInModel(PLAYER_PED, 597) then
		return true, 'L', 'LINCOLN'
	elseif isCharInModel(PLAYER_PED, 598) then
		return true, 'L', 'LINCOLN'
	elseif isCharInModel(PLAYER_PED, 599) then
		return true, 'L', 'LINCOLN'		
	elseif isCharInModel(PLAYER_PED, 427) then
		return true, 'C', 'CHARLIE'
	elseif isCharInModel(PLAYER_PED, 601) then
		return true, 'C', 'CHARLIE'
	elseif isCharInModel(PLAYER_PED, 490) then
		return true, 'C', 'CHARLIE'
	elseif isCharInModel(PLAYER_PED, 415) then
		return true, 'H', 'HENRY'
	elseif isCharInModel(PLAYER_PED, 487) then
		return true, 'AIR', 'AIR'
	elseif isCharInModel(PLAYER_PED, 497) then
		return true, 'AIR', 'AIR'
	end
	return false
end

function ItemActive(text)
	if text ~= nil then
		if imgui.IsItemHovered() then
			imgui.BeginTooltip()
				imgui.Text(u8(text))
			imgui.EndTooltip()
		end
	end
end

function apply_custom_style()
    imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4

	style.WindowRounding = 2.0
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
	style.ChildWindowRounding = 2.0
	style.FrameRounding = 2.0
	style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
	style.ScrollbarSize = 13.0
	style.ScrollbarRounding = 0
	style.GrabMinSize = 8.0
	style.GrabRounding = 1.0
	colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
	colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
	colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
	colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
	colors[clr.ComboBg]                = colors[clr.PopupBg]
	colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
	colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.FrameBg]                = ImVec4(0.16, 0.29, 0.48, 0.54)
	colors[clr.FrameBgHovered]         = ImVec4(0.26, 0.59, 0.98, 0.40)
	colors[clr.FrameBgActive]          = ImVec4(0.26, 0.59, 0.98, 0.67)
	colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
	colors[clr.TitleBgActive]          = ImVec4(0.16, 0.29, 0.48, 1.00)
	colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
	colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
	colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
	colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
	colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
	colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
	colors[clr.CheckMark]              = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.SliderGrab]             = ImVec4(0.24, 0.52, 0.88, 1.00)
	colors[clr.SliderGrabActive]       = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.Button]                 = ImVec4(0.26, 0.59, 0.98, 0.40)
	colors[clr.ButtonHovered]          = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.ButtonActive]           = ImVec4(0.06, 0.53, 0.98, 1.00)
	colors[clr.Header]                 = ImVec4(0.26, 0.59, 0.98, 0.31)
	colors[clr.HeaderHovered]          = ImVec4(0.26, 0.59, 0.98, 0.80)
	colors[clr.HeaderActive]           = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.Separator]              = colors[clr.Border]
	colors[clr.SeparatorHovered]       = ImVec4(0.26, 0.59, 0.98, 0.78)
	colors[clr.SeparatorActive]        = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.ResizeGrip]             = ImVec4(0.26, 0.59, 0.98, 0.25)
	colors[clr.ResizeGripHovered]      = ImVec4(0.26, 0.59, 0.98, 0.67)
	colors[clr.ResizeGripActive]       = ImVec4(0.26, 0.59, 0.98, 0.95)
	colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
	colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
	colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
	colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
	colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
	colors[clr.TextSelectedBg]         = ImVec4(0.26, 0.59, 0.98, 0.35)
	colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end

function imgui.CenterTextColoredRGB(text)
    local width = imgui.GetWindowWidth()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end

    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImColor(r, g, b, a):GetVec4()
    end

    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local textsize = w:gsub('{.-}', '')
            local text_width = imgui.CalcTextSize(u8(textsize))
            imgui.SetCursorPosX( width / 2 - text_width .x / 2 )
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else
                imgui.Text(u8(w))
            end
        end
    end
    render_text(text)
end

function imgui.TextColoredRGB(string)
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col

    local function color_imvec4(color)
        if color:upper() == 'SSSSSS' then return colors[clr.Text] end
        local color = type(color) == 'number' and ('%X'):format(color):upper() or color:upper()
        local rgb = {}
        for i = 1, #color/2 do rgb[#rgb+1] = tonumber(color:sub(2*i-1, 2*i), 16) end
        return imgui.ImVec4(rgb[1]/255, rgb[2]/255, rgb[3]/255, rgb[4] and rgb[4]/255 or colors[clr.Text].w)
    end

    local function render_text(string)
        local text, color = {}, {}
        local m = 1
        while string:find('{......}') do
            local n, k = string:find('{......}')
            text[#text], text[#text+1] = string:sub(m, n-1), string:sub(k+1, #string)
            color[#color+1] = color_imvec4(string:sub(n+1, k-1))
            local t1, t2 = string:sub(1, n-1), string:sub(k+1, #string)
            string = t1..t2
            m = k-7
        end
        if text[0] then
            for i, _ in ipairs(text) do
                imgui.TextColored(color[i] or colors[clr.Text], u8(text[i]))
                imgui.SameLine(nil, 0)
            end
            imgui.NewLine()
        else imgui.Text(u8(string)) end
    end

    render_text(string)
end

function imgui.ToggleButton(str_id, bool)

   local rBool = false

   if LastActiveTime == nil then
      LastActiveTime = {}
   end
   if LastActive == nil then
      LastActive = {}
   end

   local function ImSaturate(f)
      return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
   end

   local p = imgui.GetCursorScreenPos()
   local draw_list = imgui.GetWindowDrawList()

   local height = imgui.GetTextLineHeightWithSpacing() + (imgui.GetStyle().FramePadding.y / 2)
   local width = height * 1.55
   local radius = height * 0.50
   local ANIM_SPEED = 0.15

   if imgui.InvisibleButton(str_id, imgui.ImVec2(width, height)) then
      bool.v = not bool.v
      rBool = true
      LastActiveTime[tostring(str_id)] = os.clock()
      LastActive[str_id] = true
   end

   local t = bool.v and 1.0 or 0.0

   if LastActive[str_id] then
      local time = os.clock() - LastActiveTime[tostring(str_id)]
      if time <= ANIM_SPEED then
         local t_anim = ImSaturate(time / ANIM_SPEED)
         t = bool.v and t_anim or 1.0 - t_anim
      else
         LastActive[str_id] = false
      end
   end

   local col_bg
   if imgui.IsItemHovered() then
      col_bg = imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.FrameBgHovered])
   else
      col_bg = imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.FrameBg])
   end

   draw_list:AddRectFilled(p, imgui.ImVec2(p.x + width, p.y + height), col_bg, height * 0.5)
   draw_list:AddCircleFilled(imgui.ImVec2(p.x + radius + t * (width - radius * 2.0), p.y + radius), radius - 1.5, imgui.GetColorU32(bool.v and imgui.GetStyle().Colors[imgui.Col.ButtonActive] or imgui.GetStyle().Colors[imgui.Col.Button]))

   return rBool
end

function sampev.onServerMessage(color, text)
	logchat[tonumber(table.maxn(logchat)) + 1] = '{ffffff}CHAT\t   [' .. os.date('%H') .. ':' .. os.date('%M') .. ':' .. os.date('%S') .. '] ' .. text

	if color == 13369599 and text:find('Отправил') and not ini.set.stopad then return false end

	if text:find('  Объявление проверил сотрудник СМИ (.+)') and not ini.set.stopad then return false end

	if color == 869033727 and text:find('[R]') and ini.set.radio then
		text = string.sub(text, 5)
		text = string.gsub(text, '_', ' ')
		sampAddChatMessage('[TAC-1] '..text,0x9ACD32)
		return false
	end

	if color == 1721355519 and text:find('[F]') and ini.set.radio then
		text = string.sub(text, 5)
		text = string.gsub(text, '_', ' ')
		sampAddChatMessage('[TAC-2] '..text,0x20B2AA)
		return false
	end

	if text:find('Вы оглушили (.+) на 15 секунд') then
		if ini.info.male then
			if getCurrentCharWeapon(PLAYER_PED) == 3 then
				sampSendChat('/me размахнувшись, ударил нарушителя дубинкой, тем самым оглушил его')
			else
				sampSendChat('/me выхватив тэйзер, нажал на кнопку спуска, тем самым парализовал нарушителя')
			end
		else
			if getCurrentCharWeapon(PLAYER_PED) == 3 then
				sampSendChat('/me размахнувшись, ударила нарушителя дубинкой, тем самым оглушила его')
			else
				sampSendChat('/me выхватив тэйзер, нажала на кнопку спуска, тем самым парализовала нарушителя')
			end
		end
	end

	if text:find('Сотрудники ФБР взломали дверь Вашего дома!') and color == -10092289 and ini.set.antifbi then
		sampSendChat('/home')
		antifbi = true
		return true
	end

	if text:match('(.+) не удалось взломать дверь у дома №(%d+)') and color == -577699841 then
		name, homeid = text:match('(.+)[%s]не[%s]удалось[%s]взломать[%s]дверь[%s]у[%s]дома[%s]№(%d+)')
		_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
		if name == sampGetPlayerNickname(id) then
			lua_thread.create(function()
				wait(1000)
				if ini.info.male then
					sampSendChat('/me повторно размахнулся дубинкой и ударил тыльной частью по замку')
				else
					sampSendChat('/me повторно размахнулась дубинкой и ударила тыльной частью по замку')
				end
				wait(1000); sampSendChat('/hack ' .. homeid)
			end)
		end
		return true
	end

	if text:match('(.+) принимает Ваше предложение') then 
		if inv_id ~= nil and inv_rang ~= nil then
			lua_thread.create(function()
				if tonumber(inv_rang) > 1 then
					for i = 2, tonumber(inv_rang) do
						sampSendChat('/rang ' .. inv_id .. ' +')
						wait(800)
					end
				end
				sampSendChat('/r ' .. ini.info.rteg .. ' Новый сотрудник - ' .. string.gsub(sampGetPlayerNickname(inv_id),'_',' ') .. '.')
				inv_id, inv_rang = nil
			end)
		end
		return true
	end
	
	if text:match('(.+)[^%d](%d+)[^%d] был обнаружен в районе') then
		local name, id = string.match(text, '(.+)[^%d](%d+)[^%d] был обнаружен в районе')
		if IPC(id) then
			SCM(string.format('Чтобы объявить %s[%d] в розыск по статье 2.1 ЕПК нажмите сочетание клавиш ПКМ + 4.', sampGetPlayerNickname(id), id))
			suspect_id = {id, 1, '2.1 ЕПК'}
		end
	end
end

function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
	if string.find(title,'Меню игрока') and act then
		sampSendDialogResponse(dialogId, 1, 5, -1)
		return false
	end

	if string.find(title, 'В подразделении') then
		lines = '{FFFFFF}Имя	{FFFFFF}Ранг и должность	{FFFFFF}Телефон	{FFFFFF}Дополнительно'
		for s in string.gmatch(text, "[^\n]+") do
			if string.match(s, '(%d+). (.+)	(%d+) ранг. (.+)	(%d+)	(.+)') then
				local num, name, rang, namerang, number, state = string.match(s, '(%d+). (.+)	(%d+) ранг. (.+)	(%d+)	(.+)')
				lines = string.format('%s\n{ffffff}%d. %s	%d ранг. %s	%d	{ff5c33}%s', lines, num, name, rang, namerang, number, state)

			elseif string.match(s, '(%d+). (.+)	(%d+) ранг. (.+)	(%d+)') then
				local num, name, rang, namerang, number = string.match(s, '(%d+). (.+)	(%d+) ранг. (.+)	(%d+)')
				lines = string.format('%s\n{ffffff}%d. %s	%d ранг. %s	%d	{00cc99}Онлайн', lines, num, name, rang, namerang, number)
			end
		end
		sampShowDialog(dialogId, title, lines, button1, button2, style)
		sampSetDialogClientside()
		return false
	end

	if string.find(title,'Связь с администрацией') and act then
		sampSendDialogResponse(dialogId, 1, 0, report)
		act = false
		return false
	end

	if string.find(title, 'Точное время') and dialogId == 176 then
		local playh, playm = text:match('{FFFFFF}Время в игре сегодня:		{ffcc00}(%d+) ч (%d+) мин')
		local afkh, afkm = text:match('{FFFFFF}AFK за сегодня:		{FF7000}(%d+) ч (%d+) мин')
		local aplayh, aplaym = text:match('{FFFFFF}Время в игре вчера:		{ffcc00}(%d+) ч (%d+) мин')
		local aafkh, aafkm = text:match('{FFFFFF}AFK за вчера:			{FF7000}(%d+) ч (%d+) мин')
		clearh = tonumber(playh) - tonumber(afkh)
		clearm = tonumber(playm) - tonumber(afkm)
		aclearh = tonumber(aplayh) - tonumber(aafkh)
		aclearm = tonumber(aplaym) - tonumber(aafkm)
		if clearm < 0 then clearh = clearh - 1; clearm = 60 + clearm end
		if aclearm < 0 then aclearh = aclearh - 1; aclearm = 60 + aclearm end
		sampShowDialog(1009, title, text .. '\n{FFFFFF}Чистый онлайн:		{6495ED}' .. clearh .. ' ч ' .. clearm .. ' мин\n{FFFFFF}Чистый онлайн вчера:		{6495ED}' .. aclearh .. ' ч ' .. aclearm .. ' мин', button1, button2, 0)
		return false
	end

	if string.find(title, '{FFCD00}Информация о сотруднике') then
		local playh, playm = text:match('{FFFFFF}Время в игре сегодня: {aa80ff}(%d+) ч (%d+) мин')
		local afkh, afkm = text:match('{FFFFFF}AFK сегодня: {FF7000}(%d+) ч (%d+) мин')
		local aplayh, aplaym = text:match('{FFFFFF}Время в игре вчера: {aa80ff}(%d+) ч (%d+) мин')
		local aafkh, aafkm = text:match('{FFFFFF}AFK вчера: {FF7000}(%d+) ч (%d+) мин')
		clearh = tonumber(playh) - tonumber(afkh)
		clearm = tonumber(playm) - tonumber(afkm)
		aclearh = tonumber(aplayh) - tonumber(aafkh)
		aclearm = tonumber(aplaym) - tonumber(aafkm)
		if clearm < 0 then clearh = clearh - 1; clearm = 60 + clearm end
		if aclearm < 0 then aclearh = aclearh - 1; aclearm = 60 + aclearm end
		sampShowDialog(dialogId, title, text .. '\n{FFFFFF}Чистый онлайн: {6495ED}' .. clearh .. ' ч ' .. clearm .. ' мин\n{FFFFFF}Чистый онлайн вчера: {6495ED}' .. aclearh .. ' ч ' .. aclearm .. ' мин', button1, button2, 0)
		sampSetDialogClientside()
		return false
	end

	if string.find(title, 'Лидеры') and ini.set.upleader then
		local dline = 'Имя\tОрганизация\tДолжность\tСтатус\n'
		local all = 0
		local online = 0
		
		for line in string.gmatch(text, "[^\n]+") do
			if not string.find(line, 'Имя') then
				local name, rang, frac, state = string.match(line, '(.+)	(.+)	(.+)	(.+)')
				local id = sampGetPlayerIdByNickname(name)
				all = all + 1
				if id == 'offline' then
					dline = string.format('%s{696969}%s\t{696969}%s\t{696969}%s\t{ff5c33}Оффлайн\n', dline, name, rang, frac)
				else
					res, ped = sampGetCharHandleBySampPlayerId(id)
					online = online + 1
					if res then
						dist = math.floor(sampGetDistance(PLAYER_PED, id))
						if sampIsPlayerPaused(id) then
							dline = string.format('%s{%s}%s\t%s\t%s\t{ff5c33}Дист: %d м\n', dline, sampGetColor(id), name, rang, frac, dist)
						else
							dline = string.format('%s{%s}%s\t%s\t%s\t{00cc99}Дист: %d м\n', dline, sampGetColor(id), name, rang, frac, dist)
						end
					else
						dline = string.format('%s{%s}%s\t%s\t%s\t{00cc99}Онлайн\n', dline, sampGetColor(id), name, rang, frac)
					end
				end
			end
		end
		caption = string.format('{ffffff}Всего лидеров {FFCD00}%d чел. {00CC66}(онлайн %d)', all, online)
		
		sampShowDialog(dialogId, caption, dline, 'Подробнее', 'Закрыть', 5)
		sampSetDialogClientside()
		return false
	end

	if string.find(title, 'Паспорт') and autopass and ini.set.autopass then
		for s in string.gmatch(text, "[^\n]+") do
			if string.match(s, '{FFFFFF}Уровень розыска:		{80aaff}(%d+)') then
				stars = string.match(s, '{FFFFFF}Уровень розыска:		{80aaff}(%d+)')
				lua_thread.create(function()
					if ini.info.male then
						sampSendChat('/me внимательно изучил паспорт и передал информацию диспетчеру')
					else
						sampSendChat('/me внимательно изучила паспорт и передала информацию диспетчеру')
					end

					if tonumber(stars) > 0 then
						wait(1500); sampSendChat('/todo Получив информацию от диспетчера*Вы находитесь в федеральном розыске.')
						wait(1000); sampSendChat('Вам необходимо проехать со мной в ближайщий полицейский департамент.')
					else
						wait(1500); sampSendChat('/todo Получив информацию от диспетчера и вернув паспорт*С документами всё хорошо.')
					end
				end)
			end
		end
		sampSendDialogResponse(dialogId, 1, 0, 0)
		autopass = false
		return false
	end

	if string.find(title, 'Параметры дома') and antifbi then
		sampSendDialogResponse(dialogId, 1, 1, -1)
		antifbi = false
		return false
	end

	if string.find(title, 'Тюрьма') or string.find(title, 'ФБР') and dialogId == 175 then
		if ini.set.autoweapon then
			for i = 1, 12 do
				if ini.weapon[InfoWeapon[i][3]] then
					if i ~= 4 then sampSendDialogResponse(175, 1, i - 1, -1) end
					if i > 4 and ini.set.doblebullet then sampSendDialogResponse(175, 1, i - 1, -1) end
				end
			end
		end

		if ini.set.sniperpd and ini.set.autoweapon then
			sampSendDialogResponse(175, 1, 9, -1)
			if ini.set.doblebullet then sampSendDialogResponse(175, 1, 9, -1) end
		end
	end
end

function sampev.onPlayerChatBubble(id, color, dis, dur, mess)
	if not string.find(mess, 'На паузе') and IPC(id) then
		logchat[tonumber(table.maxn(logchat)) + 1] = 'BUBBLE\t[' .. os.date('%H') .. ':' .. os.date('%M') .. ':' .. os.date('%S') .. '] ' .. sampGetPlayerNickname(id) .. '[' .. id .. ']: ' .. mess
    end
end

function sampev.onSendTakeDamage(playerId, damage, weapon, bodypart)
	if playerId ~= nil and damage ~= nil and weapon ~= nil and bodypart ~= nil then
		if IPC(playerId) then
			logdmg[tonumber(table.maxn(logdmg)) + 1] = '{ffffff}You {CD5C5C}<< {' .. sampGetColor(playerId) .. '}' .. sampGetPlayerNickname(playerId) .. '[' .. playerId .. ']{ffffff} by ' .. sampGetWeaponName(weapon) .. ' [{4876FF}' .. weapon .. '{ffffff}] ' .. sampGetBodyPart(bodypart) .. ' [{4876FF}' .. bodypart .. '{ffffff}] DMG[{FFD700}' .. math.floor(damage) .. '{ffffff}] HP[{EE3B3B}' .. sampGetPlayerHealth(playerId) .. '{ffffff}] ARM[{778899}' .. sampGetPlayerArmor(playerId) .. '{ffffff}]'

			if sampGetDistance(PLAYER_PED, playerId) <= 35 and sampGetPlayerColor(playerId) ~= 4294954240 then
				if TypeWeapon[tonumber(weapon)] == 2 then
					SCM(string.format('Чтобы объявить %s[%d] в розыск по статье 1.2 ЕПК нажмите сочетание клавиш ПКМ + 4.', sampGetPlayerNickname(playerId), playerId))
					suspect_id = {playerId, 2, '1.2 ЕПК'}
				elseif TypeWeapon[tonumber(weapon)] == 3 then
					SCM(string.format('Чтобы объявить %s[%d] в розыск по статье 1.3 ЕПК нажмите сочетание клавиш ПКМ + 4.', sampGetPlayerNickname(playerId), playerId))
					suspect_id = {playerId, 5, '1.3 ЕПК'}
				elseif tonumber(weapon) == 49 then
					local res, ped = sampGetCharHandleBySampPlayerId(playerId)
					if res then
						if isCharInAnyCar(ped) then
						local carh = storeCarCharIsInNoSave(hm)
							if getDriverOfCar(carh) == ped then
								SCM(string.format('Чтобы объявить %s[%d] в розыск по статье 7.9 ЕПК нажмите сочетание клавиш ПКМ + 4.', sampGetPlayerNickname(playerId), playerId))
								suspect_id = {playerId, 1, '7.9 ЕПК'}
							end
						end
					end
				else
					SCM(string.format('Чтобы объявить %s[%d] в розыск по статье 1.1 ЕПК нажмите сочетание клавиш ПКМ + 4.', sampGetPlayerNickname(playerId), playerId))
					suspect_id = {playerId, 1, '1.1 ЕПК'}
				end
			end
		end
	end
end

function sampev.onSendGiveDamage(playerId, damage, weapon, bodypart)
	if playerId ~= nil and damage ~= nil and weapon ~= nil and bodypart ~= nil then
		if IPC(playerId) then
			logdmg[tonumber(table.maxn(logdmg)) + 1] = '{ffffff}You {9ACD32}>> {' .. sampGetColor(playerId) .. '}' .. sampGetPlayerNickname(playerId) .. '[' .. playerId .. ']{ffffff} by ' .. sampGetWeaponName(weapon) .. ' [{4876FF}' .. weapon .. '{ffffff}] ' .. sampGetBodyPart(bodypart) .. ' [{4876FF}' .. bodypart .. '{ffffff}] DMG[{FFD700}' .. math.floor(damage) .. '{ffffff}] HP[{EE3B3B}' .. sampGetPlayerHealth(playerId) .. '{ffffff}] ARM[{778899}' .. sampGetPlayerArmor(playerId) .. '{ffffff}]'
		end
	end
end

function sampev.onSendDeathNotification(reas, id)
	if reas ~= nil then
		dreason[1] = calculateZone()
		dreason[2] = os.date('%H')
		dreason[3] = os.date('%M')
		dreason[4] = os.date('%S')
	end
end

function sampev.onSendCommand(param)
    if string.match(param, '(.+) (%d+)') then file, id = string.match(param, '(.+) (%d+)') else file = param end
	if io.open('moonloader//helper/commands//' .. file .. '.txt') then
		lua_thread.create(function()
			local FileRead = io.open('moonloader//helper/commands//' .. file .. '.txt', 'r+')
			local params = FileRead:read('*l')
			FileRead:close()
			if string.match(params, '{param = 0}') then
				if string.match(param, '(%a)') then
					for line in io.lines('moonloader//helper/commands//' .. file .. '.txt') do
						if string.match(line, 'text: (.+)') or string.match(line, 'send: (.+)') then
							local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
							local line = line:gsub('{name}', ini.info.name)
							local line = line:gsub('{rTeg}', ini.info.rteg)
							local line = line:gsub('{fTeg}', ini.info.fteg)
							local line = line:gsub('{frac}', ini.info.frac)
							local line = line:gsub('{num}', '№000' .. ini.info.number)
							local line = line:gsub('{rang}', ini.info.rang)
							local line = line:gsub('{myid}', id)
							local line = line:gsub('{hello}', sampGetHelloByTime())
							local line = line:gsub('{area}', calculateZone())
							local line = line:gsub('{kvadrat}', kvadrat())
							local line = line:gsub('{time}', os.date('%X'))
							local line = line:gsub('{date}', os.date('%x'))
							
							if string.match(line, 'text: (.+)') then 
								sampSendChat(string.match(line, 'text: (.+)')) 
							elseif string.match(line, 'send: (.+)') then
								SCM(string.match(line, 'send: (.+)')) 
							end
						elseif string.match(line, 'sleep: (%d+)') then
							wait(string.match(line, 'sleep: (%d+)'))
						elseif string.match(line, '{param = (%d+)}') then
							wait(0)
						else
							SCM('Ошибка. Неизсветнная линия: ' .. line .. '.')
						end
					end
				end
			elseif string.match(params, '{param = 1}') then 
				if string.match(param, '(.+) (%d+)') then
					if IPC(id) then
						for line in io.lines('moonloader//helper/commands//' .. file .. '.txt') do
							if string.match(line, 'text: (.+)') or string.match(line, 'send: (.+)') then
								local _, pid = sampGetPlayerIdByCharHandle(PLAYER_PED)
								local line = line:gsub('{name}', ini.info.name)
								local line = line:gsub('{rTeg}', ini.info.rteg)
								local line = line:gsub('{fTeg}', ini.info.fteg)
								local line = line:gsub('{frac}', ini.info.frac)
								local line = line:gsub('{num}', '№000' .. ini.info.number)
								local line = line:gsub('{rang}', ini.info.rang)
								local line = line:gsub('{hello}', sampGetHelloByTime())
								local line = line:gsub('{area}', calculateZone())
								local line = line:gsub('{kvadrat}', kvadrat())
								local line = line:gsub('{time}', os.date('%X'))
								local line = line:gsub('{date}', os.date('%x'))
								local line = line:gsub('{id}', id)
								local line = line:gsub('{myid}', pid)
								local line = line:gsub('{name_id}', string.gsub(sampGetPlayerNickname(id),'_',' '))
								local line = line:gsub('{color_id}', '{' .. sampGetColor(id) .. '}')
								local line = line:gsub('{ping_id}', sampGetPlayerPing(id))
								local line = line:gsub('{score_id}', sampGetPlayerScore(id))
								local line = line:gsub('{frac_id}', sampGetPlayerFractionByid(id))

								if string.match(line, 'text: (.+)') then 
									sampSendChat(string.match(line, 'text: (.+)')) 
								elseif string.match(line, 'send: (.+)') then
									SCM(string.match(line, 'send: (.+)')) 
								end
							elseif string.match(line, 'sleep: (%d+)') then
								wait(string.match(line, 'sleep: (%d+)'))
							elseif string.match(line, '{param = (%d+)}') then
								wait(0)
							else
								SCM('Ошибка. Неизсветнная линия: ' .. line .. '.')
							end
						end
					else
						SCM('Данный игрок не подключён к серверу. Проверьте правильность введёного ID.')
					end
				else
					SCM('Используйте команду ' .. file .. ' [ид игрока].')
				end 
			else
				SCM('В команде не заданы параметры.')
			end
		end)
	end
end

function autoupdate(json_url, url) -- Author: http://qrlk.me/samp
  local dlstatus = require('moonloader').download_status
  local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
  if doesFileExist(json) then os.remove(json) end
  downloadUrlToFile(json_url, json,
    function(id, status, p1, p2)
      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
        if doesFileExist(json) then
          local f = io.open(json, 'r')
          if f then
            local info = decodeJson(f:read('*a'))
            updatelink = info.updateurl
            updateversion = info.latest
            f:close()
            os.remove(json)
            if updateversion ~= thisScript().version then
              lua_thread.create(function()
                local dlstatus = require('moonloader').download_status
                SCM('Обнаружено новое обновление.')
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('Загружено %d из %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      --SCM('Обновление завершено.')
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
						SCM('Обновление не было установлено.')
                        update = false
                      end
                    end 
                  end
                )
                end, prefix
              )
            else
              update = false
              SCM('Вы используйте актуальную версию скрипта.')
            end
          end
        else
          SCM('Произошла ошибка при попытке обновления скрипта.')
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end