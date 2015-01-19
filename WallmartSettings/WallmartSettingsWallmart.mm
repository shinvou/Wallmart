#import "WallmartSettingsWallmartBlur.mm"
#import "WallmartSettingsWallmartCycle.mm"

#import <Preferences/Preferences.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define settingsPath @"/var/mobile/Library/Preferences/com.shinvou.wallmart.plist"

@interface WallmartSettingsWallmartListController : PSListController
@end

@implementation WallmartSettingsWallmartListController

- (id)specifiers
{
    if (_specifiers == nil) {
        [self setTitle:@"Wallmart"];
        
        PSSpecifier *firstGroup = [PSSpecifier groupSpecifierWithName:nil];
        
        PSSpecifier *wallmartEnabled = [PSSpecifier preferenceSpecifierNamed:@"Enabled"
                                                                      target:self
                                                                         set:@selector(setValue:forSpecifier:)
                                                                         get:@selector(getValueForSpecifier:)
                                                                      detail:Nil
                                                                        cell:PSSwitchCell
                                                                        edit:Nil];
        [wallmartEnabled setIdentifier:@"wallmartEnabled"];
        [wallmartEnabled setProperty:@(YES) forKey:@"enabled"];
        
        PSSpecifier *secondGroup = [PSSpecifier groupSpecifierWithName:@"A priori"];
        
        PSSpecifier *wallpaperModeWallmart = [PSSpecifier preferenceSpecifierNamed:@"Mode"
                                                                            target:self
                                                                               set:@selector(setValue:forSpecifier:)
                                                                               get:@selector(getValueForSpecifier:)
                                                                            detail:[PSListItemsController class]
                                                                              cell:PSLinkListCell
                                                                              edit:Nil];
        [wallpaperModeWallmart setIdentifier:@"wallpaperModeWallmart"];
        [wallpaperModeWallmart setProperty:@(YES) forKey:@"enabled"];
        [wallpaperModeWallmart setValues:@[@(0), @(2), @(1)]
                                  titles:@[@"Lockscreen and homescreen", @"Lockscreen only", @"Homescreen only"]
                             shortTitles:@[@"Lockscreen and homescreen", @"Lockscreen only", @"Homescreen only"]];
        
        PSSpecifier *blurSettingsWallmart = [PSSpecifier preferenceSpecifierNamed:nil
                                                                           target:self
                                                                              set:NULL
                                                                              get:NULL
                                                                           detail:[WallmartSettingsWallmartBlurListController class]
                                                                             cell:PSLinkCell
                                                                             edit:Nil];
        blurSettingsWallmart.name = @"Blur settings";
        [blurSettingsWallmart setIdentifier:@"blurSettingsWallmart"];
        [blurSettingsWallmart setProperty:@(YES) forKey:@"enabled"];
        
        PSSpecifier *perspectiveZoomWallmart = [PSSpecifier preferenceSpecifierNamed:@"Perspective zoom"
                                                                              target:self
                                                                                 set:@selector(setValue:forSpecifier:)
                                                                                 get:@selector(getValueForSpecifier:)
                                                                              detail:Nil
                                                                                cell:PSSwitchCell
                                                                                edit:Nil];
        [perspectiveZoomWallmart setIdentifier:@"perspectiveZoomWallmart"];
        [perspectiveZoomWallmart setProperty:@(YES) forKey:@"enabled"];
        
        PSSpecifier *shuffleWallmart = [PSSpecifier preferenceSpecifierNamed:@"Shuffle wallpapers"
                                                                      target:self
                                                                         set:@selector(setValue:forSpecifier:)
                                                                         get:@selector(getValueForSpecifier:)
                                                                      detail:Nil
                                                                        cell:PSSwitchCell
                                                                        edit:Nil];
        [shuffleWallmart setIdentifier:@"shuffleWallmart"];
        [shuffleWallmart setProperty:@(YES) forKey:@"enabled"];
        
        PSSpecifier *thirdGroup = [PSSpecifier groupSpecifierWithName:nil];
        
        PSSpecifier *cycleSettingsWallmart = [PSSpecifier preferenceSpecifierNamed:nil
                                                                            target:self
                                                                               set:NULL
                                                                               get:NULL
                                                                            detail:[WallmartSettingsWallmartCycleListController class]
                                                                              cell:PSLinkCell
                                                                              edit:Nil];
        cycleSettingsWallmart.name = @"Cycle settings";
        [cycleSettingsWallmart setIdentifier:@"cycleSettingsWallmart"];
        [cycleSettingsWallmart setProperty:@(YES) forKey:@"enabled"];
        
        PSSpecifier *fourthGroup = [PSSpecifier groupSpecifierWithName:@"Photo albums"];
        [fourthGroup setIdentifier:@"fourthGroup"];
        [self doPhotoAlbumStuff];
        
        _specifiers = [NSArray arrayWithObjects:firstGroup, wallmartEnabled, secondGroup, wallpaperModeWallmart, blurSettingsWallmart, perspectiveZoomWallmart, shuffleWallmart, thirdGroup, cycleSettingsWallmart, fourthGroup, nil];
    }
    
    return _specifiers;
}

