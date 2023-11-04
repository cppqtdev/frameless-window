QT += quick core qml svg

CONFIG += c++1z
include(framelesshelper/qmake/core.pri)
include(framelesshelper/qmake/quick.pri)
SOURCES += \
	src/Def.cpp \
	src/FluApp.cpp \
	src/FluCaptcha.cpp \
	src/FluColorSet.cpp \
	src/FluColors.cpp \
	src/FluEventBus.cpp \
	src/FluHttp.cpp \
	src/FluHttpInterceptor.cpp \
	src/FluRectangle.cpp \
	src/FluRegister.cpp \
	src/FluTextStyle.cpp \
	src/FluTheme.cpp \
	src/FluTools.cpp \
	src/FluTreeModel.cpp \
	src/FluViewModel.cpp \
	src/FluWatermark.cpp \
	src/FluentUI.cpp \
	src/MainThread.cpp \
	src/Screenshot.cpp \
	src/WindowLifecycle.cpp \
	src/start/main.cpp \
	src/start/src/AppInfo.cpp \
	src/start/src/component/CircularReveal.cpp \
	src/start/src/component/FileWatcher.cpp \
	src/start/src/component/FpsItem.cpp \
	src/start/src/helper/SettingsHelper.cpp

RESOURCES += src/Qt5/imports/fluentui.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
	src/Def.h \
	src/FluApp.h \
	src/FluCaptcha.h \
	src/FluColorSet.h \
	src/FluColors.h \
	src/FluEventBus.h \
	src/FluHttp.h \
	src/FluHttpInterceptor.h \
	src/FluRectangle.h \
	src/FluRegister.h \
	src/FluTextStyle.h \
	src/FluTheme.h \
	src/FluTools.h \
	src/FluTreeModel.h \
	src/FluViewModel.h \
	src/FluWatermark.h \
	src/FluentUI.h \
	src/MainThread.h \
	src/Screenshot.h \
	src/WindowLifecycle.h \
	src/singleton.h \
	src/start/Version.h \
	src/start/src/AppInfo.h \
	src/start/src/component/CircularReveal.h \
	src/start/src/component/FileWatcher.h \
	src/start/src/component/FpsItem.h \
	src/start/src/helper/SettingsHelper.h \
	src/start/src/singleton.h \
	src/start/src/stdafx.h \
	src/stdafx.h
