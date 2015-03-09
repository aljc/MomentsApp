//
//  Moment.h
//  GratitudeJournal
//
//  Created by ajchang on 3/9/15.
//  Copyright (c) 2015 ajchang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Moment : NSObject <NSCoding>

@property NSString *text;
@property UIImageView *imageView;
@property NSDate *date;

//you can save the entire model object to NSUserDefaults using NSCoding.  //Need to make it NSCoding compliant in order to store this custom object.

@end
