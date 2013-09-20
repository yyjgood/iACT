//
//  ExpendDateViewController.m
//  iACT
//
//  Created by hongyang on 13-2-28.
//  Copyright (c) 2013年 yyj. All rights reserved.
//

#import "ExpendDateViewController.h"

@interface ExpendDateViewController ()

@end

@implementation ExpendDateViewController

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

#pragma mark -
- (void) viewWillDisappear:(BOOL)animated {
    ((GetExpendRecordViewController *)self.delegate).dateChooserVisible=NO;
}
- (void) viewDidAppear:(BOOL)animated {
    [(GetExpendRecordViewController *)self.delegate showChosenDate:[NSDate date]];
}

- (IBAction)dismissDateChooser:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)setDate:(id)sender {
    [(GetExpendRecordViewController *)self.delegate showChosenDate:((UIDatePicker *)sender).date];
}
#pragma mark -
@end
