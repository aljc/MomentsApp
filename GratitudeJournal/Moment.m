//
//  Moment.m
//  GratitudeJournal
//
//  Created by ajchang on 3/9/15.
//  Copyright (c) 2015 ajchang. All rights reserved.
//

#import "Moment.h"

@implementation Moment

//Encode moment object.
- (void)encodeWithCoder:(NSCoder*)aCoder {
    [aCoder encodeObject:self.text forKey:@"text"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.image forKey:@"image"];
}

//Decode moment object.
- (id) initWithCoder:(NSCoder*)aDecoder {
    self = [super init];
    
    self.text = [aDecoder decodeObjectForKey:@"text"];
    self.date = [aDecoder decodeObjectForKey:@"date"];
    self.image = [aDecoder decodeObjectForKey:@"image"];
    
    return self;
}

@end
