//
//  ViewController.m
//  SlyceFrameworkdemo
//
//  Created by chris on 03/02/2017.
//  Copyright © 2017 chris. All rights reserved.
//

#import "ViewController.h"
#import <Call1/Call1.h>
#import "ResultViewController.h"
#import "FileControl+Recorder.h"
#import "WebViewController.h"
#define CCSALE @"CCSALE"
#define CCRETURN @"CCRETURN"
//cardflight
#define CFSALE @"CFSALE"
#define CFRETURN @"CFRETURN"
#define CFAUTH @"CFAUTH"
#define CFCAPTURE @"CFCAPTURE"
//usaepay
#define UPSALE    @"UPSALE"
#define UPRETURN  @"UPRETURN"
#define UPAUTH    @"UPAUTH"
@interface ViewController ()<UITextFieldDelegate>
@property (nonatomic,retain) CallOne * call1;
@property (nonatomic,retain) NSArray * PinPads;
@property (nonatomic,retain)FileControl * file;
@property NSInteger selectedIndex;
@end

@implementation ViewController
@synthesize call1;
@synthesize demoProductionSwitch;
@synthesize initialLibbtn;
@synthesize salebtn;
@synthesize returnbtn;
@synthesize amountField;
@synthesize informationLabel;
@synthesize tokenField;
@synthesize connetPinBtn;
@synthesize selectPinPadBtn;
@synthesize messageLabel;
@synthesize authBtn;
@synthesize capBtn;
@synthesize cancelBtn;
@synthesize resultView;
@synthesize file;
@synthesize selectedIndex;
@synthesize logfileSwitch;

#pragma mark view operations
- (void)viewDidLoad {
    [super viewDidLoad];
    

//set all components disabled
 //self.navigationController = [[UINavigationController alloc] init];
    //NSLog(@"%@",[CallOne Version]);
    [self initComponents];
    self.title=@"cmsdemo";
    if(self.navigationController)
    {
        NSLog(@"ddd");
    }
    file = [[FileControl alloc]init];
    [file deleteFile:@"Records" theFile:CCRETURN];
    [file deleteFile:@"Records" theFile:CFRETURN];
    [file createRecordFile:CCSALE];
    [file createRecordFile:CCRETURN];
    [file createRecordFile:CFSALE];
    [file createRecordFile:CFRETURN];
    [file createRecordFile:CFAUTH];
    [file createRecordFile:CFCAPTURE];
    [file createRecordFile:UPSALE];
    [file createRecordFile:UPRETURN];
    [file createRecordFile:UPAUTH];
    [self processTokenfile];
   
    
    //[file removedRecord:1 fromFile:UPSALE];
    //[self showResult:@"ttt"];
   
    //NSLog(@"%@",res);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) processTokenfile
{
    @try {
        NSString * res=[file readFile:@"" atFile:@"CMSTokens.txt"];
        NSDictionary *tokendic= [file StringToDictionary2:res];
        NSArray *tokenarray=[tokendic objectForKey:@"CMSTokens"];
        UIAlertController* inforAlert = [UIAlertController alertControllerWithTitle:@"CMS Token List"
                                                                            message:@"Please Select Token" preferredStyle:UIAlertControllerStyleAlert];

        for (NSDictionary *token in tokenarray)
        {
            
            UIAlertAction* okAction = [UIAlertAction actionWithTitle:[token objectForKey:@"Token"] style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 [tokenField setText:[token objectForKey:@"Token"]];
                                                                  if ([[token objectForKey:@"Production"] isEqualToString:@"True"])
                                                                  {
                                                                      [demoProductionSwitch setOn:YES];
                                                                  }
                                                                 [self initbtnClicked:nil];}];
            [inforAlert addAction:okAction];
        }
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {}];
        [inforAlert addAction:cancelAction];
         [self presentViewController:inforAlert animated:YES completion:nil];
        
        
    } @catch (NSException *exception) {
        NSLog(@"no token");
    }

    
    
}

-(IBAction)getSwitch
{
    
    [call1 setfilemode: logfileSwitch.on];
    [call1 setLogMode:logfileSwitch.on];
    [call1 setProduction:demoProductionSwitch.on];
}
-(void)connectPinPad
{
    NSError * error;

    [call1 connectPinPad:&error];
    if (error)
    {
        if(error.code ==CALLTMSUpdateRequired)
        {
           [ call1 APPLog:@" connectPinPad %lld",(long long)error.code ];
            dispatch_async(dispatch_get_main_queue(), ^{
            [self updateInformationLabel:[NSString stringWithFormat:@" connectPinPad %lld",(long long)error.code]];
            [self updateInformationLabel:@"Trying TMS update"];});
            [call1 TMSupdate:&error];
            [call1 APPLog:@"TMSupdate  error %lld",(long long)error.code];
        }
        else
        {
            [self ErrorAlert:error.description];
        }
    }
}

