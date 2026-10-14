import { Shape, Path } from 'three';


// Stroke outlines sampled from RhineLabUI's shared Bezier mark, then extruded
// by the existing geometry pipeline. All coordinates retain the source SVG axes.
function stroke(path, width) {
  const points = path.getSpacedPoints(240);
  const sides = [-1, 1].map(side => points.map((p, i) => {
    const a = points[Math.max(0, i - 1)], b = points[Math.min(points.length - 1, i + 1)];
    const length = Math.hypot(b.x - a.x, b.y - a.y);
    return { x: (p.x - side * (b.y - a.y) / length * width / 2) / 310,
      y: -(p.y + side * (b.x - a.x) / length * width / 2) / 310 };
  }));
  return new Shape([...sides[0], ...sides[1].reverse()]);
}
const left = new Path();
left.moveTo(156,75); left.bezierCurveTo(127,48,103,15,70,15); left.bezierCurveTo(37,15,15,39,15,70);
left.bezierCurveTo(15,101,38,128,70,128); left.bezierCurveTo(103,128,127,96,176,52);
const right = new Path();
right.moveTo(155,75); right.bezierCurveTo(182,99,208,128,240,128); right.bezierCurveTo(273,128,295,105,295,73);
right.bezierCurveTo(295,41,273,15,240,15); right.bezierCurveTo(221,15,207,23,192,38);
const polygon = points => new Shape(points.map(([x,y]) => ({x:x/310,y:-y/310})));
export const rhineShapes = [stroke(left,26), stroke(right,26),
  polygon([[61.5,45],[76.5,45],[76.5,62.5],[94,62.5],[94,77.5],[76.5,77.5],[76.5,95],[61.5,95],[61.5,77.5],[44,77.5],[44,62.5],[61.5,62.5]]),
  polygon([[219,62.5],[263,62.5],[263,77.5],[219,77.5]])];
export const rhineSVG = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 310 145" width="400" height="200" color="white"><path d="M156 75C127 48 103 15 70 15C37 15 15 39 15 70S38 128 70 128C103 128 127 96 176 52M155 75C182 99 208 128 240 128C273 128 295 105 295 73S273 15 240 15C221 15 207 23 192 38" fill="none" stroke="currentColor" stroke-width="26"/><path d="M44 70h50M69 45v50M219 70h44" fill="none" stroke="currentColor" stroke-width="15"/></svg>';
