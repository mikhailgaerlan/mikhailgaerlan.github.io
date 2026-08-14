var size = 100, xc = new Array(size), yc = new Array(size), z = new Array(size), i, j;

for(var i = 0; i < size; i++) {
    xc[i] = -3 + (3-(-3)) * i /size;
    yc[i] = -5 + (5-(-5)) * i /size;
    z[i] = new Array(size);
}

for(var i = 0; i < size; i++){
    for(var j = 0; j < size; j++) {
	var r2 = xc[i]*xc[i] + yc[j]*yc[j];
	z[i][j] = xc[i]*xc[i]*yc[j]*yc[j]*Math.exp(-r2);
    }
}

var contour = {
    z: z,
    x: yc,
    y: xc,
    type: 'heatmap',
}

var x0 = [0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0];
var y0 = [-5.0, -5.0, -5.0, -5.0, -5.0, -5.0, -5.0, -5.0];
var xp0 = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
var yp0 = [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5];
var h = 0.25;

var x = x0.slice();
var y = y0.slice();
var xp = xp0.slice();
var yp = yp0.slice();

var trace1 = {
    x: y,
    y: x,
    mode: 'markers'
}

function compute() {
    for(var i = 0; i < x.length; i++){
	if (Math.abs(x[i]) > 3.0 || Math.abs(y[i]) > 5.0){
	    x[i] = x0[i];
	    y[i] = y0[i];
	    xp[i] = xp0[i];
	    yp[i] = yp0[i];
	} else {
	    var xt = [x[i],y[i],xp[i],yp[i]];
	    var temp = new Array(4);

	    temp = deriv(xt);
	    for (var j = 0; j < 4; j++) {
		xt[j] += h*temp[j];
	    }

	    /*var k1, k2, k3, k4;
	    
	    k1 = deriv(xt);
	    for (var j = 0; j < 4; j++){
		temp[j] = xt[j] + h*k1[j]/2.0;
	    }
	    k2 = deriv(temp);
	    for (var j = 0; j < 4; j++){
		temp[j] = xt[j] + h*k2[j]/2.0;
	    }
	    k3 = deriv(temp);
	    for (var j = 0; j < 4; j++){
		temp[j] = xt[j] + h*k3[j];
	    }
	    k4 = deriv(temp);
	    
	    for (var j = 0; j < 4; j++){
		xt[j] += h*(k1[j]+2.0*k2[j]+2.0*k3[j]+k4[j])/6.0;
	    }*/
	    
	    x[i] = xt[0];
	    y[i] = xt[1];
	    xp[i] = xt[2];
	    yp[i] = xt[3];
	}
    }
}

function deriv(x) {
    var xs = new Array(4);
    xs[0] = x[2];
    xs[1] = x[3];
    xs[2] = -x[1]*x[1]*x[0]*(1.0-x[0]*x[0])*Math.exp(-(x[0]*x[0]+x[1]*x[1]));
    xs[3] = -x[0]*x[0]*x[1]*(1.0-x[1]*x[1])*Math.exp(-(x[0]*x[0]+x[1]*x[1]));
    return xs;
}

var data = [ trace1 ];

var layout = {
    xaxis: {range: [-5,5]},
    yaxis: {range: [-3,3]},
    title: 'Particle moving through energy field',
    font: {size: 18},
}

Plotly.newPlot('plots', [ contour ], layout);

Plotly.plot('plots', data, layout, {showSendToCloud: true});

function update() {
    compute();

    Plotly.update('plots', {
	data: [{x: y, y: x}]
    }, {
	transition: {
	    duration: 0
	},
	frame: {
	    duration: 0,
	    redraw: false
	}
    });
    
    requestAnimationFrame(update);
}

requestAnimationFrame(update);