#pragma mark delgates functions
-(void)initialisCompleted:(BOOL)ready withError:(NSError*)error
{
    
    NSLog(@"APP Completed %@",error.description);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error.code != 0)//if error is rather than 0 then the init if failed
        {
            [self ErrorAlert:@"init failed"];
            [self updateInformationLabel:[NSString stringWithFormat:@"init Error %lld",(long long)error.code]];
            return;
        }
        [self updateInformationLabel:@"Initialzation Completed"];
        if ([error isEqual:nil]||error.code==0)
        {
            [self enableDevice];
            
        }
    });
    
}

-(void)TMSupdateComplete:(NSError*)error
{
    [call1 APPLog:@"TMSupdateComplete Completed"];
    [self updateInformationLabel:@"TMS update Completed"];
    if(error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
        [self updateInformationLabel:[NSString stringWithFormat:@"Error %lld",(long long)error.code]];
        });
        [call1 APPLog:@" TMSupdateComplete %lld",(long long)error.code];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateInformationLabel:@"Try Connect Pin Pad"];});
    [call1 connectPinPad:&error];
    if(error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
        [self updateInformationLabel:[NSString stringWithFormat:@" connectPinPad2 %lld",(long long)error.code]];
        });
        [call1 APPLog:@" connectPinPad2 %lld",(long long)error.code];
    }

}
-(void)PinpadconnectionComplete:(NSError*)error
{
     //[self updateInformationLabel:@"PinpadconnectionComplete"];//if error is null, application is ready for the transactions
    if(error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
        [self updateInformationLabel:[NSString stringWithFormat:@" PinpadconnectionComplete %lld",(long long)error.code]];
        });
        [call1 APPLog:@" PinpadconnectionComplete %lld",(long long)error.code];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
    [self enableTransaction];
    });

}

-(void)transAuthorizationCompleted:( NSDictionary *)resultDict
{
    //transaction complete

[call1 APPLog:@"%@",resultDict.description];
    if([resultDict objectForKey:@"error"] ==nil)
    {
        resultView=[[ResultViewController alloc]init];
        resultView.result=@"APPROVED";
        NSString *cardinfostr =[resultDict objectForKey:@"Cardinfo"];
        NSDictionary *carddict=[self dictionaryWithJsonString:cardinfostr];
        
        resultView.card=[NSString stringWithFormat:@"**************%@",[carddict objectForKey:@"Last4"]];
        resultView.reference=[resultDict objectForKey:@"AuthCode"];
        resultView.amount=[NSString stringWithFormat:@"%@", [resultDict objectForKey:@"Amount"] ];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:resultView animated:YES];
            if([call1.currentModule isEqualToString:@"CALLAudio"])
            {
                 [file addRecord:resultDict fromFile:CFAUTH];
            }
            else
            {
                 [file addRecord:resultDict fromFile:UPAUTH];
            }
           
        });
    }
    else
    {
        resultView=[[ResultViewController alloc]init];
        resultView.result=@"Decliend";
        dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:resultView animated:YES];
        });
    }

    
    
}
-(void)transactionSaleCompleted:( NSDictionary *)resultDict
{
    //transaction complete
    [call1 APPLog:@"APP sale completed %@",resultDict.description];
    @try {
        NSString *jsonString = [file dictionaryToString:resultDict];
        [call1 APPLog:@"APP sale JSON %@",jsonString];
    } @catch (NSException *exception) {
          [call1 APPLog:@"APP sale exception %@",exception.description];
    }
    if([resultDict objectForKey:@"error"] ==nil)
    {
    resultView=[[ResultViewController alloc]init];
    resultView.result=@"APPROVED";
        if([resultDict objectForKey:@"Cardinfo"]!=nil)
        {
            NSString *cardinfostr =[resultDict objectForKey:@"Cardinfo"];
            NSDictionary *carddict=[self dictionaryWithJsonString:cardinfostr];
            resultView.card=[NSString stringWithFormat:@"**********%@",[carddict objectForKey:@"Last4"]];
        }
        else
        {
            resultView.card= [resultDict objectForKey:@"MaskPan"];
        }
    resultView.reference=[resultDict objectForKey:@"AuthCode"];
    resultView.amount=[NSString stringWithFormat:@"%@", [resultDict objectForKey:@"Amount"] ];
        dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:resultView animated:YES];
        });
        if([[resultDict objectForKey:@"Module"] isEqualToString:@"M-10"])
        {
            [file addRecord:resultDict fromFile:CCSALE];
        }
        else if([[resultDict objectForKey:@"Module"] isEqualToString:@"CALLAudio"])
        {
             [file addRecord:resultDict fromFile:CFSALE];
        }else if([[resultDict objectForKey:@"Module"] isEqualToString:@"MP200"])
        {
            [file addRecord:resultDict fromFile:UPSALE];
        }
        
        
    }
    else
    {
         resultView=[[ResultViewController alloc]init];
        resultView.result=@"Decliend";
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:resultView animated:YES];
        });
    }
}

