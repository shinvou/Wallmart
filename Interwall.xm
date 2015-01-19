//
//  Interwall.xm
//  Wallmart
//
//  Created by Timm Kandziora on 16.01.15.
//  Copyright (c) 2015 Timm Kandziora. All rights reserved.
//

#import "WallmartHeader.h"

/* HELPER VARIABLES, TWEAK ONLY */

static PCPersistentTimer *persistentTimer;
static BOOL unlockedOnce = NO;
static ALAssetsLibrary *assetsLibrary;
static int currentIndexHomeScreen = 0;
static int currentIndexLockScreen = 0;

/* INFORMATION FROM SETTINGS */

static BOOL wallmartGeneralEnabled = YES;

static BOOL interwallEnabled = NO;
static int interwallTime = 60;
static BOOL interwallMomentsEnabled = NO;

static NSMutableArray *moments;

static int wallpaperModeInterwall = 0;

static BOOL blurEnabledInterwall = NO;
static int blurStrengthInterwall = 5;
static int blurModeInterwall = 0;

static BOOL perspectiveZoomInterwall = YES;
static BOOL shuffleInterwall = NO;

static NSString *albumNameLockscreenInterwall;
static NSString *albumNameHomescreenInterwall;

static UIImage* BlurImage(UIImage *image)
{
	CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
	[gaussianBlurFilter setDefaults];
	[gaussianBlurFilter setValue:[CIImage imageWithCGImage:image.CGImage] forKey:kCIInputImageKey];
	[gaussianBlurFilter setValue:@(blurStrengthInterwall) forKey:kCIInputRadiusKey];

	CIImage *outputImage = [gaussianBlurFilter outputImage];
	CIContext *context = [CIContext contextWithOptions:nil];
	CGRect rect = [outputImage extent];

	rect.origin.x += (rect.size.width  - image.size.width ) / 2;
	rect.origin.y += (rect.size.height - image.size.height) / 2;
	rect.size = image.size;

	CGImageRef cgimg = [context createCGImage:outputImage fromRect:rect];
	UIImage *blurredImage = [UIImage imageWithCGImage:cgimg];
	CGImageRelease(cgimg);

	return blurredImage;
}

static UIImage* GetBlurredImageFrom(UIImage *image, PLWallpaperMode wallpaperMode)
{
	if ((wallpaperMode == PLWallpaperModeHomeScreen && blurModeInterwall == 0) || (wallpaperMode == PLWallpaperModeHomeScreen && blurModeInterwall == 1)) {
		return BlurImage(image);
	} else if ((wallpaperMode == PLWallpaperModeLockScreen && blurModeInterwall == 0) || (wallpaperMode == PLWallpaperModeLockScreen && blurModeInterwall == 2)) {
		return BlurImage(image);
	} else {
		return image;
	}
}

static void SetWallpaperWithImage(UIImage *image, PLWallpaperMode wallpaperMode)
{
	PLStaticWallpaperImageViewController *wallpaperViewController = [[PLStaticWallpaperImageViewController alloc] initWithUIImage:image];
	wallpaperViewController.saveWallpaperData = YES;

	PLWallpaperMode wallpaperModeToSet = wallpaperMode;
	uintptr_t address = (uintptr_t)&wallpaperModeToSet;
	object_setInstanceVariable(wallpaperViewController, "_wallpaperMode", *(PLWallpaperMode **)address);

	[wallpaperViewController _savePhoto];
	[wallpaperViewController release];
}

