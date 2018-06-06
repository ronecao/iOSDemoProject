//
//  SlyceOne.h
//  Slyce1
//
//  Created by chris on 03/02/2017.
//  Copyright © 2017 chris. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FileControl.h"
#import "SlycePayiOSBridge.h"
#define SLYCEPAYMODULE @"Module"
#define SLYCEPAYTID @"passkey"
#define SLYCEPAYTK @"passkey2"
#define SLYCEPAYID @"ApplicationId"
#define SLYCEPAYAPITOKEN @"login"
#define SLYCEPAYACCOUNTTK @"passkey"


//! Project version number for Slyce1.
FOUNDATION_EXPORT double SLYCEPAYVersionNumber;

//! Project version string for Slyce1.
FOUNDATION_EXPORT const unsigned char SLYCEPAYVersionString[];

typedef NS_ENUM(NSInteger, SLYCEPAYInitDictERROR) {
    SLYCEPAYInitDictERRORNOError=0,
    SLYCEPAYInitDictERRORNOModule= -1,
    SLYCEPAYInitDictERRORNOAPPID =-2,
    SLYCEPAYInitDictERRORNOTID=-3,
    SLYCEPAYInitDictERRORNOTK =-4,
    SLYCEPAYInitDictERRORNOAPITOKEN =-5,
    SLYCEPAYInitDictERRORNOACCOUNT =-6
};
/*/**
 * @typedef TransactionErrorCode
 *
 * The possible error codes  that can be returned when a transaction is terminated.
 */

