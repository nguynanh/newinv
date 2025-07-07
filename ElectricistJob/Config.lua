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
	vector4(748.44, 2586.41, 74.62, 45.53),
	vector4(524.39, 2696.72, 42.40, 180.93),
	vector4(300.42, 2623.25, 44.59, 186.05),
	vector4(291.95, 2585.52, 44.51, 220.32),
	vector4(300.12, 3407.43, 37.31, 321.20),
	vector4(815.94, 3542.13, 34.16, 225.38),
    vector4(1249.73, 3547.68, 34.98, 190.46),
	vector4(1678.27, 3774.96, 34.64, 186.70),
	vector4(1996.22, 3800.94, 32.20, 253.91),
	vector4(2087.57, 3694.14, 34.81, 315.96),
    vector4(2437.35, 4083.84, 38.57, 257.31),
	vector4(2756.27, 4420.39, 48.64, 302.64),
	vector4(2930.73, 4409.92, 49.24, 196.25),
	vector4(1673.83, 4922.37, 42.05, 56.06),
	vector4(1685.38, 4792.75, 41.92, 137.54),
	vector4(1686.99, 4647.28, 43.51, 102.31),
    vector4(1984.33, 4658.80, 41.32, 194.44),
	vector4(91.27, 6631.86, 31.50, 49.36),
	vector4(-157.29, 6489.39, 29.64, 185.35),
	vector4(-394.02, 6150.89, 31.47, 346.01),
	vector4(-75.21, 6447.54, 31.42, 111.01),
	vector4(-48.00, 6304.30, 31.55, 357.23),
	vector4(-211.55, 6144.90, 31.44, 139.47),
	vector4(-262.63, 6095.46, 31.38, 123.97),
}

-- THAY ĐỔI: Thay thế Config.postes bằng các điểm sửa chữa cố định
Config.RepairLocations = {
	vector4(1008.02, 2701.30, 39.55, 71.35),
	vector4(909.61, 2707.69, 40.55, 134.08),
	vector4(760.75, 2539.07, 73.91, 235.26),
	vector4(572.04, 2647.79, 41.71, 20.75),
	vector4(572.33, 2702.16, 41.96, 203.08),
	vector4(313.29, 2597.21, 44.22, 309.25),
	vector4(249.88, 2648.82, 44.96, 310.23),
	vector4(252.74, 2731.62, 43.58, 274.02),
	vector4(265.74, 3356.39, 38.94, 62.47),
	vector4(549.76, 3532.08, 33.58, 26.18),
	vector4(985.69, 3549.72, 33.70, 176.85),
	vector4(1298.76, 3562.62, 35.02, 294.28),
    vector4(1452.93, 3619.21, 34.71, 313.05),
	vector4(1577.08, 3794.96, 34.58, 254.35),
    vector4(1810.71, 3776.16, 33.56, 37.64),
	vector4(2020.57, 3669.80, 34.00, 58.22),
	vector4(2389.88, 3964.67, 36.73, 44.41),
	vector4(2732.54, 4434.26, 44.63, 126.19),
	vector4(1698.69, 4619.77, 43.16, 124.92),
	vector4(39.12, 6624.56, 31.78, 49.98),
	vector4(-31.29, 6609.87, 30.16, 128.73),
	vector4(-65.68, 6583.78, 29.48, 135.95),
    vector4(-109.63, 6543.74, 29.47, 168.15),
	vector4(-139.40, 6512.01, 29.51, 146.68),
	vector4(-187.52, 6472.60, 30.44, 326.87),
	vector4(-350.22, 6288.12, 30.39, 202.07),
	vector4(-305.95, 6210.09, 31.48, 155.45),
	vector4(-311.34, 6248.23, 31.42, 226.49),
	vector4(-190.52, 6355.52, 31.47, 296.50),
	vector4(-134.56, 6431.81, 31.41, 10.00),
	vector4(-141.30, 6382.60, 31.53, 34.44),
	vector4(-235.89, 6286.57, 31.43, 129.52),
	vector4(-393.79, 6128.40, 31.48, 120.66),
	vector4(-283.84, 6092.89, 31.45, 313.36),
	vector4(-265.46, 6111.34, 31.49, 308.02),
	vector4(-247.89, 6163.52, 31.56, 34.15),
	vector4(-72.63, 6285.05, 31.49, 123.69),
    -- Thêm các vector4 khác vào đây nếu bạn muốn có thêm điểm sửa
}

