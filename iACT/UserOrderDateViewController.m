//
//  UserOrderDateViewController.m
//  iACT
//
//  Created by hongyang on 13-3-5.
//  Copyright (c) 2013年 yyj. All rights reserved.
//

#import "UserOrderDateViewController.h"

@interface UserOrderDateViewController ()

@end

@implementation UserOrderDateViewController
@synthesize delegate;
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
    [self setDelegate:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark -
- (void) viewWillDisappear:(BOOL)animated {
    ((GetUserOrderViewController *)self.delegate).dateChooserVisible=NO;
}
- (void) viewDidAppear:(BOOL)animated {
    [(GetUserOrderViewController *)self.delegate showChosenDate:[NSDate date]];
}

- (IBAction)dismissDateChooser:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)setDate:(id)sender {
    [(GetUserOrderViewController *)self.delegate showChosenDate:((UIDatePicker *)sender).date];
}
#pragma mark -

@end
