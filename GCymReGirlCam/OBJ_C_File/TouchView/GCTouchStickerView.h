//
//  GCTouchStickerView.h
//  GCGirlsCamera
//
//  Created by JOJO on 2019/7/3.
//  Copyright © 2019 JOJO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchStuffView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GCTouchStickerView : TouchStuffView

//@property (nonatomic, assign) CGRect canvasBounds;

//- (instancetype)initWithAttributeString:(NSAttributedString *)text withCanvasBounds:(CGRect)canvasBounds;
@property (nonatomic, strong) UIImageView *stickerImageView;
- (instancetype)initWithStickerName:(NSString *)stickerName withStickerSize:(CGSize)size;

//- (void)updateAttributeString:(NSAttributedString *)text;
- (void)shakeAnimation;

@end

NS_ASSUME_NONNULL_END
