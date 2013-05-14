//
//  IBInitialViewController.m
//  iBand
//
//  Created by Li QIAN on 5/1/13.
//  Copyright (c) 2013 Nerv Dev. All rights reserved.
//

#import "IBInitialViewController.h"
#import "InstrumentList.h"
#import "IBNetworkHelper.h"
#import "IBDrum.h"
#import "IBPiano.h"

@interface IBInitialViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation IBInitialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.namesOfInstruments = @[PIANO, DRUM];
    [[IBDrum sharedInstance] load];
    [[IBPiano sharedInstance] load];
    [[IBNetworkHelper helper] startBonjour];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.namesOfInstruments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Instrument";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = self.namesOfInstruments[indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:self.namesOfInstruments[indexPath.row] sender:self];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue.identifier isEqualToString:@"Show Member"]) {
//        IPBandMemberTableViewController *bandMemberTVC = (IPBandMemberTableViewController *)segue.destinationViewController;
//        NSArray *services = [IPNetworkHelper helper].deviceList;
//        bandMemberTVC.member = services;
//    }
}

@end
