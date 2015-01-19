#import <Preferences/Preferences.h>

#define settingsPath @"/var/mobile/Library/Preferences/com.shinvou.wallmart.plist"

@interface CycleDatePickerStart : PSTableCell

@property (strong, nonatomic) UIDatePicker *datePicker;

@end

@implementation CycleDatePickerStart

- (id)initWithStyle:(int)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cycleDatePickerStartCell" specifier:specifier];

    if (self) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 205)];
        _datePicker.datePickerMode = UIDatePickerModeTime;
        _datePicker.date = [self getDateFromPreferences];

        [_datePicker addTarget:self action:@selector(saveDateToPreferences) forControlEvents:UIControlEventValueChanged];

        [self addSubview:_datePicker];
    }

    return self;
}

- (NSDate *)getDateFromPreferences
{
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];

    if (settings) {
        if ([settings objectForKey:@"cycleStartTime"]) {
            return [dateFormatter dateFromString:[settings objectForKey:@"cycleStartTime"]];
        }
    }

    return [dateFormatter dateFromString:@"10:00"];
}

- (void)saveDateToPreferences
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];

    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    [settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:settingsPath]];
    [settings setObject:[formatter stringFromDate:_datePicker.date] forKey:@"cycleStartTime"];
    [settings writeToFile:settingsPath atomically:YES];

    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.shinvou.wallmart/reloadWallmartSettings"), NULL, NULL, TRUE);
}

@end

@interface CycleDatePickerEnd : PSTableCell

@property (strong, nonatomic) UIDatePicker *datePicker;

@end

@implementation CycleDatePickerEnd

- (id)initWithStyle:(int)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cycleDatePickerEndCell" specifier:specifier];

    if (self) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 205)];
        _datePicker.datePickerMode = UIDatePickerModeTime;
        _datePicker.date = [self getDateFromPreferences];

        [_datePicker addTarget:self action:@selector(saveDateToPreferences) forControlEvents:UIControlEventValueChanged];

        [self addSubview:_datePicker];
    }

    return self;
}

- (NSDate *)getDateFromPreferences
{
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];

    if (settings) {
        if ([settings objectForKey:@"cycleEndTime"]) {
            return [dateFormatter dateFromString:[settings objectForKey:@"cycleEndTime"]];
        }
    }

    return [dateFormatter dateFromString:@"20:00"];
}

- (void)saveDateToPreferences
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];

    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    [settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:settingsPath]];
    [settings setObject:[formatter stringFromDate:_datePicker.date] forKey:@"cycleEndTime"];
    [settings writeToFile:settingsPath atomically:YES];

    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.shinvou.wallmart/reloadWallmartSettings"), NULL, NULL, TRUE);
}

@end

@interface WallmartSettingsWallmartCycleListController : PSListController
@end

@implementation WallmartSettingsWallmartCycleListController

- (id)specifiers
{
    if (_specifiers == nil) {
        [self setTitle:@"Cycle settings"];

        PSSpecifier *firstGroup = [PSSpecifier groupSpecifierWithName:nil];
        [firstGroup setProperty:@"With cycle enabled the wallpaper/wallpapers only change between START TIME and END TIME." forKey:@"footerText"];

        PSSpecifier *cycleEnabledWallmart = [PSSpecifier preferenceSpecifierNamed:@"Cycle enabled"
                                                                           target:self
                                                                              set:@selector(setValue:forSpecifier:)
                                                                              get:@selector(getValueForSpecifier:)
                                                                           detail:Nil
                                                                             cell:PSSwitchCell
                                                                             edit:Nil];
        [cycleEnabledWallmart setIdentifier:@"cycleEnabledWallmart"];
        [cycleEnabledWallmart setProperty:@(YES) forKey:@"enabled"];

        PSSpecifier *secondGroup = [PSSpecifier groupSpecifierWithName:@"START TIME"];

        PSSpecifier *cycleDatePickerStart = [PSSpecifier preferenceSpecifierNamed:nil
                                                                           target:self
                                                                              set:NULL
                                                                              get:NULL
                                                                           detail:Nil
                                                                             cell:PSStaticTextCell
                                                                             edit:Nil];
        [cycleDatePickerStart setProperty:[CycleDatePickerStart class] forKey:@"cellClass"];
        [cycleDatePickerStart setProperty:@"205" forKey:@"height"];
        [cycleDatePickerStart setIdentifier:@"cycleDatePickerStart"];
        [cycleDatePickerStart setProperty:@(YES) forKey:@"enabled"];

        PSSpecifier *thirdGroup = [PSSpecifier groupSpecifierWithName:@"END TIME"];

        PSSpecifier *cycleDatePickerEnd = [PSSpecifier preferenceSpecifierNamed:nil
                                                                         target:self
                                                                            set:NULL
                                                                            get:NULL
                                                                         detail:Nil
                                                                           cell:PSStaticTextCell
                                                                           edit:Nil];
        [cycleDatePickerEnd setProperty:[CycleDatePickerEnd class] forKey:@"cellClass"];
        [cycleDatePickerEnd setProperty:@"205" forKey:@"height"];
        [cycleDatePickerEnd setIdentifier:@"cycleDatePickerEnd"];
        [cycleDatePickerEnd setProperty:@(YES) forKey:@"enabled"];

        _specifiers = [NSArray arrayWithObjects:firstGroup, cycleEnabledWallmart, secondGroup, cycleDatePickerStart, thirdGroup, cycleDatePickerEnd, nil];
    }

    return _specifiers;
}

- (id)getValueForSpecifier:(PSSpecifier *)specifier
{
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];

    if ([specifier.identifier isEqualToString:@"cycleEnabledWallmart"]) {
        if (settings) {
            if ([settings objectForKey:@"cycleEnabledWallmart"]) {
                return [settings objectForKey:@"cycleEnabledWallmart"];
            } else {
                return @(NO);
            }
        } else {
            return @(NO);
        }
    }

    return nil;
}

- (void)setValue:(id)value forSpecifier:(PSSpecifier *)specifier
{
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    [settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:settingsPath]];

    if ([specifier.identifier isEqualToString:@"cycleEnabledWallmart"]) {
        [settings setObject:value forKey:@"cycleEnabledWallmart"];
        [settings writeToFile:settingsPath atomically:YES];
    }

    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.shinvou.wallmart/reloadWallmartSettings"), NULL, NULL, TRUE);
}

@end
