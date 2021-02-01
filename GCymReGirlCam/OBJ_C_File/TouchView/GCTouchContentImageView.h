//
//  GCTouchContentImageView.h
//  GCGirlsCamera
//
//  Created by JOJO on 2019/6/28.
//  Copyright © 2019 JOJO. All rights reserved.
//

#import "TouchStuffView.h"
#import <GPUImage/GPUImage.h>
//#import "GPUImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GCTouchContentImageView : TouchStuffView
//
@property (nonatomic, strong) UIImage *contentImage;
@property (nonatomic, strong) UIImage * __nullable overlayerImage;
@property (nonatomic, strong) GPUImagePicture *gpuImagePicture;
@property (strong, nonatomic) GPUImageView *gpuImageView;
@property (strong, nonatomic) UIImageView *contentImageView;
@property (nonatomic, strong) UIImageView *overlayerImageView;
//
 
- (void)setupContentImage:(UIImage * __nullable)contentImage lookupFilterImageName:(NSString * __nullable)lookupImgName;

@end

NS_ASSUME_NONNULL_END
