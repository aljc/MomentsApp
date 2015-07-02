//
//  TextEffectsViewController.h
//  GratitudeJournal
//
//  Created by Alice Chang on 3/14/15.
//  Copyright (c) 2015 Alice Chang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Moment.h"

/* Allow user to apply text effects to the image. */

@interface TextEffectsViewController : UIViewController <UIGestureRecognizerDelegate>


@property (weak, nonatomic) IBOutlet UIView *imageContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *fontsScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *colorsScrollView;
@property (weak, nonatomic) IBOutlet UILabel *momentTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *momentDateLabel;
@property (strong, nonatomic) Moment *moment;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *momentDateLabelLeadingSpaceConstraint;

@end
