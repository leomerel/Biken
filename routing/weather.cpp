#include "weather.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrl>

#include <QByteArray>
#include <QEvent>
#include <QDebug>
#include <QObject>
#include <QEventLoop>

#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QFile>
#include <QDir>

Weather::Weather(QObject *parent) : QObject(parent) {}

Forecast::Forecast(double wDir,
                   double wS,
                   double temp,
                   QString dt,
                   QString wDes,
                   bool active,
                   QString code)
{
    windDirection = wDir;
    windSpeed = wS;
    temperature = temp;
    weatherDescription = wDes;
    this->active = active;
    iconCode = code;
    QStringList str = dt.split(QRegExp("\\s+"));
}

void Weather::createForecast(double lat, double lon)
{
    forecasts.clear();

    qDebug() << "Starting weather request for coord : " << lat << " , " << lon;
    this->lat = lat;
    this->lon = lon;

    QString lats =  QString::number(lat,'f',7),lons =QString::number(lon,'f',7);

    QUrl url("http://api.openweathermap.org/data/2.5/forecast?lat=" + lats + "&lon=" + lons + "&units=metric&APPID=ac69ab213a56edaffaac9baa47770444");
    QNetworkRequest request(url);

    QNetworkAccessManager *manager2 = new QNetworkAccessManager();

    //In this part, we create a loop that runs until the QNetworkReply has finished processing.
    QEventLoop loop;
    QObject::connect(manager2,
                     SIGNAL(finished(QNetworkReply*)), //finished is a signal from the QNetworkReply Class that is emitted when the reply has finished processing.
                     &loop,
                     SLOT(quit())); //slot from QEventLoop that calls exit()
    QNetworkReply* reply = manager2->get(request);
    loop.exec(); //enters the loop and stays in it until loop.exit() is called
    qDebug() << reply;

    //Put the reply in JSON
    if(reply->error() == QNetworkReply::NoError)
    {
        QString strReply = QString(reply->readAll()); //readAll returns a QByteArray -> we convert it into a String

        QJsonDocument jsonResponse = QJsonDocument::fromJson(strReply.toUtf8());
        QJsonObject jsonObj = jsonResponse.object();

        int length = jsonObj["list"].toArray().size();
        bool a;
        qDebug() << "length of weather list :" << length;
        for (int i=0;i<length;i++) {
            i == 0 ? a = 1 : a = 0;

            forecasts.push_back(Forecast(QJsonValue(jsonObj["list"])[i]["wind"]["deg"].toDouble(),
                    QJsonValue(jsonObj["list"])[i]["wind"]["speed"].toDouble(),
                    QJsonValue(jsonObj["list"])[i]["main"]["temp"].toDouble(),
                    QJsonValue(jsonObj["list"])[i]["dt_txt"].toString(),
                    QJsonValue(jsonObj["list"])[i]["weather"][0]["description"].toString(),
                    a,
                    QJsonValue(jsonObj["list"])[i]["weather"][0]["icon"].toString()));
        }

        translate();
        error.clear();
    }
    else {
        error = reply->errorString();
    }


}

void Weather::changeForecast(int id)
{
    unsigned index = unsigned(id);
    if (index <= forecasts.size()){
        qDebug() << "Changement de météo active :"<< id;
        for (auto &e : forecasts)
        {
            if (e.getActive())
            {
                e.swapActive();
            }
        }
        forecasts[index].swapActive();
    }
}

int Weather::findActive()
{
    int length = int(forecasts.size());
    for (int i=0;i<length;i++){
        if(forecasts[unsigned(i)].getActive()){return i;}
    }
    return 0;
}

double Weather::getActiveDirection(){
    int i = findActive();
    double dir;

    if (forecasts.size() == 0){
        return 0.0;
    }

    dir = forecasts[unsigned(i)].getWindDirection();

    return dir;
}

QString Weather::getActiveWindSpeed(){
    int i = findActive();

    if (forecasts.size() == 0){
        qDebug() << "Aucune météo disponible, retour d'une valeur par défaut";
        return "";
    }

    QString speed = QString::number(int(forecasts[unsigned(i)].getWindSpeed() * 3.6));

    return speed + " km/h";
}

double Weather::getActiveTemp(){
    int i = findActive();

    if (forecasts.size() == 0){
        qDebug() << "Aucune météo disponible, retour d'une valeur par défaut";
        return 0.0;
    }

    return forecasts[unsigned(i)].getTemp();
}

QString Weather::getActiveWindStrength(){
    int i = findActive();

    if (forecasts.size() == 0){
        qDebug() << "Aucune météo disponible, retour d'une valeur par défaut";
        return "No Wind available";
    }

    double speed = forecasts[unsigned(i)].getWindSpeed() * 3.6;

    if (speed < 20.0){
        return "qrc:/icons/ventF1.png";
    }
    else if (speed < 50.0) {
        return "qrc:/icons/ventF2.png";
    }
    else {
        return "qrc:/icons/ventF3.png";
    }

}

QString Weather::getActiveDescription(){
    int i = findActive();

    if (forecasts.size() == 0){
        qDebug() << "Aucune météo disponible, retour d'une valeur par défaut";
        return "No Description available";
    }

    return forecasts[unsigned(i)].getDescription();
}

QString Weather::getActiveIcon(){
    int i = findActive();

    if (forecasts.size() == 0){
        qDebug() << "APPEL DU CODE ------------ aucune météo disponible";
        return "qrc:/icons/01d.png";
    }

    QString code = forecasts[unsigned(i)].getIcon();
    return "qrc:/icons/"+code+".png";

}

void Weather::translate(){

    QFile file;
    QString trad;
    file.setFileName("../routing/translation/weather_descriptions.json");
    //Attention, ce chemin correspond à un acces depuis le build,
    //il faut trouver le moyen de faire un chemin correpondant au dossier d'installation du logiciel.
    file.open(QIODevice::ReadOnly |  QIODevice::Text);

    trad = file.readAll();
    file.close();

    QJsonDocument doc = QJsonDocument::fromJson(trad.toUtf8());
    QJsonObject jsonobj = doc.object();
    QJsonValue traduction = jsonobj.value(QString("french"));

    for (auto &e : forecasts){
        QString save = e.getDescription();
        e.setDescription(traduction[e.getDescription()].toString());
        if (e.getDescription().isEmpty()){
            e.setDescription("Translation error : " + save);
        }

    }

}
