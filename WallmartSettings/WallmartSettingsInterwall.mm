#import "WallmartSettingsInterwallMoments.mm"
#import "WallmartSettingsInterwallBlur.mm"

#import <Preferences/Preferences.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define settingsPath @"/var/mobile/Library/Preferences/com.shinvou.wallmart.plist"

@interface WallmartSettingsInterwallListController : PSListController
@end

@implementation WallmartSettingsInterwallListController

- (id)specifiers
{
    if (_specifiers == nil) {
        [self setTitle:@"Interwall and moments"];

        PSSpecifier *firstGroup = [PSSpecifier groupSpecifierWithName:@"Interwall"];
        [firstGroup setProperty:@"Default interval is 60 seconds.\n\n'Interwall' is used for time periods." forKey:@"footerText"];

        PSSpecifier *interwallEnabled = [PSSpecifier preferenceSpecifierNamed:@"Interwall enabled"
                                                                       target:self
                                                                          set:@selector(setValue:forSpecifier:)
                                                                          get:@selector(getValueForSpecifier:)
                                                                       detail:Nil
                                                                         cell:PSSwitchCell
                                                                         edit:Nil];
        [interwallEnabled setIdentifier:@"interwallEnabled"];
        [interwallEnabled setProperty:@(YES) forKey:@"enabled"];

        PSTextFieldSpecifier *interwallTime = [PSTextFieldSpecifier preferenceSpecifierNamed:nil
                                                                                      target:self
                                                                                         set:@selector(setValue:forSpecifier:)
                                                                                         get:@selector(getValueForSpecifier:)
                                                                                      detail:Nil
                                                                                        cell:PSEditTextCell
                                                                                        edit:Nil];
        [interwallTime setPlaceholder:@"Enter interval in seconds ..."];
        [interwallTime setIdentifier:@"interwallTime"];
        [interwallTime setProperty:@(YES) forKey:@"enabled"];

        PSSpecifier *secondGroup = [PSSpecifier groupSpecifierWithName:@"Moments"];
        [secondGroup setProperty:@"'Moments' is used for specific moments in time." forKey:@"footerText"];

        PSSpecifier *interwallMomentsEnabled = [PSSpecifier preferenceSpecifierNamed:@"Moments enabled"
                                                                              target:self
                                                                                 set:@selector(setValue:forSpecifier:)
                                                                                 get:@selector(getValueForSpecifier:)
                                                                              detail:Nil
                                                                                cell:PSSwitchCell
                                                                                edit:Nil];
        [interwallMomentsEnabled setIdentifier:@"interwallMomentsEnabled"];
        [interwallMomentsEnabled setProperty:@(YES) forKey:@"enabled"];

        PSSpecifier *interwallMoments = [PSSpecifier preferenceSpecifierNamed:nil
                                                                       target:self
                                                                          set:NULL
                                                                          get:NULL
                                                                       detail:[WallmartSettingsInterwallMomentsListController class]
                                                                         cell:PSLinkCell
                                                                         edit:Nil];
        interwallMoments.name = @"Set moments";
        [interwallMoments setIdentifier:@"interwallMoments"];
        [interwallMoments setProperty:@(YES) forKey:@"enabled"];

        PSSpecifier *thirdGroup = [PSSpecifier groupSpecifierWithName:@"A priori"];

        PSSpecifier *wallpaperModeInterwall = [PSSpecifier preferenceSpecifierNamed:@"Mode"
                                                                             target:self
                                                                                set:@selector(setValue:forSpecifier:)
                                                                                get:@selector(getValueForSpecifier:)
                                                                             detail:[PSListItemsController class]
                                                                               cell:PSLinkListCell
                                                                               edit:Nil];
        [wallpaperModeInterwall setIdentifier:@"wallpaperModeInterwall"];
        [wallpaperModeInterwall setProperty:@(YES) forKey:@"enabled"];
        [wallpaperModeInterwall setValues:@[@(0), @(2), @(1)]
                                   titles:@[@"Lockscreen and homescreen", @"Lockscreen only", @"Homescreen only"]
                              shortTitles:@[@"Lockscreen and homescreen", @"Lockscreen only", @"Homescreen only"]];

        PSSpecifier *blurSettingsInterwall = [PSSpecifier preferenceSpecifierNamed:nil
                                                                            target:self
                                                                               set:NULL
                                                                               get:NULL
                                                                            detail:[WallmartSettingsInterwallBlurListController class]
                                                                              cell:PSLinkCell
                                                                              edit:Nil];
        blurSettingsInterwall.name = @"Blur settings";
        [blurSettingsInterwall setIdentifier:@"blurSettingsInterwall"];
        [blurSettingsInterwall setProperty:@(YES) forKey:@"enabled"];

        PSSpecifier *perspectiveZoomInterwall = [PSSpecifier preferenceSpecifierNamed:@"Perspective zoom"
                                                                               target:self
                                                                                  set:@selector(setValue:forSpecifier:)
                                                                                  get:@selector(getValueForSpecifier:)
                                                                               detail:Nil
                                                                                 cell:PSSwitchCell
                                                                                 edit:Nil];
        [perspectiveZoomInterwall setIdentifier:@"perspectiveZoomInterwall"];
        [perspectiveZoomInterwall setProperty:@(YES) forKey:@"enabled"];

        PSSpecifier *shuffleInterwall = [PSSpecifier preferenceSpecifierNamed:@"Shuffle wallpapers"
                                                                       target:self
                                                                          set:@selector(setValue:forSpecifier:)
                                                                          get:@selector(getValueForSpecifier:)
                                                                       detail:Nil
                                                                         cell:PSSwitchCell
                                                                         edit:Nil];
        [shuffleInterwall setIdentifier:@"shuffleInterwall"];
        [shuffleInterwall setProperty:@(YES) forKey:@"enabled"];

        PSSpecifier *fourthGroup = [PSSpecifier groupSpecifierWithName:@"Photo albums"];
        [fourthGroup setIdentifier:@"fourthGroup"];
        [self doPhotoAlbumStuff];

        _specifiers = [NSArray arrayWithObjects:firstGroup, interwallEnabled, interwallTime, secondGroup, interwallMomentsEnabled, interwallMoments, thirdGroup, wallpaperModeInterwall, blurSettingsInterwall, perspectiveZoomInterwall, shuffleInterwall, fourthGroup, nil];
    }

    return _specifiers;
}

