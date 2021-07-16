/*
 FeatureExtractionBridge.h
 OCR Scanner
 
 Created by Minaam Ahmed Awan on 16/07/2021.
 
 Abstract:
 Feature Extraction Bridge: Header File for Bridge Between Swift and Objective-C++.
 */


// Headers:
#import <opencv2/opencv.hpp>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface FeatureExtractionBridge : NSObject

- (void)extraction_result:(UIImage *)srcImg targetImage:(UIImage *) trgtImg;

@end
