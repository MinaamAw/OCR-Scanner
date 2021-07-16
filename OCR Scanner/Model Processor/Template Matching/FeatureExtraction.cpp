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

// Show Result to Swift:
void FeatureExtraction::extraction_result(Mat imgSrc, Mat imgTrgt) {
    
    // Initialize:
    bool flag;
    
    // Get Results:
    flag = extract_features(imgSrc, imgTrgt);
}


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
bool FeatureExtraction::extract_features(Mat imgSrc, Mat imgTrgt) {
    
    // Initialize:
    float thershold = 0.75;
    vector<KeyPoint> keySrc, keyTrgt;
    vector<vector<cv::DMatch>> knnMatches;
    Mat descSrc, descTrgt;
    DMatch bestMatch, betterMatch;
    vector<DMatch> goodMatches;
    
    // Features to Extract: 1500.
    Ptr<ORB> orb = ORB::create(1500);
    
    // Convert Images:
    imgSrc = convert_image(imgSrc);
    imgTrgt = convert_image(imgTrgt);
    
    // Compute:
    orb->detectAndCompute(imgSrc, Mat(), keySrc, descSrc);
    orb->detectAndCompute(imgTrgt, Mat(), keyTrgt, descTrgt);
    
    // Matcher;
    Ptr<DescriptorMatcher> bf = DescriptorMatcher::create(BFMatcher::BRUTEFORCE);
    bf->knnMatch(descSrc, descTrgt, knnMatches, 2);
    
    for (int i = 0; i < knnMatches.size(); i++){
        
        // Value Extraction:
        bestMatch = knnMatches[i][0];
        betterMatch = knnMatches[i][1];
        
        if (bestMatch.distance < thershold * betterMatch.distance) {
            goodMatches.push_back(bestMatch);
        }
    }
    
    if (goodMatches.size() > 20) {
        return true;
    } else {
        return false;
    }
}
