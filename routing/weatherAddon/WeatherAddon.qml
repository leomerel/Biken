import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 2.4
import QtLocation 5.6
import QtPositioning 5.6
import QtQuick.Controls.Private 1.0
import QtQuick.Layouts 1.2

//This item has to be summon from a Rectangle with size parameters and id : meteoContainer
ColumnLayout {
    id : weatherAddon
    width : meteoContainer.width
    height: meteoContainer.height
    spacing:7
    Layout.alignment: Qt.AlignCenter

    Button{
        id:testWeather
        Layout.alignment: Qt.AlignCenter
        height: 20
        visible:true
        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 2
            font.pixelSize: 12
            text: "TEST"
            color: "black"
        }
        onClicked: {
            weather.createForecast(48.4000000,-4.4833300);
            if(!weather.getError()){
                testWeather.visible = false;
                weatherIcon.source = weather.getActiveIcon();
                weatherDescription.text = weather.getActiveDescription();
                windSpeed.text = weather.getActiveWindSpeed();
                windIcon.source = weather.getActiveWindStrength();
                windIcon.rotation = weather.getActiveDirection();
                weatherItem.visible = true;
                windItem.visible = true;
                box.visible = true;
                errorItem.visible = false
            }
            else{
                errorDescription.text = weather.getError();
                weatherItem.visible = false;
                windItem.visible = false;
                box.visible = false;
                errorItem.visible = true;
                testWeather.visible = true;
            }
        }
    }

    Text{
        id:weatherTitle
        font.pixelSize: 20
        color:"#ffffff"
        font.family: comfortaalight.name
        text: "Weather Forecast"
        Layout.alignment: Qt.AlignCenter
    }

    ComboBox {
        id: box
        width: 0.8*meteoContainer.width
        visible: false
        Layout.alignment: Qt.AlignCenter
        Layout.leftMargin: 20
        Layout.rightMargin: 20
        Layout.fillWidth: true
        font.pixelSize: 20
        font.family: comfortaalight.name
        model: ListModel{

            id: forecastItem
            ListElement{text:"Now"}
            ListElement{text:"+ 3 heures"}
            ListElement{text:"+ 6 heures"}
            ListElement{text:"+ 9 heures"}
            ListElement{text:"+ 12 heures"}
            ListElement{text:"+ 15 heures"}
            ListElement{text:"+ 18 heures"}
            ListElement{text:"+ 21 heures"}
            ListElement{text:"+ 24 heures"}
            ListElement{text:"+ 1 jour et 3 heures"}
            ListElement{text:"+ 1 jour et 06 heures"}
            ListElement{text:"+ 1 jour et 09 heures"}
            ListElement{text:"+ 1 jour et 12 heures"}
            ListElement{text:"+ 1 jour et 15 heures"}
            ListElement{text:"+ 1 jour et 18 heures"}
            ListElement{text:"+ 1 jour et 21 heures"}
            ListElement{text:"+ 2 jours"}
            ListElement{text:"+ 2 jours et 03 heures"}
            ListElement{text:"+ 2 jours et 06 heures"}
            ListElement{text:"+ 2 jours et 09 heures"}
            ListElement{text:"+ 2 jours et 12 heures"}
            ListElement{text:"+ 2 jours et 15 heures"}
            ListElement{text:"+ 2 jours et 18 heures"}
            ListElement{text:"+ 2 jours et 21 heures"}
            ListElement{text:"+ 3 jours"}
        }
        onCurrentIndexChanged: {
            if (weatherItem.visible === true){
                weather.changeForecast(box.currentIndex);
                weatherIcon.source = weather.getActiveIcon();
                weatherDescription.text = weather.getActiveDescription();
                windIcon.source = weather.getActiveWindStrength();
                windIcon.rotation = weather.getActiveDirection();
                windSpeed.text = weather.getActiveWindSpeed();
            }
        }
    }

    RowLayout{
        spacing:10


        ColumnLayout{
            id:weatherItem
            visible:false
            spacing : 10
            Text{
                id:weatherDescription
                Layout.margins: 10
                Layout.alignment: Qt.AlignCenter
                font.pixelSize: 20
                color:"#ffffff"
                font.family: comfortaalight.name
            }
            Image {
                id: weatherIcon
                asynchronous: true
                Layout.margins: 10
                Layout.alignment: Qt.AlignCenter
                sourceSize.width : 0.2*meteoContainer.width
                sourceSize.height : 0.2*meteoContainer.height
                fillMode: Image.Stretch
            }
        }
        ColumnLayout{
            id:windItem
            visible: false
            spacing : 10
            Text{
                id:windSpeed
                Layout.alignment: Qt.AlignCenter
                Layout.margins: 10
                font.pixelSize: 20
                color:"#ffffff"
                font.family: comfortaalight.name
            }
            Image {
                id: windIcon
                asynchronous: true
                Layout.margins: 10
                Layout.alignment: Qt.AlignCenter
                sourceSize.width : 0.2*meteoContainer.width
                sourceSize.height : 0.2*meteoContainer.height
                fillMode: Image.Stretch
            }
        }
    }


    ColumnLayout {
        id: errorItem
        visible: false
        spacing:10
        Layout.alignment: Qt.AlignCenter
        Text{
            font.pixelSize: 20
            color:"#ffffff"
            font.family: comfortaalight.name
            id:errorDescription
            Layout.alignment: Qt.AlignCenter
        }
        Image{
            id :errorIcon
            asynchronous: true
            Layout.margins: 10
            Layout.alignment: Qt.AlignCenter
            sourceSize.width : 0.3*meteoContainer.width
            sourceSize.height : 0.3*meteoContainer.height
            fillMode: Image.Stretch
            source: "qrc:/icons/connexion.png"
        }

    }
}