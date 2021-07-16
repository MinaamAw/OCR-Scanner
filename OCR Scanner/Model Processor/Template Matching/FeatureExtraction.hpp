/*
 FeatureExtraction.hpp
 OCR Scanner
 
 Created by Minaam Ahmed Awan on 14/07/2021.
 
 Abstract:
 Feature Extraction: Class Interface and Required Header Files.
 */


// Headers:
#include <stdio.h>
#include <opencv2/opencv.hpp>
#include <opencv2/features2d.hpp>


// Namespaces:
using namespace cv;
using namespace std;


// Class:
class FeatureExtraction {
    
public:
    void extraction_result(Mat imgSrc, Mat imgTrgt);
    
private:
    Mat convert_image(Mat image);
    
    bool extract_features(Mat imgSrc, Mat imgTrgt);
};
