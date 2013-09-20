//
//  PayDateViewController.m
//  iACT
//
//  Created by hongyang on 13-3-5.
//  Copyright (c) 2013年 yyj. All rights reserved.
//

#import "PayDateViewController.h"

@interface PayDateViewController ()

@end



@implementation PayDateViewController

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
    [super viewDidUnload];
    [self setDelegate:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) viewWillDisappear:(BOOL)animated {
    ((GetPayRecordViewController *)self.delegate).dateChooserVisible=NO;
}
- (void) viewDidAppear:(BOOL)animated {
    [(GetPayRecordViewController *)self.delegate showChosenDate:[NSDate date]];
}


- (IBAction)dismissDateChooser:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)setDate:(id)sender {
    [(GetPayRecordViewController *)self.delegate showChosenDate:((UIDatePicker *)sender).date];
}

@end