-(void)verifySignature:(BOOL) notifyflg
{
    UIAlertController* inforAlert = [UIAlertController alertControllerWithTitle:@"Processing Sale"
                                                                        message:@"Please Verify Signature" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         [call1 signatureVerified:YES];

                                                         
                                                     }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                             [call1 signatureVerified:NO];

                                                             
                                                         }];
    [inforAlert addAction:okAction];
    [inforAlert addAction:cancelAction];
    dispatch_async(dispatch_get_main_queue(), ^{
          [self presentViewController:inforAlert animated:YES completion:nil];
    });
  
}
-(void)transactionReturnCompleted:(NSDictionary *)resultDict
{
 [call1 APPLog:@"return APP %@",resultDict];
    [call1 APPLog:@"%@",[resultDict objectForKey:@"Transtype"]];

    dispatch_async(dispatch_get_main_queue(), ^{
        if ([resultDict objectForKey:@"error"] ==nil)
        {
            if([call1.currentModule isEqualToString:@"CALLAudio"])
            {
                [file removedRecord:selectedIndex fromFile:CFSALE];
                [file addRecord:resultDict fromFile:CFRETURN];
            }else if([call1.currentModule isEqualToString:@"MP200"])
            {
                [file removedRecord:selectedIndex fromFile:UPSALE];
                [file addRecord:resultDict fromFile:UPRETURN];
            }else
            {
                [file removedRecord:selectedIndex fromFile:CCSALE];
                [file addRecord:resultDict fromFile:CCRETURN];
            }
            [self showResult:@"Return SUCCESS"];
        }
        else
        {
              [self showResult:@"Retun FAILED"];
        }
     
    });
    
}
-(void)transactionCaptureCompleted:(NSDictionary *)resultDict
{
   [call1 APPLog:@"APP capture %@",resultDict];
    if ([resultDict objectForKey:@"error"] ==nil)
    {
        if([call1.currentModule isEqualToString:@"CALLAudio"])
        {
            [file removedRecord:selectedIndex fromFile:CFAUTH];
            [file addRecord:resultDict fromFile:CFSALE];
        }else if([call1.currentModule isEqualToString:@"MP200"])
        {
            [file removedRecord:selectedIndex fromFile:UPAUTH];
            [file addRecord:resultDict fromFile:UPSALE];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
        [self showResult:@"Capture SUCCESS"];
        });
    }
    else
    {   dispatch_async(dispatch_get_main_queue(), ^{
        [self showResult:@"Capture FAILED"];
    });
    }

}
-(void) transactionMessageUpdate:(NSString *)msg
{
   messageLabel.text= [NSString stringWithFormat:@"%@\r%@",messageLabel.text,msg];
}
-(void) voiceReferral:(BOOL)notifyflg withphone:(NSString *)phoneNumber
{
    NSString *msgTitle=[NSString stringWithFormat:@"Please Call %@",phoneNumber];

    UIAlertController* inforAlert = [UIAlertController alertControllerWithTitle:msgTitle
                                                                        message:@"Please Enter AuthCode" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         UITextField *infoTextfield= inforAlert.textFields.firstObject;
                                                             [call1 phoneReferral:YES withAuthcode:infoTextfield.text];
                                                         
                                                     }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         
                                                         [call1 phoneReferral:NO withAuthcode:@""];
                                                         
                                                     }];

    [inforAlert addTextFieldWithConfigurationHandler:^(UITextField* textfield){}];
    [inforAlert addAction:okAction];
    [inforAlert addAction:cancelAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:inforAlert animated:YES completion:nil];
    });

}

