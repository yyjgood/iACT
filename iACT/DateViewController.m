//
//  DateViewController.m
//  iACT
//
//  Created by hongyang on 13-1-30.
//  Copyright (c) 2013年 yyj. All rights reserved.
//

#import "DateViewController.h"

@interface DateViewController ()

@end

@implementation DateViewController
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
    [self setDateImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)setDateImage:(id)sender
{
    [(imageViewController *)self.delegate showChosenDate:((UIDatePicker *)sender).date];}

- (IBAction)dismissDateImage:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    ((imageViewController *)self.delegate).dateVisible = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [(imageViewController *)self.delegate showChosenDate:[NSDate date]];
}

@end
