//
//  ResultViewController.h
//  SlyceFrameworkdemo
//
//  Created by Chris on 2017/4/20.
//  Copyright © 2017年 chris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UIViewController
@property (nonatomic,retain) IBOutlet UILabel* resultlabel;
@property (nonatomic,retain) IBOutlet UILabel* cardLabel;
@property (nonatomic,retain) IBOutlet UILabel* referenceLabel;
@property (nonatomic,retain) IBOutlet UILabel* amountLabel;
@property (nonatomic,retain) IBOutlet UIButton* okBtn;

@property (nonatomic,retain) IBOutlet NSString* result;
@property (nonatomic,retain) IBOutlet NSString* card;
@property (nonatomic,retain) IBOutlet NSString* reference;
@property (nonatomic,retain) IBOutlet NSString* amount;

@end
