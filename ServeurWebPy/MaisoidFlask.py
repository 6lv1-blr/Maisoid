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


@app.route("/updatesvn")
def updatesvn():
    """ update svn """
    run('/usr/bin/svn up /home/pi/ServeurWebPy/', shell=True)
    return render_template('index.html', nomSite = 'Svn a été rechargé', temp=getTemp())


@app.route('/')
def index():
    #return 'Hello world'
    return render_template('index.html', nomSite = 'Belair Maisoid', temp=getTemp())

@app.route("/graphTemp")
def graphTempToday():
    return graphTemp(None)

def sqlVersListe(IdCapteur,dateparam):
    points = []
    temperatures = []
    db = MySQLdb.connect("192.168.1.XXX", "remoteuser", "remotepass", "remotebase")
    cursor = db.cursor()
    if dateparam is None:
        FenetreTemps = ""
    else:
        FenetreTemps = " and date(timestamp) = '" + dateparam.strftime('%Y/%m/%d')+"'"
    sql = "select TimeStamp,avg(Temperature) OVER (ORDER BY NumeroAuto ROWS BETWEEN "+str(ModuloGraphe)+" PRECEDING AND "+str(ModuloGraphe)+" FOLLOWING) AS moytemp FROM Temperature"+str(IdCapteur)+" where (Mod(NumeroAuto,"+str(ModuloGraphe)+") = 0) and (IdCapteur="+str(IdCapteur)+")"

    cursor.execute(sql + FenetreTemps)
    myresult = cursor.fetchall()

    for line in myresult:
        # Voir explications sur le site
        points.append(line[0])
        temperatures.append(line[1])
    #print ([points, temperatures])
    return [points, temperatures]

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

def sqlLinkyVersListe(TypeValeur,dateparam,HCouHP):
    DatePointsLinky = []
    ConsommationLinky = []
    indexcolonne = 1
    if dateparam is None:
        if TypeValeur == 'PAPP':
            sql = "SELECT rec_date,PAPP FROM consommationelecparjour Where Mode_HC_ou_HP = '"+ HCouHP +"' ORDER BY Rec_date DESC"
        else:
            sql = "SELECT rec_date,Conso FROM consommationelecparjour Where Mode_HC_ou_HP = '"+ HCouHP +"' ORDER BY Rec_date DESC"
    else:
        if TypeValeur == 'PAPP':
            sql = "CALL ConsommationCourbe('" + dateparam.strftime('%Y/%m/%d')+"', '"+ HCouHP +"')"
            indexcolonne = 3
        elif TypeValeur == 'PAPPMoy':
            sql = "CALL ConsommationCourbe('" + dateparam.strftime('%Y/%m/%d')+"', '"+ HCouHP +"')"
            indexcolonne = 1
        else:
            sql = "CALL ConsommationCourbe('" + dateparam.strftime('%Y/%m/%d')+"', '"+ HCouHP +"')"
            indexcolonne = 2


    db = MySQLdb.connect("192.168.1.XXX", "remoteuser", "remotepass", "reotebase")
    cursor = db.cursor()

    cursor.execute(sql)
    myresult = cursor.fetchall()

    #CALL ConsommationCourbe('2019-11-21','HC..');

    #print (myresult)

    for line in myresult:
        # Voir explications sur le site
        DatePointsLinky.append(line[0])
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