typedef NS_ENUM(NSInteger, SLYCEPAYERRORList) {
    SLYCEPAYERRORListNOError=0,
    SLYCEPAYNOPUBKEYERROR                           = -8001,
    SLYCEPAYERRORListinitHTTPError                  = -9001,
    SLYCEPAYERRORListinitHTTPNONetwork              = -9002,
    SLYCEPAYERRORListUnknow                         = 5001,
    SLYCEPAYApplicationUpdateRequired               = 1001,   /**< (1001) The current version of software is invalid and an update is required. */
    SLYCEPAYInvalidHomeNetworkIdentity              = 1004,   /**< (1004) The Home Network Identity (HNI) is invalid. */
    SLYCEPAYTerminalDisabled                        = 1005,   /**< (1005) The terminal is disabled. */
    SLYCEPAYTransactionTypeNotSupported             = 1006,   /**< (1006) The type of transaction is not supported by the terminal. */
    SLYCEPAYNoCompletedTransaction                  = 1007,   /**< (1007) A transaction has not been completed. */
    SLYCEPAYAnotherOperationBeingProcessed          = 1008,   /**< (1008) Another operation is being processed. */
    SLYCEPAYPinPadAlreadyConnected                  = 1009,   /**< (1009) The PIN pad is already connected. */
    SLYCEPAYPinPadNotConnected                      = 1010,   /**< (1010) The PIN pad is not connected. */
    SLYCEPAYUpdateNotConfigured                     = 1011,   /**< (1011) The update has not been configured. */
    SLYCEPAYTMSUpdateRequired                       = 1012,   /**< (1012) An update from the TMS is required. */
    SLYCEPAYStandaloneRefundNotSupported            = 1013,   /**< (1013) Standalone refunds are not supported by the terminal. */
    SLYCEPAYLinkedRefundNotSupported                = 1014,   /**< (1014) Linked refunds are not supported by the terminal. */
    SLYCEPAYCashTransactionsNotSupported            = 1015,   /**< (1015) Cash transactions are not supported by this terminal. */
    SLYCEPAYChequeTransactionsNotSupported          = 1016,    /**< (1016) Cheque transactions are not supported by this terminal. */
    //1017
    SLYCEPAYGratuityNotSupported                    = 1018,    /**< (1018) Gratuity not supported. */
    SLYCEPAYCurrencyNotFound                        = 1019,    /**< (1019) Currency not found in configuration data. */
    SLYCEPAYCurrencyNotSet                          = 1020,    /**< (1020) Currency is not set. */
    SLYCEPAYCurrencyNotSupportedForPaymentMethod    = 1021,    /**< (1021) Currency is not supported for payment method. */
    SLYCEPAYEndOfDayTippingNotSupported             = 1022,    /**< (1022) End of Day Tipping is not supported */
    SLYCEPAYOnDeviceTippingNotSupported             = 1023,    /**< (1023) On Device Tipping is not supported */
    SLYCEPAYPinpadcheckrequired                     = 1024,    /**< (1024) A PIN pad check is required. */
    SLYCEPAYSREDKeyRequired                         = 1025,     /**< (1024) The SRED Key has failed to inject and is missing. */
    SLYCEPAYUnableToOpenURL                         = 3001,   /**< (3001) Unable to open the specified URL. */
    SLYCEPAYUnableToSpecifyCommunicationProtocol    = 3002,   /**< (3002) Unable to specify communication protocol. */
    SLYCEPAYUnableToSendRequest                     = 3003,   /**< (3003) Unable to send request. */
    SLYCEPAYUnableToGetHttpResponseCode             = 3004,   /**< (3004) Unable to retrieve HTTP response code. */
    SLYCEPAYUnsuccessfulHttpRequest                 = 3005,   /**< (3005) The response to the HTTP request was not equal to 200(OK). */
    SLYCEPAYUnableToReadResponse                    = 3006,   /**< (3006) Unable to read HTTP response data. */
    SLYCEPAYUnableToRetrieveResponse                = 3007,   /**< (3007) Unable to retrieve server response. */
    SLYCEPAYUnableToWriteRequestXml                 = 3008,   /**< (3008) Unable to write request XML. */
    SLYCEPAYUnableToParseResponseXml                = 3009,   /**< (3009) Unable to parse response XML. */
    SLYCEPAYUnableToReadResponseXml                 = 3010,   /**< (3010) Unable to read HTTP response data. */
    SLYCEPAYErrorParsingResponseXml                 = 3011,   /**< (3011) Error parsing response XML. */
    SLYCEPAYResponseXmlNotFound                     = 3012,   /**< (3012) Response XML not found. */
    SLYCEPAYEmptyPropertySet                        = 3013,   /**< (3013) No properties returned by TMS. */
    SLYCEPAYErrorParsingPropertyXML                 = 3014,   /**< (3014) Error parsing properties in Property element in response XML. */
    SLYCEPAYPinpadNotConfigured                     = 3015,   /**< (3015) PIN pad has not been configured for a configuration update from the TMS. */
    SLYCEPAYSpecifiedUrlMalformed                   = 3016,    /**< (3016) Specified URL is malformed. */
    SLYCEPAYDeviceNotPaired                         = 4001,   /**< (4001) The selected Bluetooth device is not paired. */
    SLYCEPAYBluetoothNotSupported                   = 4002,   /**< (4002) Bluetooth is not supported on this mobile device. */
    SLYCEPAYNoDeviceSelected                        = 4003,   /**< (4003) No supported Bluetooth device has been selected for connection. */
    SLYCEPAYConnectionFailed                        = 4004,   /**< (4004) Connection failed. */
    SLYCEPAYBluetoothNotEnabled                     = 4005,   /**< (4005) Bluetooth is not enabled on this mobile device. */
    SLYCEPAYDeviceNotPairedAndConnected             = 4006,   /**< (4006) Bluetooth device is not paired and connected. */
    SLYCEPAYUnsupportedCommunicationProtocol        = 4007,   /**< (4007) Bluetooth/EA Framework communication protocol is unsupported */
    
    SLYCEPAYServerCommunicationError                 = 5002,   /**< (5002) The transaction failed due to a communication error with the server. */
    SLYCEPAYServerRequestError                       = 5003,   /**< (5003) The transaction failed due to an error in the server request. */
    SLYCEPAYServerResponseError                      = 5004,   /**< (5004) The transaction failed due to an error in the server response. */
    SLYCEPAYNoResponseFromServer                     = 5005,   /**< (5005) The transaction failed as no response was received from the server. */
    SLYCEPAYAmountInvalid                            = 5006,   /**< (5006) The amount is invalid. */
    SLYCEPAYAmountMissing                            = 5007,   /**< (5007) The amount is missing. */
    SLYCEPAYAmountTooLarge                           = 5008,   /**< (5008) The merchant is not set up to accept a payment this high. */
    SLYCEPAYAmountTooSmall                           = 5009,   /**< (5009) The merchant is not set up to accept a payment this low. */
    SLYCEPAYCardBanned                               = 5010,   /**< (5010) The card has been banned for use on this payment system. */
    SLYCEPAYCardDetailsNotFound                      = 5011,   /**< (5011) The card details have not been found. */
    SLYCEPAYCardDetailsUnavailable                   = 5012,   /**< (5012) The card details are unavailable. */
    SLYCEPAYReferenceInvalid                         = 5013,   /**< (5013) The internal system reference is invalid. */
    SLYCEPAYReferenceMissing                         = 5014,   /**< (5014) The internal system reference is missing. */
    SLYCEPAYCardHashInvalid                          = 5015,   /**< (5015) The card hash is invalid. */
    SLYCEPAYCardReferenceInvalid                     = 5016,   /**< (5016) The card reference is invalid. */
    SLYCEPAYCardSchemeNotSupported                   = 5017,   /**< (5017) The merchant is not set up to accept a payment from this card scheme. */
    SLYCEPAYCardUsageExceeded                        = 5018,   /**< (5018) The card has been used too many times on this payment system. */
    SLYCEPAYExpiredCard                              = 5019,   /**< (5019) The expiry date is invalid; it cannot be in the past. */
    SLYCEPAYExpiryDateInvalid                        = 5020,   /**< (5020) The expiry date is invalid. */
    SLYCEPAYExpiryDateMissing                        = 5021,   /**< (5021) The expiry date is missing. */
    SLYCEPAYInvalidData                              = 5022,   /**< (5022) The transaction failed due to invalid data. */
    SLYCEPAYInvalidMessageType                       = 5023,   /**< (5023) The transaction failed due to an invalid message type. */
    SLYCEPAYInvalidXMLRequest                        = 5024,   /**< (5024) The transaction failed due to an invalid XML request. */
    SLYCEPAYIssueNoInvalid                           = 5025,   /**< (5025) The issue number is incorrect for this card. */
    SLYCEPAYIssueNoMissing                           = 5026,   /**< (5026) The issue number must be supplied for this card. */
    SLYCEPAYMessageTypeInvalid                       = 5027,   /**< (5027) The transaction failed due to an invalid message type. */
    SLYCEPAYMessageTypeMissing                       = 5028,   /**< (5028) The transaction failed due to a missing message type. */
    SLYCEPAYNotAllowed                               = 5029,   /**< (5029) The transaction request was not permitted. */
    SLYCEPAYPANFailsLuhnCheck                        = 5030,   /**< (5030) The card number is invalid. */
    SLYCEPAYPANInvalid                               = 5031,   /**< (5031) The card number is invalid. */
    SLYCEPAYPANMissing                               = 5032,   /**< (5032) The card number is missing. */
    SLYCEPAYPANTooLong                               = 5033,   /**< (5033) The card number is too long. */
    SLYCEPAYPANTooShort                              = 5034,   /**< (5034) The card number is too short. */
    SLYCEPAYPreValidCard                             = 5035,   /**< (5035) The start date is invalid; it cannot be in the future. */
    SLYCEPAYStartDateInvalid                         = 5036,   /**< (5036) The start date must be specified for this card. */
    SLYCEPAYStartDateMissing                         = 5037,   /**< (5037) The start date is missing. */
    SLYCEPAYTemporarilyUnavailable                   = 5038,   /**< (5038) The payment system is temporarily unavailable. */
    SLYCEPAYTerminalIDDisabled                       = 5039,   /**< (5039) The Terminal ID is disabled. */
    TSLYCEPAYerminalIDInvalid                        = 5040,   /**< (5040) The Terminal ID is invalid. */
    SLYCEPAYTerminalIDMissing                        = 5041,   /**< (5041) The Terminal ID is missing. */
    SLYCEPAYTerminalIDUnknown                        = 5042,   /**< (5042) The Terminal ID is unknown. */
    SLYCEPAYTerminalUsageExceeded                    = 5043,   /**< (5043) The terminal has been used too many times on this payment system. */
    SLYCEPAYTransactionAlreadyRefunded               = 5044,   /**< (5044) The transaction has already been refunded or refund is greater than original amount. */
    SLYCEPAYTransactionAlreadySettled                = 5045,   /**< (5045) The transaction has already been settled. */
    SLYCEPAYTransactionAlreadyVoided                 = 5046,   /**< (5046) The transaction has already been voided. */
    SLYCEPAYTransactionKeyIncorrect                  = 5047,   /**< (5047) The transaction key is incorrect. */
    SLYCEPAYTransactionKeyInvalid                    = 5048,   /**< (5048) The transaction key is invalid. */
    SLYCEPAYTransactionKeyMissing                    = 5049,   /**< (5049) The transaction key is missing. */
    SLYCEPAYTransactionNotFound                      = 5050,   /**< (5050) The transaction has not been found. */
    SLYCEPAYTransactionOriginallyDeclined            = 5051,   /**< (5051) The transaction was originally declined. */
    SLYCEPAYTransactionNotCommitted                  = 5052,   /**< (5052) The transaction was approved but not committed. */
    SLYCEPAYXMLDecryptionError                       = 5053,   /**< (5053) The transaction failed due to an XML decryption error. */
    SLYCEPAYXMLElementMissing                        = 5054,   /**< (5054) The transaction failed due to a missing element. */
    SLYCEPAYUnableToStartPinpadTransaction           = 5055,   /**< (5055) The transaction could not be started on the PIN pad. */
    SLYCEPAYUnableToInitialisePinpad                 = 5056,   /**< (5056) Unable to initialise the PIN pad for operation. */
    SLYCEPAYUnableToStartPinpadProcess               = 5057,   /**< (5057) The transaction process could not be started on the PIN pad. */
    SLYCEPAYFailedToTransmitPinpadMessage            = 5058,   /**< (5058) Failed to transmit message to PIN pad. */
    SLYCEPAYPinpadConnectionClosed                   = 5059,   /**< (5059) The Bluetooth connection to the PIN pad is closed. */
    SLYCEPAYUnknownRequestFromPinpad                 = 5060,   /**< (5060) The request recieved from the PIN pad is unknown. */
    SLYCEPAYUnexpectedRequestFromPinpad              = 5061,   /**< (5061) The request recieved from the PIN pad is not expected. */
    SLYCEPAYTerminalConfigurationError               = 5062,   /**< (5062) Terminal has not been configured correctly to perform a transaction (a property is missing). */
    SLYCEPAYInvalidIssuerResponse                    = 5063,   /**< (5063) The issuer response has an invalid format. */
    SLYCEPAYInvalidPinpadRefundResult                = 5064,   /**< (5064) Unknown transaction result received from PIN pad. */
    SLYCEPAYPinpadTransactionTerminated              = 5065,   /**< (5065) (PIN pad) Transaction Terminated. */
    SLYCEPAYChipApplicationSelectionFailure          = 5066,   /**< (5066) (Chip) Application Selection Failure. */
    SLYCEPAYChipInitiateApplicationProcessingFailure = 5067,   /**< (5067) (Chip) Initiate Application Processing Failure. */
    SLYCEPAYChipReadApplicationDataFailure           = 5068,   /**< (5068) (Chip) Read Application Data Failure. */
    SLYCEPAYChipOfflineDataAuthenticationFailure     = 5069,   /**< (5069) (Chip) Offline Data Authentication Failure. */
    SLYCEPAYChipProcessRestrictionsFailure           = 5070,   /**< (5070) (Chip) Process Restrictions Failure. */
    SLYCEPAYChipTerminalRiskManagementFailure        = 5071,   /**< (5071) (Chip) Terminal Risk Management Failure. */
    SLYCEPAYChipCardholderVerificationMethodFailure  = 5072,   /**< (5072) (Chip) Cardholder Verification Method Failure. */
    SLYCEPAYChipTerminalActionAnalysisFailure        = 5073,   /**< (5073) (Chip) Terminal Action Analysis. */
    SLYCEPAYChipCardActionAnalysisFailure            = 5074,   /**< (5074) (Chip) Card Action Analysis Failure. */
    SLYCEPAYChipCompletionFailure                    = 5075,   /**< (5075) (Chip) Completion Failure. */
    SLYCEPAYEposTransactionTerminated                = 5076,   /**< (5076) (EPOS) Transaction Terminated. */
    SLYCEPAYChipNoAnswerToReset                      = 5077,   /**< (5077) (Chip) No Answer to Reset. */
    SLYCEPAYSwipeReadFailure                         = 5078,   /**< (5078) (Swipe) Read Failure. */
    SLYCEPAYChipCardRemoved                          = 5079,   /**< (5079) (Chip) Card Removed. */
    SLYCEPAYPinpadUserCancelled                      = 5080,   /**< (5080) (PIN pad) User Cancelled. */
    SLYCEPAYChipNoSupportedApplications              = 5081,   /**< (5081) (Chip) No Supported Applications. */
    SLYCEPAYChipCardBlocked                          = 5082,   /**< (5082) (Chip) Card Blocked. */
    SLYCEPAYChipReadFailure                          = 5083,   /**< (5083) (Chip) Read Failure. */
    SLYCEPAYApplicationNotSupported                  = 5084,   /**< (5084) Terminal has not been configured to support the selected application. */
    SLYCEPAYVoiceReferralNotificationError           = 5085,   /**< (5085) An error occurred while notifying the server of the voice referral result. */
    SLYCEPAYOfflineIccAuthorisationError             = 5086,   /**< (5086) An error occurred during authorisation of an off-line ICC transaction. */
    SLYCEPAYAtmCashOnlyCard                          = 5087,   /**< (5087) The third digit of the service code indicates this is an ATM or cash only card and cannot be used for a transaction. */
    SLYCEPAYCardHolderActionTimedOut                 = 5088,   /**< (5088) (PIN pad) CardHolder Action Timed Out. */
    SLYCEPAYPinpadDukptKeyFailure                    = 5089,   /**< (5089) (PIN pad) DUKPT Key Failure. */
    SLYCEPAYInvalidDataInCommandError                = 5090,   /**< (5090) Invalid Data in command APDU. */
    SLYCEPAYTerminalNotReadyError                    = 5091,   /**< (5091) Terminal not ready (Continue before Start). */
    SLYCEPAYNoSmartcardInSlotError                   = 5092,   /**< (5092) No smartcard in slot. */
    SLYCEPAYInvalidCardResponseError                 = 5093,   /**< (5093) Invalid card, card responded incorrectly, no MSR fall back allowed. */
    SLYCEPAYTransactionAlreadyInProgressError        = 5094,   /**< (5094) Transaction already in progress. */
    SLYCEPAYMissingDataInCommandError                = 5095,   /**< (5095) Data missing from command APDU (data field should list missing object(s)). */
    SLYCEPAYMissingFileError                         = 5096,   /**< (5096) Missing file (data field should list missing file). */
    SLYCEPAYInvalidIssuerPublicKeyError              = 5097,   /**< (5097) Invalid issuer public key, hash check failed. */
    SLYCEPAYTestCheckError                           = 5098,   /**< (5098) Test check failed with an unknown error.*/
    SLYCEPAYGeneralEMVError                          = 5099,   /**< (5099) General EMV error occurred.*/
    SLYCEPAYCardBlockedError                         = 5100,   /**< (5100) Card blocked.*/
    SLYCEPAYTimeOutError                             = 5101,   /**< (5101) The transaction has timed out.*/
    SLYCEPAYTransactionAbortedError                  = 5102,   /**< (5102) The transaction was aborted.*/
    SLYCEPAYConfigurationError                       = 5103,   /**< (5103) Configuration files are not loaded.*/
    SLYCEPAYInvalidApplicationError                  = 5104,   /**< (5104) Invalid application error.*/
    SLYCEPAYPINError                                 = 5105,   /**< (5105) An error occurred during the PIN entry.*/
    SLYCEPAYOperatorPinIncorrect                     = 5106,   /**< (5106) An operator PIN in incorrect. */
    SLYCEPAYOfflineRequestTooOld                     = 5107,   /**< (5107) Offline stored request too old to be processed. */
    SLYCEPAYTimeOutErrorContactless                  = 5108,   /**< (5108) Contactless transaction timed out. */
    SLYCEPAYContactlessHardwareError                 = 5109,   /**< (5109) Contactless hardware error. */
    SLYCEPAYNoInterfacesEnabled                      = 5110,   /**< (5110) There are no enabled interfaces for processing transactions. */
    SLYCEPAYMagstripeInterfaceNotEnabled             = 5111,   /**< (5111)  Magstripe card has been swiped and magstripe interface is not enabled. */
    SLYCEPAYEMVInterfaceNotEnabled                   = 5112,   /**< (5112) EMV interface is not enabled and the card cannot be processed using magstripe interface. */
    SLYCEPAYMagstripeInterfaceNotEnabledEMVFallbackNotPossible                = 5113,   /**< (5113) EMV card requires a fallback to magstripe and magstripe interface is not enabled. */
    SLYCEPAYEMVAndMagstripeInterfacesNotEnabledContactlessFallForwardNotPossible = 5114,   /**< (5114) Contactless card requires EMV or magstripe, EMV and magstripe interfaces are not enabled. */
    SLYCEPAYEMVInterfaceNotEnabledContactlessFallbackNotPossible              = 5115,   /**< (5115) Contactless card requires EMV, EMV interface is not enabled. */
    SLYCEPAYOnlinePINInternalError1                  = 5116,   /**< (5116) Online PIN internal error 1. */
    SLYCEPAYOnlinePINInternalError2                  = 5117,   /**< (5117) Online PIN internal error 2. */
    SLYCEPAYOnlinePINInternalError3                  = 5118,   /**< (5118) Online PIN internal error 3. */
    SLYCEPAYOnlinePINKeyMissingForMagstripeDebit     = 5119,   /**< (5119) Online PIN key is missing, magstripe debit transaction cannot be carried out. */
    SLYCEPAYTransactionTenderInvalid                  =5120,
    SLYCEPAYMerchantTerminateTransaction
    
};

