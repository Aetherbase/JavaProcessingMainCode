import sys, webbrowser
import json, urllib
import urllib.request
import urllib.parse
from urllib.parse import urlencode
from urllib.request import urlopen
import googlemaps
import polyline

start = sys.argv[1]
finish = sys.argv[2]
key = "AIzaSyAtIVw0RHb58CH9Cb_R9ibMevfGyifdQuc"


url = 'https://maps.googleapis.com/maps/api/directions/json?%s' % urlencode((
            ('key',key),
            ('origin', start),
            ('destination', finish),
 ))

mappath = 'C:\\Runnable\\mapdirection.html?%s'%urlencode((
            ('start', start),
            ('end', finish),
 ))
webbrowser.get('C:/Program Files (x86)/Google/Chrome/Application/chrome.exe %s').open(mappath);
ur = urlopen(url)
result = json.load(ur)
#decode polyline coordinates
for i in range (0, len (result['routes'][0]['legs'][0]['steps'])):
    j = result['routes'][0]['legs'][0]['steps'][i]['polyline']['points'] 
    print(polyline.decode(j))

