//
//  ViewController.h
//  SlyceFrameworkdemo
//
//  Created by chris on 03/02/2017.
//  Copyright © 2017 chris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Call1/Call1.h>
#import "ResultViewController.h"
@interface ViewController : UIViewController<CallOneDelegate>

@property (nonatomic,retain) IBOutlet UIButton *initialLibbtn;
@property (nonatomic,retain) IBOutlet UIButton *salebtn;
@property (nonatomic,retain) IBOutlet UIButton *returnbtn;
@property (nonatomic,retain) IBOutlet UIButton *connetPinBtn;
@property (nonatomic,retain) IBOutlet UIButton *selectPinPadBtn;
@property (nonatomic,retain) IBOutlet UIButton *authBtn;
@property (nonatomic,retain) IBOutlet UIButton *capBtn;
@property (nonatomic,retain) IBOutlet UIButton *cancelBtn;
@property (nonatomic,retain) IBOutlet UITextField *amountField;
@property (nonatomic,retain) IBOutlet UITextField *tokenField;
@property (nonatomic,retain) IBOutlet UILabel *informationLabel;
@property (nonatomic,retain) IBOutlet UILabel *messageLabel;
@property (nonatomic,retain) IBOutlet ResultViewController *resultView;
-(IBAction)initbtnClicked:(id)sender;
@end

