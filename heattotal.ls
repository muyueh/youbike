{flatten, values} = require "prelude-ls"

# remember sunday is 0 need to become 6
data = {}


ggl = {}
ggl.margin = {top: 20, left: 15, right: 10, bottom: 10}
ggl.w = 550 - ggl.margin.left - ggl.margin.right
ggl.h = 200 - ggl.margin.top - ggl.margin.bottom

ggl.rect_round = 4
ggl.rect_width = 20
ggl.rect_margin = 1


# data = []

# [1 to 7].map (w, i)->
# 	[1 to 24].map (h, j)->
# 		data.push {
# 			"hour": h
# 			"week": w
# 			"value": ~~(Math.random! * 5)
# 		}


color-list = ["RdPu","PuBu","YlOrRd","RdYlGn","RdYlBu","YlGn","YlGnBu","GnBu","BuGn","PuBuGn","BuPu","RdPu","PuRd","Paired","Greys","Reds","PiYG","PRGn","BrBG","PuOr"]
# colorscheme = "PuBu"

# datalist = ["八德市場","三民公園","三張犁","士林運動中心","大業大同街口","大豐公園","大鵬華城","中山行政中心","中正基河路口","中研公園","中崙高中","中強公園","五常公園","仁愛逸仙路口","仁愛醫院","仁愛醫院(施工暫停)","天母運動公園","文山行政中心","文湖國小","世貿二館","世貿三館","北投運動中心","台北市災害應變中心","台北市政府","台北花木批發市場","台灣科技大學","市民廣場","市立美術館","民生光復路口","民生活動中心","民生敦化路口","民權復興路口","民權運動公園","永吉松信路口","永樂市場","玉成公園","成功國宅","汐止火車站","汐止區公所","百齡國小","老松國小","考試院","西園艋舺路口","吳興公車總站","辛亥新生路口","和平重慶路口","東湖國小","東湖國中","東園國小","東新國小","松山車站","松山家商","松德公園","松德站","林安泰古厝","林森公園","社教館","金山市民路口","金山愛國路口","青年公園3號出口","信義建國路口","信義連雲街口","信義敦化路口","信義廣場(台北101)","南昌公園","南港世貿公園","南港車站","南港國小","建國長春路口","建國農安街口","洲子二號公園","凌雲市場","峨嵋停車場","師範大學公館校區","振華公園","酒泉延平路口","國立政治大學","國立臺北護理健康大學","國防大學","國家圖書館","國泰綜合醫院","國興青年路口","基隆光復路口","基隆長興路口","捷運士林站(2號出口)","捷運大安站","捷運大安森林公園站","捷運大坪林站","捷運大橋頭站(2號出口)","捷運小南門站(1號出口)","捷運中山站(2號出口)","捷運公館站(2號出口)","捷運六張犁站","捷運文德站(2號出口)","捷運木柵站","捷運北投站","捷運台北101_世貿站","捷運台電大樓站(2號出口)","捷運市政府站(3號出口)","捷運民權西路站(3號出口)","捷運永春站(2號出口)","捷運石牌站(2號出口)","捷運行天宮站(1號出口)","捷運行天宮站(3號出口)","捷運西門站(3號出口)","捷運忠孝復興站(2號出口)","捷運忠孝新生(3號出口)","捷運昆陽站(1號出口)","捷運明德站","捷運東門站(4號出口)","捷運芝山站(2號出口)","捷運信義安和站","捷運南港展覽館站(5號出口)","捷運南港軟體園區站(2號出口)","捷運後山埤站(1號出口)","捷運科技大樓站","捷運動物園站(2號出口)","捷運國父紀念館站","捷運善導寺站(1號出口)","捷運景美站","捷運港墘站(2號出口)","捷運象山站","捷運圓山站(2號出口)","捷運新北投站","捷運臺大醫院(4號出口)","捷運劍南路站(2號出口)","捷運劍潭站(2號出口)","捷運龍山寺站(1號出口)","捷運雙連站(2號出口)","捷鋥--投站","復華花園新城","敦化基隆路口","華山文創園區","華江高中","華西公園","開封西寧路口","新生和平路口","新生長安路口","新生長春路口","瑞光港墘路口","萬大興寧街口","裕隆公園","榮星花園","福林公園","福德公園","臺大資訊大樓","臺北孔廟","臺北市立圖書館(總館)","臺北市客家文化主題公園","臺北田徑場","臺北轉運站","臺北醫學大學","臺灣師範大學(圖書館)","蔣渭水紀念公園","樹德公園","興雅國中","興豐公園","龍江南京路口","龍門廣場","羅斯福景隆街口","羅斯福新生南路口","羅斯福寧波東街口","麗山國小","饒河夜市","蘭雅公園","蘭興公園","Total","Y-17青少年育樂中心"]
datalist = ["捷運公館站(2號出口)","捷運信義安和站","捷運台北101_世貿站","捷運大安站","捷運國父紀念館站","台灣科技大學","捷運行天宮站(3號出口)","三張犁","捷運台電大樓站(2號出口)","信義建國路口","龍門廣場","臺大資訊大樓","信義敦化路口","捷運芝山站(2號出口)","捷運科技大樓站","捷運忠孝新生(3號出口)","捷運六張犁站","臺北市立圖書館(總館)","捷運大安森林公園站","捷運忠孝復興站(2號出口)","捷運臺大醫院(4號出口)","捷運象山站","信義廣場(台北101)","辛亥新生路口","臺灣師範大學(圖書館)","基隆長興路口","臺北田徑場","捷運永春站(2號出口)","中強公園","捷運東門站(4號出口)","捷運南港展覽館站(5號出口)","社教館","捷運雙連站(2號出口)","新生和平路口","松山車站","仁愛醫院","世貿二館","捷運市政府站(3號出口)","南昌公園","基隆光復路口","林森公園","民生敦化路口","捷運西門站(3號出口)","臺北醫學大學","捷運後山埤站(1號出口)","永吉松信路口","羅斯福寧波東街口","捷運行天宮站(1號出口)","羅斯福新生南路口","捷運圓山站(2號出口)","信義連雲街口","捷運中山站(2號出口)","捷運善導寺站(1號出口)","台北市災害應變中心","捷運劍南路站(2號出口)","興雅國中","仁愛逸仙路口","吳興公車總站","台北市政府","松山家商","捷運劍潭站(2號出口)","國家圖書館","八德市場","捷運港墘站(2號出口)","中崙高中","民生光復路口","華山文創園區","成功國宅","中山行政中心","國興青年路口","捷運民權西路站(3號出口)","建國長春路口","臺北轉運站","饒河夜市","捷運小南門站(1號出口)","和平重慶路口","南港車站","臺北孔廟","文湖國小","師範大學公館校區","捷運士林站(2號出口)","松德站","捷運景美站","福德公園","國立臺北護理健康大學","蘭雅公園","華江高中","捷運昆陽站(1號出口)","捷運北投站","捷運石牌站(2號出口)","峨嵋停車場","東園國小","市立美術館","捷運新北投站","世貿三館","玉成公園","民生活動中心","松德公園","萬大興寧街口","榮星花園","蘭興公園","敦化基隆路口","汐止火車站","捷運龍山寺站(1號出口)","開封西寧路口","永樂市場","龍江南京路口","百齡國小","台北花木批發市場","士林運動中心","大業大同街口","金山愛國路口","中研公園","民權復興路口","五常公園","老松國小","捷運大坪林站","洲子二號公園","中正基河路口","金山市民路口","振華公園","瑞光港墘路口","國泰綜合醫院","南港世貿公園","考試院","青年公園3號出口","捷運大橋頭站(2號出口)","興豐公園","羅斯福景隆街口","捷運明德站","復華花園新城","臺北市客家文化主題公園","蔣渭水紀念公園","東新國小","福林公園","南港國小","天母運動公園","市民廣場","樹德公園","建國農安街口","捷運文德站(2號出口)","三民公園","新生長安路口","國防大學","民權運動公園","酒泉延平路口","新生長春路口","東湖國小","捷運動物園站(2號出口)","華西公園","東湖國中","林安泰古厝","西園艋舺路口","捷運南港軟體園區站(2號出口)","北投運動中心","國立政治大學","凌雲市場","大鵬華城","文山行政中心","大豐公園","捷運木柵站","裕隆公園","汐止區公所","麗山國小","Y-17青少年育樂中心","仁愛醫院(施工暫停)","Total","捷鋥--投站"]

