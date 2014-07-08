// Generated by LiveScript 1.2.0
var ggl, data, colorList, buildHeatMap;
ggl = {};
ggl.margin = {
  top: 10,
  left: 10,
  right: 10,
  bottom: 10
};
ggl.w = 550 - ggl.margin.left - ggl.margin.right;
ggl.h = 200 - ggl.margin.top - ggl.margin.bottom;
ggl.rect_round = 4;
ggl.rect_width = 20;
ggl.rect_margin = 1;
data = [];
[1, 2, 3, 4, 5, 6, 7].map(function(w, i){
  return [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24].map(function(h, j){
    return data.push({
      "hour": h,
      "week": w,
      "value": ~~(Math.random() * 5)
    });
  });
});
colorList = ["RdPu", "PuBu", "YlOrRd", "YlOrRd", "RdYlGn", "RdYlBu", "YlGn", "YlGnBu", "GnBu", "BuGn", "PuBuGn", "BuPu", "RdPu", "PuRd", "Paired", "Greys", "Reds", "PiYG", "PRGn", "BrBG", "PuOr"];
buildHeatMap = function(colorscheme){
  var svg;
  svg = d3.select("body").append("svg").attr("width", ggl.w + ggl.margin.left + ggl.margin.right).attr("height", ggl.h + ggl.margin.top + ggl.margin.bottom).append("g").attr("transform", "translate(" + ggl.margin.left + ", " + ggl.margin.top + ")");
  return svg.selectAll("heatreact").data(data).enter().append("rect").attr({
    "x": function(it, i){
      return it.hour * (ggl.rect_width + ggl.rect_margin);
    },
    "y": function(it, i){
      return it.week * (ggl.rect_width + ggl.rect_margin);
    },
    "rx": ggl.rect_round,
    "ry": ggl.rect_round,
    "width": ggl.rect_width,
    "height": ggl.rect_width
  }).style({
    "fill": function(it){
      return colorbrewer[colorscheme]["5"][it.value];
    }
  });
};
colorList.map(function(it){
  return buildHeatMap(it);
});