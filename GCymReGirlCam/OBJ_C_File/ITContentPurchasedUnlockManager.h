//
//  ITContentPurchasedUnlockManager.h
//  ITImageTag
//
//  Created by JOJO on 2019/4/8.
//  Copyright © 2019 JOJO. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ITContentPurchasedUnlockManager : NSObject

+ (instancetype)sharedInstance;

- (BOOL)hasUnlockContentWithContentItemId:(NSString *)contentItemId;
- (void)unlockContentItemWithItemId:(NSString *)contentItemId completion:(void(^)(void))completion;
- (BOOL)isProSVGTempleteWithTempleteName:(NSString *)templeteName;
@end

NS_ASSUME_NONNULL_END
