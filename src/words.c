
#include <opencv/cv.h>
#include <opencv/highgui.h>
#include <opencv2/highgui/highgui_c.h>
#include <opencv2/imgproc/imgproc_c.h>
#include <math.h>
#include <stdio.h>

#define MORPH_ELLIPSE  	2
#define MORPH_GRADIENT 	4
#define MORPH_RECT 	0
#define MORPH_CLOSE 3
#define THRESH_BINARY 0
#define THRESH_OTSU 8

void showImage(IplImage* img,const char* title) {
    cvNamedWindow( title, 1 );
    cvShowImage( title, img );
    cvWaitKey(0);
}


void process_lines(char* filename,int complexity) {//,int minLength,int rho,int theta,int threshold) {

    IplImage* src = cvLoadImage( filename,1);

	if( !src ) {
        return;
    }

	CvSize size = cvGetSize(src);
	IplImage* gray = cvCreateImage(size, 8, 1 );
	cvCvtColor(src,gray,CV_BGR2GRAY);

	int i;

    CvSeq* c = 0;
	CvMemStorage *storage = cvCreateMemStorage(0);

	int bkp = 1;

	c = cvHoughCircles(gray, storage, CV_HOUGH_GRADIENT, 1, 100, 100, 100, 200, 0);
	int thickness = 4;
	for(int i = 0; i<c->total; i++ ) {
		float* p = (float*) cvGetSeqElem( c, i );
		int r = (int)p[2];
	
		cvRectangle(
			src,
			cvPoint((int)p[0]-r-thickness,(int)p[1]-r-thickness),
			cvPoint((int)p[0]+r+thickness,(int)p[1]+r+thickness),
			CV_RGB(255,0,0),1,8,0
		);
	}
		
	showImage(src,"Standard Lines");
}

int main(int argc, char** argv) {

	int complexity=1;
	if(argc>2) {
		sscanf(argv[2],"%d",&complexity);
	}
	process_lines(argv[1],complexity);
	return 0;
}
