//
//  SlyceOne.h
//  Slyce1
//
//  Created by chris on 03/02/2017.
//  Copyright © 2017 chris. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Call1.h"
#import "CallOneTransResponse.h"
@protocol CallOneDelegate <NSObject>

@required
-(void)initialisCompleted:(BOOL)ready withError:(NSError*)error;
-(void)TMSupdateComplete:(NSError*)error;
-(void)PinpadconnectionComplete:(NSError*)error;
-(void)transactionSaleCompleted:( NSDictionary *)resultDict;
-(void)transAuthorizationCompleted:( NSDictionary *)resultDict;
-(void)transactionReturnCompleted:( NSDictionary *)resultDict;
-(void)transactionCaptureCompleted:( NSDictionary *)resultDict;
-(void)transactionVoidCompleted:( NSDictionary *)resultDict;
-(void)verifySignature:(BOOL) notifyflg;
-(void)voiceReferral:(BOOL) notifyflg withphone:(NSString *) phoneNumber;
@optional
-(void)confirmCardinfo:(NSDictionary *)cardinfo;
-(void)Pinpaddisattached;
-(void)Pinpadattached;
-(void)transactionMessageUpdate:(NSString *) msg;
-(void)EMVApplicationList:(NSArray *)applications;

@end


@interface CallOne : NSObject
@property (nonatomic, assign) id <CallOneDelegate> SLYDelegate;
@property (nonatomic,retain)NSString * currentModule;


+ (NSString *)CMSversion;
-(id)initwith:(NSDictionary *)initDict andDelegate:(id<CallOneDelegate>)delegates;
-(id)initwith:(NSString *)token fromServer:(NSString *)serverURL Delegate:(id<CallOneDelegate>) delegates;
-(NSArray*) getPinpadList;
-(void)selectPinPad:(NSString *)pinpadName configurationError:(NSError **)error;
-(void)connectPinPad:(NSError **)error;
-(void)TMSupdate:(NSError**) error;
-(void)setLogMode:(BOOL)logmode;//*
-(void)setProduction:(BOOL)promode;
-(void) setfilemode:(BOOL)filemode;
-(BOOL)getProduction;
-(void) APPLog:(NSString *) content, ...;
-(void) ClearLog;


-(void)processSale:( NSDictionary *)transDict withError:(NSError**)error;
-(void)signatureVerified:(BOOL)result;
-(void)phoneReferral:(BOOL)result withAuthcode:(NSString*) authcode;
-(void)processReturn:( NSDictionary *)transDict withError:(NSError**)error;
-(void)processAuthorization:( NSDictionary *)transDict withError:(NSError**)error;
-(void)processCapture:( NSDictionary *)transDict withError:(NSError**)error;
-(void)terminateTransaction;
-(void)cardinfoConfirmed:(BOOL)confirm;
-(void)applicationSelected:(NSInteger)selection;
-(void)processVoid:(NSDictionary *)transDict withError:(NSError **)error;




@end