static void ChangeWallpaperForMode(PLWallpaperMode wallpaperMode)
{
	if (wallpaperMode == PLWallpaperModeBoth) {
		[assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
			if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:albumNameHomescreenInterwall]) {
				[group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
					if (index == currentIndexHomeScreen) {
						ALAssetRepresentation *representation = [result defaultRepresentation];
						UIImage *image = [UIImage imageWithCGImage:[representation fullScreenImage]];

						if (blurEnabledInterwall) {
							SetWallpaperWithImage(GetBlurredImageFrom(image, PLWallpaperModeHomeScreen), PLWallpaperModeHomeScreen);
						} else {
							SetWallpaperWithImage(image, PLWallpaperModeHomeScreen);
						}

						if (shuffleInterwall) {
							currentIndexHomeScreen = arc4random_uniform([group numberOfAssets]);
						} else {
							currentIndexHomeScreen++;

							if (currentIndexHomeScreen == [group numberOfAssets]) {
								currentIndexHomeScreen = 0;
							}
						}

						*stop = YES;
					}
				}];
			}

			if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:albumNameLockscreenInterwall]) {
				[group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
					if (index == currentIndexLockScreen) {
						ALAssetRepresentation *representation = [result defaultRepresentation];
						UIImage *image = [UIImage imageWithCGImage:[representation fullScreenImage]];

						if (blurEnabledInterwall) {
							SetWallpaperWithImage(GetBlurredImageFrom(image, PLWallpaperModeLockScreen), PLWallpaperModeLockScreen);
						} else {
							SetWallpaperWithImage(image, PLWallpaperModeLockScreen);
						}

						if (shuffleInterwall) {
							currentIndexLockScreen = arc4random_uniform([group numberOfAssets]);
						} else {
							currentIndexLockScreen++;

							if (currentIndexLockScreen == [group numberOfAssets]) {
								currentIndexLockScreen = 0;
							}
						}

						*stop = YES;
					}
				}];
			}
		} failureBlock:^(NSError *error) {
			NSLog(@"\n\n [Wallmart] Following error occured: %@", [error description]);
		}];
	} else if (wallpaperMode == PLWallpaperModeHomeScreen) {
		[assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
			if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:albumNameHomescreenInterwall]) {
				[group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
					if (index == currentIndexHomeScreen) {
						ALAssetRepresentation *representation = [result defaultRepresentation];
						UIImage *image = [UIImage imageWithCGImage:[representation fullScreenImage]];

						if (blurEnabledInterwall) {
							SetWallpaperWithImage(GetBlurredImageFrom(image, wallpaperMode), wallpaperMode);
						} else {
							SetWallpaperWithImage(image, wallpaperMode);
						}

						if (shuffleInterwall) {
							currentIndexHomeScreen = arc4random_uniform([group numberOfAssets]);
						} else {
							currentIndexHomeScreen++;

							if (currentIndexHomeScreen == [group numberOfAssets]) {
								currentIndexHomeScreen = 0;
							}
						}

						*stop = YES;
					}
				}];
			}
		} failureBlock:^(NSError *error) {
			NSLog(@"\n\n [Wallmart] Following error occured: %@", [error description]);
		}];
	} else {
		[assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
			if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:albumNameLockscreenInterwall]) {
				[group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
					if (index == currentIndexLockScreen) {
						ALAssetRepresentation *representation = [result defaultRepresentation];
						UIImage *image = [UIImage imageWithCGImage:[representation fullScreenImage]];

						if (blurEnabledInterwall) {
							SetWallpaperWithImage(GetBlurredImageFrom(image, wallpaperMode), wallpaperMode);
						} else {
							SetWallpaperWithImage(image, wallpaperMode);
						}

						if (shuffleInterwall) {
							currentIndexLockScreen = arc4random_uniform([group numberOfAssets]);
						} else {
							currentIndexLockScreen++;

							if (currentIndexLockScreen == [group numberOfAssets]) {
								currentIndexLockScreen = 0;
							}
						}

						*stop = YES;
					}
				}];
			}
		} failureBlock:^(NSError *error) {
			NSLog(@"\n\n [Wallmart] Following error occured: %@", [error description]);
		}];
	}
}

%hook SpringBoard

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	%orig;

	if (wallmartGeneralEnabled && interwallEnabled) {
		[self configureTimer];
	}
}

%new - (void)configureTimer
{
	persistentTimer = [[PCPersistentTimer alloc] initWithFireDate:[[NSDate date] dateByAddingTimeInterval:interwallTime] serviceIdentifier:@"com.shinvou.wallmartinterwall" target:self selector:@selector(updateWallpaper) userInfo:nil];
	[persistentTimer scheduleInRunLoop:[NSRunLoop mainRunLoop]];
}

%new - (void)updateWallpaper
{
	if (wallmartGeneralEnabled && interwallEnabled) {
		if (unlockedOnce) {
			ChangeWallpaperForMode(wallpaperModeInterwall);
		}

		[self configureTimer];
	}
}

%end

%hook SBLockScreenManager

- (void)_finishUIUnlockFromSource:(int)source withOptions:(id)options
{
	%orig;

	if (!unlockedOnce) {
		unlockedOnce = YES;
		assetsLibrary = [[ALAssetsLibrary alloc] init];
	}
}

%end

%hook PLStaticWallpaperImageViewController

- (void)providerLegibilitySettingsChanged:(SBSUIWallpaperPreviewViewController *)wallpaperPreviewViewController
{
	[wallpaperPreviewViewController setMotionEnabled:perspectiveZoomInterwall];

	%orig(wallpaperPreviewViewController);
}

