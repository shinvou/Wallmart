#import <Preferences/Preferences.h>

#define settingsPath @"/var/mobile/Library/Preferences/com.shinvou.wallmart.plist"

@interface WallmartSettingsInterwallBlurListController : PSListController
@end

@implementation WallmartSettingsInterwallBlurListController

- (id)specifiers
{
    if (_specifiers == nil) {
        [self setTitle:@"Blur settings"];
        
        PSSpecifier *firstGroup = [PSSpecifier groupSpecifierWithName:nil];
        [firstGroup setProperty:@"Blur affects the performance, it is possible that switching the wallpaper takes longer." forKey:@"footerText"];
        
        PSSpecifier *blurEnabledInterwall = [PSSpecifier preferenceSpecifierNamed:@"Blur enabled"
                                                                           target:self
                                                                              set:@selector(setValue:forSpecifier:)
                                                                              get:@selector(getValueForSpecifier:)
                                                                           detail:Nil
                                                                             cell:PSSwitchCell
                                                                             edit:Nil];
        [blurEnabledInterwall setIdentifier:@"blurEnabledInterwall"];
        [blurEnabledInterwall setProperty:@(YES) forKey:@"enabled"];
        
        PSSpecifier *secondGroup = [PSSpecifier groupSpecifierWithName:@"MC BLURRY WITH SMARTIES"];
        [secondGroup setProperty:@"These settings respect the wallpaper mode settings." forKey:@"footerText"];
        
        PSSpecifier *blurStrengthInterwall = [PSSpecifier preferenceSpecifierNamed:nil
                                                                            target:self
                                                                               set:@selector(setValue:forSpecifier:)
                                                                               get:@selector(getValueForSpecifier:)
                                                                            detail:Nil
                                                                              cell:PSSliderCell
                                                                              edit:Nil];
        [blurStrengthInterwall setIdentifier:@"blurStrengthInterwall"];
        [blurStrengthInterwall setProperty:@(YES) forKey:@"enabled"];
        
        [blurStrengthInterwall setProperty:@(0) forKey:@"min"];
        [blurStrengthInterwall setProperty:@(40) forKey:@"max"];
        [blurStrengthInterwall setProperty:@(NO) forKey:@"showValue"];
        
        PSSpecifier *blurModeInterwall = [PSSpecifier preferenceSpecifierNamed:@"Blur mode"
                                                                        target:self
                                                                           set:@selector(setValue:forSpecifier:)
                                                                           get:@selector(getValueForSpecifier:)
                                                                        detail:[PSListItemsController class]
                                                                          cell:PSLinkListCell
                                                                          edit:Nil];
        [blurModeInterwall setIdentifier:@"blurModeInterwall"];
        [blurModeInterwall setProperty:@(YES) forKey:@"enabled"];
        [blurModeInterwall setValues:@[@(0), @(2), @(1)]
                              titles:@[@"Blur lockscreen and homescreen", @"Blur lockscreen only", @"Blur homescreen only"]
                         shortTitles:@[@"Blur lockscreen and homescreen", @"Blur lockscreen only", @"Blur homescreen only"]];
        
        _specifiers = [NSArray arrayWithObjects:firstGroup, blurEnabledInterwall, secondGroup, blurStrengthInterwall, blurModeInterwall, nil];
    }
    
    return _specifiers;
}

- (id)getValueForSpecifier:(PSSpecifier *)specifier
{
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
    
    if ([specifier.identifier isEqualToString:@"blurEnabledInterwall"]) {
        if (settings) {
            if ([settings objectForKey:@"blurEnabledInterwall"]) {
                return [settings objectForKey:@"blurEnabledInterwall"];
            } else {
                return @(NO);
            }
        } else {
            return @(NO);
        }
    } else if ([specifier.identifier isEqualToString:@"blurStrengthInterwall"]) {
        if (settings) {
            if ([settings objectForKey:@"blurStrengthInterwall"]) {
                return [settings objectForKey:@"blurStrengthInterwall"];
            } else {
                return @(5);
            }
        } else {
            return @(5);
        }
    } else if ([specifier.identifier isEqualToString:@"blurModeInterwall"]) {
        if (settings) {
            if ([settings objectForKey:@"blurModeInterwall"]) {
                return [settings objectForKey:@"blurModeInterwall"];
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
    
    if ([specifier.identifier isEqualToString:@"blurEnabledInterwall"]) {
        [settings setObject:value forKey:@"blurEnabledInterwall"];
        [settings writeToFile:settingsPath atomically:YES];
    } else if ([specifier.identifier isEqualToString:@"blurStrengthInterwall"]) {
        [settings setObject:value forKey:@"blurStrengthInterwall"];
        [settings writeToFile:settingsPath atomically:YES];
    } else if ([specifier.identifier isEqualToString:@"blurModeInterwall"]) {
        [settings setObject:value forKey:@"blurModeInterwall"];
        [settings writeToFile:settingsPath atomically:YES];
    }
    
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.shinvou.wallmart/reloadInterwallSettings"), NULL, NULL, TRUE);
}

@end
