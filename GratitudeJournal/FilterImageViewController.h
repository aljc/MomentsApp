//
//  FilterImageViewController.h
//  GratitudeJournal
//
//  Created by ajchang on 3/13/15.
//  Copyright (c) 2015 ajchang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterImageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *filterScrollView;

- (IBAction)chooseFilter:(UIButton *)sender;

@end
