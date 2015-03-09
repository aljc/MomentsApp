//
//  HomeViewController.m
//  GratitudeJournal
//
//  Created by ajchang on 3/4/15.
//  Copyright (c) 2015 ajchang. All rights reserved.
//

#import "HomeViewController.h"
#import "MomentsTableViewController.h"

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


#pragma mark - Caching

- (IBAction)addMoment:(UIButton *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *todaysMoment = @{
                                 @"Text" : self.dailyQuestion.text,
                                 @"Date" : @"2/28/15" //TODO: update
                                 };
    
    _moments = [NSMutableArray arrayWithArray:[defaults objectForKey:@"moments"]]; //make sure _moments property is up to date
    [_moments insertObject:todaysMoment atIndex:0]; //then add today's moment to it

    
    [defaults setObject:[NSArray arrayWithArray:_moments] forKey:@"moments"]; //then cast _moments to an NSArray and refresh the user defaults
    [defaults synchronize];
    
    NSLog(@"Moments property:%@", _moments);
    NSLog(@"Moments in default:%@", [defaults objectForKey:@"moments"]);
    
    //call the showMoments segue programmatically AFTER done adding this moment to cache
    [self performSegueWithIdentifier:@"showMoments" sender:sender]; //note: this segue needs to already be hooked up in the storyboard with
    //this identifier!!  Note: we ARE calling it upon the button press, but the segue itself is not linked to the button!  because then
    //the segue gets performed before this action gets called, and we need this action to get called first, so I just set up a segue
    //from the HVC to MTVC, and I'm calling THAT segue programmatically.
    
    //instead of using NSUserDefaults, consider writing to disk or NSCoding.
    
    //implement the apple std camera roll thing - take/choose a pic.  grab the image that gets returned
    
    [self showImagePicker];
}

#pragma mark - Image Picker

//TODO: needs work
- (void)showImagePicker
{
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.delegate = self;
    
    //if there's a camera available, jump straight to that
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSLog(@"show image picker: camera available");
    }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) //else go to saved photos album if that's available
    {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        NSLog(@"show image picker: photo gallery available");
    }
    else {
        NSLog(@"show image picker: Nothing available");
    }
    [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];
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
