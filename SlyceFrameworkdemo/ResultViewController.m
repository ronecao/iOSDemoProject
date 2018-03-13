//
//  ResultViewController.m
//  SlyceFrameworkdemo
//
//  Created by Chris on 2017/4/20.
//  Copyright © 2017年 chris. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController ()

@end

@implementation ResultViewController

@synthesize resultlabel;
@synthesize cardLabel;
@synthesize referenceLabel;
@synthesize amountLabel;
@synthesize okBtn;

@synthesize result;
@synthesize card;
@synthesize reference;
@synthesize amount;




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    resultlabel.text=result;
    cardLabel.text=card;
    referenceLabel.text=reference;
    amountLabel.text=amount;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)okBtnClicked:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