Config.TiempoParaArreglar = 6  -- Segundos

Config.EnableGroundRepairs = true -- Đặt là true để bật loại công việc này

Config.GroundRepairLocations = {
    vector3(758.47, 137.16, 78.95),
	vector3(1203.97, 2709.73, 38.0),
	vector3(1153.34, 2650.72, 38.0),
	vector3(1033.97, 2660.56, 39.55),
	vector3(734.32, 2576.6, 75.35),
	vector3(730.27, 2534.58, 73.23),
	vector3(571.23, 2666.6, 42.0),
	vector3(310.55, 2621.39, 44.47),
	vector3(182.66, 2802.63, 45.66),
	vector3(180.76, 3022.68, 44.04),
	vector3(242.57, 3097.3, 42.49),
	vector3(332.44, 3388.72, 36.4),
	vector3(433.08, 3564.6, 33.24),
	vector3(472.49, 3563.81, 33.24),
	vector3(920.86, 3650.61, 32.5),
	vector3(996.36, 3575.08, 34.61),
	vector3(1387.04, 3603.91, 34.89),
    vector3(1549.93, 3801.63, 34.25),
	vector3(1700.31, 3759.31, 34.44),
	vector3(1954.75, 3754.28, 32.18),
	vector3(1986.62, 3784.14, 32.27),
    vector3(2059.23, 3691.83, 34.59),
    vector3(2411.91, 4016.63, 36.51),
    vector3(2464.55, 4093.83, 38.06),
	vector3(2504.23, 4089.41, 38.64),
	vector3(2518.75, 4118.65, 38.63),
	vector3(2847.72, 4453.13, 48.5),
	vector3(2868.73, 4420.47, 48.85),
	vector3(2903.19, 4481.39, 48.12),
	vector3(2682.75, 4573.08, 40.62),
	vector3(1699.45, 4917.29, 42.08),
    vector3(1677.75, 4850.9, 42.06),
    vector3(1694.12, 4815.83, 41.97),
	vector3(1700.54, 4759.95, 42.01),
	vector3(1799.5, 4603.51, 37.68),
	vector3(2150.8, 4774.78, 41.14),
	vector3(113.22, 6639.34, 31.8),
	vector3(36.83, 6632.81, 31.48),
	vector3(-16.66, 6618.77, 30.66),
	vector3(-70.73, 6579.91, 29.47),
	vector3(-253.92, 6401.85, 31.01),
	vector3(-363.5, 6282.87, 30.27),
	vector3(-398.35, 6196.46, 31.5),
	vector3(-421.54, 6169.29, 31.48),
	vector3(-364.89, 6182.21, 31.37),
	vector3(-332.62, 6214.89, 31.36),
	vector3(-292.62, 6255.15, 31.46),
	vector3(-225.18, 6333.0, 32.31),
	vector3(-133.77, 6408.93, 31.47),
	vector3(-85.29, 6461.21, 31.51),
	vector3(-53.75, 6494.28, 31.44),
	vector3(-177.99, 6342.2, 31.46),
	vector3(-214.84, 6307.03, 31.43),
	vector3(-402.74, 6099.79, 31.46),
	vector3(-416.6, 6065.79, 31.64),
	vector3(-380.62, 6039.96, 31.5),
	vector3(-294.77, 6096.47, 31.38),
	vector3(-268.84, 6122.27, 31.4),
	vector3(-225.95, 6172.53, 31.45),
	vector3(-119.84, 6278.39, 31.18),
	vector3(-112.89, 6220.42, 31.32),
	vector3(-144.6, 6211.77, 31.19),
	vector3(-227.13, 6130.68, 31.44),
	vector3(-286.46, 6021.98, 31.47),

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