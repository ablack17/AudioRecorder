//
//  Recording.h
//  Audio Recorder
//
//  Created by Aislin Philomena Black on 7/6/16.
//  Copyright © 2016 Aislin Philomena Black. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recording : NSObject <NSSecureCoding>

@property (strong, nonatomic) NSDate * date;
//always save in ~/Documents/yyyymmddhhmmss

@property (readonly, nonatomic) NSString* path;
@property (readonly, nonatomic) NSURL* url;

-(Recording*) initWithDate: (NSDate*) aDate;


@end
