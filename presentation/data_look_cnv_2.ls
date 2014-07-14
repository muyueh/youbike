{lists-to-obj} = require "prelude-ls"


mk_look = (filename, ctnClass)->

	cnvidx = 0

	ggl = {}
	ggl.margin = {top: 40, left: 50, right: 60, bottom: 15}
	ggl.w = 750 - ggl.margin.left - ggl.margin.right
	ggl.h = 500 - ggl.margin.top - ggl.margin.bottom


	svg = d3.select "body"
		.select ctnClass
		.append "svg"
		.attr {
			"width": ggl.w + ggl.margin.left + ggl.margin.right
			"height": ggl.h + ggl.margin.top + ggl.margin.bottom
		}
		.style {
			"position": "absolute"
		}
		.append "g"
		.attr "transform", "translate(" + ggl.margin.left + ", " + ggl.margin.top + ")"


	d3.select "body"
		.select ctnClass
		.append "canvas"
		.attr {
			"width": ggl.w + ggl.margin.left + ggl.margin.right
			"height": ggl.h + ggl.margin.top + ggl.margin.bottom
			"id": "cnvlook" + filename
		}


	scale-m = d3.time.scale!
		.range [0, ggl.w]
		.domain [0, (24 * 60)]


	scale-w = d3.scale.linear!
		.range [ggl.h, 0]


	date-to-minute = -> it.getHours! * 60 + it.getMinutes!
	# TODO: we are now neglecting data that starts crossed day


	err, staionTSV <- d3.text "../under_n_over/" + filename + ".csv"

	string-to-date = ->
		it.trim! |> eval |> new Date _

	stationJSON = staionTSV.split "\n" .map (row, i)->
		if row is "" then return

		cells = row.split ","	
		r = {}

		r.start = string-to-date cells[0]
		r.end = string-to-date cells[1]
		r.sec = (r.end - r.start) / 1000
		r.type = cells[2].trim!

		r

	stationJSON = stationJSON.filter -> if it is undefined then false else true

	mrg = 20
	unt = (ggl.h - 6 * mrg) / 7
	hlp = d3.time.scale!
		.range [unt, 0]
		.domain d3.extent stationJSON, -> it.start

	scale-t = (time)->	
		(hlp time) + (time.getDay! - 1 + 7) % 7 * (unt + mrg) 


	stationJSON.filter (it, i)->
		it.pos_y = scale-t it.start


	cnv = document.getElementById "cnvlook" + filename
	cnvW = cnv.width
	cnvH = cnv.height
	ctx = cnv.getContext "2d"

	cnvData = ctx.getImageData 0, 0, cnvW, cnvH
	buf8 = new Uint8ClampedArray(new ArrayBuffer cnvData.data.length)

	drawPixel = (x, y, r, g, b, a)->
		index = ((x + ggl.margin.left) + (y + ggl.margin.top) * cnvW) * 4

		cnvData.data[index + 0] = r
		cnvData.data[index + 1] = g
		cnvData.data[index + 2] = b
		cnvData.data[index + 3] = a

	clear = -> 
		cnvData.data.set buf8

	updateCanvas = ->	
		ctx.putImageData(cnvData, 0, 0)



	oran = colorbrewer["RdYlBu"][5][0]
	blue = colorbrewer["RdYlBu"][5][4]

	drawHLine = (x1, x2, y1, y2, color)->
		[x1 to x2].map (xi)->
			opac = 255
			drawPixel( ~~(xi), ~~(y1), color.r, color.g, color.b, 255)
			drawPixel( ~~(xi), ~~(y1 + 1), color.r, color.g, color.b, 255)

	stationJSON.map (it, i)->
		x1 = (scale-m date-to-minute it.start)
		x2 = (scale-m (if it.start.getDate! is not it.end.getDate! then (24 * 60) else date-to-minute it.end))
		y1 = it.pos_y
		y2 = it.pos_y
		c = if it.type is "nospace" then d3.rgb blue else d3.rgb oran

		drawHLine x1, x2, y1, y2, c	

	updateCanvas!

	svg
		.selectAll ".ylabel"
		.data ["Mon.", "Tue.", "Wed.", "Thu.", "Fri.", "Sat.", "Sun."]
		.enter!
		.append "text"
		.attr {
			"x": - 40
			"y": (it, i)-> (i + 0.5) * (unt + mrg) 
		}
		.text (it,i)-> it


	scale-h = d3.scale.linear!
		.range [0, ggl.w]
		.domain [0, 24]

	svg
		.append "g"
		.attr {
			"class": "axis"
		}
		.attr {
			"transform": "translate(0, -10)"
		}
		.call(d3.svg.axis!.scale scale-h .orient "top" .tickValues [0 to 24 by 6])


	arrw = ->
		it.style {
			"stroke": "black"
			"stroke-width": 1px
		}

	svg
		.append "line"
		.attr {
			"x1": ggl.w + 10
			"x2": ggl.w + 10
			"y1": ggl.h - unt
			"y2": ggl.h
		}
		.call arrw
		.style {
			"shape-rendering": "crispEdges"
		}
		

	# ## arrow
	hdx = ggl.w + 10
	hdy = ggl.h - unt

	blt-arr = (x1, y1)->
		svg
			.append "line"
			.attr {
				"x1": x1
				"x2": x1 - 6
				"y1": y1
				"y2": y1 + 9
			}
			.call arrw

		svg
			.append "line"
			.attr {
				"x1": x1
				"x2": x1 + 6
				"y1": y1
				"y2": y1 + 9
			}
			.call arrw

	blt-arr hdx, hdy
			

	svg
		.append "text"
		.attr {
			"x": hdx - 15
			"y": hdy - 2
		}
		# .text "May '14"
		.text "Now"
		.style {
			font: 10px "sans-serif";
		}

	svg
		.append "text"
		.attr {
			"x": hdx - 15
			"y": hdy + unt + 12
		}
		.text "Nov. '13 "
		.style {
			font: 10px "sans-serif";
		}

