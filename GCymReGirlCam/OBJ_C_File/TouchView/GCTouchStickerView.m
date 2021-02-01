//
//  GCTouchStickerView.m
//  GCGirlsCamera
//
//  Created by JOJO on 2019/7/3.
//  Copyright © 2019 JOJO. All rights reserved.
//

#import "GCTouchStickerView.h"
#import "UIView+Frame.h"
#import "UIColor+SSToolkitAdditions.h"

#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

@interface GCTouchStickerView ()
{
    BOOL highlight;
}

@property (nonatomic, strong) UIButton *deleteButton;
@property (strong, nonatomic) UILabel *label;

@property (nonatomic, strong) UIView *lineBorderView;



@end

@implementation GCTouchStickerView

- (instancetype)initWithStickerName:(NSString *)stickerName withStickerSize:(CGSize)size {
    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupActionBtns];
        [self setupBorderViewWithSize:size];
        [self setupStickerContentImageWithStickerName:stickerName viewSize:size];
    }
    return self;

}

- (void)setupActionBtns {
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteButton setImage:[UIImage imageNamed:@"22girlscamera"] forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _deleteButton.hidden = YES;
    [self addSubview:_deleteButton];
    
    self.rotateButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"23girlscamera"]];
    self.rotateButton.contentMode = UIViewContentModeCenter;
    self.rotateButton.userInteractionEnabled = YES;
    self.rotateButton.hidden = YES;
    [self addSubview:self.rotateButton];
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rotateButtonPanGestureDetected:)];
    [self.rotateButton addGestureRecognizer:panGR];
}

- (void)setupBorderViewWithSize:(CGSize)size {
    _lineBorderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    _lineBorderView.hidden = YES;
    _lineBorderView.layer.allowsEdgeAntialiasing = YES;
//    _lineBorderView.layer.borderWidth = 1;
//    _lineBorderView.layer.borderColor = [[UIColor colorWithHex:@"FFFFFF"] colorWithAlphaComponent:0.9].CGColor;
//    _lineBorderView.layer.shadowOpacity = 0.8;
//    _lineBorderView.layer.shadowOffset = CGSizeZero;
//    _lineBorderView.layer.shadowRadius = 4;
//    _lineBorderView.layer.lineDashPattern = @[@(10),@(10)];
    _lineBorderView.userInteractionEnabled = NO;
    
    
    CAShapeLayer *dottedLineBorder  = [[CAShapeLayer alloc] init];
    dottedLineBorder.frame = CGRectMake(0, 0, size.width, size.height);
    dottedLineBorder.allowsEdgeAntialiasing = YES;
    [_lineBorderView.layer addSublayer:dottedLineBorder];
    dottedLineBorder.lineCap = kCALineCapSquare;
    [dottedLineBorder setStrokeColor:[UIColor colorWithHex:@"FFFFFF"].CGColor];
    [dottedLineBorder setFillColor:[UIColor clearColor].CGColor];
    dottedLineBorder.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)].CGPath;
    dottedLineBorder.lineDashPattern = @[@(5),@(5)];
    [_lineBorderView.layer addSublayer:dottedLineBorder];
    
    
    
    [self insertSubview:_lineBorderView atIndex:0];
}

- (void)setupStickerContentImageWithStickerName:(NSString *)stickerName viewSize:(CGSize)size {
    _stickerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    _stickerImageView.contentMode = UIViewContentModeScaleAspectFit;
    _stickerImageView.image = [UIImage imageNamed:stickerName];
    [self addSubview:_stickerImageView];
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = isPad?50:40;
    _deleteButton.bounds = CGRectMake(0, 0, width, width);
    _deleteButton.center = CGPointMake(0, 0);
    
    self.rotateButton.bounds = CGRectMake(0, 0, width, width);
    self.rotateButton.center = CGPointMake(self.width, self.height);
    
    _lineBorderView.frame = self.bounds;
}


- (void)deleteBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(viewDeleteBtnClick:)]) {
        [self.delegate viewDeleteBtnClick:self];
    }
}


- (void)shakeAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.keyTimes = @[@(0),@(0.25),@(0.75),@(1)];
    animation.values = @[@(0),@(0.03),@(-0.03),@(0)];
    animation.duration = 0.2;
    [self.label.layer addAnimation:animation forKey:nil];
}



- (void)setHilight:(BOOL)flag {
    _deleteButton.hidden = !flag;
    self.rotateButton.hidden = !flag;
    _lineBorderView.hidden = !flag;
    highlight = flag;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint pointForDeleteButton = [self.deleteButton convertPoint:point fromView:self];
    CGPoint pointForRotateButton = [self.rotateButton convertPoint:point fromView:self];
    if (CGRectContainsPoint(self.deleteButton.bounds, pointForDeleteButton)) {
        return [self.deleteButton hitTest:pointForDeleteButton withEvent:event];
    } else if (CGRectContainsPoint(self.rotateButton.bounds, pointForRotateButton)) {
        return [self.rotateButton hitTest:pointForRotateButton withEvent:event];
    }
    return [super hitTest:point withEvent:event];
}

- (void)touchViewButtonOppositTransform:(UIView *)touchView {
    CGAffineTransform touchTransform = self.transform;
    
    CGFloat rotation = atan2(touchTransform.b, touchTransform.a);
    CGFloat scaleX = sqrt(touchTransform.a * touchTransform.a + touchTransform.c * touchTransform.c);
    CGFloat scaleY = sqrt(touchTransform.b * touchTransform.b + touchTransform.d * touchTransform.d);
    
    touchView.transform = CGAffineTransformMakeScale(1/scaleX, 1/scaleY);
    touchView.transform = CGAffineTransformRotate(touchView.transform , - rotation);
}

- (void)touchViewBorderOppositTransform:(UIView *)touchView {
    CGAffineTransform touchTransform = self.transform;
    
    CGFloat scaleX = sqrt(touchTransform.a * touchTransform.a + touchTransform.c * touchTransform.c);
    CGFloat scaleY = sqrt(touchTransform.b * touchTransform.b + touchTransform.d * touchTransform.d);
    
    CGFloat scale = MAX(scaleX, scaleY);
    
//    touchView.layer.borderWidth = 1 / scale;
    touchView.layer.shadowRadius = 4 / scale;
}

- (void)updateBtnOppositTransform {
    [self touchViewButtonOppositTransform:self.deleteButton];
    [self touchViewButtonOppositTransform:self.rotateButton];
    [self touchViewBorderOppositTransform:self.lineBorderView];
}
@end
