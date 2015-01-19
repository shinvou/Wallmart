#import <Preferences/Preferences.h>

#define settingsPath @"/var/mobile/Library/Preferences/com.shinvou.wallmart.plist"

@interface WallmartDatePicker : PSTableCell

@property (strong, nonatomic) UIDatePicker *datePicker;

@end

@implementation WallmartDatePicker

- (id)initWithStyle:(int)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"wallmartDatePickerCell" specifier:specifier];
    
    if (self) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 205)];
        _datePicker.datePickerMode = UIDatePickerModeTime;
        
        [self addSubview:_datePicker];
    }
    
    return self;
}

- (void)saveDateToPreferences
{
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    [settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:settingsPath]];
    
    NSMutableArray *momentsArray = [[NSMutableArray alloc] init];
    [momentsArray addObjectsFromArray:[settings objectForKey:@"moments"]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    [momentsArray addObject:[formatter stringFromDate:_datePicker.date]];
    
    [settings setObject:momentsArray forKey:@"moments"];
    [settings writeToFile:settingsPath atomically:YES];
    
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.shinvou.wallmart/reloadInterwallSettings"), NULL, NULL, TRUE);
}

@end

@interface WallmartSettingsInterwallMomentsAddListController : PSListController
@end

@implementation WallmartSettingsInterwallMomentsAddListController

- (void)loadView
{
    [super loadView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveMomentTapped)];
}

- (id)specifiers
{
    if (_specifiers == nil) {
        [self setTitle:@"Add moment"];
        
        PSSpecifier *momentDatePicker = [PSSpecifier preferenceSpecifierNamed:nil
                                                                       target:self
                                                                          set:NULL
                                                                          get:NULL
                                                                       detail:Nil
                                                                         cell:PSStaticTextCell
                                                                         edit:Nil];
        [momentDatePicker setProperty:[WallmartDatePicker class] forKey:@"cellClass"];
        [momentDatePicker setProperty:@"205" forKey:@"height"];
        [momentDatePicker setIdentifier:@"momentDatePicker"];
        [momentDatePicker setProperty:@(YES) forKey:@"enabled"];
        
        _specifiers = [NSArray arrayWithObjects:momentDatePicker, nil];
    }
    
    return _specifiers;
}

- (void)saveMomentTapped
{
    WallmartDatePicker *wallmartDatePicker = [[self specifierForID:@"momentDatePicker"] propertyForKey:@"cellObject"];
    [wallmartDatePicker saveDateToPreferences];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
