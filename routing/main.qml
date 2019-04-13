import QtQuick 2.5
import QtQuick.Window 2.2
import QtLocation 5.6
import QtPositioning 5.6
import "helper.js" as Helper
import "map"

/*
  Coodrinates for the test:
  48.368718
  -4.588330

  48.535807
  -4.658547
*/

Window {
    id: mainWaindow

    property var map

    width: 1500
    minimumWidth: 800
    height: 800
    minimumHeight: 400
    visible: true

    Rectangle{
        id: mapContainer
        width: 0.8*parent.width
        height: 0.7*parent.height
        anchors.right: parent.right
        anchors.top: parent.top
        color: "green"

        Plugin {
            id: mapPlugin
            preferred: ["osm", "esri"]
        }
    }

    MyMap {
        //permet de créer un object MyMap (défini dans le fichier "MyMap.qml")
        id : thisIsTheMap
        anchors.fill: mapContainer
        plugin: mapPlugin
    }

    Rectangle{
        id: paramContainer
        width: 0.2*parent.width
        height: 0.7*parent.height
        anchors.right: mapContainer.left
        anchors.top: parent.top
        color: "#252525"
        border.color: "white"

        Text {
            id: depart
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 150
            text: qsTr("Depart")
            font.pixelSize: 12
            color:"white"
        }

        Rectangle{
            id: departInputRectangle
            anchors.left: depart.right
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 150
            width: 200
            height: 20
            color: "black"
            TextInput{
                id: fromLatitude
                width:100
                height:20
                anchors.left:parent.left
                font.pixelSize: 12
                color:"white"
            }
            TextInput{
                id: fromLongitude
                width:100
                height:20
                anchors.left:fromLatitude.right
                font.pixelSize: 12
                color:"white"
            }
        }

        Text {
            id: arrivee
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: depart.top
            anchors.topMargin: 30
            text: qsTr("Arrivee")
            font.pixelSize: 12
            color:"white"
        }

        Rectangle{
            id: arriveeInputRectangle
            anchors.left: arrivee.right
            anchors.leftMargin: 10
            anchors.top: departInputRectangle.top
            anchors.topMargin: 30
            width: 200
            height: 20
            color: "black"

            TextInput{
                id: toLatitude
                width:100
                height:20
                anchors.left:parent.left
                font.pixelSize: 12
                color:"white"
            }
            TextInput{
                id: toLongitude
                width:100
                height:20
                anchors.left:toLatitude.right
                font.pixelSize: 12
                color:"white"
            }
        }

        Rectangle{
            id: validation
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: arrivee.top
            anchors.topMargin: 30
            width: 200
            height: 20
            color: "black"
            Text{
                anchors.fill: parent
                font.pixelSize: 12
                text: "Valider"
                color: "white"
            }
            MouseArea{
                anchors.fill: parent
                onPressed: {
                    /*var startCoordinate = QtPositioning.coordinate(parseFloat(fromLatitude.text),
                                                                   parseFloat(fromLongitude.text));
                    var endCoordinate = QtPositioning.coordinate(parseFloat(toLatitude.text),
                                                                 parseFloat(toLongitude.text));*/
                    var startCoordinate = QtPositioning.coordinate(48.368718, -4.588330);
                    var endCoordinate = QtPositioning.coordinate(48.535807,-4.658547);
                    if (startCoordinate.isValid && endCoordinate.isValid) {
                        thisIsTheMap.calculateCoordinateRoute(startCoordinate,endCoordinate)
                    }
                }
            }
        }

        Rectangle{
            width: 280
            height: 300
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: validation.top
            anchors.topMargin: 30
            color:"#dddddd"
            Text{
                id: textToDisplay
                anchors.fill: parent
                font.pixelSize: 12
                color:"black"
            }
        }
    }

    Rectangle{
        id: meteoContainer
        width: 0.2*parent.width
        height: 0.3*parent.height
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        color: "#2525ff"
        border.color: "white"
    }

    Rectangle{
        id: overviewContainer
        width: 0.8*parent.width
        height: 0.3*parent.height
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        color: "#252525"
        border.color: "white"
    }

    /*MouseArea{
        id: mapMouseArea
        anchors.fill: mapContainer
        onPressAndHold: {
            mainWaindow.xtext=mapMouseArea.mouseX
        }
    }*/
}
