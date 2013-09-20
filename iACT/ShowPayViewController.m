//
//  ShowPayViewController.m
//  iACT
//
//  Created by hongyang on 13-3-5.
//  Copyright (c) 2013年 yyj. All rights reserved.
//

#import "ShowPayViewController.h"
#import "MyNavigationController.h"


@interface ShowPayViewController ()

@end

@implementation ShowPayViewController

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
            
            //NSLog(@"have %d", [((MyNavigationController *)self.parentViewController).orderIDPay count]);
            return [((MyNavigationController *)self.parentViewController).addFee count];
            
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payCell"];
    NSString * showStrings;
    
    showStrings  = [[NSString alloc] initWithFormat:
                    @"订单号: %@\n记录时间: %@\n商户号: %@\n序列号: %@\n支付模式: %@\n支付金额: %@\n充值金额: %@",
                    [((MyNavigationController *)self.parentViewController).orderIDPay objectAtIndex:indexPath.row],
                    [((MyNavigationController *)self.parentViewController).addTimePay objectAtIndex:indexPath.row],
                    [((MyNavigationController *)self.parentViewController).productID objectAtIndex:indexPath.row],
                    [((MyNavigationController *)self.parentViewController).serialNumber objectAtIndex:indexPath.row],
                    [((MyNavigationController *)self.parentViewController).payMode objectAtIndex:indexPath.row],
                    [((MyNavigationController *)self.parentViewController).payAmount objectAtIndex:indexPath.row],
                    [((MyNavigationController *)self.parentViewController).addFee objectAtIndex:indexPath.row]];
    
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