/**
 when pin pad is disconnected, all the function must be disabled
 */
-(void) Pinpaddisattached
{
    [self disableAll];
}
-(void)Pinpadattached
{
    [call1 APPLog:@" pinpad attached"];
    [self enableDevice];
    //call1=[[CallOne alloc] initwith:@"cem_123" fromServer:nil Delegate:self];
    //[call1 setLogMode:YES];
}
-(void)confirmCardinfo:(NSDictionary *)cardinfo
{
    NSLog( @"LOL crad %@",cardinfo.description);
    //[call1 cardinfoConfirmed:YES];
    NSString * card=[NSString stringWithFormat:@"%@*******%@", [cardinfo objectForKey:@"first6"], [cardinfo objectForKey:@"last4"] ];
    [self confirmcard: card];
}

- (void)transactionVoidCompleted:(NSDictionary *)resultDict {
    [call1 APPLog:@"APP void %@",resultDict];
    if ([resultDict objectForKey:@"error"] ==nil)
    {
        
            [file removedRecord:selectedIndex fromFile:UPSALE];
            //[file addRecord:resultDict fromFile:UPSALE];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showResult:@"void SUCCESS"];
        });
    }
    else
    {   dispatch_async(dispatch_get_main_queue(), ^{
        [self showResult:@"void FAILED"];
    });
    }
}



#pragma mark textField delgate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * temper=textField.text;
    
    if ([string isEqualToString:@""])//enable remove
    {
        return YES;
    }
    temper=[self formatAmountStr:temper withInput:string];//processing ammount input
    textField.text=temper;
    return NO;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"%@",textField.text);
}
#pragma mark View operations

-(void)updateInformationLabel:(NSString *) content
{
    informationLabel.text= [NSString stringWithFormat:@"%@\r%@",informationLabel.text,content];
}

-(void) initComponents
{
    [amountField setEnabled:NO];
    [selectPinPadBtn setEnabled:NO];
    [connetPinBtn setEnabled:NO];
    [salebtn setEnabled:NO];
    [returnbtn setEnabled:NO];
    [cancelBtn setEnabled:NO];
    [authBtn setEnabled:NO];
    [capBtn setEnabled:NO];
    [amountField setDelegate:self];
}

-(void) enableDevice
{
    [selectPinPadBtn setEnabled:YES];
    [connetPinBtn setEnabled:YES];
}
-(void) enableTransaction
{
    [amountField setEnabled:YES];
    [salebtn setEnabled:YES];
    [returnbtn setEnabled:YES];
    [cancelBtn setEnabled:YES];
    [authBtn setEnabled:YES];
    [capBtn setEnabled:YES];
}
-(void) disableAll
{
    [amountField setEnabled:NO];
    [selectPinPadBtn setEnabled:NO];
    [connetPinBtn setEnabled:NO];
    [salebtn setEnabled:NO];
    [returnbtn setEnabled:NO];
    [cancelBtn setEnabled:NO];
    [authBtn setEnabled:NO];
    [capBtn setEnabled:NO];
}


#pragma mark Btn functions

