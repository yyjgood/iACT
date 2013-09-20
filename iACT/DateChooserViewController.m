//
//  DateChooserViewController.m
//  iACT
//
//  Created by hongyang on 13-1-28.
//  Copyright (c) 2013年 yyj. All rights reserved.
//

#import "DateChooserViewController.h"
#import "subtitleViewController.h"

@interface DateChooserViewController ()

@end

@implementation DateChooserViewController

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
    [self setDate:nil];
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

-(void)viewWillAppear:(BOOL)animated
{
    [(subtitleViewController *)self.delegate showChosenDate:[NSDate date]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    ((subtitleViewController *)self.delegate).dateChooserVisible = NO;
}

- (IBAction)setDate:(id)sender
{
    [(subtitleViewController *)self.delegate showChosenDate:((UIDatePicker *)sender).date];
}

- (IBAction)dismissDateChooser:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
