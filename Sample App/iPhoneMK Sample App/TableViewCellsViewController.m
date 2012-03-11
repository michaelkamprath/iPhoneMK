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
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return @"MKSwitchControlTableViewCell";
            break;
        case 1:
            return @"MKIconCheckmarkTableViewCell";
            break;
            
        default:
            return nil;
            break;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 3;
            break;
        default:
            return 0;
            break;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ( [indexPath indexAtPosition:0] == 0 ) {
        static NSString *CellIdentifier = @"SwitchCell";
        
        MKSwitchControlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[MKSwitchControlTableViewCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
        }
        
        cell.switchControl.tag = [indexPath indexAtPosition:1];
        
        cell.textLabel.text = [NSString stringWithFormat:@"Switch Cell %d",cell.switchControl.tag+1];
        
        [cell addTarget:self action:@selector(switchControlValueChanged:)];
        
        return cell;
    }
    else if ( [indexPath indexAtPosition:0] == 1 ) {
        static NSString* IconCheckmarkCellIdentifier = @"IconCheckmarkCell";
        
        MKIconCheckmarkTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:IconCheckmarkCellIdentifier];
        if (cell == nil) {
            UIImage* checkImage = [UIImage imageNamed:@"checkmarkicon_on.png"];
            UIImage* emptyImage = [UIImage imageNamed:@"checkmarkicon_empty.png"];

            cell = [[[MKIconCheckmarkTableViewCell alloc] initWithStyle:MKIconCheckmarkTableViewCellStyleRight 
                                                        reuseIdentifier:IconCheckmarkCellIdentifier 
                                                             checkImage:checkImage 
                                                           uncheckImage:emptyImage] autorelease];
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"Icon Checkmark Cell %d",[indexPath indexAtPosition:1]];

        cell.checked = YES;
        
        return cell;
    }
    else {
        return nil;
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ( [indexPath indexAtPosition:0] == 1 ) {
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
        
        MKIconCheckmarkTableViewCell* cell = (MKIconCheckmarkTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        cell.checked = !cell.checked;
        
        [cell setNeedsDisplay];

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