- (id)getValueForSpecifier:(PSSpecifier *)specifier
{
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];

    if ([specifier.identifier isEqualToString:@"interwallEnabled"]) {
        if (settings) {
            if ([settings objectForKey:@"interwallEnabled"]) {
                return [settings objectForKey:@"interwallEnabled"];
            } else {
                return @(NO);
            }
        } else {
            return @(NO);
        }
    } else if ([specifier.identifier isEqualToString:@"interwallTime"]) {
        if (settings) {
            if ([settings objectForKey:@"interwallTime"]) {
                return [settings objectForKey:@"interwallTime"];
            } else {
                return nil;
            }
        } else {
            return nil;
        }
    } else if ([specifier.identifier isEqualToString:@"interwallMomentsEnabled"]) {
        if (settings) {
            if ([settings objectForKey:@"interwallMomentsEnabled"]) {
                return [settings objectForKey:@"interwallMomentsEnabled"];
            } else {
                return @(NO);
            }
        } else {
            return @(NO);
        }
    } else if ([specifier.identifier isEqualToString:@"wallpaperModeInterwall"]) {
        if (settings) {
            if ([settings objectForKey:@"wallpaperModeInterwall"]) {
                return [settings objectForKey:@"wallpaperModeInterwall"];
            } else {
                return @(0);
            }
        } else {
            return @(0);
        }
    } else if ([specifier.identifier isEqualToString:@"perspectiveZoomInterwall"]) {
        if (settings) {
            if ([settings objectForKey:@"perspectiveZoomInterwall"]) {
                return [settings objectForKey:@"perspectiveZoomInterwall"];
            } else {
                return @(YES);
            }
        } else {
            return @(YES);
        }
    } else if ([specifier.identifier isEqualToString:@"shuffleInterwall"]) {
        if (settings) {
            if ([settings objectForKey:@"shuffleInterwall"]) {
                return [settings objectForKey:@"shuffleInterwall"];
            } else {
                return @(NO);
            }
        } else {
            return @(NO);
        }
    } else if ([specifier.identifier isEqualToString:@"albumNamesLockscreenInterwall"]) {
        if (settings) {
            if ([settings objectForKey:@"albumNameLockscreenInterwall"]) {
                return [settings objectForKey:@"albumNameLockscreenInterwall"];
            } else {
                return nil;
            }
        } else {
            return nil;
        }
    } else if ([specifier.identifier isEqualToString:@"albumNamesHomescreenInterwall"]) {
        if (settings) {
            if ([settings objectForKey:@"albumNameHomescreenInterwall"]) {
                return [settings objectForKey:@"albumNameHomescreenInterwall"];
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

    if ([specifier.identifier isEqualToString:@"interwallEnabled"]) {
        [settings setObject:value forKey:@"interwallEnabled"];
        [settings writeToFile:settingsPath atomically:YES];
    } else if ([specifier.identifier isEqualToString:@"interwallTime"]) {
        [settings setObject:value forKey:@"interwallTime"];
        [settings writeToFile:settingsPath atomically:YES];
    } else if ([specifier.identifier isEqualToString:@"interwallMomentsEnabled"]) {
        [settings setObject:value forKey:@"interwallMomentsEnabled"];
        [settings writeToFile:settingsPath atomically:YES];
    } else if ([specifier.identifier isEqualToString:@"wallpaperModeInterwall"]) {
        [settings setObject:value forKey:@"wallpaperModeInterwall"];
        [settings writeToFile:settingsPath atomically:YES];
    } else if ([specifier.identifier isEqualToString:@"perspectiveZoomInterwall"]) {
        [settings setObject:value forKey:@"perspectiveZoomInterwall"];
        [settings writeToFile:settingsPath atomically:YES];
    } else if ([specifier.identifier isEqualToString:@"shuffleInterwall"]) {
        [settings setObject:value forKey:@"shuffleInterwall"];
        [settings writeToFile:settingsPath atomically:YES];
    } else if ([specifier.identifier isEqualToString:@"albumNamesLockscreenInterwall"]) {
        [settings setObject:value forKey:@"albumNameLockscreenInterwall"];
        [settings writeToFile:settingsPath atomically:YES];
    } else if ([specifier.identifier isEqualToString:@"albumNamesHomescreenInterwall"]) {
        [settings setObject:value forKey:@"albumNameHomescreenInterwall"];
        [settings writeToFile:settingsPath atomically:YES];
    }

    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.shinvou.wallmart/reloadInterwallSettings"), NULL, NULL, TRUE);
}

- (void)doPhotoAlbumStuff
{
    NSMutableArray *albumNames = [[NSMutableArray alloc] init];

    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];

    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if ([group valueForProperty:ALAssetsGroupPropertyName]) {
            [albumNames insertObject:[group valueForProperty:ALAssetsGroupPropertyName] atIndex:0];
        } else {
            PSSpecifier *albumNamesLockscreenInterwall = [PSSpecifier preferenceSpecifierNamed:@"Lockscreen"
                                                                                        target:self
                                                                                           set:@selector(setValue:forSpecifier:)
                                                                                           get:@selector(getValueForSpecifier:)
                                                                                        detail:[PSListItemsController class]
                                                                                          cell:PSLinkListCell
                                                                                          edit:Nil];
            [albumNamesLockscreenInterwall setIdentifier:@"albumNamesLockscreenInterwall"];
            [albumNamesLockscreenInterwall setProperty:@(YES) forKey:@"enabled"];
            [albumNamesLockscreenInterwall setValues:albumNames
                                              titles:albumNames
                                         shortTitles:albumNames];

            [self insertSpecifier:albumNamesLockscreenInterwall afterSpecifierID:@"fourthGroup" animated:NO];

            PSSpecifier *albumNamesHomescreenInterwall = [PSSpecifier preferenceSpecifierNamed:@"Homescreen"
                                                                                        target:self
                                                                                           set:@selector(setValue:forSpecifier:)
                                                                                           get:@selector(getValueForSpecifier:)
                                                                                        detail:[PSListItemsController class]
                                                                                          cell:PSLinkListCell
                                                                                          edit:Nil];
            [albumNamesHomescreenInterwall setIdentifier:@"albumNamesHomescreenInterwall"];
            [albumNamesHomescreenInterwall setProperty:@(YES) forKey:@"enabled"];
            [albumNamesHomescreenInterwall setValues:albumNames
                                              titles:albumNames
                                         shortTitles:albumNames];

            [self insertSpecifier:albumNamesHomescreenInterwall afterSpecifierID:@"albumNamesLockscreenInterwall" animated:NO];
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"\n\n [Wallmart Settings] Following error occured: %@", [error description]);
    }];
}

@end
