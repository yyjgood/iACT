//
//  ShowUserOrderViewController.m
//  iACT
//
//  Created by hongyang on 13-3-5.
//  Copyright (c) 2013年 yyj. All rights reserved.
//

#import "ShowUserOrderViewController.h"
#import "MyNavigationController.h"

@interface ShowUserOrderViewController ()

@end

@implementation ShowUserOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            
           // NSLog(@"have %d", [((MyNavigationController *)self.parentViewController).bizArea count]);
            return [((MyNavigationController *)self.parentViewController).bizArea count];
            
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userOrderCell"];
    NSString * showStrings;
    
    showStrings  = [[NSString alloc] initWithFormat:
                    @"开通服务地区: %@\n订单号: %@\n订单类型: %@\n资源类型: %@\n套餐信息: %@\n创建时间: %@\n播出日期: %@\n计划开始时间: %@\n审核状态: %@\n处理状态: %@",
                    [((MyNavigationController *)self.parentViewController).bizArea objectAtIndex:indexPath.row],
                    [((MyNavigationController *)self.parentViewController).orderID_ objectAtIndex:indexPath.row],
                    [((MyNavigationController *)self.parentViewController).orderType objectAtIndex:indexPath.row],
                    [((MyNavigationController *)self.parentViewController).spotType objectAtIndex:indexPath.row],
                    [((MyNavigationController *)self.parentViewController).packageInfo objectAtIndex:indexPath.row],
                    [((MyNavigationController *)self.parentViewController).createTime objectAtIndex:indexPath.row],
                    [((MyNavigationController *)self.parentViewController).planDate objectAtIndex:indexPath.row],
                    [((MyNavigationController *)self.parentViewController).planBeginTime objectAtIndex:indexPath.row],
                    [((MyNavigationController *)self.parentViewController).verifyStatus objectAtIndex:indexPath.row],
                    [((MyNavigationController *)self.parentViewController).handleStatus objectAtIndex:indexPath.row]];
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = showStrings;
            break;
            
        default:
            cell.textLabel.text = @"Unknown";
    }
    
    return cell;
}




@end
