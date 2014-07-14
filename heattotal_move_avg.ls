{flatten, values} = require "prelude-ls"

# standardize; since different station has different starting time

# TODO!!!! remember sunday is 0 need to become 6 (TODO: this should be only on draw heatmap; not on data structure)


data = {}


ggl = {}
ggl.margin = {top: 20, left: 15, right: 10, bottom: 10}
ggl.w = 550 - ggl.margin.left - ggl.margin.right
ggl.h = 200 - ggl.margin.top - ggl.margin.bottom

ggl.rect_round = 4
ggl.rect_width = 20
# ggl.rect_width = 15
ggl.rect_margin = 1


err, startJson <- d3.json "./week_hour_total/station_start.json"

enddate = new Date "Fri May 09 2014 08:22:54 GMT+0800 (CST)"
for at of startJson
	startJson[at] = (enddate - (new Date startJson[at])) / 1000 / 60 / 60 / 7 / 24

#how many time w_h occurs 




datalist = ["捷運公館站(2號出口)","捷運信義安和站","捷運台北101_世貿站","捷運大安站","捷運國父紀念館站","台灣科技大學","捷運行天宮站(3號出口)","三張犁","捷運台電大樓站(2號出口)","信義建國路口","龍門廣場","臺大資訊大樓","信義敦化路口","捷運芝山站(2號出口)","捷運科技大樓站","捷運忠孝新生(3號出口)","捷運六張犁站","臺北市立圖書館(總館)","捷運大安森林公園站","捷運忠孝復興站(2號出口)","捷運臺大醫院(4號出口)","捷運象山站","信義廣場(台北101)","辛亥新生路口","臺灣師範大學(圖書館)","基隆長興路口","臺北田徑場","捷運永春站(2號出口)","中強公園","捷運東門站(4號出口)","捷運南港展覽館站(5號出口)","社教館","捷運雙連站(2號出口)","新生和平路口","松山車站","仁愛醫院","世貿二館","捷運市政府站(3號出口)","南昌公園","基隆光復路口","林森公園","民生敦化路口","捷運西門站(3號出口)","臺北醫學大學","捷運後山埤站(1號出口)","永吉松信路口","羅斯福寧波東街口","捷運行天宮站(1號出口)","羅斯福新生南路口","捷運圓山站(2號出口)","信義連雲街口","捷運中山站(2號出口)","捷運善導寺站(1號出口)","台北市災害應變中心","捷運劍南路站(2號出口)","興雅國中","仁愛逸仙路口","吳興公車總站","台北市政府","松山家商","捷運劍潭站(2號出口)","國家圖書館","八德市場","捷運港墘站(2號出口)","中崙高中","民生光復路口","華山文創園區","成功國宅","中山行政中心","國興青年路口","捷運民權西路站(3號出口)","建國長春路口","臺北轉運站","饒河夜市","捷運小南門站(1號出口)","和平重慶路口","南港車站","臺北孔廟","文湖國小","師範大學公館校區","捷運士林站(2號出口)","松德站","捷運景美站","福德公園","國立臺北護理健康大學","蘭雅公園","華江高中","捷運昆陽站(1號出口)","捷運北投站","捷運石牌站(2號出口)","峨嵋停車場","東園國小","市立美術館","捷運新北投站","世貿三館","玉成公園","民生活動中心","松德公園","萬大興寧街口","榮星花園","蘭興公園","敦化基隆路口","汐止火車站","捷運龍山寺站(1號出口)","開封西寧路口","永樂市場","龍江南京路口","百齡國小","台北花木批發市場","士林運動中心","大業大同街口","金山愛國路口","中研公園","民權復興路口","五常公園","老松國小","捷運大坪林站","洲子二號公園","中正基河路口","金山市民路口","振華公園","瑞光港墘路口","國泰綜合醫院","南港世貿公園","考試院","青年公園3號出口","捷運大橋頭站(2號出口)","興豐公園","羅斯福景隆街口","捷運明德站","復華花園新城","臺北市客家文化主題公園","蔣渭水紀念公園","東新國小","福林公園","南港國小","天母運動公園","市民廣場","樹德公園","建國農安街口","捷運文德站(2號出口)","三民公園","新生長安路口","國防大學","民權運動公園","酒泉延平路口","新生長春路口","東湖國小","捷運動物園站(2號出口)","華西公園","東湖國中","林安泰古厝","西園艋舺路口","捷運南港軟體園區站(2號出口)","北投運動中心","國立政治大學","凌雲市場","大鵬華城","文山行政中心","大豐公園","捷運木柵站","裕隆公園","汐止區公所","麗山國小","Y-17青少年育樂中心"]



hdata = [1 to 24]
	# flatten ["a", "p"].map (d)-> [1 to 12].map (h)-> h + d
wdata = ["ㄧ" "二" "三" "四" "五" "六" "日"]


build-heat-map = (data, colorscheme, name)->


	# if colorscheme is "RdYlBu"
	# 	cdmn = [0.25, -0.25]
	# else if colorscheme is "YlOrRd"
	# 	cdmn = [0, 0.5]
	# else if colorscheme is "GnBu"
	# 	cdmn = [0, -0.5]

	if colorscheme is "RdYlBu"
		cdmn = [ -10, 10]
	else if colorscheme is "YlOrRd"
		cdmn = [0, 20]
	else if colorscheme is "GnBu"
		cdmn = [0, -20]

	color = d3.scale.quantize!domain cdmn .range colorbrewer[colorscheme][9]
	# color = d3.scale.linear!domain cdmn .range colorbrewer[colorscheme][9]

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


# console.log data.nospace["三張犁"]

run = -> 
	datalist.map (stnm)-> 
		build-heat-map data.pos[stnm], "YlOrRd", stnm
		build-heat-map data.neg[stnm], "GnBu", stnm
		build-heat-map data.sum[stnm], "RdYlBu", stnm



ls = ["neg", "pos", "sum"]

fwait = ls.length

ls.map (it, j)-> 
	data[it] := {}

	err, temp <- d3.tsv "./move_week _hour/" + it + ".tsv"
	--fwait
	

	wait = temp.length

	temp.filter (row, i)->
		--wait
		
		data[it][row.stations] := []
		for cell of row
			if cell is not "stations"
				row[cell] = +row[cell]

				data[it][row.stations].push {
					"hour": +(cell.split "_")[1]
					"week": +((cell.split "_")[0] - 1  + 7) % 7 ## start at monday
					"value": row[cell] / startJson[row.stations]
					# avg times per w_h
				}

			# if cell is "6_23" then console.log wait + " " + fwait
			if wait is 0 and fwait is 0 and cell is "6_23" then run!
				