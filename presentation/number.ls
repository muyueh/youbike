{each} = require "prelude-ls"

svg = d3.select ".svgctnr"
	.append "svg"
	.attr {
		"width": 700px
		"height": 800px
	}
	.style {
		"position": "fixed"
		"left": 700
		"top": 250
	}
	.append "g"

# svg
# 	.append "circle"
# 	.attr {
# 		"cx": 300
# 		"cy": 300
# 		"r": 100
# 	}
# 	.style {
# 		"fill": "orange"
# 		"opacity": 0.6
# 	}


line = d3.svg.line!
	.interpolate "basis"
	.x (it, i)-> i * 30
	.y (it, i)-> it

svg
	.selectAll "path"
	.data [([0 to 20].map -> Math.random! * 500)]
	.enter!
	.append "path"
	.style {
		"fill": "none"
		"stroke-width": 5px
		"stroke": "orange"
	}
	.attr {
		"d": -> line [0 to 20].map -> 600
	}
	.transition!
	.duration 1000
	.attr {
		"d": -> line it
	}
	


