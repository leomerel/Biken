# -*- coding: utf-8 -*-
import folium
import os

c= folium.Map(location=[48.3677820, -4.7591771])

#on lit le fichier pour remplir le tableau points
path=os.getcwd()
with open(path+"/coordinates.txt") as file:
	lines = [line.strip('\n') for line in file.readlines()]
	#pointsep contient chq lon et lap séparées
	pointsep=[float(i) for i in lines]
#on remplit maintenant la liste points
points=[]
a=0
b=1
for i in xrange(len(pointsep)/2):
	points.append([pointsep[a],pointsep[b]])
	global a
	a=a+2
	global b
	b=b+2
print(points)

for each in points:
    folium.Marker(each).add_to(c)
 
#add lines
folium.PolyLine(points, color="red", weight=2.5, opacity=1).add_to(c)
folium.PolyLine(points).add_to(c)

c.save('card.html')

#METTRE TOUT ÇA DANS UNE FONCTION, dans un fichier au propre

#je peux donc créer une carte centrée sur une coordonnée --> possibiilté géolocaliser l'utilisateur
#si je récupére points --> les relier en desinnant ect : https://python-visualization.github.io/folium/
#https://pixees.fr/informatiquelycee/n_site/snt_carto_osmPerso.html
#mais basé sur OSM et d'autres équivalents --> problème ?


#A VERIFIER : peut-on mettre un zoom sur la carte pour avoir télécharger la carte une bonne fois pour toute
#autour du domicile de l'tilisateur par exemple ? ou par rapport à sa géolocalisation
#cf fitbounds() dos folium

#on a liste de Node. A partir de cette liste, récupérer lat et lon de chq en cpp --> mettre dans un tableau. Puis script Python qui les print sur la carte
#marqueur au premier et au dernier puis polyline pour chq couple
