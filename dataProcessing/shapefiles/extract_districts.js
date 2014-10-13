var fs = require('fs')

var UNITS_FILE = './IBLIunits/KenyaEthiopia_IBLIunits_July2014.geojson';

var units = JSON.parse(fs.readFileSync(UNITS_FILE))
var districts = {}

for (f in units.features) {
	d = units.features[f].properties.DISTRICT
	if (districts[d]) 
		districts[d].features.push(units.features[f]) 
	else
		districts[d] = {"type":"FeatureCollection","features":[units.features[f]]}
}

for (d in districts) {
	outfile = './districts/'+d+'.geojson'
	fs.writeFileSync(outfile, JSON.stringify(districts[d]))
	console.log(outfile)
}

