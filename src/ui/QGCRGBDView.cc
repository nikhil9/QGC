#include <QMenu>
#include <QContextMenuEvent>
#include <QSettings>
#include <stdio.h>
#include <sstream>
#include <string>
#include <iostream>

#include "QGCRGBDView.h"
#include "UASManager.h"

#include <cv.h>
#include "highgui.h"
#include "opencv2\core\core.hpp"
#include "opencv2\highgui\highgui.hpp"

#include "OpenCVGrabFrame.h"



QGCRGBDView::QGCRGBDView(int width, int height, QWidget *parent) :
    HUD(width, height, parent),
    rgbEnabled(false),
    depthEnabled(false),
	OpenCVEnabled(false),
	lat(0),
	lon(0)
{
    enableRGBAction = new QAction(tr("Enable RGB Image"), this);
    enableRGBAction->setStatusTip(tr("Show the RGB image live stream in this window"));
    enableRGBAction->setCheckable(true);
    enableRGBAction->setChecked(rgbEnabled);
    connect(enableRGBAction, SIGNAL(triggered(bool)), this, SLOT(enableRGB(bool)));

    enableDepthAction = new QAction(tr("Enable Depthmap"), this);
    enableDepthAction->setStatusTip(tr("Show the Depthmap in this window"));
    enableDepthAction->setCheckable(true);
    enableDepthAction->setChecked(depthEnabled);
    connect(enableDepthAction, SIGNAL(triggered(bool)), this, SLOT(enableDepth(bool)));

	enableOpenCVAction = new QAction(tr("Enable OpenCV Video"), this);
    enableOpenCVAction->setStatusTip(tr("Show the OpenCV live video in this window"));
    enableOpenCVAction->setCheckable(true);
    enableOpenCVAction->setChecked(rgbEnabled);
    connect(enableOpenCVAction, SIGNAL(triggered(bool)), this, SLOT(enableOpenCV(bool)));

    connect(UASManager::instance(), SIGNAL(activeUASSet(UASInterface*)), this, SLOT(setActiveUAS(UASInterface*)));

	cam.open(0);
	//if(cam.isOpened == FALSE){
	//	qDebug("Unable to open Camera");
	//}
	opencvTimer = new QTimer(this);
	//cvNamedWindow("OpenCV Video");
	connect(opencvTimer, SIGNAL(timeout()), this, SLOT(processFrames()));
	saveTimer = new QTimer(this);
	saveInterval = 0;
	numSamples = 0;
	
	

    clearData();
    loadSettings();
}



QGCRGBDView::~QGCRGBDView()
{
    storeSettings();
	

}

void QGCRGBDView::processFrames()
{
    saveInterval++;
    cam.read(camFrame);	
	IplImage* showFrame = new IplImage(camFrame);
	cvShowImage("OpenCV Video", showFrame);
	if(saveInterval % 50 == 0){
		numSamples++;
		std::stringstream imgName_;// = std::to_string(numSamples);
		imgName_ << numSamples;
		std::string imgName(imgName_.str());
		//const char* FileName = imgName + ".jpg";

		//char fileName[50];
		//sprintf(fileName, "Sample %d.jpeg",numSamples);
		//cvSaveImage(fileName,showFrame);


		bool isSaved = imwrite("Sample" + imgName + ".jpg",camFrame);
		if(!isSaved){
			qDebug("Failed to save Images ");
		}
		else{
			qDebug("Saved Image SuccesFully ");
			SaveGPSData();

		}

		/*if(gpsDataFil.open(QFile::WriteOnly |QFile::Truncate)){
			QTextStream strm( &gpsDataFil );
			QString dataNum = QString::number(numSamples);
			strm<<dataNum<<endl ;
			gpsDataFil.close();
		}*/
    }
	//qDebug("lat: %05.6f lon: %06.6f alt: %06.2f", lat, lon, alt);
	//cam.~VideoCapture();

}


void QGCRGBDView::SaveGPSData(){

	
	QFile gpsdatafile("gpsData.csv");
	if(!gpsdatafile.open(QFile::WriteOnly | QFile::Text | QFile::Append)){
		qDebug("Could not open Text File");
		return;
	}

	QTextStream dataOut(&gpsdatafile);
	QString gpsinfo = (QString::number(numSamples) + ", "+ QString::number(lat)+ ", " +  QString::number(lon) + ","+QString::number(alt));
	dataOut << gpsinfo<< endl;
	gpsdatafile.flush();
	gpsdatafile.close();

}
void QGCRGBDView::storeSettings()
{
    QSettings settings;
    settings.beginGroup("QGC_RGBDWIDGET");
    settings.setValue("STREAM_RGB_ON", rgbEnabled);
    settings.setValue("STREAM_DEPTH_ON", depthEnabled);
	settings.setValue("STREAM_OpenCV_ON", OpenCVEnabled);
    settings.endGroup();
    settings.sync();
}

