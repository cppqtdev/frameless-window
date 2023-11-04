import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

import "../component"

FluWindow {

    id:window
    title:"about"
    width: 600
    height: 650
    fixSize: true
    launchMode: FluWindowType.SingleTask

    ColumnLayout{
        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
        }

        RowLayout{
            Layout.topMargin: 20
            Layout.leftMargin: 15
            spacing: 14
            FluText{
                text:"QRCode Generator"
                font: FluTextStyle.Title
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        FluApp.navigate("/")
                    }
                }
            }
            FluText{
                text:"v%1".arg(AppInfo.version)
                font: FluTextStyle.Body
                Layout.alignment: Qt.AlignBottom
            }
        }

        RowLayout{
            spacing: 14
            Layout.topMargin: 20
            Layout.leftMargin: 15
            FluText{
                text:"author:"
            }
            FluText{
                text:"Adesh Singh"
                Layout.alignment: Qt.AlignBottom
            }
        }

        RowLayout{
            spacing: 14
            Layout.leftMargin: 15
            FluText{
                text:"GitHub："
            }
            FluTextButton{
                id:text_hublink
                topPadding:0
                bottomPadding:0
                text:"https://github.com/cppqtdev/QtCodeGenerator"
                Layout.alignment: Qt.AlignBottom
                onClicked: {
                    Qt.openUrlExternally(text_hublink.text)
                }
            }
        }

        RowLayout{
            spacing: 14
            Layout.leftMargin: 15
            FluText{
                text:"Youtube :"
            }
            FluTextButton{
                topPadding:0
                bottomPadding:0
                text:"https://www.youtube.com/@techcoderhub"
                Layout.alignment: Qt.AlignBottom
                onClicked: {
                    Qt.openUrlExternally(text)
                }
            }
        }

        RowLayout{
            spacing: 14
            Layout.leftMargin: 15
            FluText{
                id:text_info
                Layout.maximumWidth: window.width * 0.9
                wrapMode: Label.WrapAtWordBoundaryOrAnywhere
                text:"If this project is useful to you, please click the link above to give a free star, or connect three times with one click, thank you!"
                ColorAnimation {
                    id: animation
                    target: text_info
                    property: "color"
                    from: "red"
                    to: "blue"
                    duration: 1000
                    running: true
                    loops: Animation.Infinite
                    easing.type: Easing.InOutQuad
                }
            }
        }

        RowLayout{
            spacing: 14
            Layout.topMargin: 20
            Layout.leftMargin: 15
            FluText{
                text:"Donate:"
            }
        }

        Item{
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: 252
            Row{
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 30
                Image{
                    width: 250
                    height: 250
                    source: "qrc:/qt/qml/start/res/image/qrcode_adeshsingh.png"
                }
                Image{
                    visible: false
                    width: 250
                    height: 250
                    source: "qrc:/qt/qml/start/res/image/qrcode_zfb.jpg"
                }
            }
        }

        RowLayout{
            spacing: 14
            Layout.leftMargin: 15
            Layout.topMargin: 20
            Layout.preferredHeight: 50
            FluText{
                id:text_desc
                Layout.maximumWidth: window.width * 0.9
                wrapMode: Label.WrapAtWordBoundaryOrAnywhere
                text:"Personal development and maintenance are not easy, your donations are the motivation for me to continue updating! \nIf you have any questions, please raise Issues and I will solve them as long as there is enough time! "
            }
        }
    }
}
