/*
 FeatureExtractionBridge.h
 OCR Scanner
 
 Created by Minaam Ahmed Awan on 16/07/2021.
 
 Abstract:
 Feature Extraction Bridge: Header File for Bridge Between Swift and Objective-C++.
 */


// Headers:
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface FeatureExtractionBridge : NSObject

- (NSString *)extraction_result:(UIImage *)srcImg creditCardImg:(UIImage *)srcCCImg targetImage:(UIImage *) trgtImg;

- (UIImage *)image_preprocess:(UIImage *)trgtImg;

@end
