Input is from google map json path used for intractive graph on http://www.seneca7.com/course/index.html
Output is distance plot and data table 

```bash
# get data from interative map
curl http://tracker-1144.appspot.com.storage.googleapis.com/races/paths.js > paths.js

# json to kml
perl -lne 'BEGIN{$end="</coordinates></LineString></Placemark>"; print qq(<?xml version="1.0" encoding="UTF-8"?> <kml xmlns="http://www.opengis.net/kml/2.2"><Document><name>S7</name>)} if(m/coordinates /){ print ($i++?$end:""); print "<Placemark><name>$i</name><LineString><extrude>1</extrude><tessellate>1</tessellate><coordinates>"} print "$2,$1" if m/LatLng\(([-0-9.]+),([-0-9.]+)\)/;END{print "$end</Document></kml>"}' paths.js > paths.kml

# manually copy output from http://www.gpsvisualizer.com/convert?output_elevation
# to get altitude
 xclip -o | perl -slane 'if(m/^type/){$i++;next} chomp; print "$i @F[(0..3)]" if m/^T/' > path_alt.txt

# get stats 
Rscript legstat.R
```

