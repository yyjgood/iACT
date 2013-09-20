//
//  OrderViewController.m
//  iACT
//
//  Created by yyj on 1/10/13.
//  Copyright (c) 2013 yyj. All rights reserved.
//

#import "OrderViewController.h"
#import "BizNavigationController.h"
#import "HomepageTabBarController.h"

@interface OrderViewController ()

@end

@implementation OrderViewController
@synthesize showLabel;
@synthesize showLabel2;

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
    [self shoOrderDetail];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setShowLabel:nil];
    [self setShowLabel2:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)shoOrderDetail
{
    NSString *showString;
    NSString *broadcast;
    broadcast = [[NSString alloc] initWithFormat:@"%@-%@",((BizNavigationController *)self.parentViewController).packageBeginTime, ((BizNavigationController *)self.parentViewController).packageEndTime];
    showString = [[NSString alloc] initWithFormat:
                  @"套餐编号: %@\n套餐名称: %@\n套餐类型: %@  播放%@次\n开通地区: %@\n播出时段: %@\n",
                  ((BizNavigationController *)self.parentViewController).packageID,
                  ((BizNavigationController *)self.parentViewController).packageName,
                  ((BizNavigationController *)self.parentViewController).packageSpotType,
                  ((BizNavigationController *)self.parentViewController).packagePlayNumber,
                  ((BizNavigationController *)self.parentViewController).areaName_,
                  broadcast];
    self.showLabel.text = showString;
    
    NSString *showString2;
    showString2 = [[NSString alloc] initWithFormat:
                   @"%@  %@\n需付金额: ¥%@元    播放%@次",
                   ((BizNavigationController *)self.parentViewController).packageName,
                   broadcast,
                   ((BizNavigationController *)self.parentViewController).packagePrice,
                   ((BizNavigationController *)self.parentViewController).packagePlayNumber
                   ];
    self.showLabel2.text = showString2;
}

- (IBAction)addUserOrder:(id)sender
{
        if (
            [((BizNavigationController *)self.parentViewController).balance intValue]
            >=
            [((BizNavigationController *)self.parentViewController).packagePrice intValue]
            )
        {
            if ([((BizNavigationController *)self.parentViewController).packageSpotType isEqualToString:@"文字"]) {
                [self performSegueWithIdentifier:@"toSubtitle" sender:self];
            }else
            {
                [self performSegueWithIdentifier:@"toImage" sender:self];
            }
        

    }else
    {
        UIAlertView *showError;
        showError = [[UIAlertView alloc] initWithTitle:@"余额不足" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [showError show];
    }
        
}
@end
