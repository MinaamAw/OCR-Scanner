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
string FeatureExtraction::extraction_result(Mat imgSrc, Mat imgCCSrc, Mat imgTrgt) {
    
    // Initialize:
    string flag;
    
    // Get Results:
    flag = extract_features(imgSrc, imgCCSrc, imgTrgt);
    
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


// Convert Image to Greyscale (BGRA):
Mat FeatureExtraction::convert_image_bgr(Mat image) {
    
    // Initialize:
    Mat greyscaleImg;
    
    // Convert Image to Greyscale:
    cvtColor(image, greyscaleImg, CV_RGBA2GRAY);
    
    return greyscaleImg;
}


// Pre-Process Image for OCR:
Mat FeatureExtraction::image_process(Mat imgTrgt) {
    
    // Initialize:
    Mat imgGray, imgNoise, imgCntrst;
    Mat element = getStructuringElement( MORPH_RECT, Size(9,3));
    
    // Convert Image to Greyscale:
    cvtColor(imgTrgt, imgGray, COLOR_BGR2GRAY);
    
    // Image Noise Removal:
    medianBlur(imgTrgt, imgNoise, 5);
    
    // Image Contrast:
    imgNoise.convertTo(imgCntrst, -1, 1.05, 0); //increase the contrast by 2
    
    return imgCntrst;
}


// Extract Features using ORB:
string FeatureExtraction::extract_features(Mat imgSrc, Mat imgCCSrc, Mat imgTrgt) {
    
    // Initialize:
    float thershold = 0.70;
    vector<KeyPoint> keySrc, keyTrgt, keySrcCC, keyTrgtCC;
    vector<vector<cv::DMatch>> knnMatches, knnMatchesCC;
    Mat descSrc, descTrgt, descSrcCC, descTrgtCC;
    DMatch bestMatch, betterMatch, bestMatchCC, betterMatchCC;
    vector<DMatch> goodMatches, goodMatchesCC;
    
    // Features to Extract: 1500.
    Ptr<ORB> orb = ORB::create(1000);
    Ptr<ORB> orbCC = ORB::create(1000);
    
    //Crop Image for CC:
    Mat cropTrgt = imgTrgt(Range(80,280),Range(150,330));
    
    // Convert Images:
    imgSrc = convert_image(imgSrc);
    imgCCSrc = convert_image(imgCCSrc);
    imgTrgt = convert_image_bgr(imgTrgt);
    cropTrgt = convert_image_bgr(cropTrgt);
    
    // Compute:
    orb->detectAndCompute(imgSrc, Mat(), keySrc, descSrc);
    orbCC->detectAndCompute(imgCCSrc, Mat(), keySrcCC, descSrcCC);
    orb->detectAndCompute(imgTrgt, Mat(), keyTrgt, descTrgt);
    orbCC->detectAndCompute(cropTrgt, Mat(), keyTrgtCC, descTrgtCC);
    
    // Matcher;
    if (descSrc.empty() || descTrgt.empty() || descSrcCC.empty() || descTrgtCC.empty()) {
        return "FALSE";
    }
    else {
        Ptr<DescriptorMatcher> bf = DescriptorMatcher::create(BFMatcher::BRUTEFORCE);
        bf->knnMatch(descSrc, descTrgt, knnMatches, 2);
        
        Ptr<DescriptorMatcher> bfCC = DescriptorMatcher::create(BFMatcher::BRUTEFORCE);
        bfCC->knnMatch(descSrcCC, descTrgtCC, knnMatchesCC, 2);
        
        goodMatches.clear();
        goodMatchesCC.clear();
        
        for (int i = 0; i < knnMatches.size(); i++){
            
            // Value Extraction:
            bestMatch = knnMatches[i][0];
            betterMatch = knnMatches[i][1];
            
            float finalDistance = bestMatch.distance / betterMatch.distance;
            
            if (finalDistance <= thershold) {
                goodMatches.push_back(bestMatch);
            }
        }
        
        for (int j = 0; j < knnMatchesCC.size(); j++){
            
            // Value Extraction:
            bestMatchCC = knnMatchesCC[j][0];
            betterMatchCC = knnMatchesCC[j][1];
            
            float finalDistance = bestMatchCC.distance / betterMatchCC.distance;
            
            if (finalDistance <= thershold) {
                goodMatchesCC.push_back(bestMatchCC);
            }
        }
        
        if (goodMatches.size() >= 12) {
            return "CNIC";
        } else if (goodMatchesCC.size() >= 9) {
            return "CC";
        } else {
            return "FALSE";
        }
    }
}
