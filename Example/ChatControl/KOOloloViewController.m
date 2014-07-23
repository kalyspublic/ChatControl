//
//  KOOloloViewController.m
//  ChatControl
//
//  Created by Kalys Osmonov on 7/21/14.
//  Copyright (c) 2014 Kalys Osmonov. All rights reserved.
//

#import "KOOloloViewController.h"
#import "SPLMChatCell.h"

@interface KOOloloViewController ()

@end

@implementation KOOloloViewController

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
    //[self.tableView registerClass:[SPLMChatCell class] forCellReuseIdentifier:@"KOChatCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"KOChatCellView" bundle:nil] forCellReuseIdentifier:@"KOChatCell"];
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
