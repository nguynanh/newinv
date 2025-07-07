Config = {}
Config.AdminDebug = true
Config.distance = 1.5 -- Khoảng cách để tương tác với điểm sửa
Config.Car = "burrito" 
Config.PlatePrefix = "ELE"
Config.RepairHeight = 3.8
-- [[THAY ĐỔI]] Cấu trúc trả tiền mới cho từng loại công việc
Config.Payments = {
    ladder_normal = {min = 1500, max = 2500}, -- Tiền công cho việc sửa trên thang thường
    ladder_high   = {min = 3000, max = 4500}, -- Tiền công cho việc sửa trên thang cao
    ground        = {min = 1000, max = 1800}, -- Tiền công cho việc sửa dưới đất
}

Config.Account = 'bank' -- This is where the money is go.
Config.EnableJobGiverNpc = true -- Đặt là true để BẬT NPC, false để TẮT
Config.JobGiverNpcModel = 's_m_m_autoshop_01'
Config.RentalCost = 1000 -- Số tiền phải trả để thuê xe khi bắt đầu công việc
Config.RefundAmount = 500 -- Số tiền được hoàn lại khi trả xe
Config.ReturnVehicleMaxDistance = 15.0

Config.NormalLadderModel = "hw1_06_ldr_" -- Thang tiêu chuẩn
Config.TallLadderModel = "hw1_06_ldr_04"   -- Thang cao mới bạn yêu cầu

-- Tạo một bảng mới cho các vị trí cần thang cao
Config.HighRepairLocations = {
    -- Thêm các tọa độ vector4 của các điểm sửa chữa trên cao vào đây
    vector4(740.97, 123.97, 79.75, 111.93),
}

-- THAY ĐỔI: Thay thế Config.postes bằng các điểm sửa chữa cố định
Config.RepairLocations = {
    vector4(740.99, 141.18, 80.76, 17.60),
	vector4(736.96, 134.0, 80.73, 69.87),
    -- Thêm các vector4 khác vào đây nếu bạn muốn có thêm điểm sửa
}

Config.TiempoParaArreglar = 6  -- Segundos

Config.EnableGroundRepairs = true -- Đặt là true để bật loại công việc này

Config.GroundRepairLocations = {
    vector3(758.47, 137.16, 78.95),
    -- Thêm các tọa độ vector3 khác vào đây
}

Config.GroundRepairTime = 8  -- Thời gian (giây) để hoàn thành việc sửa chữa dưới đất
Config.GroundRepairAnimation = {
    lib = 'mini@repair',
    anim = 'fixing_a_ped'
}

Config.Locales = {
	iniciarrepa = "PRESIONA  ~b~Y~w~  PARA INICIAR LA REPARACION",
	ponerescalera = "PRESIONA  ~b~Y~w~  PARA ĐẶT THANG",
	sacarescalera = "PRESIONA  ~b~Y~w~  PARA LẤY LẠI THANG",
	espera = "Espera ~b~ ", -- ..seconds 
	tofinish = "~w~ segundos para terminar de reparar.",
	startjob = "PRESIONA  ~b~E~w~  PARA INICIAR EL TRABAJO",
	jobiniciado = "Trabajo iniciado, ve a un estacionamiento.",
	endjob = "PRESSIONE  ~b~E~w~  PARA TERMINAR EL TRABAJO",
	jobterminado = "Terminaste tu trabajo, te espero otro dia!",
	saveescalera = "PRESIONA  ~b~E~w~  PARA GUARDAR LA ESCALERA",
	cogerescala = "PRESIONA  ~b~E~w~  PARA COGER LA ESCALERA"
}

---qbcore clothes--
Config.Uniforms = {
	['male'] = {
		outfitData = {
			['t-shirt'] = {item = 15, texture = 0},
			['torso2']  = {item = 56, texture = 0},
			['arms']    = {item = 85, texture = 0},
			['pants']   = {item = 45, texture = 4},
			['shoes']   = {item = 42, texture = 2},
		}
	},
	['female'] = {
	 	outfitData = {
			['t-shirt'] = {item = 14, texture = 0},
			['torso2']  = {item = 22, texture = 0},
			['arms']    = {item = 85, texture = 0},
			['pants']   = {item = 47, texture = 4},
			['shoes']   = {item = 98, texture = 1},
	 	}
	},
}