-(IBAction)cnlBtnClicked:(id)sender
{
    
    [call1 terminateTransaction];
    
}
-(IBAction)voidBtnClicked:(id)sender
{
    
    NSString * filestr;
    if([call1.currentModule isEqualToString:@"MP200"])
    {
        filestr=[file readFile:@"Records" atFile:UPSALE];
    }else if([call1.currentModule isEqualToString:@"Miura 125"]){
         filestr=[file readFile:@"Records" atFile:CCSALE];
    }
    else
    {
        return;
    }
    if([filestr isEqual:[NSNull null]]||filestr==nil)
    {
        return;
    }
    
    NSDictionary *filedic= [file StringToDictionary:filestr];
    NSArray *recordsArray= [filedic objectForKey:@"data"];
    UIAlertController* inforAlert = [UIAlertController alertControllerWithTitle:@"Processing void" message:@"please select Transaction"   preferredStyle:UIAlertControllerStyleAlert];
    NSInteger counter=0;
    for (NSDictionary *res in recordsArray)
    {
        
        NSString * cardinfostr = [res objectForKey:@"Cardinfo"];
        if(cardinfostr==nil)
        {
            return;
        }
        NSDictionary * cardinfo = [file StringToDictionary:cardinfostr];
        NSString * title=[NSString stringWithFormat:@"%@*******%@,%@,%@",[cardinfo objectForKey:@"First6"],[cardinfo objectForKey:@"Last4"], [res objectForKey:@"AuthCode"],[res objectForKey:@"AuthorizedAmount"]];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //result=@"ok"
                                                             NSError *error;
                                                             
                                                             selectedIndex = counter;
                                                             NSDictionary *paymentInfo= [self buildDictforrtn:[res objectForKey:@"Reference"] withCurrency:@"USD" andAmount:[res objectForKey:@"AuthorizedAmount"] cardinfo:cardinfostr];
                                                             [call1 processVoid:paymentInfo withError:&error];
                                                             messageLabel.text=@" ";
                                                             [call1 APPLog:@"return is selected %@",paymentInfo.description ];
                                                             if (error)
                                                             {
                                                                 NSString * msg= [NSString stringWithFormat:@"return error %@",error.description];
                                                                 [self showResult:msg];
                                                             }
                                                             
                                                         }];
        [inforAlert addAction:okAction];
        counter ++;
        
        
    }
    
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                             //result=@"cancel"
                                                             
                                                         }];
    
    [inforAlert addAction:cancelAction];
    
    [self presentViewController:inforAlert animated:YES completion:nil];
    
    
}
-(IBAction)rtnBtnClicked:(id)sender
{
    NSString * filestr;
    if([call1.currentModule isEqualToString:@"CALLAudio"])
    {
        filestr = [file readFile:@"Records" atFile:CFSALE];
    }else if([call1.currentModule isEqualToString:@"Miura 125"])
    {
        filestr= [file readFile:@"Records" atFile:CCSALE];
    }else if([call1.currentModule isEqualToString:@"MP200"])
    {
        filestr=[file readFile:@"Records" atFile:UPSALE];
    }
    else{
        return;
    }
    if([filestr isEqual:[NSNull null]])
    {
        return;
    }
    
    NSDictionary *filedic= [file StringToDictionary:filestr];
    NSArray *recordsArray= [filedic objectForKey:@"data"];
    UIAlertController* inforAlert = [UIAlertController alertControllerWithTitle:@"Processing Return" message:@"please select Transaction"   preferredStyle:UIAlertControllerStyleAlert];
    NSInteger counter=0;
    for (NSDictionary *res in recordsArray)
    {
        
        NSString * cardinfostr = [res objectForKey:@"Cardinfo"];
        NSDictionary * cardinfo = [file StringToDictionary:cardinfostr];
        NSString * title=[NSString stringWithFormat:@"%@*******%@,%@,%@",[cardinfo objectForKey:@"First6"],[cardinfo objectForKey:@"Last4"], [res objectForKey:@"AuthCode"],[res objectForKey:@"AuthorizedAmount"]];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //result=@"ok"
                                                             NSError *error;
                                                             
                                                             selectedIndex = counter;
                                                             NSDictionary *paymentInfo= [self buildDictforrtn:[res objectForKey:@"Reference"] withCurrency:@"USD" andAmount:[res objectForKey:@"AuthorizedAmount"] cardinfo:cardinfostr];
                                                             [call1 processReturn:paymentInfo withError:&error];
                                                             messageLabel.text=@" ";
                                                             [call1 APPLog:@"return is selected %@",paymentInfo.description ];
                                                             if (error)
                                                             {
                                                                 NSString * msg= [NSString stringWithFormat:@"return error %@",error.description];
                                                                 [self showResult:msg];
                                                             }
                                                             
                                                         }];
        [inforAlert addAction:okAction];
        counter ++;
        
        
    }
    
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                             //result=@"cancel"
                                                             
                                                         }];
    
    [inforAlert addAction:cancelAction];
    
    [self presentViewController:inforAlert animated:YES completion:nil];
    
    
    
}
-(IBAction)capBtnClicked:(id)sender
{
    
    //[call1 processCapture:paymentInfo withError:&error];
    if([amountField.text isEqualToString:@"0.00"]||amountField.text.length==0)
    {
        [self ErrorAlert:@"Enter Amount First"];
    }
    else{
        NSString *    filestr;
        if([call1.currentModule isEqualToString:@"CALLAudio"])
        {
            filestr = [file readFile:@"Records" atFile:CFAUTH];
        }else if([call1.currentModule isEqualToString:@"MP200"])
        {
            filestr = [file readFile:@"Records" atFile:UPAUTH];
        }
        NSDictionary *filedic= [file StringToDictionary:filestr];
        NSArray *recordsArray= [filedic objectForKey:@"data"];
        UIAlertController* inforAlert = [UIAlertController alertControllerWithTitle:@"Processing Capture" message:@"please select Transaction"   preferredStyle:UIAlertControllerStyleAlert];
        NSInteger counter=0;
        for (NSDictionary *res in recordsArray)
        {
            NSString *cardinfostr= [res objectForKey:@"Cardinfo"];
            NSLog(@"%@",cardinfostr);
            NSDictionary * cardinfo = [file StringToDictionary:cardinfostr];
            NSString * title=[NSString stringWithFormat:@"%@*******%@,%@",[cardinfo objectForKey:@"First6"],[cardinfo objectForKey:@"Last4"], [res objectForKey:@"AuthCode"]];
            UIAlertAction* okAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 //result=@"ok"
                                                                 NSError *error;
                                                                 
                                                                 selectedIndex = counter;
                                                                 NSDictionary *paymentInfo=[self buildDictforcap:[res objectForKey:@"Reference"] withAmount:amountField.text andCardinfo:cardinfo]; //[self buildDictforrtn:[res objectForKey:@"AuthCode"] withCurrency:@"USD" andAmount:[res objectForKey:@"AuthorizedAmount"]];
                                                                 [call1 processCapture:paymentInfo withError:&error];
                                                                 messageLabel.text=@" ";
                                                                 if(error)
                                                                 {
                                                                     [call1 APPLog:@" processCapture Error:%lld",(long long)error.code];
                                                                     return ;
                                                                 }
                                                                 
                                                             }];
            [inforAlert addAction:okAction];
            counter ++;
            
            
        }
        
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 
                                                                 //result=@"cancel"
                                                                 
                                                             }];
        
        [inforAlert addAction:cancelAction];
        
        [self presentViewController:inforAlert animated:YES completion:nil];
        
        
        /*UIAlertController* inforAlert = [UIAlertController alertControllerWithTitle:@"Processing capture" message:@"please enter the reference"   preferredStyle:UIAlertControllerStyleAlert];
         
         
         
         [inforAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
         
         
         }];
         UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
         handler:^(UIAlertAction * action) {
         //result=@"ok"
         NSError *error;
         NSLog(@"%@",inforAlert.textFields.firstObject.text);
         if(inforAlert.textFields.firstObject.text.length>0&&amountField.text.length>0)
         {
         NSDictionary *paymentInfo = [self buildDictforcap:inforAlert.textFields.firstObject.text withAmount:amountField.text];
         [call1 processCapture:paymentInfo withError:&error];
         messageLabel.text=@" ";
         }
         
         }];
         UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
         handler:^(UIAlertAction * action) {
         
         //result=@"cancel"
         
         }];
         [inforAlert addAction:okAction];
         [inforAlert addAction:cancelAction];
         
         [self presentViewController:inforAlert animated:YES completion:nil];
         
         messageLabel.text=@" ";*/
    }
}

