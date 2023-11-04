import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.wangwenx190.FramelessHelper 1.0
import Qt.labs.platform 1.1
import AkshUI 1.0
import example 1.0

Window {
    default property alias content: container.data
    QtObject{
        id:fluTheme
        property bool dark: false

    }

    property bool closeDestory: true
    property var argument:({})
    property var background : com_background
    property bool fixSize: false
    property Component loadingItem: com_loading
    property var appBar: com_app_bar
    property color backgroundColor: {
        if(active){
            return fluTheme.dark ? Qt.rgba(26/255,34/255,40/255,1) : Qt.rgba(243/255,243/255,243/255,1)
        }
        return fluTheme.dark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(237/255,237/255,237/255,1)
    }
    property bool stayTop: false
    property var _pageRegister
    property string _route
    property var closeListener: function(event){
        if(closeDestory){
            destoryOnClose()
        }else{
            visible = false
            event.accepted = false
        }
    }
    signal initArgument(var argument)
    id:window
    flags: Qt.Window | Qt.CustomizeWindowHint | Qt.WindowTitleHint | Qt.WindowSystemMenuHint | Qt.WindowMinMaxButtonsHint | Qt.WindowCloseButtonHint
    color: {
        if (FramelessHelper.blurBehindWindowEnabled) {
            return "transparent";
        }
        if (FramelessUtils.systemTheme === FramelessHelperConstants.Dark) {
            return FramelessUtils.defaultSystemDarkColor;
        }
        return FramelessUtils.defaultSystemLightColor;
    }
    onStayTopChanged: {
        d.changedStayTop()
    }
    Component.onCompleted: {
        initArgument(argument)
        d.changedStayTop()
    }

    QtObject{
        id:d
        function changedStayTop(){
            function toggleStayTop(){
                if(window.stayTop){
                    window.flags = window.flags | Qt.WindowStaysOnTopHint
                }else{
                    window.flags = window.flags &~ Qt.WindowStaysOnTopHint
                }
            }
            if(window.visibility === Window.Maximized){
                window.visibility = Window.Windowed
                toggleStayTop()
                window.visibility = Window.Maximized
            }else{
                toggleStayTop()
            }
        }
    }
    Connections{
        target: window
        function onClosing(event){closeListener(event)}
    }
    Component{
        id:com_background
        Rectangle{
            color: window.backgroundColor
        }
    }

    function distance(x1,y1,x2,y2){
        return Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
    }

    function handleDarkChanged(button){
        loader_reveal.sourceComponent = com_reveal
        var target = window.contentItem
        var pos = button.mapToItem(target,0,0)
        var mouseX = pos.x
        var mouseY = pos.y
        var radius = Math.max(distance(mouseX,mouseY,0,0),distance(mouseX,mouseY,target.width,0),distance(mouseX,mouseY,0,target.height),distance(mouseX,mouseY,target.width,target.height))
        var reveal = loader_reveal.item
        reveal.start(reveal.width*Screen.devicePixelRatio,reveal.height*Screen.devicePixelRatio,Qt.point(mouseX,mouseY),radius)
    }

    Loader{
        id:loader_reveal
        anchors.fill: parent
    }

    Component{
        id:com_reveal
        CircularReveal{
            id:reveal
            target:window.contentItem
            anchors.fill: parent
            onAnimationFinished:{
                //Release resources after animation ends
                loader_reveal.sourceComponent = undefined
            }
            onImageChanged: {
                changeDark()
            }
        }
    }

    function changeDark(isDark){
        if(isDark){
            fluTheme.dark = true
        }else{
            fluTheme.dark = false
        }
    }

    Component{
        id:com_app_bar
        FluAppBar {
            title: window.title
            icon:"qrc:/start/favicon.ico"
            darkText: "Dark"
            showDark: true
            onIsDarkChanged: changeDark(isDark)
            //darkClickListener:(button)=>handleDarkChanged(button)
        }
    }
    Loader{
        anchors.fill: parent
        sourceComponent: background
    }
    Loader{
        id: loader_title_bar
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        sourceComponent: window.appBar
    }
    Item{
        id:container
        anchors{
            top: loader_title_bar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        clip: true
    }
    Loader{
        property string loadingText: "Loding..."
        property bool cancel: false
        id:loader_loading
        anchors.fill: container
    }
    Component{
        id:com_loading
        Popup{
            id:popup_loading
            focus: true
            width: window.width
            height: window.height
            anchors.centerIn: Overlay.overlay
            closePolicy: {
                if(cancel){
                    return Popup.CloseOnEscape | Popup.CloseOnPressOutside
                }
                return Popup.NoAutoClose
            }
            Overlay.modal: Item {}
            onVisibleChanged: {
                if(!visible){
                    loader_loading.sourceComponent = undefined
                }
            }
            padding: 0
            opacity: 0
            visible:true
            Behavior on opacity {
                SequentialAnimation {
                    PauseAnimation {
                        duration: 88
                    }
                    NumberAnimation{
                        duration:  167
                    }
                }
            }
            Component.onCompleted: {
                opacity = 1
            }
            background: Rectangle{
                color:"#44000000"
            }
            contentItem: Item{
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if (cancel){
                            popup_loading.visible = false
                        }
                    }
                }
                ColumnLayout{
                    spacing: 8
                    anchors.centerIn: parent
                    ProgressBar{
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text{
                        text:loadingText
                        Layout.alignment: Qt.AlignHCenter
                        renderType: Text.QtRendering
                        font: FluTextStyle.Body
                    }
                }
            }
        }
    }

    Connections{
        target: fluTheme
        function onDarkChanged(){
            if (fluTheme.dark)
                FramelessUtils.systemTheme = FramelessHelperConstants.Dark
            else
                FramelessUtils.systemTheme = FramelessHelperConstants.Light
        }
    }

    FramelessHelper{
        id:framless_helper
        onReady: {
            if(appBar){
                var title_bar = loader_title_bar.item
                setTitleBarItem(title_bar)
                moveWindowToDesktopCenter()
                setHitTestVisible(title_bar.darkButton())
                setHitTestVisible(title_bar.minimizeButton())
                setHitTestVisible(title_bar.maximizeButton())
                setHitTestVisible(title_bar.closeButton())
                setHitTestVisible(title_bar.stayTopButton())
                setWindowFixedSize(fixSize)
                title_bar.maximizeButton.visible = !fixSize
                if (blurBehindWindowEnabled)
                    window.background = undefined
            }
            window.show()
        }
    }

    WindowBorder{
        z:999
    }
    function destoryOnClose(){
        //lifecycle.onDestoryOnClose()
    }

    function showLoading(text = "Loading...",cancel = true){
        loader_loading.loadingText = text
        loader_loading.cancel = cancel
        loader_loading.sourceComponent = com_loading
    }
    function hideLoading(){
        loader_loading.sourceComponent = undefined
    }
    function showSuccess(text,duration,moremsg){
        //infoBar.showSuccess(text,duration,moremsg)
    }
    function showInfo(text,duration,moremsg){
        //infoBar.showInfo(text,duration,moremsg)
    }
    function showWarning(text,duration,moremsg){
        //infoBar.showWarning(text,duration,moremsg)
    }
    function showError(text,duration,moremsg){
        //infoBar.showError(text,duration,moremsg)
    }

    function onResult(data){
        if(_pageRegister){
            _pageRegister.onResult(data)
        }
    }
}
