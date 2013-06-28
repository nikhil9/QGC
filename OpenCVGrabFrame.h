#include <cv.h>
#include "highgui.h"
#include "opencv2\core\core.hpp"
#include "opencv2\highgui\highgui.hpp"

#include <QThread>

class OpenCVGrabFrame : public QThread
{
public:
	OpenCVGrabFrame();
	~OpenCVGrabFrame();
	void run();
	char key;
};