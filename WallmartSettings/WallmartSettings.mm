#import "WallmartSettingsGeneral.mm"
#import "WallmartSettingsWallmart.mm"
#import "WallmartSettingsInterwall.mm"

#import <Preferences/Preferences.h>

#define settingsPath @"/var/mobile/Library/Preferences/com.shinvou.wallmart.plist"
#define UIColorRGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@interface WallmartBanner : PSTableCell
@end

@implementation WallmartBanner

- (id)initWithStyle:(int)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"wallmartBannerCell" specifier:specifier];
    
    if (self) {
        self.backgroundColor = UIColorRGB(74, 74, 74);
        
        UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 206)];
        label.font = [UIFont fontWithName:@"Helvetica-Light" size:60];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = @"#pantarhei";
        
        [self addSubview:label];
    }
    
    return self;
}

@end

@interface WallmartSettingsListController : PSListController
@end

@implementation WallmartSettingsListController

- (id)specifiers
{
    if (_specifiers == nil) {
        [self setTitle:@"Wallmart"];
        
        PSSpecifier *banner = [PSSpecifier preferenceSpecifierNamed:nil
                                                             target:self
                                                                set:NULL
                                                                get:NULL
                                                             detail:Nil
                                                               cell:PSStaticTextCell
                                                               edit:Nil];
        [banner setProperty:[WallmartBanner class] forKey:@"cellClass"];
        [banner setProperty:@"206" forKey:@"height"];
        
        PSSpecifier *firstGroup = [PSSpecifier groupSpecifierWithName:nil];
        [firstGroup setProperty:@"These settings apply to 'Wallmart' and 'Interwall and moments'." forKey:@"footerText"];
        
        PSSpecifier *generalSettings = [PSSpecifier preferenceSpecifierNamed:nil
                                                                      target:self
                                                                         set:NULL
                                                                         get:NULL
                                                                      detail:[WallmartSettingsGeneralListController class]
                                                                        cell:PSLinkCell
                                                                        edit:Nil];
        generalSettings.name = @"General";
        [generalSettings setIdentifier:@"generalSettings"];
        [generalSettings setProperty:@(YES) forKey:@"enabled"];
        
        PSSpecifier *secondGroup = [PSSpecifier groupSpecifierWithName:nil];
        
        PSSpecifier *wallmartSettings = [PSSpecifier preferenceSpecifierNamed:nil
                                                                       target:self
                                                                          set:NULL
                                                                          get:NULL
                                                                       detail:[WallmartSettingsWallmartListController class]
                                                                         cell:PSLinkCell
                                                                         edit:Nil];
        wallmartSettings.name = @"Wallmart";
        [wallmartSettings setIdentifier:@"wallmartSettings"];
        [wallmartSettings setProperty:@(YES) forKey:@"enabled"];
        
        PSSpecifier *interwallSettings = [PSSpecifier preferenceSpecifierNamed:nil
                                                                        target:self
                                                                           set:NULL
                                                                           get:NULL
                                                                        detail:[WallmartSettingsInterwallListController class]
                                                                          cell:PSLinkCell
                                                                          edit:Nil];
        interwallSettings.name = @"Interwall and moments";
        [interwallSettings setIdentifier:@"interwallSettings"];
        [interwallSettings setProperty:@(YES) forKey:@"enabled"];
        
        PSSpecifier *thirdGroup = [PSSpecifier groupSpecifierWithName:@"contact developer"];
        [thirdGroup setProperty:@"Feel free to follow me on twitter for any updates on my apps and tweaks or contact me for support questions.\n \nThis tweak is Open-Source, so make sure to check out my GitHub." forKey:@"footerText"];
        
        PSSpecifier *twitter = [PSSpecifier preferenceSpecifierNamed:@"twitter"
                                                              target:self
                                                                 set:NULL
                                                                 get:NULL
                                                              detail:Nil
                                                                cell:PSLinkCell
                                                                edit:Nil];
        twitter.name = @"@biscoditch";
        twitter->action = @selector(openTwitter);
        [twitter setIdentifier:@"twitter"];
        [twitter setProperty:@(YES) forKey:@"enabled"];
        [twitter setProperty:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/WallmartSettings.bundle/twitter.png"] forKey:@"iconImage"];
        
        PSSpecifier *github = [PSSpecifier preferenceSpecifierNamed:@"github"
                                                             target:self
                                                                set:NULL
                                                                get:NULL
                                                             detail:Nil
                                                               cell:PSLinkCell
                                                               edit:Nil];
        github.name = @"https://github.com/shinvou";
        github->action = @selector(openGithub);
        [github setIdentifier:@"github"];
        [github setProperty:@(YES) forKey:@"enabled"];
        [github setProperty:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/WallmartSettings.bundle/github.png"] forKey:@"iconImage"];
        
        _specifiers = [NSArray arrayWithObjects:banner, firstGroup, generalSettings, secondGroup, wallmartSettings, interwallSettings, thirdGroup, twitter, github, nil];
    }
    
    return _specifiers;
}

- (void)openTwitter
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetbot:///user_profile/biscoditch"]];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitterrific:///profile?screen_name=biscoditch"]];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetings:///user?screen_name=biscoditch"]];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=biscoditch"]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://mobile.twitter.com/biscoditch"]];
    }
}

- (void)openGithub
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/shinvou"]];
}

@end
