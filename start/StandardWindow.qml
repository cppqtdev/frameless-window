import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.wangwenx190.FramelessHelper 1.0

MainWindow {
    id:window
    title:"Standard"
    width: 800
    height: 600
    fixSize: false

    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: timeLabel.text = Qt.formatTime(new Date(), "hh:mm:ss")
    }

    Label {
        id: timeLabel
        anchors.centerIn: parent
        font {
            pointSize: 70
            bold: true
        }
        color: (FramelessUtils.systemTheme === FramelessHelperConstants.Dark) ? Qt.color("white") : Qt.color("black")
    }
}
