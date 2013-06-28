#include "OpenCVGrabFrame.h"
#include "qthread.h"
#include <cv.h>
#include "highgui.h"
#include "opencv2\core\core.hpp"
#include "opencv2\highgui\highgui.hpp"



OpenCVGrabFrame::OpenCVGrabFrame()
{

}

void OpenCVGrabFrame::run()
{


	cvNamedWindow("Camera_Output", 1);    //Create window
	CvCapture* capture = cvCaptureFromCAM(1); //Capture using any camera connected to your system
	while(1){ //Create infinte loop for live streaming

        IplImage* frame = cvQueryFrame(capture); //Create image frames from capture
        cvShowImage("Camera_Output", frame);   //Show image frames on created window
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