void QGCRGBDView::loadSettings()
{
    QSettings settings;
    settings.beginGroup("QGC_RGBDWIDGET");
    rgbEnabled = settings.value("STREAM_RGB_ON", rgbEnabled).toBool();
    // Only enable depth if RGB is not on
    if (!rgbEnabled) depthEnabled = settings.value("STREAM_DEPTH_ON", depthEnabled).toBool();
    settings.endGroup();
}

void QGCRGBDView::setActiveUAS(UASInterface* uas)
{
    if (this->uas != NULL)
    {
        // Disconnect any previously connected active MAV
        disconnect(this->uas, SIGNAL(rgbdImageChanged(UASInterface*)), this, SLOT(updateData(UASInterface*)));
        disconnect(this->uas, SIGNAL(globalPositionChanged(UASInterface*,double,double,double,quint64)), this, SLOT(updateGlobalPosition(UASInterface*,double,double,double,quint64)));
		isUAV = FALSE;
        clearData();
    }

    if (uas)
    {
        // Now connect the new UAS
        // Setup communication
        connect(uas, SIGNAL(rgbdImageChanged(UASInterface*)), this, SLOT(updateData(UASInterface*)));
	    connect(uas, SIGNAL(globalPositionChanged(UASInterface*,double,double,double,quint64)), this, SLOT(updateGlobalPosition(UASInterface*,double,double,double,quint64)));
		isUAV = TRUE;

    }

    HUD::setActiveUAS(uas);
}

void QGCRGBDView::clearData(void)
{
    QImage offlineImg;
    qDebug() << offlineImg.load(":/files/images/status/colorbars.png");

    glImage = QGLWidget::convertToGLFormat(offlineImg);
}

void QGCRGBDView::updateGlobalPosition(UASInterface*, double lat, double lon, double alt, quint64 usec)
{
    this->lat = lat;
    this->lon = lon;
    this->alt = alt;
    //globalAvailable = usec;
	//qDebug("lat: %05.6f lon: %06.6f alt: %06.2f", lat, lon, alt);
}

void QGCRGBDView::contextMenuEvent(QContextMenuEvent* event)
{
    QMenu menu(this);
    // Update actions
    enableHUDAction->setChecked(hudInstrumentsEnabled);
    //enableVideoAction->setChecked(videoEnabled);
    enableRGBAction->setChecked(rgbEnabled);
    enableDepthAction->setChecked(depthEnabled);
	enableOpenCVAction->setChecked(OpenCVEnabled);

    menu.addAction(enableHUDAction);
    menu.addAction(enableRGBAction);
    menu.addAction(enableDepthAction);
	menu.addAction(enableOpenCVAction);
    //menu.addAction(selectHUDColorAction);
    //menu.addAction(enableVideoAction);
    //menu.addAction(selectOfflineDirectoryAction);
    //menu.addAction(selectVideoChannelAction);
    menu.exec(event->globalPos());
}

void QGCRGBDView::enableRGB(bool enabled)
{
    rgbEnabled = enabled;
    dataStreamEnabled = rgbEnabled | depthEnabled;
    resize(size());
	
}

void QGCRGBDView::enableDepth(bool enabled)
{
    depthEnabled = enabled;
    dataStreamEnabled = rgbEnabled | depthEnabled;
    resize(size());
}

void QGCRGBDView::enableOpenCV(bool enabled)
{
    OpenCVEnabled = enabled;
    dataStreamEnabled = rgbEnabled | depthEnabled;
    resize(size());
	if(OpenCVEnabled)
		{
		   opencvTimer->start(20);
		   saveTimer->start();
		}
	else
		{
		   opencvTimer->stop();
		   saveTimer->stop();
		}
	//OpenCVGrabFrame CVFrame1;
	//CVFrame1.run();

}

