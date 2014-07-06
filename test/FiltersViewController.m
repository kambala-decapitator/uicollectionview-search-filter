//
//  FiltersViewController.m
//  test
//
//  Created by Andrey Filipenkov on 06.07.14.
//  Copyright (c) 2014 Andrey Filipenkov. All rights reserved.
//

#import "FiltersViewController.h"

@interface FiltersViewController ()

@property (nonatomic, strong) NSMutableSet *selectedRowObjects;

@end

@implementation FiltersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.selectedRowObjects = [NSMutableSet setWithCapacity:10];
}

- (IBAction)filtersSelected:(id)sender {
    [self.delegate filtersSelected:self.selectedRowObjects];
}

- (IBAction)cancelFilterSelection:(id)sender {
    [self.delegate filterSelectionCancelled];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%u", indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *obj = cell.textLabel.text;
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectedRowObjects removeObject:obj];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedRowObjects addObject:obj];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