# stnm = "捷運公館站(2號出口)"
# stnm = "捷運台電大樓站(2號出口)"
# stnm = "羅斯福寧波東街口"
# stnm = "中研公園"
# stnm = "仁愛逸仙路口"

	# "大鵬華城"

# err, stationsJSON <- d3.json "./week_hour/" + stnm + ".json"

# console.log stationsJSON


hdata = [1 to 24]
	# flatten ["a", "p"].map (d)-> [1 to 12].map (h)-> h + d
wdata = ["ㄧ" "二" "三" "四" "五" "六" "日"]


build-heat-map = (data, colorscheme, name)->
	rg = if colorscheme is "YlOrRd" then 100 else 600
	# rg = 100
	# 350
	color = d3.scale.quantize!domain [0, rg] .range colorbrewer[colorscheme][9]

	svg = d3.select "body"
		.append "svg"
		.attr "width", ggl.w + ggl.margin.left + ggl.margin.right
		.attr "height", ggl.h + ggl.margin.top + ggl.margin.bottom
		.append "g"
		.attr "transform", "translate(" + ggl.margin.left + ", " + ggl.margin.top + ")"

	svg.selectAll "heatreact"
		.data data
		.enter!
		.append "rect"
		.attr {
			"x": (it, i)-> it.hour * (ggl.rect_width + ggl.rect_margin)
			"y": (it, i)-> it.week * (ggl.rect_width + ggl.rect_margin) + (if it.week >= 5 then 5 else 0)
			"rx": ggl.rect_round
			"ry": ggl.rect_round
			"width": ggl.rect_width
			"height": ggl.rect_width
		}
		.style {
			"fill":-> color it.value
		}

	svg.selectAll ".xaxis"
		.data hdata
		.enter!
		.append "text"
		.attr {
			"x": (it, i)-> i * (ggl.rect_width + ggl.rect_margin)
			"y": 0
		}
		.text -> it

	svg.selectAll ".yaxis"
		.data wdata
		.enter!
		.append "text"
		.attr {
			"x": -15
			"y": (it, i)-> (ggl.rect_width * 3 / 4)+ i * (ggl.rect_width + ggl.rect_margin) + (if i >= 5 then 5 else 0)
		}
		.text -> it

	svg
		.append "text"
		.text name
		.attr {
			"x": 100
			"y": 100
		}