@app.route("/Linky/<dateparam>")
def Linky(dateparam):
    global ModuloGraphe
    if request.args.get('datasample') is not None:
        ModuloGraphe = request.args['datasample']
    if dateparam is None:
        # On a entre 192.xx.xx.xx/graphTemp sans indiquer de date, on affiche donc le graph du jour
        d = datetime.datetime.now()
        ListCapteurCourbe = [
         ['HC..','PAPP','Blue'],
         ['HP..','PAPP','Red'],
         ['HC..','CONSO','Green'],
         ['HP..','CONSO','Yellow']
        ]
        titre = "Consomation Electrique"
    else:
        # Sinon, on affiche le graph de la date donnee | Ex : 192.xx.xx.xx/graphTemp/20180618
        ListCapteurCourbe = [
         ['HC..','PAPP','Blue'],
         ['HP..','PAPP','Red'],
         ['HC..','PAPPMoy','Blue'],
         ['HP..','PAPPMoy','Red']
        ]
        d = datetime.datetime.strptime(dateparam, '%Y%m%d')
        # Les 6 prochaines lignes permettent d'avoir un titre type : 08/09/2018 au lieu de 8/9/2018
        strMonth = str(d.month)
        strDay = str(d.day)
        if len(strMonth) == 1:
            strMonth = "0" + strMonth
        if len(strDay) == 1:
            strDay = "0" + strDay
        dateTitle = strDay + "/" + strMonth + "/" + str(d.year)
        titre = "Statistiques du " + dateTitle
        dateparam = d

    MinimumDate=0
    MaximumDate=0

    time_range= [None]*len(ListCapteurCourbe)
    avg_temp = [None]*len(ListCapteurCourbe)
    for i in range(len(ListCapteurCourbe)):
        DateEtConsoLinky = sqlLinkyVersListe(ListCapteurCourbe[i][1],dateparam,ListCapteurCourbe[i][0])
        #print(DateEtConsoLinky )
        # convert data into lists
        time_range[i] = list(DateEtConsoLinky[0])
        avg_temp[i] = list(DateEtConsoLinky[1])

        if MinimumDate == 0:
            MinimumDate = time_range[i][0]
            MaximumDate = time_range[i][0]
        MinimumDate = min(min(time_range[i]),MinimumDate)
        MaximumDate = max(max(time_range[i]),MaximumDate)

    # for i, year in enumerate(data.Year):
    #     T = resource_check(data['T'][i])
    #     TM = resource_check(data['TM'][i])
    #     Tm = resource_check(data['Tm'][i])
    #     # exclude any year that's missing any data
    #     if T is not None or TM is not None or Tm is not None:
    #         time_range.append(year)
    #         avg_temp.append(T)
    #         avg_max_temp.append(TM)
    #         avg_min_temp.append(Tm)

    # overall size and look of graph
    fig = figure(title='Belair Linky ({} - {})'.format(MinimumDate,MaximumDate),
                 toolbar_location="above",
                 plot_width=1800, plot_height=800, x_axis_type="datetime")

    # x/y axis for the lines

    #print(avg_temp)

    # upper and lower limits for the box annotations
    lower_limit = 10 #(min(average) - max(minimum)) / 2 + max(minimum)
    upper_limit = 18 #(min(maximum) - max(average)) / 2 + max(average)
    low_box = BoxAnnotation(top=lower_limit, fill_alpha=0.1, fill_color='blue')
    mid_box = BoxAnnotation(bottom=lower_limit, top=upper_limit, fill_alpha=0.1, fill_color='green')
    high_box = BoxAnnotation(bottom=upper_limit, fill_alpha=0.1, fill_color='red')



    fig.add_layout(LinearAxis(y_range_name="mbar"), 'right')
    fig.yaxis[1].axis_label = 'Conso instantanée'
    # plot each of the lines
    for i in range(len(ListCapteurCourbe)):
        if (ListCapteurCourbe[i][1] != 'PAPP'):
            fig.line(time_range[i], avg_temp[i], line_width=1, legend_label=ListCapteurCourbe[i][0],  line_color=ListCapteurCourbe[i][2])

    #fig.y_range = Range1d(-5, 28)
    fig.extra_y_ranges = {"mbar": Range1d(start=980, end=1050)}

    #Y axis PAPP
    for i in range(len(ListCapteurCourbe)):
        if (ListCapteurCourbe[i][1] == 'PAPP'):
            fig.circle(time_range[i], avg_temp[i], size=3, legend_label=ListCapteurCourbe[i][0],line_dash=[4, 4], line_color=ListCapteurCourbe[i][2],y_range_name="mbar")

    # configure the x axis
    # fig.xaxis.ticker = time_range[::2]
    #fig.xaxis.ticker = xExt
    fig.xaxis.major_label_orientation = 3.14159 / 4

    fig.xaxis.formatter=DatetimeTickFormatter(
        minutes=["%H:%M"],
        hours=["%d/%m %H:%M"],
        days=["%d/%m/%Y"],
        months=["%m/%Y"],
        years=["%Y"],
    )
    fig.xaxis[0].ticker.desired_num_ticks=20

    # add circles to each data point on the lines
    # fig.circle(xExt, minimum, fill_color=None, line_color='blue', size=8, legend='Ext')
    # fig.circle(xExt, average, fill_color=None, line_color='green', size=8, legend='Garage')
    # fig.circle(xExt, maximum, fill_color=None, line_color='red', size=8, legend='Salon')
    fig.yaxis[0].axis_label = 'kWh'

    # tweak the graph
    #fig.add_layout(Title(text="Year's not included had missing data", align='center'), 'below')
    fig.add_layout(low_box)
    fig.add_layout(mid_box)
    fig.add_layout(high_box)

    # tweak the legend
    fig.legend.label_standoff = 5
    fig.legend.location = 'top_left'
    fig.legend.background_fill_alpha = 0.5

    # grab the static resources
    js_resources = INLINE.render_js()
    css_resources = INLINE.render_css()

    nextDate = d + datetime.timedelta(days=1)
    prevDate = d - datetime.timedelta(days=1)

    # render template
    script, div = components(fig)
    html = render_template(
        'indexbokeh.html',
        titre = titre,
        plot_script=script,
        plot_div=div,
        js_resources=js_resources,
        css_resources=css_resources,
        prevDate = "/Linky/" + prevDate.strftime("%Y%m%d"),
        nextDate = "/Linky/" + nextDate.strftime("%Y%m%d")
    )

    return encode_utf8(html)

