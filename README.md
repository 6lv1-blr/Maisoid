# Maisoid
Gestion UI Domotique Delphi sous Android/Windows
version spécifique pour ma maison mais peut donner des idées pour faire votre version.

Utilise Fmx pour l'interface 3D
API REST avec données Json (désactivée en simulation offline)
Utilise TLight point pour l'affichage en multi étage et TLight spot pour le mode par étage
discussion des limitations sur
https://www.developpez.net/forums/d2067813/environnements-developpement/delphi/composants-fmx/probleme-tlight-mode-spot/
j'ai mis la subdivision de mes Tplanes à 30 pour avoir les effets spots en vue d'un seul étage.
en mode multi étage cela bascule sur un affichage avec une Tsphere applati transparente

j'ai fait une version qui fonctionne en simulation offline si vous voulez tester, en vrai cela fonctionne avec des requetes Rest en Json
les fichiers samples renvoyés par le serveur Python sont dans la racine

un affichage des courbes températures et conso électrique est aussi accessible avec le bouton i 
il fonctionne en mode simulation en Windows si vous placer le fichier TempJsonSample.json dans le répertoire de l'application.
cette partie est pas terminée.

une partie python flask montre le serveur avec affichage des graphes sur une page web avec bokeh et flask
ainsi que une version minimale pour l'application Delphi

