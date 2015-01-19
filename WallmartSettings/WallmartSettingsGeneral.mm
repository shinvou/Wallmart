#import <Preferences/Preferences.h>

#define settingsPath @"/var/mobile/Library/Preferences/com.shinvou.wallmart.plist"

@interface WallmartSettingsGeneralListController : PSListController
@end

@implementation WallmartSettingsGeneralListController

- (id)specifiers
{
    if (_specifiers == nil) {
        [self setTitle:@"General"];
        
        PSSpecifier *firstGroup = [PSSpecifier groupSpecifierWithName:nil];
        
        PSSpecifier *wallmartGeneralEnabled = [PSSpecifier preferenceSpecifierNamed:@"Enabled"
                                                                             target:self
                                                                                set:@selector(setValue:forSpecifier:)
                                                                                get:@selector(getValueForSpecifier:)
                                                                             detail:Nil
                                                                               cell:PSSwitchCell
                                                                               edit:Nil];
        [wallmartGeneralEnabled setIdentifier:@"wallmartGeneralEnabled"];
        [wallmartGeneralEnabled setProperty:@(YES) forKey:@"enabled"];
        
        _specifiers = [NSArray arrayWithObjects:firstGroup, wallmartGeneralEnabled, nil];
    }
    
    return _specifiers;
}

- (id)getValueForSpecifier:(PSSpecifier *)specifier
{
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
    
    if ([specifier.identifier isEqualToString:@"wallmartGeneralEnabled"]) {
        if (settings) {
            if ([settings objectForKey:@"wallmartGeneralEnabled"]) {
                return [settings objectForKey:@"wallmartGeneralEnabled"];
            } else {
                return @(YES);
            }
        } else {
            return @(YES);
        }
    }
    
    return nil;
}

- (void)setValue:(id)value forSpecifier:(PSSpecifier *)specifier
{
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    [settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:settingsPath]];
    
    if ([specifier.identifier isEqualToString:@"wallmartGeneralEnabled"]) {
        [settings setObject:value forKey:@"wallmartGeneralEnabled"];
        [settings writeToFile:settingsPath atomically:YES];
    }
    
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.shinvou.wallmart/reloadWallmartSettings"), NULL, NULL, TRUE);
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.shinvou.wallmart/reloadInterwallSettings"), NULL, NULL, TRUE);
}

@end