%end

%hook SBStatusBarStateAggregator

- (void)_updateTimeItems
{
	%orig;

	if (wallmartGeneralEnabled && interwallMomentsEnabled) {
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setDateFormat:@"HH:mm"];

		NSString *currentTimeString = [dateFormatter stringFromDate:[NSDate date]];

		for (int i = 0; i < moments.count; i++) {
			if ([moments[i] isEqualToString:currentTimeString]) {
				[self updateWallpaper];
				[moments removeObjectAtIndex:i];
			}
		}
	}
}

%new - (void)updateWallpaper
{
	if (wallmartGeneralEnabled && interwallMomentsEnabled) {
		if (unlockedOnce) {
			if (wallpaperModeInterwall == PLWallpaperModeBoth) {
				ChangeWallpaperForMode(PLWallpaperModeHomeScreen);
				ChangeWallpaperForMode(PLWallpaperModeLockScreen);
			} else {
				if (wallpaperModeInterwall == PLWallpaperModeHomeScreen) {
					ChangeWallpaperForMode(PLWallpaperModeHomeScreen);
				} else {
					ChangeWallpaperForMode(PLWallpaperModeLockScreen);
				}
			}
		}
	}
}

%end

static void ReloadSettings()
{
	NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];

	if (settings) {
		if ([settings objectForKey:@"interwallEnabled"]) {
			if ([[settings objectForKey:@"interwallEnabled"] boolValue] != interwallEnabled) {
				interwallEnabled = [[settings objectForKey:@"interwallEnabled"] boolValue];

				[persistentTimer invalidate];
				[(SpringBoard *)[UIApplication sharedApplication] configureTimer];
			}
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

		if ([settings objectForKey:@"interwallMomentsEnabled"]) {
			interwallMomentsEnabled = [[settings objectForKey:@"interwallMomentsEnabled"] boolValue];
		}

		if ([settings objectForKey:@"moments"]) {
			moments = [[settings objectForKey:@"moments"] mutableCopy];
		}

		if ([settings objectForKey:@"wallpaperModeInterwall"]) {
			wallpaperModeInterwall = [[settings objectForKey:@"wallpaperModeInterwall"] intValue];
		}

		if ([settings objectForKey:@"blurEnabledInterwall"]) {
			blurEnabledInterwall = [[settings objectForKey:@"blurEnabledInterwall"] boolValue];
		}

		if ([settings objectForKey:@"blurStrengthInterwall"]) {
			blurStrengthInterwall = [[settings objectForKey:@"blurStrengthInterwall"] intValue];
		}

		if ([settings objectForKey:@"blurModeInterwall"]) {
			blurModeInterwall = [[settings objectForKey:@"blurModeInterwall"] intValue];
		}

		if ([settings objectForKey:@"perspectiveZoomInterwall"]) {
			perspectiveZoomInterwall = [[settings objectForKey:@"perspectiveZoomInterwall"] boolValue];
		}

		if ([settings objectForKey:@"shuffleInterwall"]) {
			shuffleInterwall = [[settings objectForKey:@"shuffleInterwall"] boolValue];
		}

		if ([settings objectForKey:@"albumNameLockscreenInterwall"]) {
			if (unlockedOnce && ![[settings objectForKey:@"albumNameLockscreenInterwall"] isEqualToString:albumNameLockscreenInterwall]) {
				currentIndexHomeScreen = 0;
				currentIndexLockScreen = 0;
			}

			albumNameLockscreenInterwall = [[settings objectForKey:@"albumNameLockscreenInterwall"] mutableCopy];
		}

		if ([settings objectForKey:@"albumNameHomescreenInterwall"]) {
			if (unlockedOnce && ![[settings objectForKey:@"albumNameHomescreenInterwall"] isEqualToString:albumNameHomescreenInterwall]) {
				currentIndexHomeScreen = 0;
				currentIndexLockScreen = 0;
			}

			albumNameHomescreenInterwall = [[settings objectForKey:@"albumNameHomescreenInterwall"] mutableCopy];
		}
	}

	[settings release];
}

%ctor {
	@autoreleasepool {
		[[NSNotificationCenter defaultCenter] addObserverForName:NSCalendarDayChangedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
			NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];

			if ([settings objectForKey:@"moments"]) {
				moments = [[settings objectForKey:@"moments"] mutableCopy];
			}

			[settings release];
		}];

		ReloadSettings();
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)ReloadSettings, CFSTR("com.shinvou.wallmart/reloadInterwallSettings"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	}
}