# color-list.map -> build-heat-map it 




parse = (json)-> 
	result = []
	# sunday zero to last

	for itm of json
		result.push {
			"hour": (itm.split "_")[1]
			"week": ((itm.split "_")[0] - 1  + 7) % 7
			"value": json[itm]
		}

	result

# console.log data.nospace["三張犁"]

run = -> 
	datalist.map (stnm)-> 
		build-heat-map data.nobike[stnm], "YlOrRd", stnm
		build-heat-map data.nospace[stnm], "GnBu", stnm


# build-heat-map (parse stationsJSON["nobike"]), "YlOrRd"
# build-heat-map (parse stationsJSON["nospace"]), "GnBu"


["nospace", "nobike"].map (it, j)-> 
	data[it] := {}
	err, temp <- d3.tsv "./week_hour_total/" + it + ".tsv"
	
	if j is 1 then wait = temp.length

	temp.filter (row, i)->
		--wait
		data[it][row.stations] := []
		for cell of row
			if cell is not "stations"
				row[cell] = +row[cell]

				data[it][row.stations].push {
					"hour": +(cell.split "_")[1]
					"week": +((cell.split "_")[0] - 1  + 7) % 7
					"value": row[cell]
				}

			if j is 1 and wait is 0 and cell is "6_23" then run!
				
			# console.log 

		# if j is 1 and  is 0 then console.log "hi"
		# setTimeout run, 1000
#this is bad
		


		# data[it][row.stations] := rslt

		# 
		# console.log --wait

	# run!
		# if j is 1 and i is (temp.length - 1) then run!
		# console.log "hi"
		# 