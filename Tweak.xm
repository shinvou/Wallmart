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

@interface SpringBoard
- (void)applicationDidFinishLaunching:(id)application;
- (void)configureTimer;
- (void)updateWallpaper;
@end

@interface PCPersistentTimer : NSObject
- (id)initWithFireDate:(id)arg1 serviceIdentifier:(id)arg2 target:(id)arg3 selector:(SEL)arg4 userInfo:(id)arg5;
- (void)scheduleInRunLoop:(id)arg1;
- (void)invalidate;
@end

@interface SBSUIWallpaperPreviewViewController : UIViewController
- (void)setMotionEnabled:(BOOL)enabled;
@end

#define settingsPath @"/var/mobile/Library/Preferences/com.shinvou.wallmart.plist"

static BOOL unlockedAfterBoot = NO;
static int currentIndex = 0;
static NSString *albumName = @"Wallmart";
static ALAssetsLibrary *assetsLibrary = nil;
static PCPersistentTimer *persistentTimer = nil;

static BOOL enabled = YES;
static PLWallpaperMode wallpaperMode = PLWallpaperModeBoth;
static BOOL shuffleEnabled = NO;
static BOOL perspectiveZoom = YES;
static BOOL blurEnabled = NO;
static int blurStrenght = 5;
static BOOL interwallEnabled = NO;
static int interwallTime = 60;

static void SetWallpaper(UIImage *image)
{
	if (blurEnabled) {
		CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
		[gaussianBlurFilter setDefaults];
		[gaussianBlurFilter setValue:[CIImage imageWithCGImage:image.CGImage] forKey:kCIInputImageKey];
		[gaussianBlurFilter setValue:@(blurStrenght) forKey:kCIInputRadiusKey];

		CIImage *outputImage = [gaussianBlurFilter outputImage];
		CIContext *context = [CIContext contextWithOptions:nil];
		CGRect rect = [outputImage extent];

		rect.origin.x += (rect.size.width  - image.size.width ) / 2;
		rect.origin.y += (rect.size.height - image.size.height) / 2;
		rect.size = image.size;

		CGImageRef cgimg = [context createCGImage:outputImage fromRect:rect];
		image = [UIImage imageWithCGImage:cgimg];
		CGImageRelease(cgimg);
	}

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

						if (shuffleEnabled) {
							currentIndex = arc4random_uniform([group numberOfAssets]);
						} else {
							currentIndex++;

							if (currentIndex == [group numberOfAssets]) {
								currentIndex = 0;
							}
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

						if (shuffleEnabled) {
							currentIndex = arc4random_uniform([group numberOfAssets]);
						} else {
							currentIndex++;

							if (currentIndex == [group numberOfAssets]) {
								currentIndex = 0;
							}
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

		if ([settings objectForKey:@"shuffle_enabled"]) {
			shuffleEnabled = [[settings objectForKey:@"shuffle_enabled"] boolValue];
		}

		if ([settings objectForKey:@"perspective_zoom"]) {
			perspectiveZoom = [[settings objectForKey:@"perspective_zoom"] boolValue];
		}

		if ([settings objectForKey:@"blur_enabled"]) {
			blurEnabled = [[settings objectForKey:@"blur_enabled"] boolValue];
		}

		if ([settings objectForKey:@"blur_strenght"]) {
			blurStrenght = [[settings objectForKey:@"blur_strenght"] intValue];
		}

		if ([settings objectForKey:@"interwall_enabled"]) {
			interwallEnabled = [[settings objectForKey:@"interwall_enabled"] boolValue];
		}

		if ([settings objectForKey:@"interwallTime"]) {
			NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
			NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
			[numberFormatter setLocale:locale];
			[numberFormatter setAllowsFloats:NO];

			if (![[settings objectForKey:@"interwallTime"] isEqualToString:@""] && [numberFormatter numberFromString:[settings objectForKey:@"interwallTime"]]) {
				if ([[settings objectForKey:@"interwallTime"] intValue] != interwallTime) {
					interwallTime = [[settings objectForKey:@"interwallTime"] intValue];

					[persistentTimer invalidate];
					[(SpringBoard *)[UIApplication sharedApplication] configureTimer];
				}
			} else {
				interwallTime = 60;
			}

			[numberFormatter release];
			[locale release];
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

%hook SpringBoard

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	%orig;

	[self configureTimer];
}

%new - (void)configureTimer
{
	persistentTimer = [[PCPersistentTimer alloc] initWithFireDate:[[NSDate date] dateByAddingTimeInterval:interwallTime] serviceIdentifier:@"com.shinvou.wallmart" target:self selector:@selector(updateWallpaper) userInfo:nil];
	[persistentTimer scheduleInRunLoop:[NSRunLoop mainRunLoop]];
}

%new - (void)updateWallpaper
{
	if (interwallEnabled && unlockedAfterBoot) {
		GetWallpapersFromAlbum();
	}

	[self configureTimer];
}

%end

%hook PLStaticWallpaperImageViewController

- (void)providerLegibilitySettingsChanged:(SBSUIWallpaperPreviewViewController *)wallpaperPreviewViewController
{
	[wallpaperPreviewViewController setMotionEnabled:perspectiveZoom];

	%orig(wallpaperPreviewViewController);
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
