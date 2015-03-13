//
//  HomeViewController.m
//  GratitudeJournal
//
//  Created by ajchang on 3/4/15.
//  Copyright (c) 2015 ajchang. All rights reserved.
//

#import "HomeViewController.h"
#import "MomentsTableViewController.h"
#import "Moment.h"
//#import "UIImage+Resize.h" //???? @@@not found?

/* TODOS
 instagram integration!!
 madlibs type input?  Today I saw ____.  My favorite moment was when ____.  My goal for tomorrow is ______. (next button, diff views)
 
 */

@interface HomeViewController ()

@property NSMutableArray *placeholderArray;
@property NSMutableArray *moments;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self resetNSUserDefaults];
    // Do any additional setup after loading the view, typically from a nib.
    
    _placeholderArray = [[NSMutableArray alloc] init];
    [_placeholderArray addObject:@"What made you smile today?"];
    [_placeholderArray addObject:@"Who did something nice for you today?"];
    [_placeholderArray addObject:@"Did you eat anything yummy today?"];
    [_placeholderArray addObject:@"Did you see anyone special today?"];
    
    NSString *placeholderText = [_placeholderArray objectAtIndex:arc4random_uniform(4)]; //TODO: 0-8
    
    self.dailyQuestion.placeholder = placeholderText;
    
    _moments = [[NSMutableArray alloc] init];
    
    self.dailyQuestion.delegate = self;
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
        //every time you submit a new moment, automatically update the moments array in the table view controller
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        MomentsTableViewController *mtvc = [segue destinationViewController];
        mtvc.moments = [defaults objectForKey:@"moments"];
    }
}

#pragma mark - NS User Defaults

//for testing purposes - reset user defaults
//Source: http://stackoverflow.com/questions/6358737/nsuserdefaults-reset
- (void)resetNSUserDefaults {
    NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    for (NSString *key in [defaultsDictionary allKeys]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark - Caching

- (IBAction)loadImagePicker:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    //default to choose photo from gallery
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        NSLog(@"show image picker: photo gallery available");
    }
    
    [self presentViewController:picker animated:YES completion:nil];
    
    NSLog(@"finished loading image picker"); 
    
}

- (void)addMomentToDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    Moment *todaysMoment = [[Moment alloc] init];
    todaysMoment.text = self.dailyQuestion.text;
    todaysMoment.date = @"2/28/15";
    todaysMoment.image = _image;
    //[self.view addSubview:[[UIImageView alloc] initWithImage:_image]];
    
    //ENCODE THE DATA: MOMENT -> NSDATA
    
    NSData *todaysMomentData = [NSKeyedArchiver archivedDataWithRootObject:todaysMoment];
    //MOMENTS IS AN NSMUTABLEARRAY OF TYPE NSDATA
    _moments = [NSMutableArray arrayWithArray:[defaults objectForKey:@"moments"]]; //make sure _moments property is up to date
    [_moments insertObject:todaysMomentData atIndex:0]; //then add today's moment to it

    [defaults setObject:[NSArray arrayWithArray:_moments] forKey:@"moments"]; //then cast _moments to an NSArray and refresh the user defaults
    [defaults synchronize];

}

#pragma mark - Image picker delegate methods

//http://www.raywenderlich.com/13541/how-to-create-an-app-like-instagram-with-a-web-service-backend-part-22
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
     NSLog(@"did finish picking");
    
    //get the image from the dictionary
    _image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //now that you have the image reference, create the full moment and add to NSUserDefaults
    [self addMomentToDefaults];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"dismissed picker");
    //call the showMoments segue programmatically AFTER done adding this moment to cache
    [self performSegueWithIdentifier:@"showMoments" sender:self];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
