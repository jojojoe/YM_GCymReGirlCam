//
//  GCTouchContentImageView.m
//  GCGirlsCamera
//
//  Created by JOJO on 2019/6/28.
//  Copyright © 2019 JOJO. All rights reserved.
//

#import "GCTouchContentImageView.h"

#import "UIView+Frame.h"


@interface GCTouchContentImageView ()
@property (nonatomic, strong) GPUImageLookupFilter *lookupFilter;

@end

@implementation GCTouchContentImageView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _gpuImageView = [[GPUImageView alloc] init];
        _gpuImageView.fillMode = kGPUImageFillModeStretch;
        _gpuImageView.userInteractionEnabled = NO;
        _gpuImageView.clipsToBounds = YES;
        self.clipsToBounds = YES;
//        [self addSubview:_gpuImageView];
        
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        _contentImageView.clipsToBounds = YES;
        [self addSubview:_contentImageView];
        
        _overlayerImageView = [[UIImageView alloc] init];
        _overlayerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _overlayerImageView.clipsToBounds = YES;
        [self addSubview:_overlayerImageView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gpuImageView.bounds = self.bounds;
    self.gpuImageView.center = CGPointMake(self.width/2, self.height/2);
    
    self.contentImageView.bounds = self.bounds;
    self.contentImageView.center = CGPointMake(self.width/2, self.height/2);
    
    self.overlayerImageView.bounds = self.bounds;
    self.overlayerImageView.center = CGPointMake(self.width/2, self.height/2);
}
 

- (void)setupContentImage:(UIImage * __nullable)contentImage lookupFilterImageName:(NSString * __nullable)lookupImgName {
    if (!contentImage && !self.contentImage) {
        return;
    }
    
    if (contentImage) {
        self.contentImage = contentImage;
        self.gpuImagePicture = [[GPUImagePicture alloc] initWithImage:contentImage];
    }
    UIImage *lookupImage = [UIImage imageNamed:lookupImgName];
    if (lookupImage) {
        [self.gpuImagePicture removeAllTargets];
        
        self.lookupFilter = [[GPUImageLookupFilter alloc] init];
        GPUImagePicture *lookupPicture = [[GPUImagePicture alloc] initWithImage:lookupImage];
        [self.gpuImagePicture addTarget:self.lookupFilter atTextureLocation:0];
        [lookupPicture addTarget:self.lookupFilter atTextureLocation:1];
        self.lookupFilter.intensity = 0.7;
//        [self.lookupFilter addTarget:self.gpuImageView];
        [lookupPicture processImage];
        [self.gpuImagePicture processImage];
        
        [self.lookupFilter useNextFrameForImageCapture];
        UIImage *processedImage = [self.lookupFilter imageFromCurrentFramebuffer];

        self.contentImageView.image = processedImage;
        
        
    } else {
        [self.gpuImagePicture removeAllTargets];
        [self.gpuImagePicture addTarget:self.gpuImageView];
        [self.gpuImagePicture processImage];
        
        self.contentImageView.image = self.contentImage;
    }
    
}

- (void)setOverlayerImage:( UIImage * __nullable)overlayerImage {
    _overlayerImage = overlayerImage;
    self.overlayerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.overlayerImageView.image = overlayerImage;
}


@end