@app.route("/Linky")
def Linkyfull():
    return Linky(None)


@app.route("/Bokeh/<dateparam>")
def Bokeh(dateparam):
    global ModuloGraphe
    ListeCapteursParam = None
    if request.args.get('datasample') is not None:
        ModuloGraphe = request.args['datasample']
    if request.args.get('capteur') is not None:
        ListeCapteursParam = [eval(str(request.args['capteur']))]
    if request.args.get('capteurs') is not None:
        ListeCapteursParam = eval(request.args['capteurs'])
    #return render_template('index.html', nomSite = 'Belair Modulo'+str(ListeCapteursParam), temp=getTemp())
    if dateparam is None:
        # On a entre 192.xx.xx.xx/graphTemp sans indiquer de date, on affiche donc le graph du jour
        d = datetime.datetime.now()
        titre = "Température actuelle"
    else:
        # Sinon, on affiche le graph de la date donnee | Ex : 192.xx.xx.xx/graphTemp/20180618
        d = datetime.datetime.strptime(dateparam, '%Y%m%d')
        # Les 6 prochaines lignes permettent d'avoir un titre type : 08/09/2018 au lieu de 8/9/2018
        strMonth = str(d.month)
        strDay = str(d.day)
        if len(strMonth) == 1:
            strMonth = "0" + strMonth
        if len(strDay) == 1:
            strDay = "0" + strDay
        dateTitle = strDay + "/" + strMonth + "/" + str(d.year)
        titre = "Statistiques du " + dateTitle
        dateparam = d

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
    #ListeCapteursParam = ['Pression','Garage',15]
    if (ListeCapteursParam is not None):
        ListCapteurCourbe = [i for i in ListCapteurCourbe if (i[0] in ListeCapteursParam) or ((i[1] in ListeCapteursParam))]

    MinimumDate=0
    MaximumDate=0
    MinimumTemp=50
    MaximumTemp=0

    time_range= [None]*len(ListCapteurCourbe)
    avg_temp = [None]*len(ListCapteurCourbe)
    for i in range(len(ListCapteurCourbe)):
        pointsAndTemp = sqlVersListe(ListCapteurCourbe[i][1],dateparam)

        # convert data into lists
        time_range[i] = list(pointsAndTemp[0])
        avg_temp[i] = list(pointsAndTemp[1])

        if (ListCapteurCourbe[i][0] != 'Pression'):
            if MinimumDate == 0:
                MinimumDate = time_range[i][0]
            if MaximumDate == 0:
                MaximumDate = time_range[i][0]
            MinimumDate = min(min(time_range[i]),MinimumDate)
            MaximumDate = max(max(time_range[i]),MaximumDate)
            MinimumTemp = min(min(avg_temp[i]),MinimumTemp)
            MaximumTemp = max(max(avg_temp[i]),MaximumTemp)

    # for i, year in enumerate(data.Year):
    #     T = resource_check(data['T'][i])
    #     TM = resource_check(data['TM'][i])
    #     Tm = resource_check(data['Tm'][i])
    #     # exclude any year that's missing any data
    #     if T is not None or TM is not None or Tm is not None:
    #         time_range.append(year)
    #         avg_temp.append(T)
    #         avg_max_temp.append(TM)
    #         avg_min_temp.append(Tm)

    # overall size and look of graph
    fig = figure(title='Belair Temperatures ({} - {})'.format(MinimumDate,MaximumDate),
                 toolbar_location="above",
                 plot_width=1800, plot_height=800, x_axis_type="datetime")

    # x/y axis for the lines

    #print(avg_temp)

    # upper and lower limits for the box annotations
    lower_limit = 10 #(min(average) - max(minimum)) / 2 + max(minimum)
    upper_limit = 18 #(min(maximum) - max(average)) / 2 + max(average)
    low_box = BoxAnnotation(top=lower_limit, fill_alpha=0.1, fill_color='blue')
    mid_box = BoxAnnotation(bottom=lower_limit, top=upper_limit, fill_alpha=0.1, fill_color='green')
    high_box = BoxAnnotation(bottom=upper_limit, fill_alpha=0.1, fill_color='red')



    fig.extra_y_ranges = {"mbar": Range1d(start=980, end=1050)}
    fig.add_layout(LinearAxis(y_range_name="mbar"), 'right')
    fig.yaxis[1].axis_label = 'pression (mbar)'
    # plot each of the lines
    for i in range(len(ListCapteurCourbe)):
        if (ListCapteurCourbe[i][0] != 'Pression'):
            fig.line(time_range[i], avg_temp[i], line_width=1, legend_label=ListCapteurCourbe[i][0],  line_color=ListCapteurCourbe[i][2])

    fig.y_range = Range1d(-5, 28)
    #Y axis mbar
    for i in range(len(ListCapteurCourbe)):
        if (ListCapteurCourbe[i][0] == 'Pression'):
            fig.line(time_range[i], avg_temp[i], line_width=1, legend_label=ListCapteurCourbe[i][0],line_dash=[4, 4], line_color=ListCapteurCourbe[i][2],y_range_name="mbar")

    # configure the x axis
    # fig.xaxis.ticker = time_range[::2]
    #fig.xaxis.ticker = xExt
    fig.xaxis.major_label_orientation = 3.14159 / 4

    fig.xaxis.formatter=DatetimeTickFormatter(
        minutes=["%H:%M"],
        hours=["%d/%m %H:%M"],
        days=["%d/%m/%Y"],
        months=["%m/%Y"],
        years=["%Y"],
    )
    fig.xaxis[0].ticker.desired_num_ticks=20

    # add circles to each data point on the lines
    # fig.circle(xExt, minimum, fill_color=None, line_color='blue', size=8, legend='Ext')
    # fig.circle(xExt, average, fill_color=None, line_color='green', size=8, legend='Garage')
    # fig.circle(xExt, maximum, fill_color=None, line_color='red', size=8, legend='Salon')
    fig.yaxis[0].axis_label = 'Temperatures (°C)'

    # tweak the graph
    #fig.add_layout(Title(text="Year's not included had missing data", align='center'), 'below')
    fig.add_layout(low_box)
    fig.add_layout(mid_box)
    fig.add_layout(high_box)

    # tweak the legend
    fig.legend.label_standoff = 5
    fig.legend.location = 'top_left'
    fig.legend.background_fill_alpha = 0.5

    # grab the static resources
    js_resources = INLINE.render_js()
    css_resources = INLINE.render_css()

    nextDate = d + datetime.timedelta(days=1)
    prevDate = d - datetime.timedelta(days=1)

    # render template
    script, div = components(fig)
    html = render_template(
        'indexbokeh.html',
        titre = titre,
        plot_script=script,
        plot_div=div,
        js_resources=js_resources,
        css_resources=css_resources,
        prevDate = "/Bokeh/" + prevDate.strftime("%Y%m%d"),
        nextDate = "/Bokeh/" + nextDate.strftime("%Y%m%d")
    )

    return encode_utf8(html)