float colormapJet[128][3] = {
    {0.0f,0.0f,0.53125f},
    {0.0f,0.0f,0.5625f},
    {0.0f,0.0f,0.59375f},
    {0.0f,0.0f,0.625f},
    {0.0f,0.0f,0.65625f},
    {0.0f,0.0f,0.6875f},
    {0.0f,0.0f,0.71875f},
    {0.0f,0.0f,0.75f},
    {0.0f,0.0f,0.78125f},
    {0.0f,0.0f,0.8125f},
    {0.0f,0.0f,0.84375f},
    {0.0f,0.0f,0.875f},
    {0.0f,0.0f,0.90625f},
    {0.0f,0.0f,0.9375f},
    {0.0f,0.0f,0.96875f},
    {0.0f,0.0f,1.0f},
    {0.0f,0.03125f,1.0f},
    {0.0f,0.0625f,1.0f},
    {0.0f,0.09375f,1.0f},
    {0.0f,0.125f,1.0f},
    {0.0f,0.15625f,1.0f},
    {0.0f,0.1875f,1.0f},
    {0.0f,0.21875f,1.0f},
    {0.0f,0.25f,1.0f},
    {0.0f,0.28125f,1.0f},
    {0.0f,0.3125f,1.0f},
    {0.0f,0.34375f,1.0f},
    {0.0f,0.375f,1.0f},
    {0.0f,0.40625f,1.0f},
    {0.0f,0.4375f,1.0f},
    {0.0f,0.46875f,1.0f},
    {0.0f,0.5f,1.0f},
    {0.0f,0.53125f,1.0f},
    {0.0f,0.5625f,1.0f},
    {0.0f,0.59375f,1.0f},
    {0.0f,0.625f,1.0f},
    {0.0f,0.65625f,1.0f},
    {0.0f,0.6875f,1.0f},
    {0.0f,0.71875f,1.0f},
    {0.0f,0.75f,1.0f},
    {0.0f,0.78125f,1.0f},
    {0.0f,0.8125f,1.0f},
    {0.0f,0.84375f,1.0f},
    {0.0f,0.875f,1.0f},
    {0.0f,0.90625f,1.0f},
    {0.0f,0.9375f,1.0f},
    {0.0f,0.96875f,1.0f},
    {0.0f,1.0f,1.0f},
    {0.03125f,1.0f,0.96875f},
    {0.0625f,1.0f,0.9375f},
    {0.09375f,1.0f,0.90625f},
    {0.125f,1.0f,0.875f},
    {0.15625f,1.0f,0.84375f},
    {0.1875f,1.0f,0.8125f},
    {0.21875f,1.0f,0.78125f},
    {0.25f,1.0f,0.75f},
    {0.28125f,1.0f,0.71875f},
    {0.3125f,1.0f,0.6875f},
    {0.34375f,1.0f,0.65625f},
    {0.375f,1.0f,0.625f},
    {0.40625f,1.0f,0.59375f},
    {0.4375f,1.0f,0.5625f},
    {0.46875f,1.0f,0.53125f},
    {0.5f,1.0f,0.5f},
    {0.53125f,1.0f,0.46875f},
    {0.5625f,1.0f,0.4375f},
    {0.59375f,1.0f,0.40625f},
    {0.625f,1.0f,0.375f},
    {0.65625f,1.0f,0.34375f},
    {0.6875f,1.0f,0.3125f},
    {0.71875f,1.0f,0.28125f},
    {0.75f,1.0f,0.25f},
    {0.78125f,1.0f,0.21875f},
    {0.8125f,1.0f,0.1875f},
    {0.84375f,1.0f,0.15625f},
    {0.875f,1.0f,0.125f},
    {0.90625f,1.0f,0.09375f},
    {0.9375f,1.0f,0.0625f},
    {0.96875f,1.0f,0.03125f},
    {1.0f,1.0f,0.0f},
    {1.0f,0.96875f,0.0f},
    {1.0f,0.9375f,0.0f},
    {1.0f,0.90625f,0.0f},
    {1.0f,0.875f,0.0f},
    {1.0f,0.84375f,0.0f},
    {1.0f,0.8125f,0.0f},
    {1.0f,0.78125f,0.0f},
    {1.0f,0.75f,0.0f},
    {1.0f,0.71875f,0.0f},
    {1.0f,0.6875f,0.0f},
    {1.0f,0.65625f,0.0f},
    {1.0f,0.625f,0.0f},
    {1.0f,0.59375f,0.0f},
    {1.0f,0.5625f,0.0f},
    {1.0f,0.53125f,0.0f},
    {1.0f,0.5f,0.0f},
    {1.0f,0.46875f,0.0f},
    {1.0f,0.4375f,0.0f},
    {1.0f,0.40625f,0.0f},
    {1.0f,0.375f,0.0f},
    {1.0f,0.34375f,0.0f},
    {1.0f,0.3125f,0.0f},
    {1.0f,0.28125f,0.0f},
    {1.0f,0.25f,0.0f},
    {1.0f,0.21875f,0.0f},
    {1.0f,0.1875f,0.0f},
    {1.0f,0.15625f,0.0f},
    {1.0f,0.125f,0.0f},
    {1.0f,0.09375f,0.0f},
    {1.0f,0.0625f,0.0f},
    {1.0f,0.03125f,0.0f},
    {1.0f,0.0f,0.0f},
    {0.96875f,0.0f,0.0f},
    {0.9375f,0.0f,0.0f},
    {0.90625f,0.0f,0.0f},
    {0.875f,0.0f,0.0f},
    {0.84375f,0.0f,0.0f},
    {0.8125f,0.0f,0.0f},
    {0.78125f,0.0f,0.0f},
    {0.75f,0.0f,0.0f},
    {0.71875f,0.0f,0.0f},
    {0.6875f,0.0f,0.0f},
    {0.65625f,0.0f,0.0f},
    {0.625f,0.0f,0.0f},
    {0.59375f,0.0f,0.0f},
    {0.5625f,0.0f,0.0f},
    {0.53125f,0.0f,0.0f},
    {0.5f,0.0f,0.0f}
};