-(IBAction)saleBtnClicked:(id)sender
{
    
    messageLabel.text=@"";
    NSError *error;
    [amountField resignFirstResponder];
    
    if([amountField.text isEqualToString:@"0.00"]||amountField.text.length==0)
    {
        [self ErrorAlert:@"Enter Amount First"];
    }
    else{
        [informationLabel setText:@"start Transaction:"];
        NSDictionary *saleDict=[self buildSaleDict:amountField.text withTender:@"credit"];
        [call1 processSale:saleDict withError:&error];
        if(error)
        {
            [call1 APPLog:@" processSale Error:%lld",(long long)error.code];
            return ;
        }
        [self updateInformationLabel:@"Please Swipe/dip Card"];
    }
    
}
-(IBAction)authBtnClicked:(id)sender
{
    messageLabel.text=@"";
    NSError *error;
    [amountField resignFirstResponder];
    
    if([amountField.text isEqualToString:@"0.00"]||amountField.text.length==0)
    {
        [self ErrorAlert:@"Enter Amount First"];
    }
    else{
        [informationLabel setText:@"start Transaction:"];
        NSDictionary *authDict=[self buildAuthDict:amountField.text withTender:@"credit"];
        [call1 processAuthorization:authDict withError:&error];
        if(error)
        {
            [call1 APPLog:@" processAuth Error:%lld",(long long)error.code];
            
            return ;
        }
        [self updateInformationLabel:@"Please Swipe/dip Card"];
    }
    
}
-(IBAction)selectPinPadClicked:(id)sender
{
    NSArray * devlise=[call1 getPinpadList];
    if ([devlise count]==0)
    {
        [self ErrorAlert:@"No Pinpad"];
        return;
    }
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"DeviceList"
                                                                   message:@"Please Select one"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    NSInteger counter=0;
    for(counter=0;counter<[devlise count];counter++)
        
    {
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:[devlise objectAtIndex:counter] style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  NSError * err;
                                                                  [call1 selectPinPad:[devlise objectAtIndex:counter] configurationError:&err];
                                                              }];
        
        [alert addAction:defaultAction];
    }
    [self presentViewController:alert animated:YES completion:nil];
}
-(IBAction)connectPinpadClicked:(id)sender
{
    [self connectPinPad];
}
-(IBAction)textFiledReturnEditing:(id)sender {
    [sender resignFirstResponder];
}

