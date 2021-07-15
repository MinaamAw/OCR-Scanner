/*
 FeatureExtraction.cpp
 OCR Scanner
 
 Created by Minaam Ahmed Awan on 13/07/2021.
 
 Abstract:
 Feature Extraction: Performs Feature Extraction through OpenCV Libraries.
 */


// Header Files
#include "FeatureExtraction.hpp"
#include "opencv2/core.hpp"


// Namespaces:
using namespace cv;
using namespace std;


// Driver Code:
int test() {
    
    Mat color = imread("/Users/minaamawan/Desktop/Test.png");
    
    if (color.empty()) {
        cout << "No File";
        
        return 1;
    }
    
    imshow("Display window", color);
    
    int k = waitKey(0); // Wait for a keystroke in the window
    
    if(k == 's') {
        imwrite("starry_night.png",color);
    }
    
    return 0;
}
