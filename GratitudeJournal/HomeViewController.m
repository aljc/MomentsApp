//
//  HomeViewController.m
//  GratitudeJournal
//
//  Created by ajchang on 3/4/15.
//  Copyright (c) 2015 ajchang. All rights reserved.
//

#import "HomeViewController.h"
#import <QuartzCore/QuartzCore.h>

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Caching

- (IBAction)addMoment:(UIButton *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *todaysMoment = @{
                                 @"Text" : self.dailyQuestion.text,
                                 @"Date" : @"2/28/15" //TODO: update
                                 };
    
    [_moments addObject:todaysMoment]; //TODO: make _ and self's consistent

    
    [defaults setObject:[NSArray arrayWithArray:_moments] forKey:@"moments"];
    [defaults synchronize];
    
    NSLog(@"Moments:%@", [defaults objectForKey:@"moments"]);
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
