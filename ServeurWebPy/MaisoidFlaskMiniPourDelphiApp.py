from flask import Flask, render_template,url_for,request
import flask
import os
import time
import datetime

#from bokeh.templates import RESOURCES
from bokeh.plotting import figure
from bokeh.resources import CDN
from bokeh.embed import file_html

from bokeh.embed import components
from bokeh.models import Title, BoxAnnotation, DatetimeTickFormatter,HoverTool, tickers

from bokeh.resources import INLINE
from bokeh.util.string import encode_utf8
from bokeh.models import LinearAxis, Range1d

from flask.json import jsonify
from subprocess import run

import shutil
try:
    import pymysql
    pymysql.install_as_MySQLdb()
    import MySQLdb
except ImportError:
    pass

ModuloGraphe = 1

app = Flask(__name__)
def getTemp():
        db = MySQLdb.connect("192.168.1.XXX", "remoteuser", "remotepass", "remotebase")
        cursor = db.cursor()
        sql = "select NomCapteur,Temperature,Unite FROM Temperatures order by timestamp DESC LIMIT 1"
        cursor.execute(sql)
        myresult = cursor.fetchall()
        return (myresult[0][0]+" "+str(myresult[0][1])+myresult[0][2])




def sqlVersListeMaisoid(IdCapteur):
    points = []
    temperatures = []
    db = MySQLdb.connect("192.168.1.XXX", "remoteuser", "remotepass", "reotebase")
    cursor = db.cursor()

    FenetreTemps = " and date(timestamp) > '" + (datetime.datetime.now() - datetime.timedelta(days=10)).strftime('%Y/%m/%d')+"'"
    sql = "select TimeStamp,avg(Temperature) OVER (ORDER BY NumeroAuto ROWS BETWEEN "+str(4)+" PRECEDING AND "+str(4)+" FOLLOWING) AS moytemp FROM Temperature"+str(IdCapteur)+" where (IdCapteur="+str(IdCapteur)+")"

    cursor.execute(sql + FenetreTemps)
    myresult = cursor.fetchall()

    for line in myresult:
        # Voir explications sur le site
        points.append(int(time.mktime(line[0].timetuple())))
        temperatures.append(line[1])
    #print ([points, temperatures])
    return [points, temperatures]

def sqlLinkyVersListeMaisoid(TypeValeur,dateparam,HCouHP):
    DatePointsLinky = []
    ConsommationLinky = []
    indexcolonne = 1
    FenetreTemps = " and rec_date > '" + (datetime.datetime.now() - datetime.timedelta(days=10)).strftime('%Y/%m/%d') + "'"
    if dateparam is None:
        if TypeValeur == 'PAPP':
            sql = "SELECT rec_date,PAPP FROM consommationelecparjour Where Mode_HC_ou_HP = '"+ HCouHP +"'"+ FenetreTemps +" ORDER BY Rec_date DESC"
        else:
            sql = "SELECT rec_date,Conso FROM consommationelecparjour Where Mode_HC_ou_HP = '"+ HCouHP +"'"+ FenetreTemps +" ORDER BY Rec_date DESC"
    else:
        if TypeValeur == 'PAPP':
            sql = "CALL Consommation2Jours('" + datetime.datetime.now().strftime('%Y/%m/%d')+"', '"+ HCouHP +"')"
            indexcolonne = 3
        elif TypeValeur == 'PAPPMoy':
            sql = "CALL Consommation2Jours('" + datetime.datetime.now().strftime('%Y/%m/%d')+"', '"+ HCouHP +"')"
            indexcolonne = 1
        else:
            sql = "CALL Consommation2Jours('" + datetime.datetime.now().strftime('%Y/%m/%d')+"', '"+ HCouHP +"')"
            indexcolonne = 2


    db = MySQLdb.connect("192.168.1.XXX", "remoteuser", "remotepass", "reotebase")
    cursor = db.cursor()

    cursor.execute(sql)
    myresult = cursor.fetchall()


    #print (myresult)

    for line in myresult:
        # Voir explications sur le site
        DatePointsLinky.append(int(time.mktime(line[0].timetuple())))
        ConsommationLinky.append(line[indexcolonne])
    #print ([DatePointsLinky, ConsommationLinky])
    return [DatePointsLinky, ConsommationLinky]


@app.route("/TempJson")
def TempJson():
    global ModuloGraphe
    ModuloGraphe = 20
    ListCapteurCourbe = [
     ['Ext',2,'red'],
     ['Garage',1,'blue'],
     ['Salon',13,'green'],
     ['Bureau',14,'red'],
     ['Sde',15,'blue'],
     ['Elec',11,'green'],
     ['ChambreEst',21,'blue'],
     ['Nous',22,'green'],
     ['Bnb',23,'red'],
     ['Pression',12,'red']
    ]
    ListCompteurCourbe = [
         ['HC..','PAPP','Blue'],
         ['HP..','PAPP','Red'],
         ['HC..','CONSO','Green'],
         ['HP..','CONSO','Yellow']
        ]

    def TimeStampConverter(InputTime):
        return int(time.mktime(InputTime.timetuple()))

    pointsAndTemp = []
    #pointsAndTemp = [None]*(len(ListCapteurCourbe)+len(ListCapteurCourbe))
    for i in range(len(ListCapteurCourbe)):
        JsonArrayTemp = sqlVersListeMaisoid(ListCapteurCourbe[i][1])
        pointsAndTemp.append([JsonArrayTemp[0],JsonArrayTemp[1],ListCapteurCourbe[i][0]])

    for i in range(len(ListCompteurCourbe)):
        JsonArrayTemp = sqlLinkyVersListeMaisoid(ListCompteurCourbe[i][1],None,ListCompteurCourbe[i][0])
        pointsAndTemp.append([JsonArrayTemp[0],JsonArrayTemp[1],ListCompteurCourbe[i][0] + ListCompteurCourbe[i][1] + " Par Jour"])

    for i in range(len(ListCompteurCourbe)):
        JsonArrayTemp = sqlLinkyVersListeMaisoid(ListCompteurCourbe[i][1],'123',ListCompteurCourbe[i][0])
        pointsAndTemp.append([JsonArrayTemp[0],JsonArrayTemp[1],ListCompteurCourbe[i][0] + ListCompteurCourbe[i][1]])


    return jsonify(pointsAndTemp)





