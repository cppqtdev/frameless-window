import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt.labs.platform 1.1
import FluentUI 1.0
import example 1.0
import "../component"
import "../viewmodel"
import "../global"

FluWindow {
    id:window
    title: "QR Code Generator"
    width: 1000
    height: 640
    minimumWidth: 520
    minimumHeight: 200
    launchMode: FluWindowType.SingleTask
    appBar: undefined

    SettingsViewModel{
        id:viewmodel_settings
    }

    FluEvent{
        id:event_checkupdate
        name: "checkUpdate"
        onTriggered: {
            checkUpdate(false)
        }
    }

    Component.onCompleted: {
        tour.open()
        //checkUpdate(true)
        //FluEventBus.registerEvent(event_checkupdate)
    }

    Component.onDestruction: {
        //FluEventBus.unRegisterEvent(event_checkupdate)
    }

    SystemTrayIcon {
        id:system_tray
        visible: true
        icon.source: "qrc:/qt/qml/start/app.ico"
        tooltip: "QR Code Generator"
        menu: Menu {
            MenuItem {
                text: "quit"
                onTriggered: {
                    FluApp.exit()
                }
            }
        }
        onActivated:
            (reason)=>{
                if(reason === SystemTrayIcon.Trigger){
                    window.show()
                    window.raise()
                    window.requestActivate()
                }
            }
    }

    FluContentDialog{
        id:dialog_close
        title:"quit"
        message:"Are you sure you want to exit the program?"
        negativeText:"Minimize"
        buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.NeutralButton | FluContentDialogType.PositiveButton
        onNegativeClicked:{
            window.hide()
            system_tray.showMessage("friendly reminder","QR Code Generator has been hidden in the tray. Click the tray to activate the window again.");
        }
        positiveText:"quit"
        neutralText:"Cancel"
        onPositiveClicked:{
            FluApp.exit(0)
        }
    }

    Component{
        id:nav_item_right_menu
        FluMenu{
            id:menu
            width: 130
            FluMenuItem{
                text: "Open in separate window"
                visible: true
                onClicked: {
                    FluApp.navigate("/pageWindow",{title:modelData.title,url:modelData.url})
                }
            }
        }
    }

    Flipable{
        id:flipable
        anchors.fill: parent
        property bool flipped: false
        property real flipAngle: 0
        transform: Rotation {
            id: rotation
            origin.x: flipable.width/2
            origin.y: flipable.height/2
            axis { x: 0; y: 1; z: 0 }
            angle: flipable.flipAngle

        }
        states: State {
            PropertyChanges { target: flipable; flipAngle: 180 }
            when: flipable.flipped
        }
        transitions: Transition {
            NumberAnimation { target: flipable; property: "flipAngle"; duration: 1000 ; easing.type: Easing.OutCubic}
        }
        back: Item{
            anchors.fill: flipable
            visible: flipable.flipAngle !== 0
            FluAppBar {
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                darkText: Lang.dark_mode
                showDark: true
                z:7
                darkClickListener:(button)=>handleDarkChanged(button)
                closeClickListener: ()=>{dialog_close.open()}
            }
            Row{
                z:8
                anchors{
                    top: parent.top
                    left: parent.left
                    topMargin: FluTools.isMacos() ? 20 : 5
                    leftMargin: 5
                }
                FluIconButton{
                    iconSource: FluentIcons.ChromeBack
                    width: 30
                    height: 30
                    iconSize: 13
                    onClicked: {
                        flipable.flipped = false
                    }
                }
                FluIconButton{
                    iconSource: FluentIcons.Sync
                    width: 30
                    height: 30
                    iconSize: 13
                    onClicked: {
                        loader.reload()
                    }
                }
            }
            FluRemoteLoader{
                id:loader
                lazy: true
                anchors.fill: parent
                source: "https://zhu-zichu.gitee.io/Qt5_156_LieflatPage.qml"
            }
        }
        front: Item{
            id:page_front
            visible: flipable.flipAngle !== 180
            anchors.fill: flipable
            FluAppBar {
                id:app_bar_front
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                darkText: Lang.dark_mode
                showDark: true
                darkClickListener:(button)=>handleDarkChanged(button)
                closeClickListener: ()=>{dialog_close.open()}
                z:7
            }
            FluNavigationView{
                property int clickCount: 0
                id:nav_view
                width: parent.width
                height: parent.height
                z:999
                //In Stack mode, every time you switch, the page will be pushed into the stack. As the number of pages in the stack increases, more memory will be consumed. If the memory consumption is too high, it will become stuck. At this time, you need to press return to pop the page out and release the memory. This mode can be used with the launchMode attribute in FluPage to set the launch mode of the page.
                //                pageMode: FluNavigationViewType.Stack
                //NoStack mode, each switch will destroy the previous page and create a new page. It only consumes a small amount of memory and can be used with FluViewModel to save page data (recommended)
                pageMode: FluNavigationViewType.NoStack
                items: ItemsOriginal
                footerItems:ItemsFooter
                topPadding:FluTools.isMacos() ? 20 : 0
                displayMode:viewmodel_settings.displayMode
                logo: "qrc:/qt/qml/start/res/image/app.ico"
                title:"QR Code Generator"
                onLogoClicked:{
                    clickCount += 1
                    showSuccess("Click%1Second-rate".arg(clickCount))
                    if(clickCount === 5){
                        loader.reload()
                        flipable.flipped = true
                        clickCount = 0
                    }
                }
                autoSuggestBox:FluAutoSuggestBox{
                    iconSource: FluentIcons.Search
                    items: ItemsOriginal.getSearchData()
                    placeholderText: Lang.search
                    onItemClicked:
                        (data)=>{
                            ItemsOriginal.startPageByItem(data)
                        }
                }
                Component.onCompleted: {
                    ItemsOriginal.navigationView = nav_view
                    ItemsOriginal.paneItemMenu = nav_item_right_menu
                    ItemsFooter.navigationView = nav_view
                    ItemsFooter.paneItemMenu = nav_item_right_menu
                    setCurrentIndex(0)
                }
            }

        }

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

    Loader{
        id:loader_reveal
        anchors.fill: parent
    }

    function distance(x1,y1,x2,y2){
        return Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
    }

    function handleDarkChanged(button){
        if(!FluTheme.enableAnimation){
            changeDark()
        }else{
            loader_reveal.sourceComponent = com_reveal
            var target = window.contentItem
            var pos = button.mapToItem(target,0,0)
            var mouseX = pos.x
            var mouseY = pos.y
            var radius = Math.max(distance(mouseX,mouseY,0,0),distance(mouseX,mouseY,target.width,0),distance(mouseX,mouseY,0,target.height),distance(mouseX,mouseY,target.width,target.height))
            var reveal = loader_reveal.item
            reveal.start(reveal.width*Screen.devicePixelRatio,reveal.height*Screen.devicePixelRatio,Qt.point(mouseX,mouseY),radius)
        }
    }

    function changeDark(){
        if(FluTheme.dark){
            FluTheme.darkMode = FluThemeType.Light
        }else{
            FluTheme.darkMode = FluThemeType.Dark
        }
    }

    Shortcut {
        sequence: "F5"
        context: Qt.WindowShortcut
        onActivated: {
            if(flipable.flipped){
                loader.reload()
            }
        }
    }

    Shortcut {
        sequence: "F6"
        context: Qt.WindowShortcut
        onActivated: {
            tour.open()
        }
    }

    FluTour{
        id:tour
        steps:[
            {title:"Night mode",description: "Here you can switch to night mode.",target:()=>app_bar_front.darkButton()},
            {title:"Hidden easter eggs",description: "Try a few more times！",target:()=>nav_view.logoButton()},
        ]
    }

    FluHttp{
        id:http
    }

    FpsItem{
        id:fps_item
    }

    FluText{
        text:"fps %1".arg(fps_item.fps)
        opacity: 0.3
        anchors{
            bottom: parent.bottom
            right: parent.right
            bottomMargin: 5
            rightMargin: 5
        }
    }

    FluContentDialog{
        property string newVerson
        property string body
        id:dialog_update
        title:"Upgrade tips"
        message:"The latest version of FluentUI "+ newVerson +" -- Current application version "+AppInfo.version+" \nDo you want to download the new version now?？\n\nupdate content：\n"+body
        buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.PositiveButton
        negativeText: "Cancel"
        positiveText:"Sure"
        onPositiveClicked:{
            Qt.openUrlExternally("https://github.com/zhuzichu520/FluentUI/releases/latest")
        }
    }

    HttpCallable{
        id:callable
        property bool silent: true
        onStart: {
            console.debug("satrt check update...")
        }
        onFinish: {
            console.debug("check update finish")
            FluEventBus.post("checkUpdateFinish");
        }
        onSuccess:
            (result)=>{
                var data = JSON.parse(result)
                console.debug("current version "+AppInfo.version)
                console.debug("new version "+data.tag_name)
                if(data.tag_name !== AppInfo.version){
                    dialog_update.newVerson =  data.tag_name
                    dialog_update.body = data.body
                    dialog_update.open()
                }else{
                    if(!silent){
                        showInfo("The current version is already the latest version")
                    }
                }
            }
        onError:
            (status,errorString)=>{
                if(!silent){
                    showError("network anomaly!")
                }
                console.debug(status+";"+errorString)
            }
    }

    function checkUpdate(silent){
        callable.silent = silent
        var request = http.newRequest("https://api.github.com/repos/zhuzichu520/FluentUI/releases/latest")
        http.get(request,callable);
    }

}