@app.route("/Bokeh")
def BokehContinue():
    return Bokeh(None)

# Entree : Liste; Sortie : Moyenne de cette liste
def moyenneListe(liste):
    res = 0
    for i in liste:
        res += i
    return (res/len(liste))


@app.route("/graphTemp/<date>")
def graphTemp(date):
    if date is None:
        # On a entre 192.xx.xx.xx/graphTemp sans indiquer de date, on affiche donc le graph du jour
        d = datetime.datetime.now()
        titre = "Température actuelle : " + str(getTemp())
    else:
        # Sinon, on affiche le graph de la date donnee | Ex : 192.xx.xx.xx/graphTemp/20180618
        d = datetime.datetime.strptime(date, '%Y%m%d')
        # Les 6 prochaines lignes permettent d'avoir un titre type : 08/09/2018 au lieu de 8/9/2018
        strMonth = str(d.month)
        strDay = str(d.day)
        if len(strMonth) == 1:
            strMonth = "0" + strMonth
        if len(strDay) == 1:
            strDay = "0" + strDay
        dateTitle = strDay + "/" + strMonth + "/" + str(d.year)
        titre = "Statistiques du " + dateTitle
    # Liste contenant deux liste :
    # pointsAndTemp[0] : coordonnees des points du graph;
    # pointsAndTemp[1] : temperatures, permet de faire des stats : max,min,moy
    pointsAndTemp = sqlVersListe(11,d)
    temperatures = pointsAndTemp[1]
    pointsDate = []
    for i in range(len(pointsAndTemp[0])):
        pointsDate.append([pointsAndTemp[0][i][0],int(pointsAndTemp[0][i][1])])
    # On calcule des dates precedantes et suivantes pour la navigation entre les jours
    nextDate = d + datetime.timedelta(days=1)
    prevDate = d - datetime.timedelta(days=1)
    # On retourne tout a la page graphTemp.html
    return render_template(
        'graphTemp.html',
        d = d.strftime("%Y-%m-%d"),
        titre = titre,
        temp = getTemp(),
        points = pointsDate,
        tempMin = round(min(temperatures), 1),
        tempMax = round(max(temperatures), 1),
        tempMoy = round(moyenneListe(temperatures), 1),
        prevDate = "/graphTemp/" + prevDate.strftime("%Y%m%d"),
        nextDate = "/graphTemp/" + nextDate.strftime("%Y%m%d")
    )


@app.route('/Domotique/EtatDomotiqueBelair.php')
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

@app.route('/Domotique/ListeTemp')
def returnlisteTemp():
        db = MySQLdb.connect("192.168.1.XXX", "remoteuser", "remotepass", "reotebase")
        cursor = db.cursor()
        sql = "select * FROM Temperatures"
        cursor.execute(sql)
        myresultall = cursor.fetchall()

        #for x in myresultall:
        #    print(x)

        sql = "select Temperature FROM Temperatures order by timestamp DESC LIMIT 1"
        cursor.execute(sql)
        myresult = cursor.fetchall()

        #for x in myresult:
        #    print(x[0])
        return str(myresultall)

context = ('/etc/letsencrypt/live/siteweb.com/cert.pem', '/etc/letsencrypt/live/siteweb.com/privkey.pem')


#app.run( host='0.0.0.0', port=5000) # pour mode non ssl
app.run(host='0.0.0.0', port=5000, threaded=True, debug=True, ssl_context=context)
app.add_url_rule('/favicon.ico', url_for('static', filename='favicon.ico'))

