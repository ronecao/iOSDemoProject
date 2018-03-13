//
//  WebViewController.m
//  SlyceFrameworkdemo
//
//  Created by Chris on 26/10/2017.
//  Copyright © 2017 chris. All rights reserved.
//

#import "WebViewController.h"
#import <Call1/Call1.h>
#import <Call1/EMVIOiOSBridge.h>
#import <JavaScriptCore/JavaScriptCore.h>
@interface WebViewController ()
@property (strong, nonatomic) JSContext *context;
@end

@implementation WebViewController
@synthesize context;
@synthesize webView;

- (void)viewDidLoad
{
    [super viewDidLoad];
        // Do any additional setup after loading the view from its nib.
    self.title = @"js call oc";
        
        NSString *path = [[[NSBundle mainBundle] bundlePath]  stringByAppendingPathComponent:@"JSCallOC.html"];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
        [self.webView loadRequest:request];
    
}
    // Do any additional setup after loading the view from its nib.


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // Undocumented access to UIWebView's JSContext
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.context.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        NSLog(@"%@", exceptionValue);
    };
    context[@"EMVIO"] =[[EMVIOiOSBridge alloc]initwith:self.context];
}
-(IBAction)testaction
{
    JSValue *function=[self.context objectForKeyedSubscript:@"OnClicked"];
    [function callWithArguments:nil];
    
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
