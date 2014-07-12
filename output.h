#ifndef OUTPUT_H
#define OUTPUT_H

#include "mainwindow.h"


class MainWindow;
class Output
{
public:
    static Output* Inst();

    void kprintf(const char* msg, ...);

    void updateStatus(unsigned long long ms, unsigned long long eventInit,
                      unsigned long long internalEvents, unsigned long long externalEvents){

    }

    void clearProgressBar(){

    }

    void progressBar(unsigned long long current, unsigned long long maximum);

    void updatePosition(int id, double x, double y);

    void setMainWindow(MainWindow *mainwindow);

private:
    Output();
    static Output* output;
    static MainWindow* mainWindow;
};

#endif // OUTPUT_H