# Entree : Liste; Sortie : Moyenne de cette liste
def moyenneListe(liste):
    res = 0
    for i in liste:
        res += i
    return (res/len(liste))


@app.route('PageRetourneResultat')
def returnstatus():
    ListeEtat = []
    for x in os.listdir('/media/ramdiskNuit/EtatRelais/'):
        ListeEtat.append(128000+int(x))
    for x in os.listdir('/media/ramdiskJour/EtatRelais/'):
        ListeEtat.append(118000+int(x))
    for x in os.listdir('/media/ramdiskSousSol/EtatRelais/'):
        if int(x) >10:
                ListeEtat.append(108300+int(x))
        else:
                ListeEtat.append(108000+int(x))
    for x in os.listdir('/media/ramdiskNuit/EtatChauffage/'):
        ListeEtat.append('ENC'+x)
    for x in os.listdir('/media/ramdiskJour/EtatChauffage/'):
        ListeEtat.append('EJC'+x)
    for x in os.listdir('/media/ramdiskSousSol/EtatChauffage/'):
        ListeEtat.append('ESC'+x)
    for x in os.listdir('/media/ramdiskNuit/EtatTemperature/'):
        ListeEtat.append(x)
    for x in os.listdir('/media/ramdiskJour/EtatTemperature'):
        ListeEtat.append(x)
    for x in os.listdir('/media/ramdiskSousSol/EtatTemperature'):
        ListeEtat.append(x)
    for x in os.listdir('/media/ramdiskNuit/EtatInterrupteur/'):
        ListeEtat.append('ENI'+x)
    for x in os.listdir('/media/ramdiskJour/EtatInterrupteur/'):
        ListeEtat.append('EJI'+x)
    for x in os.listdir('/media/ramdiskSousSol/EtatInterrupteur/'):
        ListeEtat.append('ESI'+x)
    return jsonify(ListeEtat)


@app.route('PageDemandeActionRetourneResultat')
def PageDemandeActionRetourneResultat():
# copie un fichier dans la demande de scénario
# cette méthode permet d'éviter que des requetes d'attaque ne copie pas des données n'importe où
# un parametre non attendu ne fera du coup aucune action

    if request.args.get('parametrerequete') is not None:
        CompteurScenario = int(request.args['parametrerequete'])
        fichierAcopier = "/home/pi/ServeurWebPy/ScenariosSources/"
        if (int(CompteurScenario) == 111):
            fichierAcopier = ""
        elif (int(CompteurScenario) > 120000):
            CompteurScenario = CompteurScenario -120000;
            fichierAcopier = fichierAcopier + str(CompteurScenario) + ".Nuit.txt";
            emplacementFinal = "/media/ramdiskNuit/Scenarios/" + str(CompteurScenario);
            shutil.copyfile(fichierAcopier , emplacementFinal);
        elif (int(CompteurScenario) > 110000):
            CompteurScenario = CompteurScenario -110000;
            fichierAcopier = fichierAcopier + str(CompteurScenario) + ".Jour.txt";
            emplacementFinal = "/media/ramdiskJour/Scenarios/" + str(CompteurScenario);
            shutil.copyfile(fichierAcopier , emplacementFinal);
        elif (int(CompteurScenario) > 100000):
            CompteurScenario = CompteurScenario -100000;
            fichierAcopier = fichierAcopier + str(CompteurScenario) + ".SousSol.txt";
            emplacementFinal = "/media/ramdiskSousSol/Scenarios/" + str(CompteurScenario);
            shutil.copyfile(fichierAcopier , emplacementFinal);
            if (int(CompteurScenario) > 8300) and (int(CompteurScenario) < 8320):
                #pour les Sonoff attend plus longtemps la bascule
                time.sleep(1)
        else:
            fichierAcopier = fichierAcopier + str(CompteurScenario) + ".Jour.txt";
            emplacementFinal = "/media/ramdiskJour/Scenarios/" + str(CompteurScenario);
            shutil.copyfile(fichierAcopier , emplacementFinal);

    time.sleep(3/10)
    return returnstatus()



@app.route('/favicon.ico')
def favicon():
    return flask.send_from_directory(os.path.join(app.root_path, 'static'),
                          'favicon.ico',mimetype='image/vnd.microsoft.icon')

context = ('/etc/letsencrypt/live/siteweb.com/cert.pem', '/etc/letsencrypt/live/siteweb.com/privkey.pem')


#app.run( host='0.0.0.0', port=5000) # pour mode non ssl
app.run(host='0.0.0.0', port=5000, threaded=True, debug=True, ssl_context=context)
app.add_url_rule('/favicon.ico', url_for('static', filename='favicon.ico'))

