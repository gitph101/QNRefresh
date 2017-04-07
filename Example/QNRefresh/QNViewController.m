//
//  QNViewController.m
//  QNRefresh
//
//  Created by gitph101 on 04/01/2017.
//  Copyright (c) 2017 gitph101. All rights reserved.
//

#import "QNViewController.h"
#import "UIScrollView+QNRefresh.h"

@interface QNViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation QNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.alpha = 1;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSLog(@"%@",NSStringFromCGSize(self.tableView.contentSize));
    
    [self.tableView addHeaderRefreshWithRefreshBlock:^{
        NSLog(@"####下拉刷新######");
        [self performSelector:@selector(afterHeaderRefresh) withObject:nil afterDelay:5];
    }];
    [self.tableView addFooterRefreshWithRefreshBlock:^{
        NSLog(@"####上拉加载######");
        [self performSelector:@selector(afterFooterRefresh) withObject:nil afterDelay:5];
    }];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    cell.textLabel.text = @"Demo";
    return cell;
}

-(void)afterHeaderRefresh
{
    QNRefreshComponent *headerView = (QNRefreshComponent *)self.tableView.headerRefreshView;
    [headerView endRefresh];
}

-(void)afterFooterRefresh
{
    QNRefreshComponent *footerView = (QNRefreshComponent *)self.tableView.footerRefreshView;
    [footerView endRefresh];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