-(IBAction)initbtnClicked:(id)sender
{
    informationLabel.text=@"";
    [self updateInformationLabel:@"Start"];
    //tokenField.text=@"phQP9iBIEgl4nEFi8vQmFf25q6m8PieC";//creditcall
    //tokenField.text=@"JHjBXXjnC0FIHTTmweKrVsA797FPlJLj";//cardflight
    //tokenField.text=@"teiU6f4zf6dBx9oGDKx4bBxOqmADhAWG";//USEAEPAY
    //tokenField.text=@"2l588Thtu6dfFamFKg4JAYCn5XlUzqoC";//USAEPAyLive
    tokenField.text=@"1FgJZnjTAfBVi3fWysrnPpxIdGxTfNls";//creditcall
    //tokenField.text=@"3fyl02KZBOERy7yEd6SkWqbuYmGqHQ2T";//cardflight;
    //tokenField.text=@"1FgJZnjTAfBVi3fWysrnPpxIdGxTfNls";//creditcall
    if([tokenField.text isEqual:[NSNull null]]||tokenField.text.length==0)
    {
        [self updateInformationLabel:@"Enter CMS Token Please"];
        
        return;
    }
    //call1 =[[CallOne alloc] initwith:tokenField.text fromServer:@"https://api-staging.slycepay.com" Delegate:self];
    call1 =[[CallOne alloc] initwith:tokenField.text fromServer:@"" Delegate:self];
    
    //[call1 setProduction:demoProductionSwitch.on];
    [call1 setfilemode:NO];
    [call1 setLogMode:YES];
    [tokenField resignFirstResponder];
    
    //NSArray *valuearray=[[NSArray alloc] initWithObjects:@"CardFlight",@"b6c934bb9ea45e8d6f8437ba872f40e1",@"acc_d8caa1cc6d2c76d2", nil];//testing merchant stripe only
    //NSArray *valuearray=[[NSArray alloc] initWithObjects:@"CardFlight",@"6ca7f625be6d03a5e97d9d914213c519",@"acc_fc0cfe7ab2cc7df1", nil];
    
    //card flight testing code
    /*[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ROOT_API_URL"];//testing api
     NSArray *keyarray= [[NSArray alloc]initWithObjects:CALLMODULE,CALLAPITOKEN,CALLACCOUNTTK, nil];
     NSArray *valuearray=[[NSArray alloc] initWithObjects:@"CardFlight",@"b6c934bb9ea45e8d6f8437ba872f40e1",@"acc_ba9e59cba758af66", nil];//testing merchant with emv
     NSDictionary * initDict= [[NSDictionary alloc]initWithObjects:valuearray forKeys:keyarray];
     call1 = [[CallOne alloc] initwith:initDict andDelegate:self];*/
    NSLog(@"%@",  [[NSUserDefaults standardUserDefaults] objectForKey:@"ROOT_API_URL" ]);
    
    
}

-(void)confirmcard: (NSString *) cardinfo
{
    UIAlertController* confirmAlert = [UIAlertController alertControllerWithTitle:@"Please confirm Card"
                                                                          message:cardinfo
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          [call1 cardinfoConfirmed:YES];
                                                      }];
    UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         [call1 cardinfoConfirmed:NO];
                                                     }];
    
    [confirmAlert addAction:yesAction];
    [confirmAlert addAction:noAction];
    
    [self presentViewController:confirmAlert animated:YES completion:nil];
    
}




