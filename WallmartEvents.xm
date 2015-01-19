//
//  WallmartEvents.xm
//  Wallmart
//
//  Created by Timm Kandziora on 19.01.15.
//  Copyright (c) 2015 Timm Kandziora. All rights reserved.
//

#import <libactivator/libactivator.h>
#import <Foundation/NSDistributedNotificationCenter.h>

@interface WallmartEventSwitchBothWallpapers : NSObject <LAListener>
@end

@implementation WallmartEventSwitchBothWallpapers

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event
{
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"WallmartEventSwitchBothWallpapers" object:nil userInfo:nil];

	[event setHandled:YES]; // To prevent the default OS implementation
}

- (UIImage *)activator:(LAActivator *)activator requiresSmallIconForListenerName:(NSString *)listenerName scale:(CGFloat)scale
{
	if (scale > 2) {
		return [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/WallmartSettings.bundle/WallmartSettings@3x.png"];
	}

	return [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/WallmartSettings.bundle/WallmartSettings@2x.png"];
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedGroupForListenerName:(NSString *)listenerName
{
	return @"Wallmart";
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName
{
	return @"Wallmart";
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName
{
	return @"Switch your wallpapers on ls and hs";
}

- (NSArray *)activator:(LAActivator *)activator requiresCompatibleEventModesForListenerWithName:(NSString *)listenerName
{
	return [NSArray arrayWithObjects:@"springboard", @"lockscreen", @"application", nil];
}

+ (void)load
{
	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.springboard"]) {
		[[%c(LAActivator) sharedInstance] registerListener:[self new] forName:@"com.shinvou.wallmartevent.switchbothwallpapers"];
	}
}
@end

@interface WallmartEventSwitchLockScreenWallpaper : NSObject <LAListener>
@end

@implementation WallmartEventSwitchLockScreenWallpaper

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event
{
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"WallmartEventSwitchLockScreenWallpaper" object:nil userInfo:nil];

	[event setHandled:YES]; // To prevent the default OS implementation
}

- (UIImage *)activator:(LAActivator *)activator requiresSmallIconForListenerName:(NSString *)listenerName scale:(CGFloat)scale
{
	if (scale > 2) {
		return [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/WallmartSettings.bundle/WallmartSettings@3x.png"];
	}

	return [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/WallmartSettings.bundle/WallmartSettings@2x.png"];
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedGroupForListenerName:(NSString *)listenerName
{
	return @"Wallmart";
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName
{
	return @"Wallmart";
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName
{
	return @"Switch your wallpaper on ls";
}

- (NSArray *)activator:(LAActivator *)activator requiresCompatibleEventModesForListenerWithName:(NSString *)listenerName
{
	return [NSArray arrayWithObjects:@"springboard", @"lockscreen", @"application", nil];
}

+ (void)load
{
	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.springboard"]) {
		[[%c(LAActivator) sharedInstance] registerListener:[self new] forName:@"com.shinvou.wallmartevent.switchlockscreenwallpaper"];
	}
}
@end

@interface WallmartEventSwitchHomeScreenWallpaper : NSObject <LAListener>
@end

@implementation WallmartEventSwitchHomeScreenWallpaper

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event
{
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"WallmartEventSwitchHomeScreenWallpaper" object:nil userInfo:nil];

	[event setHandled:YES]; // To prevent the default OS implementation
}

- (UIImage *)activator:(LAActivator *)activator requiresSmallIconForListenerName:(NSString *)listenerName scale:(CGFloat)scale
{
	if (scale > 2) {
		return [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/WallmartSettings.bundle/WallmartSettings@3x.png"];
	}

	return [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/WallmartSettings.bundle/WallmartSettings@2x.png"];
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedGroupForListenerName:(NSString *)listenerName
{
	return @"Wallmart";
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName
{
	return @"Wallmart";
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName
{
	return @"Switch your wallpaper on hs";
}

- (NSArray *)activator:(LAActivator *)activator requiresCompatibleEventModesForListenerWithName:(NSString *)listenerName
{
	return [NSArray arrayWithObjects:@"springboard", @"lockscreen", @"application", nil];
}

+ (void)load
{
	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.springboard"]) {
		[[%c(LAActivator) sharedInstance] registerListener:[self new] forName:@"com.shinvou.wallmartevent.switchhomescreenwallpaper"];
	}
}
@end

@interface WallmartEventToggleWallmartEnabled : NSObject <LAListener>
@end

@implementation WallmartEventToggleWallmartEnabled

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event
{
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"WallmartEventToggleWallmartEnabled" object:nil userInfo:nil];

	[event setHandled:YES]; // To prevent the default OS implementation
}

- (UIImage *)activator:(LAActivator *)activator requiresSmallIconForListenerName:(NSString *)listenerName scale:(CGFloat)scale
{
	if (scale > 2) {
		return [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/WallmartSettings.bundle/WallmartSettings@3x.png"];
	}

	return [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/WallmartSettings.bundle/WallmartSettings@2x.png"];
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedGroupForListenerName:(NSString *)listenerName
{
	return @"Wallmart";
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName
{
	return @"Wallmart";
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName
{
	return @"Toggle Wallmart enabled";
}

- (NSArray *)activator:(LAActivator *)activator requiresCompatibleEventModesForListenerWithName:(NSString *)listenerName
{
	return [NSArray arrayWithObjects:@"springboard", @"lockscreen", @"application", nil];
}

+ (void)load
{
	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.springboard"]) {
		[[%c(LAActivator) sharedInstance] registerListener:[self new] forName:@"com.shinvou.wallmartevent.togglewallmartenabled"];
	}
}
@end
