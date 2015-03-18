//
//  HomeViewController.m
//  GratitudeJournal
//
//  Created by ajchang on 3/4/15.
//  Copyright (c) 2015 ajchang. All rights reserved.
//

#import "HomeViewController.h"
#import "MomentsCollectionViewController.h"
#import "FilterImageViewController.h"

@interface HomeViewController ()

@property NSMutableArray *placeholderArray;
@property NSMutableArray *moments;
@property BOOL didPresentSplashScreen;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    //If splash screen has not already been presented, then present the splash screen upon launch.
    if (!self.didPresentSplashScreen) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController* splashScreen = [storyboard instantiateViewControllerWithIdentifier:@"splashScreen"];
        
        [self.tabBarController presentViewController:splashScreen animated:NO completion:nil];
        self.didPresentSplashScreen = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    //Initialize auto-generated random placeholder text
    self.placeholderArray = [[NSMutableArray alloc] init];
    [self.placeholderArray addObject:@"What made you smile today?"];
    [self.placeholderArray addObject:@"Little things count too!"];
    [self.placeholderArray addObject:@"What made you happy today?"];
    
    NSString *placeholderText = [self.placeholderArray objectAtIndex:arc4random_uniform((int)[self.placeholderArray count])];
    
    self.dailyQuestion.placeholder = placeholderText;
    
    self.moments = [[NSMutableArray alloc] init];
    
    self.dailyQuestion.delegate = self;
    
    //set display properties
    self.submitButton.layer.cornerRadius = 10;
    [self.submitButton.titleLabel setFont:[UIFont fontWithName:@"Avenir" size:17.0]];
    self.submitButton.backgroundColor = [UIColor colorWithRed:0.627 green:0.569 blue:0.929 alpha:1]; /*#a091ed*/
    
    self.infoViewButton.layer.cornerRadius = 10;
    
    self.infoView.layer.cornerRadius = 10;

    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    //need to adjust bottom space constraints if app is running older iPhone models to get all
    //subviews to fit within the info view
    if (screenBounds.size.height <= 480) {
        NSLog(@"Running on a 4S");
        self.infoViewBottomSpaceConstraint.constant = 50.0;
        self.infoViewButtonBottomSpaceConstraint.constant = 15.0;
    }
    else if (screenBounds.size.height <= 568) {
        NSLog(@"Running on a 5 or 5S");
        self.infoViewBottomSpaceConstraint.constant = 100.0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"showMoments"])
    {
        NSLog(@"Performing showMoments segue");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        MomentsCollectionViewController *mvc = [segue destinationViewController];
        //Update the saved moments array in the Moments collection view
        mvc.savedMoments = [defaults objectForKey:@"moments"];
    }
    else if ([[segue identifier] isEqualToString:@"showFilters"])
    {
        NSLog(@"Performing showFilters segue");
        //pass Moment object to Filter Image View Controller
        //Note: this segue goes to the navigation controller, not the filters view controller, in order to show the nav bar.
        //In order to pass along the image to the FVC itself, we can retrieve the FVC from the NVC by using nvc.topViewController.
        UINavigationController *nvc = [segue destinationViewController];
        FilterImageViewController *fvc = (FilterImageViewController*) nvc.topViewController; //NOW you can pass along the moment to this view controller's property
        fvc.moment = self.moment;
    }
}

#pragma mark - Saving Moments

//Reset NSUserDefaults - for testing purposes.
//Source: http://stackoverflow.com/questions/6358737/nsuserdefaults-reset
- (void)resetNSUserDefaults {
    NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    for (NSString *key in [defaultsDictionary allKeys]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Target Action

//Upon info button click, present the info view if it is not already showing.
- (IBAction)presentInfo:(UIButton *)sender {
    NSLog(@"Button pressed target action: present info");
    if (self.infoView.hidden) {
        self.infoView.alpha = 0;
        self.infoView.hidden = NO;
        
        //Fade in animation
        [UIView animateWithDuration:0.5 animations:
         ^{
             self.infoView.alpha = 1.0;
         } completion:nil];
    }
}

//Upon info view button click, dismiss the info view.
- (IBAction)dismissInfo:(UIButton *)sender {
    NSLog(@"Button pressed target action: dismiss info");
    [UIView animateWithDuration:0.5 animations:
     ^{
         self.infoView.alpha = 0;
     } completion:^(BOOL finished) {
         self.infoView.hidden = YES;
     }];
}

//Load the image picker so user can choose a photo from gallery upon submitting gratitude text.
//TODO: Later versions will allow user to take a photo as well.
- (IBAction)loadImagePicker:(UIButton *)sender {
    NSLog(@"Button pressed target action: load image picker");
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        NSLog(@"show image picker: photo gallery available");
    }
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - Image picker delegate methods

//Once user has chosen an image, crop the image to a square if they have not done so already.
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
     NSLog(@"Did finish picking image");
    
    //get the image from the dictionary
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage]; //save the EDITED, cropped image!
    
    //if user did not sufficiently crop their image to a sqaure, crop it for them
    if (chosenImage.size.height != chosenImage.size.width) {
        //Crop the image to a square
        //Source: http://stackoverflow.com/questions/17712797/ios-custom-uiimagepickercontroller-camera-crop-to-square
        CGSize imageSize = chosenImage.size;
        CGFloat width = imageSize.width;
        CGFloat height = imageSize.height;
        if (width != height) {
            CGFloat newDimension = MIN(width, height);
            CGFloat widthOffset = (width - newDimension) / 2;
            CGFloat heightOffset = (height - newDimension) / 2;
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(newDimension, newDimension), NO, 0.);
            [chosenImage drawAtPoint:CGPointMake(-widthOffset, -heightOffset)
                      blendMode:kCGBlendModeCopy
                          alpha:1.];
            chosenImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
    
    //after user has selected a photo, create the moment and segue to Filters
    [picker dismissViewControllerAnimated:YES completion:^{
        Moment *todaysMoment = [[Moment alloc] init];
        todaysMoment.text = self.dailyQuestion.text;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-mm-dd"];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        NSString *todaysDate = [dateFormatter stringFromDate:[NSDate date]];
        todaysMoment.date = todaysDate;
        todaysMoment.image = chosenImage;
        
        self.moment = todaysMoment;
        [self performSegueWithIdentifier:@"showFilters" sender:self];
    }];
    
    NSLog(@"Dismissed image picker");
}

//If user presses cancel on the image picker view, dismiss the image picker controller.
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextField Delegate

//Return YES when user has begun editing the text field.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

//Return YES when user has finished editing the text field.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
