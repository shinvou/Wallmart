//
//  WallmartEvent.xm
//  Wallmart
//
//  Created by Timm Kandziora on 09.01.15.
//  Copyright (c) 2015 Timm Kandziora. All rights reserved.
//

#import <libactivator/libactivator.h>
#import <Foundation/NSDistributedNotificationCenter.h>

@interface WallmartEvent : NSObject <LAListener>
@end

@implementation WallmartEvent

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event
{
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"WallmartEvent" object:nil userInfo:nil];

	[event setHandled:YES]; // To prevent the default OS implementation
}

+ (void)load
{
	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.springboard"]) {
		[[%c(LAActivator) sharedInstance] registerListener:[self new] forName:@"com.shinvou.wallmartevent"];
	}
}
@end
