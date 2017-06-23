#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#undef seed

#include <opencv/cv.h>
#include <opencv/highgui.h>
#include <opencv2/highgui/highgui_c.h>
#include <opencv2/imgproc/imgproc_c.h>
#include <math.h>
#include <stdio.h>

SV* fcj_get_info(const char* filename) {

    IplImage* src = cvLoadImage( filename,0);

    if( !src ) {
        return newRV(newSV(0));
    }

    CvSize size = cvGetSize(src);
    int i;

    CvSeq* c = 0;
    CvMemStorage *storage = cvCreateMemStorage(0);

    int bkp = 1;
    c = cvHoughCircles(src, storage, CV_HOUGH_GRADIENT, 1, 100, 100, 100, 200, 0);
    int thickness = 5;
		AV* yoffs = newAV();
		HV* ret = newHV();

    for(int i = 0; i<c->total; i++ ) {
      float* p = (float*) cvGetSeqElem( c, i );
      int r = (int)p[2];

			hv_store(ret,"radius",6,newSViv(r),0);
			hv_store(ret,"x",1,newSViv((int)p[0]),0);
			hv_store(ret,"y",1,newSViv((int)p[1]),0);
			

			av_push(yoffs,newSViv((int)p[0]-r));	
			av_push(yoffs,newSViv((int)p[1]+r+thickness+5));
			av_push(yoffs,newSViv((int)p[0]+r+thickness));
			av_push(yoffs,newSViv(src->height));
		
			hv_store(ret,"rect",4,newRV((SV*)yoffs),0);
		
    }

		cvReleaseMemStorage(&storage);
    cvReleaseMemStorage(&c);
		cvReleaseImage(&src);
	
		return newRV((SV*)ret);
}

MODULE = FCJ::Info  PACKAGE = FCJ::Info
PROTOTYPES: DISABLE

SV*
get(filename)
	const char* filename
	CODE:
		RETVAL = fcj_get_info(filename);
	OUTPUT:
		RETVAL
