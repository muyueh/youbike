ggl = {}
ggl.margin = {top: 10, left: 10, right: 10, bottom: 10}
ggl.w = 550 - ggl.margin.left - ggl.margin.right
ggl.h = 200 - ggl.margin.top - ggl.margin.bottom

ggl.rect_round = 4
ggl.rect_width = 20
ggl.rect_margin = 1


data = []

[1 to 7].map (w, i)->
	[1 to 24].map (h, j)->
		data.push {
			"hour": h
			"week": w
			"value": ~~(Math.random! * 5)
		}

# colorscheme = "PuBu"

color-list = ["RdPu","PuBu","YlOrRd","YlOrRd","RdYlGn","RdYlBu","YlGn","YlGnBu","GnBu","BuGn","PuBuGn","BuPu","RdPu","PuRd","Paired","Greys","Reds","PiYG","PRGn","BrBG","PuOr"]

build-heat-map = (colorscheme)->

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
			"y": (it, i)-> it.week * (ggl.rect_width + ggl.rect_margin)
			"rx": ggl.rect_round
			"ry": ggl.rect_round
			"width": ggl.rect_width
			"height": ggl.rect_width
		}
		.style {
			"fill":-> colorbrewer[colorscheme]["5"][it.value]
		}

color-list.map -> build-heat-map it 


