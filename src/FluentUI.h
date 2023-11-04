#ifndef FLUENTUI_H
#define FLUENTUI_H

#include <QObject>
#include <QQmlEngine>
#include "FluApp.h"


class FluentUI : public QObject
{
    Q_OBJECT
public:
    static FluentUI *getInstance();
    static FluApp *getFapp();
    Q_DECL_EXPORT void registerTypes(QQmlEngine *engine);
    void registerTypes(const char *uri);
    void initializeEngine(QQmlEngine *engine, const char *uri);
private:
    static FluentUI* m_instance;
    static FluApp* fapp;
};

#endif // FLUENTUI_H
