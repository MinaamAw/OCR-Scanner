/*
 FeatureExtraction.cpp
 OCR Scanner
 
 Created by Minaam Ahmed Awan on 14/07/2021.
 
 Abstract:
 Feature Extraction: Performs Feature Extraction through OpenCV Libraries.
 */


// Header Files
#include "FeatureExtraction.hpp"


// Namespaces:
using namespace cv;
using namespace std;


// Driver Code:

// Show Result to Swift:
bool FeatureExtraction::extraction_result(Mat imgSrc, Mat imgTrgt) {
    
    // Initialize:
    bool flag;
    
    // Get Results:
    flag = extract_features(imgSrc, imgTrgt);
    
    return flag;
}


// Convert Image to Greyscale (BGRA):
Mat FeatureExtraction::convert_image(Mat image) {
    
    // Initialize:
    Mat greyscaleImg;
    
    // Convert Image to Greyscale:
    cvtColor(image, greyscaleImg, CV_RGB2GRAY);
    
    return greyscaleImg;
}
Mat convert_image(Mat image);

// Convert Image to Greyscale (BGRA):
Mat FeatureExtraction::convert_image_bgr(Mat image) {
    
    // Initialize:
    Mat greyscaleImg;
    
    // Convert Image to Greyscale:
    cvtColor(image, greyscaleImg, CV_RGBA2GRAY);
    
    return greyscaleImg;
}


// Extract Features using ORB:
bool FeatureExtraction::extract_features(Mat imgSrc, Mat imgTrgt) {
    
    // Initialize:
    float thershold = 0.70;
    vector<KeyPoint> keySrc, keyTrgt;
    vector<vector<cv::DMatch>> knnMatches;
    Mat descSrc, descTrgt;
    DMatch bestMatch, betterMatch;
    vector<DMatch> goodMatches;
    
    // Features to Extract: 1500.
    Ptr<ORB> orb = ORB::create(1000);
    
    // Convert Images:
    imgSrc = convert_image(imgSrc);
    imgTrgt = convert_image_bgr(imgTrgt);
    
    // Compute:
    orb->detectAndCompute(imgSrc, Mat(), keySrc, descSrc);
    orb->detectAndCompute(imgTrgt, Mat(), keyTrgt, descTrgt);
    
    // Matcher;
    if (descSrc.empty() || descTrgt.empty()) {
        return false;
    }
    else {
        Ptr<DescriptorMatcher> bf = DescriptorMatcher::create(BFMatcher::BRUTEFORCE);
        bf->knnMatch(descSrc, descTrgt, knnMatches, 2);
        goodMatches.clear();
        
        for (int i = 0; i < knnMatches.size(); i++){
            
            // Value Extraction:
            bestMatch = knnMatches[i][0];
            betterMatch = knnMatches[i][1];
            
            float finalDistance = bestMatch.distance / betterMatch.distance;
            
            if (finalDistance <= thershold) {
                goodMatches.push_back(bestMatch);
            }
        }
        
        if (goodMatches.size() >= 12) {
            return true;
        } else {
            return false;
        }
    }
}
