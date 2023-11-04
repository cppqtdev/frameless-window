QT += quick core qml svg

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

CONFIG += c++1z
include(framelesshelper/qmake/core.pri)
include(framelesshelper/qmake/quick.pri)
SOURCES += \
	start/main.cpp \
	start/src/AppInfo.cpp \
	start/src/Def.cpp \
	start/src/FluTextStyle.cpp \
	start/src/component/CircularReveal.cpp \
	start/src/component/FileWatcher.cpp \
	start/src/component/FpsItem.cpp \
	start/src/helper/SettingsHelper.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
	start/Version.h \
	start/src/AppInfo.h \
	start/src/Def.h \
	start/src/FluTextStyle.h \
	start/src/component/CircularReveal.h \
	start/src/component/FileWatcher.h \
	start/src/component/FpsItem.h \
	start/src/helper/SettingsHelper.h \
	start/src/singleton.h \
	start/src/stdafx.h
