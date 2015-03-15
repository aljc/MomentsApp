//
//  TextEffectsViewController.h
//  GratitudeJournal
//
//  Created by ajchang on 3/14/15.
//  Copyright (c) 2015 ajchang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Moment.h"

@interface TextEffectsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *fontsScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *colorsScrollView;
@property (weak, nonatomic) IBOutlet UILabel *momentTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *momentDateLabel;
@property (strong, nonatomic) Moment *moment;

- (IBAction)chooseFont:(UIButton *)sender;
- (IBAction)chooseColor:(UIButton *)sender;

@end
