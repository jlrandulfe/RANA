#include <math.h>
#include <climits>

#include "maphandler.h"

QImage *MapHandler::image = NULL;
MainWindow *MapHandler::parent = NULL;
std::map<int, MATRICE > MapHandler::radialMasks;


MapHandler::MapHandler(MainWindow *parent)
{
    parent = parent;
}

void MapHandler::setImage(QImage *argImage)
{
    image = argImage;

}

rgba* MapHandler::getPixelInfo(int argX, int argY)
{
    if (image !=NULL)
    {
        QRgb info = image->pixel(argX, argY);
        rgba* values = new rgba;
        values->red = qRed(info);
        values->green = qGreen(info);
        values->blue = qBlue(info);
        values->alpha = 0;
        //beware of potentional memory leak!
        return values;

    } else
        return NULL;
}

void MapHandler::setPixelInfo(int argX, int argY, rgba argValue)
{
    if (image != NULL && image->width() >= argX && image->height() >= argY)
    {
        QRgb value;
        value = qRgb(argValue.red, argValue.green, argValue.red);
        image->setPixel(argX, argY, value);
        parent->updateMap();
    }
}

MATRICE MapHandler::radialScan( int radius, char channel)
{
    MATRICE mask;
    MATRICE result;

    if(image == NULL)
            return result;

    if(MapHandler::radialMasks.find(radius) == MapHandler::radialMasks.end())
    {
        //calculate new mask:
        //this can be optimized, since the scan is radial...
        double angle = 0;
        double dx = 0;
        double dy = 0;

        for(int x = 0; x < radius; x++)
        {
            for(int y =0; y < radius; y++)
            {
                angle = atan2(x,y);
                dx = sin(angle) * radius;
                dy = cos(angle) * radius;

                if(abs(dx + 0.5) > radius || abs(dy + 0.5) > radius)
                {
                    mask[x][y] = INT_MIN;
                } else
                    mask[x][y] = 1;
            }
        }
        MapHandler::radialMasks[radius] = mask;
    }
    mask = MapHandler::radialMasks[radius];

    for(int x = 0; x < radius ; x++)
    {
        for(int y = 0; y < radius; y++)
        {
            if(image->width() >= x && image->height() >= y)
            {
                QRgb info = image->pixel(x, y);
                int value = mask[x][y];

                if(value != INT_MIN)
                {
                    if(channel == 'r')
                        result[x][y] = value * qRed(info);
                    if(channel == 'g')
                        result[x][y] = value * qGreen(info);
                    if(channel == 'b')
                        result[x][y] = value * qBlue(info);
                } else
                    result[x][y] = INT_MIN;
             } else
                result[x][y] = INT_MAX;
        }
    }
    return result;
}



