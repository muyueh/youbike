// Generated by LiveScript 1.2.0
var map, drawsvg;
map = require("prelude-ls").map;
drawsvg = function(svgClass, file){
  var dsc, svg;
  dsc = {};
  dsc.mgtop = 50;
  dsc.mgbottom = 50;
  dsc.mgleft = 50;
  dsc.mgright = 80;
  dsc.w = 800 - dsc.mgleft - dsc.mgright;
  dsc.h = 700 - dsc.mgtop - dsc.mgbottom;
  svg = d3.select(svgClass).attr({
    "width": dsc.w + dsc.mgleft + dsc.mgright,
    "height": dsc.h + dsc.mgtop + dsc.mgbottom
  }).append("g").attr({
    "transform": "translate(" + dsc.mgleft + "," + dsc.mgtop + ")"
  });
  return d3.tsv("./" + file + ".tsv", function(err, usageTsv){
    var x, y, line;
    usageTsv = usageTsv.filter(function(it, i){
      it.kpi = +it.kpi;
      return it.dt = new Date(it.dt);
    });
    x = d3.time.scale().domain(d3.extent(usageTsv, function(it){
      return it.dt;
    })).range([0, dsc.w]);
    y = d3.scale.linear().domain([
      0, d3.max(usageTsv, function(it){
        return it.kpi;
      })
    ]).range([dsc.h, 0]);
    line = d3.svg.line().interpolate("basis").x(function(it){
      return x(it.dt);
    }).y(function(it){
      return y(it.kpi);
    });
    svg.append("g").attr({
      "class": "axis"
    }).attr({
      "transform": "translate(0," + dsc.h + ")"
    }).call(d3.svg.axis().scale(x).orient("bottom"));
    svg.append("g").attr({
      "class": "axis"
    }).attr({
      "transform": "translate(" + dsc.w + ", 0)"
    }).call(d3.svg.axis().scale(y).orient("right"));
    return svg.selectAll(".pfm").data([usageTsv]).enter().append("path").attr({
      "d": function(it){
        return line(it);
      },
      "fill": "none",
      "class": "pfm"
    }).style({
      "stroke": "black",
      "stroke-width": 2
    });
  });
};
drawsvg(".svgusage", "usage");
drawsvg(".svgbad", "bad");