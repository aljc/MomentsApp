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

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) UIImage *image;

//you can save the entire model object to NSUserDefaults using NSCoding. (way to encode/decode instances of custom classes)
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;

@end
