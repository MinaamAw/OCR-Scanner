/*
 FeatureExtractionBridge.mm
 OCR Scanner
 
 Created by Minaam Ahmed Awan on 16/07/2021.
 
 Abstract:
 Feature Extraction Bridge: Bridge Between Swift and Objective-C++.
 */


// Header Files
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <Foundation/Foundation.h>
#import "FeatureExtractionBridge.h"
#include "FeatureExtraction.hpp"


@implementation FeatureExtractionBridge

- (bool) extraction_result:(UIImage *)srcImg targetImage:(UIImage *)trgtImg {
    
    // Initialize Mat Image Variables for OpenCV:
    FeatureExtraction ftExtrct;
    cv::Mat srcImage, trgtImage;
    bool ans = false;
    
    // Convert UI Image to Mat:
    UIImageToMat(srcImg, srcImage, true);
    UIImageToMat(trgtImg, trgtImage, true);
    
    // Condition:
    if (srcImage.empty() || trgtImage.empty()) {
        return ans;
    } else {
        // Function Call:
        ans = ftExtrct.extraction_result(srcImage, trgtImage);
    }
    
    return ans;
}

@end
