Config = {}
Config.distance = 5.0
Config.Car = "comet2"
Config.Plate = "ELECTRIC"
Config.framework = "qbcore"

Config.Pay = math.random(1000,4000)

Config.TargetPoints = {
    { location = vector4(-824.88, -766.65, 21.45, 0.0), isRepaired = false },
    { location = vector4(-826.06, -755.01, 22.54, 0.0), isRepaired = false },
}

Config.LadderOffset = 1.1
Config.TiempoParaArreglar = 6

Config.Locales = {
	iniciarrepa = "PRESIONA  ~b~Y~w~  ĐỂ BẮT ĐẦU SỬA CHỮA",
	ponerescalera = "PRESIONA  ~b~E~w~  ĐỂ ĐẶT THANG",
	sacarescalera = "PRESIONA  ~b~E~w~  ĐỂ LẤY THANG",
	espera = "Vui lòng chờ ~b~",
	tofinish = "~w~ giây để hoàn thành.",
	startjob = "PRESIONA  ~b~E~w~  ĐỂ BẮT ĐẦU CÔNG VIỆC",
	jobiniciado = "Công việc bắt đầu. Hãy đến các điểm sửa chữa trên bản đồ.",
	endjob = "PRESIONA  ~b~E~w~  ĐỂ KẾT THÚC CÔNG VIỆC",
	jobterminado = "Bạn đã kết thúc ca làm việc!",
	saveescalera = "PRESIONA  ~b~E~w~  ĐỂ CẤT THANG",
	cogerescala = "PRESIONA  ~b~E~w~  ĐỂ LẤY THANG",
    reparado = "Nơi này đã được sửa chữa."
}

---qbcore clothes--
-- LỖI NẰM Ở ĐÂY. BẠN CẦN THAY THẾ CÁC GIÁ TRỊ 'item' VÀ 'texture' BÊN DƯỚI.
Config.Uniforms = {
	['male'] = {
		outfitData = {
			['t-shirt'] = {item = 15, texture = 0},
			['torso2']  = {item = 56, texture = 0},
			['arms']    = {item = 85, texture = 0},
			['pants']   = {item = 45, texture = 4},
            -- Lỗi có thể ở dòng này. Tôi đã đổi texture thành 0 để an toàn hơn.
            -- Nếu vẫn lỗi, hãy thử thêm '--' ở đầu dòng để vô hiệu hóa nó.
			['shoes']   = {item = 42, texture = 0}, -- Ví dụ: -- ['shoes']   = {item = 42, texture = 0},
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