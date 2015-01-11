//
//  Tweak.xm
//  Wallmart
//
//  Created by Timm Kandziora on 09.01.15.
//  Copyright (c) 2015 Timm Kandziora. All rights reserved.
//

#import <substrate.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <PhotoLibrary/PLStaticWallpaperImageViewController.h>
#import <Foundation/NSDistributedNotificationCenter.h>

#define settingsPath @"/var/mobile/Library/Preferences/com.shinvou.wallmart.plist"

static BOOL unlockedAfterBoot = NO;
static int currentIndex = 0;
static NSString *albumName = @"Wallmart";
static ALAssetsLibrary *assetsLibrary = nil;

static BOOL enabled = YES;
static PLWallpaperMode wallpaperMode = PLWallpaperModeBoth;

static void SetWallpaper(UIImage *image)
{
	PLStaticWallpaperImageViewController *wallpaperViewController = [[PLStaticWallpaperImageViewController alloc] initWithUIImage:image];
	wallpaperViewController.saveWallpaperData = YES;

	uintptr_t address = (uintptr_t)&wallpaperMode;
	object_setInstanceVariable(wallpaperViewController, "_wallpaperMode", *(PLWallpaperMode **)address);

	[wallpaperViewController _savePhoto];
	[wallpaperViewController release];
}

static void GetWallpapersFromAlbum()
{
	if (!assetsLibrary) {
		assetsLibrary = [[ALAssetsLibrary alloc] init];
	}

	[assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
		NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];

		if (settings && [settings objectForKey:@"albumName"] && ![[settings objectForKey:@"albumName"] isEqualToString:@""]) {
			if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:[settings objectForKey:@"albumName"]]) {
				[group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
					if (index == currentIndex) {
						ALAssetRepresentation *representation = [result defaultRepresentation];
						UIImage *image = [UIImage imageWithCGImage:[representation fullScreenImage]];
						SetWallpaper(image);

						currentIndex++;

						if (currentIndex == [group numberOfAssets]) {
							currentIndex = 0;
						}

						*stop = YES;
					}
				}];

				[settings release];
			}
		} else {
			if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:albumName]) {
				[group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
					if (index == currentIndex) {
						ALAssetRepresentation *representation = [result defaultRepresentation];
						UIImage *image = [UIImage imageWithCGImage:[representation fullScreenImage]];
						SetWallpaper(image);

						currentIndex++;

						if (currentIndex == [group numberOfAssets]) {
							currentIndex = 0;
						}

						*stop = YES;
					}
				}];
			}
		}
	} failureBlock:^(NSError *error) {
		NSLog(@"\n\n [Wallmart] Following error occured: %@", [error description]);
	}];
}

static void ReloadSettings()
{
	NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];

	if (settings) {
		if ([settings objectForKey:@"enabled"]) {
			enabled = [[settings objectForKey:@"enabled"] boolValue];
		}

		if ([settings objectForKey:@"wallpaperMode"]) {
			wallpaperMode = [[settings objectForKey:@"wallpaperMode"] intValue];
		}
	}

	[settings release];
}

%hook SBLockScreenManager

- (void)lockUIFromSource:(int)source withOptions:(id)options
{
	%orig;

	if (enabled && unlockedAfterBoot) {
		GetWallpapersFromAlbum();
	}
}

- (void)_finishUIUnlockFromSource:(int)source withOptions:(id)options
{
	%orig;

	unlockedAfterBoot = YES;
}

%end

%ctor {
	@autoreleasepool {
		[[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"WallmartEvent" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
			GetWallpapersFromAlbum();
		}];

		ReloadSettings();
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)ReloadSettings, CFSTR("com.shinvou.wallmart/reloadSettings"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	}
}