#pragma mark Utilis
-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"jsonfailure：%@",err);
        return nil;
    }
    return dic;
}
- (BOOL)validInput:(NSString*)inputstr {
    
    if (inputstr.length == 0)  //delete operation
        return YES;
    
    int asciiCode = [inputstr characterAtIndex:0];
    
    if (asciiCode >= 48 && asciiCode <= 57)
        return YES;
    else
        return NO;
}
-(NSString *) formatAmountStr: (NSString *) basicAmt withInput:(NSString*) input
{
    NSString * temper=basicAmt;
    NSString * header;
    NSString * tail;
    
    if ([self validInput:input])
    {
        temper =[temper stringByAppendingString:input];
        NSRange r= [temper rangeOfString:@"."];
        NSLog(@" r %ld",(long)r.location );
        if (r.location<temper.length)
        {
            temper = [temper stringByReplacingCharactersInRange:r withString:@""];
        }
        NSInteger i= [temper intValue];
        NSLog(@" ri %ld",(long)i );
        temper = [NSString stringWithFormat:@"%ld",(long)i];
        switch (temper.length) {
            case 0:
                return temper;
                break;
            case 1:
                temper =[NSString stringWithFormat:@"0.0%@",temper];
                
                break;
            case 2:
                temper =[NSString stringWithFormat:@"0.%@",temper];
                break;
            default:
                header= [temper substringToIndex:temper.length-2];
                tail =[temper substringFromIndex:temper.length-2];
                temper=[NSString stringWithFormat:@"%@.%@",header,tail];
                break;
        }
        
        return temper;
        
    }
    return temper;
}

-(NSDictionary*) buildSaleDict:(NSString*) amount withTender:(NSString*) tender
{
    NSString* amountValue= [amount stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSArray *key=[[NSArray alloc] initWithObjects:@"Amount",@"Tender", nil];
    NSArray *value= [[NSArray alloc] initWithObjects:amountValue,tender,nil];
    NSDictionary *t=[[NSDictionary alloc]initWithObjects:value forKeys:key];
    
    return t;
}
-(NSDictionary*) buildAuthDict:(NSString*) amount withTender:(NSString*) tender
{
    NSString* amountValue= [amount stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSArray *key=[[NSArray alloc] initWithObjects:@"Amount",@"Tender", nil];
    NSArray *value= [[NSArray alloc] initWithObjects:amountValue,tender,nil];
    NSDictionary *t=[[NSDictionary alloc]initWithObjects:value forKeys:key];
    
    return t;
}
-(NSDictionary*) buildDictforrtn:(NSString*) referencestr withCurrency:(NSString*)currency andAmount:(NSString*)amount cardinfo:(NSString*) card
{
    
    
    NSArray *key=[[NSArray alloc] initWithObjects:@"Reference",@"currency",@"description", @"Tender",@"Amount",@"Cardinfo",nil];
    NSArray *value= [[NSArray alloc] initWithObjects:referencestr,currency,@"",@"credit",amount,card,nil];
    NSDictionary *t=[[NSDictionary alloc]initWithObjects:value forKeys:key];
    
    return t;
}

-(NSDictionary*) buildDictforcap:(NSString*) referencestr withAmount:(NSString*)amount andCardinfo:(NSDictionary*)dic
{
    NSString* amountValue= [amount stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    
    NSArray *key=[[NSArray alloc] initWithObjects:@"Reference",@"Amount",@"description",@"Cardinfo", nil];
    NSArray *value= [[NSArray alloc] initWithObjects:referencestr,amountValue,@"",[file dictionaryToString:dic],nil];
    NSDictionary *t=[[NSDictionary alloc]initWithObjects:value forKeys:key];
    
    
    return t;
}

-(void) showResult:(NSString *) message
{
    UIAlertController* errorAlert = [UIAlertController alertControllerWithTitle:@"Result"
                                                                        message:message
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                     }];
    
    [errorAlert addAction:okAction];
    
    [self presentViewController:errorAlert animated:YES completion:nil];
    
}

-(void)ErrorAlert: (NSString *) message
{
    UIAlertController* errorAlert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                        message:message
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                     }];
    
    [errorAlert addAction:okAction];
    
    [self presentViewController:errorAlert animated:YES completion:nil];
    
}

-(IBAction)clearlogs:(id)sender
{
    //[call1 RSAtest];
    [call1 ClearLog];
}
-(IBAction)toWebView:(id)sender
{
    WebViewController * webviewcontroller= [[WebViewController alloc]init];
    [self presentViewController:webviewcontroller animated:YES completion:nil];
}



@end
