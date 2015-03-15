//
//  MomentsTableViewController.m
//  GratitudeJournal
//
//  Created by ajchang on 3/4/15.
//  Copyright (c) 2015 ajchang. All rights reserved.
//

#import "MomentsTableViewController.h"
#import "MomentsTableViewCell.h"

@interface MomentsTableViewController ()

@end

@implementation MomentsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.view addSubview:[[UIImageView alloc] initWithImage:self.moment.image]];
    
    //if we arrived at this view controller from the submitMoment segue
    if (self.moment != NULL) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.savedMoments = [defaults objectForKey:@"moments"];
        
        NSLog(@"Adding moment to user defaults");
        NSLog(@"IMAGE: %@", self.moment.image);
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.title = @"Moments";
        [self addMomentToDefaults];
    }
    
    NSLog(@"updating savedMoments");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.savedMoments = [defaults objectForKey:@"moments"];
    
    //refresh control
    UIRefreshControl *pullToRefresh = [[UIRefreshControl alloc] init];
    [pullToRefresh addTarget:self action:@selector(refreshTable)
            forControlEvents:UIControlEventValueChanged];
    self.refreshControl = pullToRefresh;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshTable {
    NSLog(@"Pull To Refresh");
    
    //Reload the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.savedMoments = [defaults objectForKey:@"moments"];
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

#pragma mark - NSUserDefaults

- (void)addMomentToDefaults {
    //if a Moment object was passed in, that means a new moment was just created and must be added to NSUserDefaults.
    //(aka we arrived at this view controller via the "Submit" button and not the tab bar controller.)
    if (self.moment != NULL) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        //@@@WHY AREN'T FILTERED IMAGES ENCODING PROPERLY?!?!? *********
        //ENCODE THE DATA: MOMENT -> NSDATA
        NSData *momentData = [NSKeyedArchiver archivedDataWithRootObject:self.moment];
        
        //MOMENTS IS AN NSMUTABLEARRAY OF TYPE NSDATA
        NSMutableArray *tempMoments = [[NSMutableArray alloc] init];
        tempMoments = [NSMutableArray arrayWithArray:[defaults objectForKey:@"moments"]]; //NSArray -> NSMutableArray
        [tempMoments insertObject:momentData atIndex:0]; //then add the new moment to it
        
        self.savedMoments = [NSArray arrayWithArray:tempMoments]; //NSMutableArray -> NSArray
        
        [defaults setObject:self.savedMoments forKey:@"moments"];
        [defaults synchronize];
        
        [self.tableView reloadData];
        NSLog(@"Finished adding new moment to defaults");
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1; //1 section for now
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.savedMoments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MomentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"momentCell" forIndexPath:indexPath];
    
    NSLog(@"populating table view cells");
    
    // Configure the cell...
    NSData *currentMoment = [self.savedMoments objectAtIndex:indexPath.row];
    
    //DECODE DATA: NSDATA -> MOMENT
    Moment *currentMomentDecoded= (Moment*) [NSKeyedUnarchiver unarchiveObjectWithData:currentMoment];
    
    NSLog(@"DECODED MOMENT: %@", currentMomentDecoded.text);
    
    cell.imageView1.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView1.clipsToBounds = YES;
    [cell.imageView1 setImage:currentMomentDecoded.image];
    
    cell.imageView2.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView2.clipsToBounds = YES;
    [cell.imageView2 setImage:currentMomentDecoded.image];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
