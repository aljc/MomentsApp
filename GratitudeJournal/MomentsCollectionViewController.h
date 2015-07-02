//
//  MomentsCollectionViewController.h
//  GratitudeJournal
//
//  Created by Alice Chang on 3/15/15.
//  Copyright (c) 2015 Alice Chang. All rights reserved.
//
/* Collection View Controller for presenting the user's past moments. */

#import <UIKit/UIKit.h>
#import "Moment.h"

@interface MomentsCollectionViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout>

@property NSArray *savedMoments;
@property (strong, nonatomic) Moment *moment;

@end
