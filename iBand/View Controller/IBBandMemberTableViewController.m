//
//  IBBandMemberTableViewController.m
//  iBand
//
//  Created by Li QIAN on 5/10/13.
//  Copyright (c) 2013 Nerv Dev. All rights reserved.
//

#import "IBBandMemberTableViewController.h"
#import "IBNetworkHelper.h"

@interface IBBandMemberTableViewController () <IBNetworkHelperDelegate>

@end

@implementation IBBandMemberTableViewController


@synthesize member = _member;

- (void)setMember:(NSArray *)member
{
    if (_member != member) {
        _member = member;
        if (self.tableView.window) [self.tableView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [IBNetworkHelper helper].delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.member = [IBNetworkHelper helper].deviceList;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.member count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"device";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = self.member[indexPath.row];
    return cell;
}

#pragma mark - IBNetworkHelperDelegate
- (void)didUpdateBonjourDeviceList
{
    self.member = [IBNetworkHelper helper].deviceList;
    if (self.tableView.window) [self.tableView reloadData];
}

@end
