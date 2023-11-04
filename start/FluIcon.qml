import QtQuick 2.15
import QtQuick.Controls 2.15

Text {
    property int iconSource
    property int iconSize: 20
    property color iconColor: false ? "#FFFFFF" : "#000000"
    id:control
    font.family: "Segoe Fluent Icons"
    font.pixelSize: iconSize
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    color: iconColor
    text: (String.fromCharCode(iconSource).toString(16))
    FontLoader{
        source: "../start/Font/Segoe_Fluent_Icons.ttf"
    }
}
