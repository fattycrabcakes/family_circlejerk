#include "family_circlejerk.h"
#include <stdio.h>

SV* fcj_get_info(const char* data) {


	IplImage* src = cvLoadImage(data,0);

	
	if( !src ) {
        return newRV((SV*)newHV());
    }

    CvSize size = cvGetSize(src);
    int i;

    CvSeq* c = 0;
    CvMemStorage *storage = cvCreateMemStorage(0);

    int bkp = 1;
	
    c = cvHoughCircles(src, storage, CV_HOUGH_GRADIENT, 1, 100, 150, 100, 150, 0);
    int thickness = 5;
	AV* yoffs = newAV();
	HV* ret = newHV();
	AV* entries = newAV();

	hv_store(ret,"count",5,newSViv((int)c->total),0);
		

    for(int i = 0; i<c->total; i++ ) {
      	float* p = (float*) cvGetSeqElem( c, i );
      	int r = (int)p[2];

		HV* entry = newHV();

		hv_store(entry,"radius",6,newSViv(r),0);
		hv_store(entry,"x",1,newSViv((int)p[0]),0);
		hv_store(entry,"y",1,newSViv((int)p[1]),0);
		hv_store(entry,"left",4,newSViv((int)p[0]-p[2]),0);
	 	hv_store(entry,"top",3,newSViv((int)p[1]-p[2]),0);
		hv_store(entry,"size",4,newSViv((int)p[2]*2),0);
			

			
			

		av_push(yoffs,newSViv((int)p[0]-r));	
		av_push(yoffs,newSViv((int)p[1]+r+thickness+5));
		av_push(yoffs,newSViv((int)p[0]+r+thickness));
		av_push(yoffs,newSViv(src->height));
	
		hv_store(entry,"points",6,newRV((SV*)yoffs),0);

		av_push(entries,newRV((SV*)entry));
    }
	hv_store(ret,"entries",7,newRV((SV*)entries),0);

	cvReleaseMemStorage(&storage);
    cvReleaseMemStorage(&c);
	cvReleaseImage(&src);
	
	return newRV((SV*)ret);
}
