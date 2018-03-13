//
//  WebViewController.h
//  SlyceFrameworkdemo
//
//  Created by Chris on 26/10/2017.
//  Copyright © 2017 chris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Call1/Call1.h>
@interface WebViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
