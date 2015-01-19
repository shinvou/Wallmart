#import "WallmartSettingsInterwallMomentsAdd.mm"

#import <Preferences/Preferences.h>

#define settingsPath @"/var/mobile/Library/Preferences/com.shinvou.wallmart.plist"

@interface WallmartSettingsInterwallMomentsListController : PSEditableListController
@end

@implementation WallmartSettingsInterwallMomentsListController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadSpecifiers];
}

- (id)specifiers
{
    if (_specifiers == nil) {
        NSMutableArray *specifiers = [[NSMutableArray alloc] init];
        
        [self setTitle:@"Moments"];
        
        PSSpecifier *firstGroup = [PSSpecifier groupSpecifierWithName:nil];
        [firstGroup setProperty:@"Below are the moments when your wallpaper/wallpapers change." forKey:@"footerText"];
        [specifiers addObject:firstGroup];
        
        PSSpecifier *addMoment = [PSSpecifier preferenceSpecifierNamed:nil
                                                                target:self
                                                                   set:NULL
                                                                   get:NULL
                                                                detail:[WallmartSettingsInterwallMomentsAddListController class]
                                                                  cell:PSLinkCell
                                                                  edit:Nil];
        addMoment.name = @"Add moment";
        [addMoment setProperty:@(YES) forKey:@"enabled"];
        [specifiers addObject:addMoment];
        
        PSSpecifier *secondGroup = [PSSpecifier groupSpecifierWithName:nil];
        [specifiers addObject:secondGroup];
        
        NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
        
        if (settings) {
            if ([settings objectForKey:@"moments"]) {
                NSMutableArray *momentsArray = [[NSMutableArray alloc] init];
                [momentsArray addObjectsFromArray:[settings objectForKey:@"moments"]];
                
                for (int i = 0; i < [momentsArray count]; i++) {
                    PSSpecifier *moment = [PSSpecifier preferenceSpecifierNamed:[NSString stringWithFormat:@"%@", momentsArray[i]]
                                                                         target:self
                                                                            set:NULL
                                                                            get:NULL
                                                                         detail:Nil
                                                                           cell:PSTitleValueCell
                                                                           edit:Nil];
                    [moment setIdentifier:[NSString stringWithFormat:@"%@", momentsArray[i]]];
                    [moment setProperty:@(YES) forKey:@"enabled"];
                    [specifiers addObject:moment];
                }
            }
        }
        
        _specifiers = specifiers;
    }
    
    return _specifiers;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return UITableViewCellEditingStyleNone;
    }
    
    return UITableViewCellEditingStyleDelete;
}

- (void)removeSpecifier:(PSSpecifier *)specifier animated:(BOOL)animated
{
    [super removeSpecifier:specifier animated:animated];
    
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    [settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:settingsPath]];
    
    NSMutableArray *momentsArray = [[NSMutableArray alloc] init];
    [momentsArray addObjectsFromArray:[settings objectForKey:@"moments"]];
    
    for (int i = 0; i < [momentsArray count]; i++) {
        if ([momentsArray[i] isEqualToString:specifier.identifier]) {
            [momentsArray removeObjectAtIndex:i];
        }
    }
    
    [settings setObject:momentsArray forKey:@"moments"];
    [settings writeToFile:settingsPath atomically:YES];
}

@end
