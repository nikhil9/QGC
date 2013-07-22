#include <cv.h>
#include "highgui.h"
#include "opencv2\core\core.hpp"
#include "opencv2\highgui\highgui.hpp"
#include "UASInterface.h"
#include <QThread>

class OpenCVGrabFrame : public QThread
{
public:
	OpenCVGrabFrame();
	~OpenCVGrabFrame();
	void run();
	char key;
	double lat;
    double lon;
    double alt;
	int gpsFix;
	CvFont font;
	double hScale;
	double vScale;
	int lineWidth;

public slots:
	void setActiveUAS(UASInterface* uas);
	void updateGlobalPosition(UASInterface*,double,double,double,quint64);
	void updateGpsLocalization(UASInterface* uas, int localization);
	///virtual void setActiveUAS(UASInterface* uas);
protected:
	UASInterface* uas;
};