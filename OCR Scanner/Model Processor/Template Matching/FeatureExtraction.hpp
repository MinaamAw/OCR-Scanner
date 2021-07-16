/*
 FeatureExtraction.hpp
 OCR Scanner
 
 Created by Minaam Ahmed Awan on 14/07/2021.
 
 Abstract:
 Feature Extraction: Class Interface and Required Header Files.
 */


#ifndef FeatureExtraction_hpp
#define FeatureExtraction_hpp


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
    Mat extraction_result(Mat image);
    
private:
    Mat convert_image(Mat image);
    
    Mat extract_features(Mat image);
};


#endif /* FeatureExtraction_hpp */
