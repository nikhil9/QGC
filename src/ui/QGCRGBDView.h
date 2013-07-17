#ifndef QGCRGBDVIEW_H
#define QGCRGBDVIEW_H

#include "HUD.h"

class QGCRGBDView : public HUD
{
    Q_OBJECT
public:
    explicit QGCRGBDView(int width=640, int height=480, QWidget *parent = 0);
    ~QGCRGBDView();

signals:

public slots:
    void setActiveUAS(UASInterface* uas);

    void clearData(void);
    void enableRGB(bool enabled);
    void enableDepth(bool enabled);
	void enableOpenCV(bool enabled);
    void updateData(UASInterface *uas);

protected:
    bool rgbEnabled;
    bool depthEnabled;
	bool OpenCVEnabled;
    QAction* enableRGBAction;
    QAction* enableDepthAction;
	QAction* enableOpenCVAction;

    void contextMenuEvent (QContextMenuEvent* event);
    /** @brief Store current configuration of widget */
    void storeSettings();
    /** @brief Load configuration of widget */
    void loadSettings();
};

#endif // QGCRGBDVIEW_H
