//
//  WallmartHeader.h
//  Wallmart
//
//  Created by Timm Kandziora on 16.01.15.
//  Copyright (c) 2015 Timm Kandziora. All rights reserved.
//

#import <substrate.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <PhotoLibrary/PLStaticWallpaperImageViewController.h>
#import <Foundation/NSDistributedNotificationCenter.h>

#define MAYBE arc4random_uniform(2)

#define settingsPath @"/var/mobile/Library/Preferences/com.shinvou.wallmart.plist"

@interface SpringBoard
- (void)applicationDidFinishLaunching:(UIApplication *)application;
- (void)configureTimer;
- (void)updateWallpaper;
@end

@interface SBStatusBarStateAggregator
- (void)_updateTimeItems;
- (void)updateWallpaper;
@end

@interface PCPersistentTimer : NSObject
- (id)initWithFireDate:(NSDate *)date serviceIdentifier:(NSString *)identifier target:(id)target selector:(SEL)selector userInfo:(id)userInfo;
- (void)scheduleInRunLoop:(NSRunLoop *)runLoop;
- (void)invalidate;
@end

@interface SBSUIWallpaperPreviewViewController : UIViewController
- (void)setMotionEnabled:(BOOL)enabled;
@end
