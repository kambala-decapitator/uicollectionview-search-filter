//
//  ViewController.m
//  test
//
//  Created by Andrey Filipenkov on 06.07.14.
//  Copyright (c) 2014 Andrey Filipenkov. All rights reserved.
//

#import "ViewController.h"
#import "FiltersViewController.h"

@interface ViewController () <FiltersViewControllerProtocol>

@property (nonatomic, strong) NSMutableArray *dataSource, *originalDataSource;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) FiltersViewController *fvc;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    UISearchBar *searchBar = [UISearchBar new];
    searchBar.delegate = self;
    searchBar.showsCancelButton = YES;
    self.navigationItem.titleView = searchBar;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filters" style:UIBarButtonItemStylePlain target:self action:@selector(showFilters)];

    self.dataSource = [NSMutableArray arrayWithCapacity:30];
    for (NSUInteger i = 0; i < 30; ++i) {
        [self.dataSource addObject:[NSString stringWithFormat:@"cell %u", i]];
    }
    self.originalDataSource = self.dataSource;
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [(UILabel *)cell.contentView.subviews[0] setText:self.dataSource[indexPath.row]];
    return cell;
}

#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self applyFilters:[NSSet setWithObject:searchBar.text]];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![searchText length]) {
        self.dataSource = self.originalDataSource;
        [self.collectionView reloadData];
    }
}

#pragma mark FiltersViewControllerProtocol

- (void)filtersSelected:(NSSet *)filters {
    [self hideFilters];
    [self applyFilters:filters];
}

- (void)filterSelectionCancelled {
    [self hideFilters];
}

#pragma mark private

- (void)showFilters
{
    if (!self.fvc) {
        self.fvc = [self.storyboard instantiateViewControllerWithIdentifier:@"filters"];
        self.fvc.delegate = self;

        __block CGRect r = CGRectMake(20, self.view.bounds.size.height, self.view.bounds.size.width - 40, self.view.bounds.size.height / 2);
        self.fvc.view.frame = r;
        self.fvc.view.layer.borderWidth = 1;
        [self addChildViewController:self.fvc];
        [self.view addSubview:self.fvc.view];
        [UIView animateWithDuration:0.5 animations:^{
            r.origin.y = 150;
            self.fvc.view.frame = r;
        } completion:^(BOOL finished) {
            [self.fvc didMoveToParentViewController:self];
        }];
    }
}

- (void)hideFilters {
    [self.fvc willMoveToParentViewController:nil];
    __block CGRect r = self.fvc.view.frame;
    [UIView animateWithDuration:0.5 animations:^{
        r.origin.y = self.view.bounds.size.height;
        self.fvc.view.frame = r;
    } completion:^(BOOL finished) {
        [self.fvc.view removeFromSuperview];
        [self.fvc removeFromParentViewController];
        self.fvc = nil;
    }];
}

- (void)applyFilters:(NSSet *)filters {
    NSMutableArray *newData = [NSMutableArray array];
    for (NSString *s in self.dataSource) {
        for (NSString *filter in filters) {
            if ([s rangeOfString:filter].location != NSNotFound) {
                [newData addObject:s];
                break;
            }
        }
    }
    self.dataSource = newData;

    [self.collectionView reloadData];
}

@end