mk_look "信義廣場(台北101)", ".data_look_1"
mk_look "捷運公館站(2號出口)", ".data_look_2"

# mk_look "饒河夜市", ".data_look_3"
# mk_look "捷運六張犁站", ".data_look_3"

# mk_look "青年公園3號出口", ".data_look_3"


# datalist = ["八德市場","三民公園","三張犁","士林運動中心","大業大同街口","大豐公園","大鵬華城","中山行政中心","中正基河路口","中研公園","中崙高中","中強公園","五常公園","仁愛逸仙路口","仁愛醫院","仁愛醫院(施工暫停)","天母運動公園","文山行政中心","文湖國小","世貿二館","世貿三館","北投運動中心","台北市災害應變中心","台北市政府","台北花木批發市場","台灣科技大學","市民廣場","市立美術館","民生光復路口","民生活動中心","民生敦化路口","民權復興路口","民權運動公園","永吉松信路口","永樂市場","玉成公園","成功國宅","汐止火車站","汐止區公所","百齡國小","老松國小","考試院","西園艋舺路口","吳興公車總站","辛亥新生路口","和平重慶路口","東湖國小","東湖國中","東園國小","東新國小","松山車站","松山家商","松德公園","松德站","林安泰古厝","林森公園","社教館","金山市民路口","金山愛國路口","青年公園3號出口","信義建國路口","信義連雲街口","信義敦化路口","信義廣場(台北101)","南昌公園","南港世貿公園","南港車站","南港國小","建國長春路口","建國農安街口","洲子二號公園","凌雲市場","峨嵋停車場","師範大學公館校區","振華公園","酒泉延平路口","國立政治大學","國立臺北護理健康大學","國防大學","國家圖書館","國泰綜合醫院","國興青年路口","基隆光復路口","基隆長興路口","捷運士林站(2號出口)","捷運大安站","捷運大安森林公園站","捷運大坪林站","捷運大橋頭站(2號出口)","捷運小南門站(1號出口)","捷運中山站(2號出口)","捷運公館站(2號出口)","捷運六張犁站","捷運文德站(2號出口)","捷運木柵站","捷運北投站","捷運台北101_世貿站","捷運台電大樓站(2號出口)","捷運市政府站(3號出口)","捷運民權西路站(3號出口)","捷運永春站(2號出口)","捷運石牌站(2號出口)","捷運行天宮站(1號出口)","捷運行天宮站(3號出口)","捷運西門站(3號出口)","捷運忠孝復興站(2號出口)","捷運忠孝新生(3號出口)","捷運昆陽站(1號出口)","捷運明德站","捷運東門站(4號出口)","捷運芝山站(2號出口)","捷運信義安和站","捷運南港展覽館站(5號出口)","捷運南港軟體園區站(2號出口)","捷運後山埤站(1號出口)","捷運科技大樓站","捷運動物園站(2號出口)","捷運國父紀念館站","捷運善導寺站(1號出口)","捷運景美站","捷運港墘站(2號出口)","捷運象山站","捷運圓山站(2號出口)","捷運新北投站","捷運臺大醫院(4號出口)","捷運劍南路站(2號出口)","捷運劍潭站(2號出口)","捷運龍山寺站(1號出口)","捷運雙連站(2號出口)","捷鋥--投站","復華花園新城","敦化基隆路口","華山文創園區","華江高中","華西公園","開封西寧路口","新生和平路口","新生長安路口","新生長春路口","瑞光港墘路口","萬大興寧街口","裕隆公園","榮星花園","福林公園","福德公園","臺大資訊大樓","臺北孔廟","臺北市立圖書館(總館)","臺北市客家文化主題公園","臺北田徑場","臺北轉運站","臺北醫學大學","臺灣師範大學(圖書館)","蔣渭水紀念公園","樹德公園","興雅國中","興豐公園","龍江南京路口","龍門廣場","羅斯福景隆街口","羅斯福新生南路口","羅斯福寧波東街口","麗山國小","饒河夜市","蘭雅公園","蘭興公園","Total","Y-17青少年育樂中心"]


	# "師範大學公館校區"
	# "捷運公館站(2號出口)"
	# "捷運信義安和站"
	# "大豐公園"
	# "捷運台電大樓站(2號出口)"
	# "中崙高中"
	# "青年公園3號出口"
	# "仁愛醫院"
	# "信義廣場(台北101)"
	# "三張犁"
