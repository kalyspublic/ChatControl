//
//  MYTestViewController.m
//  ChatControl
//
//  Created by Kalys Osmonov on 8/11/14.
//  Copyright (c) 2014 Kalys Osmonov. All rights reserved.
//

#import "MYTestViewController.h"

@interface MYTestViewController ()

@property (nonatomic, weak) IBOutlet UIButton *cancelButton;

@end

@implementation MYTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.cancelButton addTarget:self action:@selector(cancelTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) cancelTapped:(id) sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
