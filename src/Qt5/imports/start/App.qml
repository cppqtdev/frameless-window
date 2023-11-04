import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Item {
    id: app

    Connections{
        target: FluTheme
        function onDarkModeChanged(){
            SettingsHelper.saveDarkMode(FluTheme.darkMode)
        }
    }

    Connections{
        target: FluApp
        function onVsyncChanged(){
            SettingsHelper.saveVsync(FluApp.vsync)
        }
    }

    FluHttpInterceptor{
        id:interceptor
        function onIntercept(request){
            if(request.method === "get"){
                request.params["method"] = "get"
            }
            if(request.method === "post"){
                request.params["method"] = "post"
            }
            request.headers["token"] ="yyds"
            request.headers["os"] ="pc"
            console.debug(JSON.stringify(request))
            return request
        }
    }

    Component.onCompleted: {
        FluApp.init(app)
        FluApp.vsync = SettingsHelper.getVsync()
        FluTheme.darkMode = SettingsHelper.getDarkMode()
        FluTheme.enableAnimation = true
        FluApp.routes = {
            "/":"qrc:/qt/qml/start/qml/window/MainWindow.qml",
            "/about":"qrc:/qt/qml/start/qml/window/AboutWindow.qml",
            "/login":"qrc:/qt/qml/start/qml/window/LoginWindow.qml",
            "/hotload":"qrc:/qt/qml/start/qml/window/HotloadWindow.qml",
            "/singleTaskWindow":"qrc:/qt/qml/start/qml/window/SingleTaskWindow.qml",
            "/standardWindow":"qrc:/qt/qml/start/qml/window/StandardWindow.qml",
            "/singleInstanceWindow":"qrc:/qt/qml/start/qml/window/SingleInstanceWindow.qml",
            "/pageWindow":"qrc:/qt/qml/start/qml/window/PageWindow.qml"
        }
        FluApp.initialRoute = "/"
        FluApp.httpInterceptor = interceptor
        FluApp.run()
    }
}
