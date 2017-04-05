//
//  QNViewController.m
//  QNRefresh
//
//  Created by gitph101 on 04/01/2017.
//  Copyright (c) 2017 gitph101. All rights reserved.
//

#import "QNViewController.h"
#import "UIScrollView+QNHeaderRefresh.h"


@interface QNViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation QNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.alpha = 0.1;
    [self.tableView addHeaderRefreshWithRefreshBlock:^{
    } position:QNRefreshPositionTop];
    
    
//    UIEdgeInsets contentInset = self.tableView.contentInset;
//    self.tableView.contentInset = UIEdgeInsetsMake(20,contentInset.left,contentInset.bottom,contentInset.right);

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