void QGCRGBDView::updateData(UASInterface *uas)
{
#if defined(QGC_PROTOBUF_ENABLED) && defined(QGC_USE_PIXHAWK_MESSAGES)
    px::RGBDImage rgbdImage = uas->getRGBDImage();

    if (rgbdImage.rows() == 0 || rgbdImage.cols() == 0 || (!rgbEnabled && !depthEnabled))
    {
        return;
    }

    QImage fill;

    if (rgbEnabled)
    {
//        fill = QImage(reinterpret_cast<const unsigned char*>(rgbdImage.imagedata1().c_str()),
//                      rgbdImage.cols(), rgbdImage.rows(), QImage::Format_Mono);


        // Construct PGM header
        QString header("P5\n%1 %2\n%3\n");
        int imgColors = 255;
        header = header.arg(rgbdImage.cols()).arg(rgbdImage.rows()).arg(imgColors);

        //QByteArray tmpImage(rgbdImage.imagedata1().c_str(), rgbdImage.cols()*rgbdImage.rows());
        QByteArray tmpImage(header.toStdString().c_str(), header.toStdString().size());
        tmpImage.append(rgbdImage.imagedata1().c_str(), rgbdImage.cols()*rgbdImage.rows());

        //qDebug() << "IMAGE SIZE:" << tmpImage.size() << "HEADER SIZE: (15):" << header.size() << "HEADER: " << header;

//        if (imageRecBuffer.isNull())
//        {
//            qDebug()<< "could not convertToPGM()";
//            return QImage();
//        }

        if (!fill.loadFromData(tmpImage, "PGM"))
        {
            qDebug()<< "could not create extracted image";
//            return QImage();
        }
    }

    if (depthEnabled)
    {
        QByteArray coloredDepth(rgbdImage.cols() * rgbdImage.rows() * 3, 0);

        for (uint32_t r = 0; r < rgbdImage.rows(); ++r)
        {
            const float* depth = reinterpret_cast<const float*>(rgbdImage.imagedata2().c_str() + r * rgbdImage.step2());
            uint8_t* pixel = reinterpret_cast<uint8_t*>(coloredDepth.data()) + r * rgbdImage.cols() * 3;
            for (uint32_t c = 0; c < rgbdImage.cols(); ++c)
            {
                if (depth[c] != 0)
                {
                    int idx = fminf(depth[c], 10.0f) / 10.0f * 127.0f;
                    idx = 127 - idx;

                    pixel[0] = colormapJet[idx][2] * 255.0f;
                    pixel[1] = colormapJet[idx][1] * 255.0f;
                    pixel[2] = colormapJet[idx][0] * 255.0f;
                }

                pixel += 3;
            }
        }

        fill = QImage(reinterpret_cast<const uchar*>(coloredDepth.constData()),
                      rgbdImage.cols(), rgbdImage.rows(), QImage::Format_RGB888);
    }

    glImage = QGLWidget::convertToGLFormat(fill);
#else
	Q_UNUSED(uas);
#endif
}
