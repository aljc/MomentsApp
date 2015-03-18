//
//  SplashScreenViewController.m
//  GratitudeJournal
//
//  Created by ajchang on 3/16/15.
//  Copyright (c) 2015 ajchang. All rights reserved.
//

#import "SplashScreenViewController.h"

@interface SplashScreenViewController ()

@end

@implementation SplashScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Display the splash screen view for 1.5 seconds upon launch.
    [self performSelector:@selector(dismissSplashScreen) withObject:nil afterDelay:1.5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Dismiss the splash screen view controller.
- (void) dismissSplashScreen {
    [self dismissViewControllerAnimated:NO completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
