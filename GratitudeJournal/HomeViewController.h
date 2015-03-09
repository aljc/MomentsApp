//
//  HomeViewController.h
//  GratitudeJournal
//
//  Created by ajchang on 3/4/15.
//  Copyright (c) 2015 ajchang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *dailyQuestion;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)addMoment:(UIButton *)sender;

@end
