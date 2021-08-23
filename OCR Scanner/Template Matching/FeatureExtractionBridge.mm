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

- (NSString *) extraction_result:(UIImage *)srcImg creditCardImg:(UIImage *)srcCCImg targetImage:(UIImage *)trgtImg {
    
    // Initialize Mat Image Variables for OpenCV:
    FeatureExtraction ftExtrct;
    cv::Mat srcImage, srcCCImage, trgtImage;
    string ans = "";
    NSString *errorMessage;
    
    // Convert UI Image to Mat:
    UIImageToMat(srcImg, srcImage, true);
    UIImageToMat(srcCCImg, srcCCImage, true);
    UIImageToMat(trgtImg, trgtImage, true);
    
    // Condition:
    if (srcImage.empty() || srcCCImage.empty() || trgtImage.empty()) {
        return @"FALSE";
    } else {
        // Function Call:
        ans = ftExtrct.extraction_result(srcImage, srcCCImage, trgtImage);
        
        errorMessage = [NSString stringWithCString:ans.c_str()
                                           encoding:[NSString defaultCStringEncoding]];
        
        return errorMessage;
    }
    
    return errorMessage;
}


// Image Pre-Process:
- (UIImage *)image_preprocess:(UIImage *)trgtImg {
    
    // Initialize Mat Image Variables for OpenCV:
    FeatureExtraction ftProcess;
    cv::Mat trgtImage, processedImage;

    // Convert UI Image to Mat:
    UIImageToMat(trgtImg, trgtImage, true);
    
    // Condition:
    if (trgtImage.empty()) {
        return nil;
    } else {
        
        // Function Call:
        processedImage = ftProcess.image_process(trgtImage);
        
        return MatToUIImage(processedImage);
    }
    
    return nil;
}


@end
