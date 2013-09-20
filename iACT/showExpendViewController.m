//
//  showExpendViewController.m
//  iACT
//
//  Created by hongyang on 13-3-4.
//  Copyright (c) 2013年 yyj. All rights reserved.
//

#import "showExpendViewController.h"
#import "MyNavigationController.h"

@interface showExpendViewController ()

@end

@implementation showExpendViewController

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
            
            return [((MyNavigationController *)self.parentViewController).orderID count];
           
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"expendCell"];
    NSString * showStrings;
    
    showStrings  = [[NSString alloc] initWithFormat:
                    @"订单号: %@\n记录时间: %@\n预付费时间: %@\n预付费金额: %@\n最终付费时间: %@\n最终付费金额: %@\n支付状态: %@",
                    [((MyNavigationController *)self.parentViewController).orderID objectAtIndex:indexPath.row],
                    [((MyNavigationController *)self.parentViewController).addTime objectAtIndex:indexPath.row],
                    [((MyNavigationController *)self.parentViewController).prepaidTime objectAtIndex:indexPath.row],
                    [((MyNavigationController *)self.parentViewController).prepaidAmount objectAtIndex:indexPath.row],
                    [((MyNavigationController *)self.parentViewController).finalpaidTime objectAtIndex:indexPath.row],
                    [((MyNavigationController *)self.parentViewController).finalpaidAmount objectAtIndex:indexPath.row],
                    [((MyNavigationController *)self.parentViewController).paidStatus objectAtIndex:indexPath.row]];
    
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
