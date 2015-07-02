//
//  Moment.h
//  GratitudeJournal
//
//  Created by Alice Chang on 3/9/15.
//  Copyright (c) 2015 Alice Chang. All rights reserved.
//

/* Model object for a moment, compliant with NSCoding */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Moment : NSObject <NSCoding>

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) UIImage *image;

- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;

@end
