//
//  ITContentPurchasedUnlockManager.m
//  ITImageTag
//
//  Created by JOJO on 2019/4/8.
//  Copyright © 2019 JOJO. All rights reserved.
//

#import "ITContentPurchasedUnlockManager.h"

#define DEF_PathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//#import "NBTCoinsManager.h"

@implementation ITContentPurchasedUnlockManager

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (BOOL)hasUnlockContentWithContentItemId:(NSString *)contentItemId {

    NSString *freeContentListPath = [[NSBundle mainBundle] pathForResource:@"ITFreeContentItemList" ofType:@"plist"];
    NSArray *freeContentList = [NSArray arrayWithContentsOfFile:freeContentListPath];
    
    NSArray *unlockItemList = [NSArray arrayWithContentsOfFile:[self unlockContentItemPlistPath]];
    
    NSMutableArray *freeItemAndUnlockItem_M = [NSMutableArray arrayWithArray:freeContentList];
    if (unlockItemList) {
        [freeItemAndUnlockItem_M addObjectsFromArray:unlockItemList];
    }
    
    if (freeItemAndUnlockItem_M) {
        BOOL hasUnlockItem = NO;
        for (NSString *unlockItemId in freeItemAndUnlockItem_M) {
            if ([unlockItemId isEqualToString:contentItemId]) {
                hasUnlockItem = YES;
                break;
            }
        }
        return hasUnlockItem;
    } else {
        return NO;
    }
    return NO;
    
}

- (BOOL)isProSVGTempleteWithTempleteName:(NSString *)templeteName {
    NSString *freeContentListPath = [[NSBundle mainBundle] pathForResource:@"ITFreeContentItemList" ofType:@"plist"];
    NSArray *freeContentList = [NSArray arrayWithContentsOfFile:freeContentListPath];
    for (NSString *freeName in freeContentList) {
        if ([freeName isEqualToString:templeteName]) {
            return NO;
        }
    }
    return YES;
    
}

- (void)unlockContentItemWithItemId:(NSString *)contentItemId completion:(void(^)(void))completion {
//    [[NBTCoinsManager sharedManager] useCoin:CoinCostCount];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self unlockContentItemPlistPath]]) {
        
    } else {
        
    }
    
    NSArray *unlockItemList = [NSArray arrayWithContentsOfFile:[self unlockContentItemPlistPath]];
    if (unlockItemList) {
        NSMutableArray *unlockItemList_M = [NSMutableArray arrayWithArray:unlockItemList];
        [unlockItemList_M addObject:contentItemId];
        
        unlink([[self unlockContentItemPlistPath] UTF8String]);
        
        
        BOOL hasWrite = [unlockItemList_M writeToFile:[self unlockContentItemPlistPath] atomically:YES];
        
        if (hasWrite) {
            completion();
        } else {
            completion();
//            [[AppDelegate shareAppdelegate] showHUDMsg:@"Something Wrong!"];
//            Alertift.alert(title: "Something Wrong!", message: error.localizedDescription)
//            .action(.cancel("Close"))
//            .show(on: self, completion: nil)
        }
    } else {
        NSArray *itemList = @[contentItemId];
        BOOL hasWrite = [itemList writeToFile:[self unlockContentItemPlistPath] atomically:YES];
        if (hasWrite) {
            completion();
        } else {
            completion();
//            [[AppDelegate shareAppdelegate] showHUDMsg:@"Something Wrong!"];
//            Alertift.alert(title: "Something Wrong!", message: error.localizedDescription)
//            .action(.cancel("Close"))
//            .show(on: self, completion: nil)
        }
        
    }
    
}

- (NSString *)unlockContentItemPlistPath {
    NSString *path = [DEF_PathDocument stringByAppendingPathComponent:@"unlockItemPlist.plist"];
    
    return path;
}


@end
