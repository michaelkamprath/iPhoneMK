//
//  TableViewCellsViewController.m
//  iPhoneMK Sample App
//
//  Created by Michael Kamprath on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TableViewCellsViewController.h"
#import "MKSwitchControlTableViewCell.h"
#import "MKIconCheckmarkTableViewCell.h"
#import "MKSocialShareTableViewCell.h"
#import "MKParentalGate.h"
#import "ParentalGateSuccessViewController.h"

#define SECTIONID_MKSwitchControlTableViewCell  0
#define SECTIONID_MKIconCheckmarkTableViewCell  1
#define SECTIONID_MKSocialShareTableViewCell    3
#define SECTIONID_MKParentalGate                2

@interface TableViewCellsViewController ()

- (void)switchControlValueChanged:(id)sender;

@end

@implementation TableViewCellsViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.title = @"Table View Cells";
        self.tabBarItem.image = [UIImage imageNamed:@"third"];
        if ( [self respondsToSelector:@selector(edgesForExtendedLayout)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ( [MKSocialShareTableViewCell socialShareAvailable] ) {
        return 4;
    }
    else {
        return 3;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case SECTIONID_MKSwitchControlTableViewCell:
            return @"MKSwitchControlTableViewCell";
            break;
        case SECTIONID_MKIconCheckmarkTableViewCell:
            return @"MKIconCheckmarkTableViewCell";
            break;
        case SECTIONID_MKSocialShareTableViewCell:
            return @"MKSocialShareTableViewCell";
            break;
        case SECTIONID_MKParentalGate:
            return @"MKParentalGate";
            break;
        default:
            return nil;
            break;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case SECTIONID_MKSwitchControlTableViewCell:
            return 3;
            break;
        case SECTIONID_MKIconCheckmarkTableViewCell:
            return 3;
            break;
        case SECTIONID_MKSocialShareTableViewCell:
            if ( [MKSocialShareTableViewCell socialShareAvailable]) {
                return 1;
            }
            else {
                return 0;
            }
            break;
        case SECTIONID_MKParentalGate:
            return 1;
            break;
        default:
            return 0;
            break;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger sectionID = [indexPath indexAtPosition:0];
    
    if ( sectionID == SECTIONID_MKSwitchControlTableViewCell ) {
        static NSString *CellIdentifier = @"SwitchCell";
        
        MKSwitchControlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[MKSwitchControlTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
        }
        
        cell.switchControl.tag = [indexPath indexAtPosition:1];
        
        cell.textLabel.text = [NSString stringWithFormat:@"Switch Cell %d",cell.switchControl.tag+1];
        
        [cell addTarget:self action:@selector(switchControlValueChanged:)];
        
        return cell;
    }
    else if ( sectionID == SECTIONID_MKIconCheckmarkTableViewCell ) {
        static NSString* IconCheckmarkCellIdentifier = @"IconCheckmarkCell";
        
        MKIconCheckmarkTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:IconCheckmarkCellIdentifier];
        if (cell == nil) {
            UIImage* checkImage = [UIImage imageNamed:@"checkmarkicon_on.png"];
            UIImage* emptyImage = [UIImage imageNamed:@"checkmarkicon_empty.png"];

            cell = [[MKIconCheckmarkTableViewCell alloc] initWithStyle:MKIconCheckmarkTableViewCellStyleRight 
                                                        reuseIdentifier:IconCheckmarkCellIdentifier 
                                                             checkImage:checkImage 
                                                           uncheckImage:emptyImage];
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"Icon Checkmark Cell %d",[indexPath indexAtPosition:1]];

        cell.checked = YES;
        
        return cell;
    }
    else if ( sectionID == SECTIONID_MKSocialShareTableViewCell ) {
        static NSString* SocialShareCellIdentifier = @"SocialShare";
        
        MKSocialShareTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:SocialShareCellIdentifier];
        
        if (cell == nil ) {
            cell = [[MKSocialShareTableViewCell alloc] initWithReuseIdentifier:SocialShareCellIdentifier
                                                                 facebookImage:[UIImage imageNamed:@"facebook.png"]
                                                                  twitterImage:[UIImage imageNamed:@"twitter.png"]
                                                                sinaWeiboImage:[UIImage imageNamed:@"weibo.png"]
                                                             tencentWeiboImage:[UIImage imageNamed:@"tencent.png"]];
            
            cell.postText = @"I am using iPhoneMK to make my iOS app better. So can you!";
            cell.postURLList = [NSArray arrayWithObjects:[NSURL URLWithString:@"https://github.com/michaelkamprath/iPhoneMK"], nil];
            
        }
        
        cell.textLabel.text = @"Share iPhoneMK";
        
        return cell;
    }
    else if ( sectionID == SECTIONID_MKParentalGate ) {
        static NSString* ParentGateCellIdentifier = @"ParentalGate";
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ParentGateCellIdentifier];
        
        if ( nil == cell ) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ParentGateCellIdentifier];
        }
        
        cell.textLabel.text = @"Parental Gate";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
    else {
        return nil;
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ( [indexPath indexAtPosition:0] == SECTIONID_MKIconCheckmarkTableViewCell ) {
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
        
        MKIconCheckmarkTableViewCell* cell = (MKIconCheckmarkTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        cell.checked = !cell.checked;
        
        [cell setNeedsDisplay];

    }
    else if ( [indexPath indexAtPosition:0] == SECTIONID_MKParentalGate ) {
        MKParentalGateSuccessBlock success = ^{
            ParentalGateSuccessViewController* vc = [[ParentalGateSuccessViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        [MKParentalGate displayGateWithCurrentViewController:self successBlock:success failureBlock:NULL];
    }
}



#pragma mark - MKSwitchControlTableViewCell Support

- (void)switchControlValueChanged:(id)sender {
    
    if ( [sender isKindOfClass:[UISwitch class]] ) {
        UISwitch* cellSwitch = (UISwitch*)sender;
        
        NSUInteger pathArray[2];
        pathArray[0] = 0;
        pathArray[1] = cellSwitch.tag;
        
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathWithIndexes:pathArray length:2]];
        
        if (cellSwitch.on) {
            cell.textLabel.textColor = [UIColor redColor];
        }
        else {
            cell.textLabel.textColor = [UIColor blackColor];
        }
    }
}

@end