@protocol SlycePayDelegate <NSObject>
@required
-(void)initialisCompleted:(BOOL)ready withError:(NSError*)error;
-(void)deviceconnectionComplete:(NSError*)error;
-(void)transactionSaleCompleted:( NSDictionary *)resultDict;
-(void)transAuthorizationCompleted:( NSDictionary *)resultDict;
-(void)transactionReturnCompleted:( NSDictionary *)resultDict;
-(void)transactionCaptureCompleted:( NSDictionary *)resultDict;
-(void)transactionVoidCompleted:( NSDictionary *)resultDict;
-(void)voiceReferral:(BOOL) notifyflg withphone:(NSString *) phoneNumber;
-(void)transactionMessageUpdate:(NSString *) msg;
@optional
-(void)devicedisattached; // usaepay creditcall cardflight
-(void)deviceattached;//cardflight
-(void)EMVApplicationList:(NSArray *)applications; //cardflight
-(void)captureSignature;

@end


@interface SlycePay : NSObject
@property (nonatomic, assign) id <SlycePayDelegate> SLYDelegate;
@property (nonatomic,retain)NSString * currentModule;


+ (NSString *)CMSversion;
-(id)initwith:(NSString *)token Delegate:(id<SlycePayDelegate>) delegates;
-(NSArray*) getDevice;
-(void)connectDevice:(NSString*) name configerror:(NSError **)error;
//transactions API
-(void)processSale:( NSDictionary *)transDict withError:(NSError**)error;
-(void)signatureCaptured:(BOOL)result withImag:(UIImage *) img;
-(void)phoneReferral:(BOOL)result withAuthcode:(NSString*) authcode;
-(void)processReturn:( NSDictionary *)transDict withError:(NSError**)error;
-(void)processAuthorization:( NSDictionary *)transDict withError:(NSError**)error;
-(void)processCapture:( NSDictionary *)transDict withError:(NSError**)error;
-(void)terminateTransaction;
-(void)applicationSelected:(NSInteger)selection;
-(void)processVoid:(NSDictionary *)transDict withError:(NSError **)error;
//utility
-(void)setLogMode:(BOOL)logmode;//*
-(void)setProduction:(BOOL)promode;
-(void)setfilemode:(BOOL)filemode;
-(BOOL)getProduction;
-(void)APPLog:(NSString *) content, ...;
-(void)ClearLog;




@end
