/*
 FeatureExtraction.cpp
 OCR Scanner
 
 Created by Minaam Ahmed Awan on 14/07/2021.
 
 Abstract:
 Feature Extraction: Performs Feature Extraction through OpenCV Libraries.
 */


// Header Files
#include "FeatureExtraction.hpp"
//#include "opencv2/core.hpp"


// Namespaces:
using namespace cv;
using namespace std;


// Driver Code:

// Convert Image to Greyscale:
Mat FeatureExtraction::convert_image(Mat image) {
    
    // Initialize:
    Mat greyscaleImg;
    Mat resultImg;
    
    // Convert Image to Greyscale:
    cvtColor(image, greyscaleImg, CV_RGB2GRAY);
    
    return resultImg;
}


// Extract Features using ORB:
Mat FeatureExtraction::extract_features(Mat resultImg) {
    
    // Initialize:
    vector<KeyPoint> keypoints;
    Mat descriptors;
    
    // Features to Extract: 1500.
    Ptr<ORB> orb = ORB::create(1500);
    
    // Compute:
    orb->detectAndCompute(resultImg, Mat(), keypoints, descriptors);
    
    // Matcher;
    Ptr<DescriptorMatcher> bf = DescriptorMatcher::create(BFMatcher::BRUTEFORCE);
    
    return resultImg;
}
