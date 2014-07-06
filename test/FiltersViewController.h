//
//  FiltersViewController.h
//  test
//
//  Created by Andrey Filipenkov on 06.07.14.
//  Copyright (c) 2014 Andrey Filipenkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FiltersViewControllerProtocol <NSObject>

- (void)filtersSelected:(NSSet *)filters;
- (void)filterSelectionCancelled;

@end

@interface FiltersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<FiltersViewControllerProtocol> delegate;

@end
