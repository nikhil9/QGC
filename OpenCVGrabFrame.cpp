#include "OpenCVGrabFrame.h"
#include "qthread.h"
#include <cv.h>
#include "highgui.h"
#include "opencv2\core\core.hpp"
#include "opencv2\highgui\highgui.hpp"

#include "UASManager.h"
#include "UAS.h"

OpenCVGrabFrame::OpenCVGrabFrame()
{
gpsFix = 0;
lat = 0;
lon = 0;
alt = 0;


hScale=1.0;
vScale=1.0;
lineWidth=1;
cvInitFont(&font,CV_FONT_HERSHEY_SIMPLEX|CV_FONT_ITALIC, hScale,vScale,0,lineWidth);

connect(UASManager::instance(), SIGNAL(activeUASSet(UASInterface*)), this, SLOT(setActiveUAS(UASInterface*)));
if (UASManager::instance()->getActiveUAS() != NULL) setActiveUAS(UASManager::instance()->getActiveUAS());
}

void OpenCVGrabFrame::setActiveUAS(UASInterface* uas){
	
	if (this->uas != NULL) {
		//disconnect(this->uas, SIGNAL(globalPositionChanged(UASInterface*,double,double,double,quint64)), this, SLOT(updateGlobalPosition(UASInterface*,double,double,double,quint64)));
	}
	if (uas) {
		connect(uas, SIGNAL(globalPositionChanged(UASInterface*,double,double,double,quint64)), this, SLOT(updateGlobalPosition(UASInterface*,double,double,double,quint64)));
	}
	this->uas = uas;
}

void OpenCVGrabFrame::updateGlobalPosition(UASInterface* uas,double lat, double lon, double altitude, quint64 timestamp)
{
    Q_UNUSED(uas);
    Q_UNUSED(timestamp);
    this->lat = lat;
    this->lon = lon;
    this->alt = altitude;
	qDebug("OpenCV lat: %05.6f lon: %06.6f alt: %06.2f", lat, lon, alt);
}

void OpenCVGrabFrame::updateGpsLocalization(UASInterface* uas, int fix)
{
    Q_UNUSED(uas);
    gpsFix = fix;
    
}

void OpenCVGrabFrame::run()
{
	cvNamedWindow("OpenCV Window", 1);    //Create window
	CvCapture* capture = cvCaptureFromCAM(0); //Capture using any camera connected to your system
	//cvNamedWindow("OpenCV Window1", 1);    //Create window
	//CvCapture* capture1 = cvCaptureFromCAM(1);
	//cvNamedWindow("OpenCV Window2", 1);    //Create window
	//CvCapture* capture2 = cvCaptureFromCAM(2);
	
	while(1){ //Create infinte loop for live streaming

        IplImage* frame = cvQueryFrame(capture); //Create image frames from capture
       
		//IplImage* frame1 = cvQueryFrame(capture1);
		//IplImage* frame2 = cvQueryFrame(capture2);
		if(gpsFix == 0){
			cvPutText (frame,"Waiting for GPS Fix ",cvPoint(100,400), &font, cvScalar(255,255,0));
		}
		else{
			QString gpsinfo = ("Lat: "+ QString::number(lat)+ ", Lon: " +  QString::number(lon) + ", Alt: "+QString::number(alt));
			cvPutText (frame,qPrintable(gpsinfo),cvPoint(100,400), &font, cvScalar(255,255,0));
		}
		
		cvShowImage("OpenCV Window", frame);
		//cvShowImage("OpenCV Window1", frame1);  
		//cvShowImage("OpenCV Window2", frame2); //Show image frames on created window
        key = cvWaitKey(10);     //Capture Keyboard stroke
        if (char(key) == 27)
		{
            break;      //If you hit ESC key loop will break.
        }
    }
}

OpenCVGrabFrame::~OpenCVGrabFrame()
{

}