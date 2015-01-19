#import <Preferences/Preferences.h>

#define settingsPath @"/var/mobile/Library/Preferences/com.shinvou.wallmart.plist"

@interface WallmartSettingsWallmartBlurListController : PSListController
@end

@implementation WallmartSettingsWallmartBlurListController

- (id)specifiers
{
    if (_specifiers == nil) {
        [self setTitle:@"Blur settings"];
        
        PSSpecifier *firstGroup = [PSSpecifier groupSpecifierWithName:nil];
        [firstGroup setProperty:@"Blur affects the performance, it is possible that switching the wallpaper takes longer." forKey:@"footerText"];
        
        PSSpecifier *blurEnabledWallmart = [PSSpecifier preferenceSpecifierNamed:@"Blur enabled"
                                                                          target:self
                                                                             set:@selector(setValue:forSpecifier:)
                                                                             get:@selector(getValueForSpecifier:)
                                                                          detail:Nil
                                                                            cell:PSSwitchCell
                                                                            edit:Nil];
        [blurEnabledWallmart setIdentifier:@"blurEnabledWallmart"];
        [blurEnabledWallmart setProperty:@(YES) forKey:@"enabled"];
        
        PSSpecifier *secondGroup = [PSSpecifier groupSpecifierWithName:@"MC BLURRY WITH SMARTIES"];
        [secondGroup setProperty:@"These settings respect the wallpaper mode settings." forKey:@"footerText"];
        
        PSSpecifier *blurStrengthWallmart = [PSSpecifier preferenceSpecifierNamed:nil
                                                                           target:self
                                                                              set:@selector(setValue:forSpecifier:)
                                                                              get:@selector(getValueForSpecifier:)
                                                                           detail:Nil
                                                                             cell:PSSliderCell
                                                                             edit:Nil];
        [blurStrengthWallmart setIdentifier:@"blurStrengthWallmart"];
        [blurStrengthWallmart setProperty:@(YES) forKey:@"enabled"];
        
        [blurStrengthWallmart setProperty:@(0) forKey:@"min"];
        [blurStrengthWallmart setProperty:@(40) forKey:@"max"];
        [blurStrengthWallmart setProperty:@(NO) forKey:@"showValue"];
        
        PSSpecifier *blurModeWallmart = [PSSpecifier preferenceSpecifierNamed:@"Blur mode"
                                                                       target:self
                                                                          set:@selector(setValue:forSpecifier:)
                                                                          get:@selector(getValueForSpecifier:)
                                                                       detail:[PSListItemsController class]
                                                                         cell:PSLinkListCell
                                                                         edit:Nil];
        [blurModeWallmart setIdentifier:@"blurModeWallmart"];
        [blurModeWallmart setProperty:@(YES) forKey:@"enabled"];
        [blurModeWallmart setValues:@[@(0), @(2), @(1)]
                             titles:@[@"Blur lockscreen and homescreen", @"Blur lockscreen only", @"Blur homescreen only"]
                        shortTitles:@[@"Blur lockscreen and homescreen", @"Blur lockscreen only", @"Blur homescreen only"]];
        
        _specifiers = [NSArray arrayWithObjects:firstGroup, blurEnabledWallmart, secondGroup, blurStrengthWallmart, blurModeWallmart, nil];
    }
    
    return _specifiers;
}

- (id)getValueForSpecifier:(PSSpecifier *)specifier
{
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
    
    if ([specifier.identifier isEqualToString:@"blurEnabledWallmart"]) {
        if (settings) {
            if ([settings objectForKey:@"blurEnabledWallmart"]) {
                return [settings objectForKey:@"blurEnabledWallmart"];
            } else {
                return @(NO);
            }
        } else {
            return @(NO);
        }
    } else if ([specifier.identifier isEqualToString:@"blurStrengthWallmart"]) {
        if (settings) {
            if ([settings objectForKey:@"blurStrengthWallmart"]) {
                return [settings objectForKey:@"blurStrengthWallmart"];
            } else {
                return @(5);
            }
        } else {
            return @(5);
        }
    } else if ([specifier.identifier isEqualToString:@"blurModeWallmart"]) {
        if (settings) {
            if ([settings objectForKey:@"blurModeWallmart"]) {
                return [settings objectForKey:@"blurModeWallmart"];
            } else {
                return @(0);
            }
        } else {
            return @(0);
        }
    }
    
    return nil;
}

- (void)setValue:(id)value forSpecifier:(PSSpecifier *)specifier
{
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    [settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:settingsPath]];
    
    if ([specifier.identifier isEqualToString:@"blurEnabledWallmart"]) {
        [settings setObject:value forKey:@"blurEnabledWallmart"];
        [settings writeToFile:settingsPath atomically:YES];
    } else if ([specifier.identifier isEqualToString:@"blurStrengthWallmart"]) {
        [settings setObject:value forKey:@"blurStrengthWallmart"];
        [settings writeToFile:settingsPath atomically:YES];
    } else if ([specifier.identifier isEqualToString:@"blurModeWallmart"]) {
        [settings setObject:value forKey:@"blurModeWallmart"];
        [settings writeToFile:settingsPath atomically:YES];
    }
    
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.shinvou.wallmart/reloadWallmartSettings"), NULL, NULL, TRUE);
}

@end
