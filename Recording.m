//
//  Recording.m
//  Audio Recorder
//
//  Created by Aislin Philomena Black on 7/6/16.
//  Copyright © 2016 Aislin Philomena Black. All rights reserved.
//

#import "Recording.h"

@implementation Recording

@synthesize date;
-(Recording*) initWithDate:(NSDate *)aDate
{
    self = [super init];
    if(self)
    {
        self.date = aDate;
    }
    return self;
}
-(NSString*) path
{
    NSString* home = NSHomeDirectory();
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString* dateString = [formatter stringFromDate: self.date];
    return [NSString stringWithFormat:@"%@/Documents/%@.caf", home, dateString];
}
+ (BOOL)supportsSecureCoding
{
    return YES;
}
- (instancetype)initWithCoder:(NSCoder *)decoder
{
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder
{

}

-(NSString*) description
{
    return [NSString stringWithFormat:@"Recording from %@", date];
}
//make url and description
@end
