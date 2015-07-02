//
//  AppDelegate.m
//  GratitudeJournal
//
//  Created by Alice Chang on 3/2/15.
//  Copyright (c) 2015 Alice Chang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"Alice Sea" forKey:@"Developer"];
    [defaults setValue:@"1.0" forKey:@"Version"];
    [defaults setValue:[NSDate date] forKey:@"Initial Launch"];
    
    NSNumber *launchNumber = [defaults objectForKey:@"Launch Number"];
    //first launch
    if (launchNumber == nil) {
        [defaults setValue:[NSNumber numberWithInt:1] forKey:@"Launch Number"];
    }
    else {
        [defaults setValue:[NSNumber numberWithInt:([launchNumber intValue]+1)] forKey:@"Launch Number"];
    }
    [defaults synchronize];
    
    NSLog(@"Developer: %@", [defaults objectForKey:@"Developer"]);
    NSLog(@"Version: %@", [defaults objectForKey:@"Version"]);
    NSLog(@"Initial Launch: %@", [defaults objectForKey:@"Initial Launch"]);
    NSNumber *launchNumberNow = [defaults objectForKey:@"Launch Number"];
    NSLog(@"Launch Number: %@", launchNumberNow);
    
    if ([launchNumberNow intValue] == 5) {
        NSLog(@"Rate us in the app store - alert view");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Like us?" message:@"Rate us in the app store!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [alertView show];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
