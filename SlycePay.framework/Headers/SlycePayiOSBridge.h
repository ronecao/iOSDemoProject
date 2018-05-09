//
//  NexioniOSBridge
//  Slyce1
//
//  Created by Chris on 26/10/2017.
//  Copyright © 2017 chris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <UIKit/UIKit.h>
#import "SlycePay.h"
@protocol TestJSExport <JSExport>
-(void)initframework:(NSString*)value;

-(void)processsale:(NSString*)transdict;
-(void)processauthorize:(NSString*)transdict;
-(void)processcapture:(NSString*)transdict;
-(void)processvoid:(NSString*)transdict;
-(void)processreturn:(NSString*)transdict;
-(void)phonereferral:(NSString*)transdict;
-(void)confirmcardinforesult:(NSString*)transdict;
-(void)getpinpads;
-(void)selectpinpad:(NSString*) name;
-(void)connectpinpad;
-(void)tmsupdate;
-(void)signatureverified:(NSString*)result;


@end
@interface SlycePayiOSBridge : NSObject
-(id)initwith:(JSContext*)conttext;

@end
