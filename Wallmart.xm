//
//  Wallmart.xm
//  Wallmart
//
//  Created by Timm Kandziora on 16.01.15.
//  Copyright (c) 2015 Timm Kandziora. All rights reserved.
//

#import "WallmartHeader.h"

/* HELPER VARIABLES, TWEAK ONLY */

static BOOL unlockedOnce = NO;
static ALAssetsLibrary *assetsLibrary;
static int currentIndexHomeScreen = 0;
static int currentIndexLockScreen = 0;

/* INFORMATION FROM SETTINGS */

static BOOL wallmartGeneralEnabled = YES;

static BOOL wallmartEnabled = YES;
static int wallpaperModeWallmart = 0;

static BOOL blurEnabledWallmart = NO;
static int blurStrengthWallmart = 5;
static int blurModeWallmart = 0;

static BOOL perspectiveZoomWallmart = YES;
static BOOL shuffleWallmart = NO;

static BOOL cycleEnabledWallmart = NO;
static NSString *cycleStartTime = @"10:00";
static NSString *cycleEndTime = @"20:00";

static NSString *albumNameLockscreenWallmart;
static NSString *albumNameHomescreenWallmart;

static UIImage* BlurImage(UIImage *image)
{
	CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
	[gaussianBlurFilter setDefaults];
	[gaussianBlurFilter setValue:[CIImage imageWithCGImage:image.CGImage] forKey:kCIInputImageKey];
	[gaussianBlurFilter setValue:@(blurStrengthWallmart) forKey:kCIInputRadiusKey];

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
	if ((wallpaperMode == PLWallpaperModeHomeScreen && blurModeWallmart == 0) || (wallpaperMode == PLWallpaperModeHomeScreen && blurModeWallmart == 1)) {
		return BlurImage(image);
	} else if ((wallpaperMode == PLWallpaperModeLockScreen && blurModeWallmart == 0) || (wallpaperMode == PLWallpaperModeLockScreen && blurModeWallmart == 2)) {
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
			if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:albumNameHomescreenWallmart]) {
				[group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
					if (index == currentIndexHomeScreen) {
						ALAssetRepresentation *representation = [result defaultRepresentation];
						UIImage *image = [UIImage imageWithCGImage:[representation fullScreenImage]];

						if (blurEnabledWallmart) {
							SetWallpaperWithImage(GetBlurredImageFrom(image, PLWallpaperModeHomeScreen), PLWallpaperModeHomeScreen);
						} else {
							SetWallpaperWithImage(image, PLWallpaperModeHomeScreen);
						}

						if (shuffleWallmart) {
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

			if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:albumNameLockscreenWallmart]) {
				[group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
					if (index == currentIndexLockScreen) {
						ALAssetRepresentation *representation = [result defaultRepresentation];
						UIImage *image = [UIImage imageWithCGImage:[representation fullScreenImage]];

						if (blurEnabledWallmart) {
							SetWallpaperWithImage(GetBlurredImageFrom(image, PLWallpaperModeLockScreen), PLWallpaperModeLockScreen);
						} else {
							SetWallpaperWithImage(image, PLWallpaperModeLockScreen);
						}

						if (shuffleWallmart) {
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
			if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:albumNameHomescreenWallmart]) {
				[group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
					if (index == currentIndexHomeScreen) {
						ALAssetRepresentation *representation = [result defaultRepresentation];
						UIImage *image = [UIImage imageWithCGImage:[representation fullScreenImage]];

						if (blurEnabledWallmart) {
							SetWallpaperWithImage(GetBlurredImageFrom(image, wallpaperMode), wallpaperMode);
						} else {
							SetWallpaperWithImage(image, wallpaperMode);
						}

						if (shuffleWallmart) {
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
			if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:albumNameLockscreenWallmart]) {
				[group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
					if (index == currentIndexLockScreen) {
						ALAssetRepresentation *representation = [result defaultRepresentation];
						UIImage *image = [UIImage imageWithCGImage:[representation fullScreenImage]];

						if (blurEnabledWallmart) {
							SetWallpaperWithImage(GetBlurredImageFrom(image, wallpaperMode), wallpaperMode);
						} else {
							SetWallpaperWithImage(image, wallpaperMode);
						}

						if (shuffleWallmart) {
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

static BOOL CurrentTimeIsLaterThan(NSString *timeToCompareString)
{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"HH:mm"];

	NSString *currentTimeString = [dateFormatter stringFromDate:[NSDate date]];
	NSDate *currentTime= [dateFormatter dateFromString:currentTimeString];
	NSDate *timeToCompare = [dateFormatter dateFromString:timeToCompareString];

	NSComparisonResult result = [currentTime compare:timeToCompare];

	if (result == NSOrderedDescending) {
		return YES;
	} else if (result == NSOrderedAscending) {
		return NO;
	} else {
		return MAYBE;
	}
}

%hook SBLockScreenManager

- (void)lockUIFromSource:(int)source withOptions:(id)options
{
	%orig;

	if (unlockedOnce && wallmartGeneralEnabled && wallmartEnabled) {
		if (cycleEnabledWallmart) {
			if (CurrentTimeIsLaterThan(cycleStartTime) && !CurrentTimeIsLaterThan(cycleEndTime)) {
				goto CHANGE;
			} else {
				return;
			}
		}

		CHANGE:
		ChangeWallpaperForMode(wallpaperModeWallmart);
	}
}

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
	[wallpaperPreviewViewController setMotionEnabled:perspectiveZoomWallmart];

	%orig(wallpaperPreviewViewController);
}

%end

static void ReloadSettings()
{
	NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];

	if (settings) {
		if ([settings objectForKey:@"wallmartGeneralEnabled"]) {
			wallmartGeneralEnabled = [[settings objectForKey:@"wallmartGeneralEnabled"] boolValue];
		}

		if ([settings objectForKey:@"wallmartEnabled"]) {
			wallmartEnabled = [[settings objectForKey:@"wallmartEnabled"] boolValue];
		}

		if ([settings objectForKey:@"wallpaperModeWallmart"]) {
			wallpaperModeWallmart = [[settings objectForKey:@"wallpaperModeWallmart"] intValue];
		}

		if ([settings objectForKey:@"blurEnabledWallmart"]) {
			blurEnabledWallmart = [[settings objectForKey:@"blurEnabledWallmart"] boolValue];
		}

		if ([settings objectForKey:@"blurStrengthWallmart"]) {
			blurStrengthWallmart = [[settings objectForKey:@"blurStrengthWallmart"] intValue];
		}

		if ([settings objectForKey:@"blurModeWallmart"]) {
			blurModeWallmart = [[settings objectForKey:@"blurModeWallmart"] intValue];
		}

		if ([settings objectForKey:@"perspectiveZoomWallmart"]) {
			perspectiveZoomWallmart = [[settings objectForKey:@"perspectiveZoomWallmart"] boolValue];
		}

		if ([settings objectForKey:@"shuffleWallmart"]) {
			shuffleWallmart = [[settings objectForKey:@"shuffleWallmart"] boolValue];
		}

		if ([settings objectForKey:@"cycleEnabledWallmart"]) {
			cycleEnabledWallmart = [[settings objectForKey:@"cycleEnabledWallmart"] boolValue];
		}

		if ([settings objectForKey:@"cycleStartTime"]) {
			cycleStartTime = [[settings objectForKey:@"cycleStartTime"] mutableCopy];
		}

		if ([settings objectForKey:@"cycleEndTime"]) {
			cycleEndTime = [[settings objectForKey:@"cycleEndTime"] mutableCopy];
		}

		if ([settings objectForKey:@"albumNameLockscreenWallmart"]) {
			if (unlockedOnce && ![[settings objectForKey:@"albumNameLockscreenWallmart"] isEqualToString:albumNameLockscreenWallmart]) {
				currentIndexHomeScreen = 0;
				currentIndexLockScreen = 0;
			}

			albumNameLockscreenWallmart = [[settings objectForKey:@"albumNameLockscreenWallmart"] mutableCopy];
		}

		if ([settings objectForKey:@"albumNameHomescreenWallmart"]) {
			if (unlockedOnce && ![[settings objectForKey:@"albumNameHomescreenWallmart"] isEqualToString:albumNameHomescreenWallmart]) {
				currentIndexHomeScreen = 0;
				currentIndexLockScreen = 0;
			}

			albumNameHomescreenWallmart = [[settings objectForKey:@"albumNameHomescreenWallmart"] mutableCopy];
		}
	}

	[settings release];
}

%ctor {
	@autoreleasepool {
		ReloadSettings();
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)ReloadSettings, CFSTR("com.shinvou.wallmart/reloadWallmartSettings"), NULL, CFNotificationSuspensionBehaviorCoalesce);

		[[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"WallmartEventSwitchBothWallpapers" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
			if (unlockedOnce) {
				ChangeWallpaperForMode(PLWallpaperModeBoth);
			}
		}];

		[[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"WallmartEventSwitchLockScreenWallpaper" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
			if (unlockedOnce) {
				ChangeWallpaperForMode(PLWallpaperModeLockScreen);
			}
		}];

		[[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"WallmartEventSwitchHomeScreenWallpaper" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
			if (unlockedOnce) {
				if (unlockedOnce) {
					ChangeWallpaperForMode(PLWallpaperModeHomeScreen);
				}
			}
		}];

		[[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"WallmartEventToggleWallmartEnabled" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
			NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
			[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:settingsPath]];

			[settings setObject:@(!wallmartEnabled) forKey:@"wallmartEnabled"];
			[settings writeToFile:settingsPath atomically:YES];

			wallmartEnabled = !wallmartEnabled;
		}];
	}
}