- (id)getValueForSpecifier:(PSSpecifier *)specifier
{
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
    
    if ([specifier.identifier isEqualToString:@"wallmartEnabled"]) {
        if (settings) {
            if ([settings objectForKey:@"wallmartEnabled"]) {
                return [settings objectForKey:@"wallmartEnabled"];
            } else {
                return @(YES);
            }
        } else {
            return @(YES);
        }
    } else if ([specifier.identifier isEqualToString:@"wallpaperModeWallmart"]) {
        if (settings) {
            if ([settings objectForKey:@"wallpaperModeWallmart"]) {
                return [settings objectForKey:@"wallpaperModeWallmart"];
            } else {
                return @(0);
            }
        } else {
            return @(0);
        }
    } else if ([specifier.identifier isEqualToString:@"perspectiveZoomWallmart"]) {
        if (settings) {
            if ([settings objectForKey:@"perspectiveZoomWallmart"]) {
                return [settings objectForKey:@"perspectiveZoomWallmart"];
            } else {
                return @(YES);
            }
        } else {
            return @(YES);
        }
    } else if ([specifier.identifier isEqualToString:@"shuffleWallmart"]) {
        if (settings) {
            if ([settings objectForKey:@"shuffleWallmart"]) {
                return [settings objectForKey:@"shuffleWallmart"];
            } else {
                return @(NO);
            }
        } else {
            return @(NO);
        }
    } else if ([specifier.identifier isEqualToString:@"albumNamesLockscreenWallmart"]) {
        if (settings) {
            if ([settings objectForKey:@"albumNameLockscreenWallmart"]) {
                return [settings objectForKey:@"albumNameLockscreenWallmart"];
            } else {
                return nil;
            }
        } else {
            return nil;
        }
    } else if ([specifier.identifier isEqualToString:@"albumNamesHomescreenWallmart"]) {
        if (settings) {
            if ([settings objectForKey:@"albumNameHomescreenWallmart"]) {
                return [settings objectForKey:@"albumNameHomescreenWallmart"];
            } else {
                return nil;
            }
        } else {
            return nil;
        }
    }
    
    return nil;
}

- (void)setValue:(id)value forSpecifier:(PSSpecifier *)specifier
{
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    [settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:settingsPath]];
    
    if ([specifier.identifier isEqualToString:@"wallmartEnabled"]) {
        [settings setObject:value forKey:@"wallmartEnabled"];
        [settings writeToFile:settingsPath atomically:YES];
    } else if ([specifier.identifier isEqualToString:@"wallpaperModeWallmart"]) {
        [settings setObject:value forKey:@"wallpaperModeWallmart"];
        [settings writeToFile:settingsPath atomically:YES];
    } else if ([specifier.identifier isEqualToString:@"perspectiveZoomWallmart"]) {
        [settings setObject:value forKey:@"perspectiveZoomWallmart"];
        [settings writeToFile:settingsPath atomically:YES];
    } else if ([specifier.identifier isEqualToString:@"shuffleWallmart"]) {
        [settings setObject:value forKey:@"shuffleWallmart"];
        [settings writeToFile:settingsPath atomically:YES];
    } else if ([specifier.identifier isEqualToString:@"albumNamesLockscreenWallmart"]) {
        [settings setObject:value forKey:@"albumNameLockscreenWallmart"];
        [settings writeToFile:settingsPath atomically:YES];
    } else if ([specifier.identifier isEqualToString:@"albumNamesHomescreenWallmart"]) {
        [settings setObject:value forKey:@"albumNameHomescreenWallmart"];
        [settings writeToFile:settingsPath atomically:YES];
    }
    
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.shinvou.wallmart/reloadWallmartSettings"), NULL, NULL, TRUE);
}

- (void)doPhotoAlbumStuff
{
    NSMutableArray *albumNames = [[NSMutableArray alloc] init];
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if ([group valueForProperty:ALAssetsGroupPropertyName]) {
            [albumNames insertObject:[group valueForProperty:ALAssetsGroupPropertyName] atIndex:0];
        } else {
            PSSpecifier *albumNamesLockscreenWallmart = [PSSpecifier preferenceSpecifierNamed:@"Lockscreen"
                                                                                       target:self
                                                                                          set:@selector(setValue:forSpecifier:)
                                                                                          get:@selector(getValueForSpecifier:)
                                                                                       detail:[PSListItemsController class]
                                                                                         cell:PSLinkListCell
                                                                                         edit:Nil];
            [albumNamesLockscreenWallmart setIdentifier:@"albumNamesLockscreenWallmart"];
            [albumNamesLockscreenWallmart setProperty:@(YES) forKey:@"enabled"];
            [albumNamesLockscreenWallmart setValues:albumNames
                                             titles:albumNames
                                        shortTitles:albumNames];
            
            [self insertSpecifier:albumNamesLockscreenWallmart afterSpecifierID:@"fourthGroup" animated:NO];
            
            PSSpecifier *albumNamesHomescreenWallmart = [PSSpecifier preferenceSpecifierNamed:@"Homescreen"
                                                                                       target:self
                                                                                          set:@selector(setValue:forSpecifier:)
                                                                                          get:@selector(getValueForSpecifier:)
                                                                                       detail:[PSListItemsController class]
                                                                                         cell:PSLinkListCell
                                                                                         edit:Nil];
            [albumNamesHomescreenWallmart setIdentifier:@"albumNamesHomescreenWallmart"];
            [albumNamesHomescreenWallmart setProperty:@(YES) forKey:@"enabled"];
            [albumNamesHomescreenWallmart setValues:albumNames
                                             titles:albumNames
                                        shortTitles:albumNames];
            
            [self insertSpecifier:albumNamesHomescreenWallmart afterSpecifierID:@"albumNamesLockscreenWallmart" animated:NO];
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"\n\n [Wallmart Settings] Following error occured: %@", [error description]);
    }];
}

@end
