import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import AkshUI 1.0

Button {
    display: Button.IconOnly
    property bool isDark: false
    property int iconSize: 20
    property int iconSource
    property bool disabled: false
    property int radius:4
    property string contentDescription: ""
    property color hoverColor: isDark ? Qt.rgba(1,1,1,0.03) : Qt.rgba(0,0,0,0.03)
    property color pressedColor: isDark ? Qt.rgba(1,1,1,0.06) : Qt.rgba(0,0,0,0.06)
    property color normalColor: isDark ? Qt.rgba(0,0,0,0) : Qt.rgba(0,0,0,0)
    property color disableColor: isDark ? Qt.rgba(0,0,0,0) : Qt.rgba(0,0,0,0)
    property Component iconDelegate: com_icon
    property color color: {
        if(!enabled){
            return disableColor
        }
        if(pressed){
            return pressedColor
        }
        return hovered ? hoverColor : normalColor
    }
    property color iconColor: {
        if(isDark){
            if(!enabled){
                return Qt.rgba(130/255,130/255,130/255,1)
            }
            return Qt.rgba(1,1,1,1)
        }else{
            if(!enabled){
                return Qt.rgba(161/255,161/255,161/255,1)
            }
            return Qt.rgba(0,0,0,1)
        }
    }
    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.description: contentDescription
    Accessible.onPressAction: control.clicked()
    id:control
    focusPolicy:Qt.TabFocus
    padding: 0
    verticalPadding: 8
    horizontalPadding: 8
    enabled: !disabled
    background: Rectangle{
        implicitWidth: 30
        implicitHeight: 30
        radius: control.radius
        color:control.color
        Item {
            property int radius: 4
            id:controlFocus
            visible: control.activeFocus
            anchors.fill: parent
            Rectangle{
                width: controlFocus.width
                height: controlFocus.height
                anchors.centerIn: parent
                color: "#00000000"
                border.width: 2
                radius: controlFocus.radius
                border.color: isDark ? Qt.rgba(1,1,1,1) : Qt.rgba(0,0,0,1)
                z: 65535
            }
        }
    }
    Component{
        id:com_icon
        FluIcon {
            id:text_icon
            font.pixelSize: iconSize
            iconSize: control.iconSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            iconColor: control.iconColor
            iconSource: control.iconSource
        }
    }
    Component{
        id:com_row
        RowLayout{
            Loader{
                sourceComponent: iconDelegate
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                visible: display !== Button.TextOnly
            }
            Text{
                text:control.text
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                visible: display !== Button.IconOnly
                renderType: Text.QtRendering
                font: FluTextStyle.Body
            }
        }
    }
    Component{
        id:com_column
        ColumnLayout{
            Loader{
                sourceComponent: iconDelegate
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                visible: display !== Button.TextOnly
            }
            Text{
                text:control.text
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                visible: display !== Button.IconOnly
                renderType: Text.QtRendering
                font: FluTextStyle.Body
            }
        }
    }
    contentItem:Loader{
        sourceComponent: {
            if(display === Button.TextUnderIcon){
                return com_column
            }
            return com_row
        }
    }
}
