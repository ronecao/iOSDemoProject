//
//  Slyce1.h
//  Slyce1
//
//  Created by chris on 03/02/2017.
//  Copyright © 2017 chris. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CallOne.h"
#import "CallOneTransResponse.h"
#import "FileControl.h"
#import "EMVIOiOSBridge.h"
#define CALLMODULE @"Module"
#define CALLTID @"passkey"
#define CALLTK @"passkey2"
#define CALLAPPID @"ApplicationId"
#define CALLAPITOKEN @"login"
#define CALLACCOUNTTK @"passkey"
#define CALLSERVERURL @"ServerURL"

//! Project version number for Slyce1.
FOUNDATION_EXPORT double Slyce1VersionNumber;

//! Project version string for Slyce1.
FOUNDATION_EXPORT const unsigned char Slyce1VersionString[];

typedef NS_ENUM(NSInteger, CALLInitDictERROR) {
    CALLInitDictERRORNOError=0,
    CALLInitDictERRORNOModule= -1,
    CALLInitDictERRORNOAPPID =-2,
    CALLInitDictERRORNOTID=-3,
    CALLInitDictERRORNOTK =-4,
    CALLInitDictERRORNOAPITOKEN =-5,
    CALLInitDictERRORNOACCOUNT =-6,
    //CALLInitDictERRORNOACCOUNT =-6,
};
/*/**
 * @typedef TransactionErrorCode
 *
 * The possible error codes  that can be returned when a transaction is terminated.
 */

typedef NS_ENUM(NSInteger, CALLERRORList) {
    CALLERRORListNOError=0,
    CALLNOPUBKEYERROR                           = -8001,
    CALLERRORListinitHTTPError                  = -9001,
    CALLERRORListinitHTTPNONetwork              = -9002,
    CALLERRORListUnknow                         = 5001,
    CALLApplicationUpdateRequired               = 1001,   /**< (1001) The current version of software is invalid and an update is required. */
    CALLInvalidHomeNetworkIdentity              = 1004,   /**< (1004) The Home Network Identity (HNI) is invalid. */
    CALLTerminalDisabled                        = 1005,   /**< (1005) The terminal is disabled. */
    CALLTransactionTypeNotSupported             = 1006,   /**< (1006) The type of transaction is not supported by the terminal. */
    CALLNoCompletedTransaction                  = 1007,   /**< (1007) A transaction has not been completed. */
    CALLAnotherOperationBeingProcessed          = 1008,   /**< (1008) Another operation is being processed. */
    CALLPinPadAlreadyConnected                  = 1009,   /**< (1009) The PIN pad is already connected. */
    CALLPinPadNotConnected                      = 1010,   /**< (1010) The PIN pad is not connected. */
    CALLUpdateNotConfigured                     = 1011,   /**< (1011) The update has not been configured. */
    CALLTMSUpdateRequired                       = 1012,   /**< (1012) An update from the TMS is required. */
    CALLStandaloneRefundNotSupported            = 1013,   /**< (1013) Standalone refunds are not supported by the terminal. */
    CALLLinkedRefundNotSupported                = 1014,   /**< (1014) Linked refunds are not supported by the terminal. */
    CALLCashTransactionsNotSupported            = 1015,   /**< (1015) Cash transactions are not supported by this terminal. */
    CALLChequeTransactionsNotSupported          = 1016,    /**< (1016) Cheque transactions are not supported by this terminal. */
    //1017
    CALLGratuityNotSupported                    = 1018,    /**< (1018) Gratuity not supported. */
    CALLCurrencyNotFound                        = 1019,    /**< (1019) Currency not found in configuration data. */
    CALLCurrencyNotSet                          = 1020,    /**< (1020) Currency is not set. */
    CALLCurrencyNotSupportedForPaymentMethod    = 1021,    /**< (1021) Currency is not supported for payment method. */
    CALLEndOfDayTippingNotSupported             = 1022,    /**< (1022) End of Day Tipping is not supported */
    CALLOnDeviceTippingNotSupported             = 1023,    /**< (1023) On Device Tipping is not supported */
    CALLPinPadeckRequired                       = 1024,    /**< (1024) A PIN pad check is required. */
    CALLSREDKeyRequired                         = 1025,     /**< (1024) The SRED Key has failed to inject and is missing. */
    CALLUnableToOpenURL                         = 3001,   /**< (3001) Unable to open the specified URL. */
    CALLUnableToSpecifyCommunicationProtocol    = 3002,   /**< (3002) Unable to specify communication protocol. */
    CALLUnableToSendRequest                     = 3003,   /**< (3003) Unable to send request. */
    CALLUnableToGetHttpResponseCode             = 3004,   /**< (3004) Unable to retrieve HTTP response code. */
    CALLUnsuccessfulHttpRequest                 = 3005,   /**< (3005) The response to the HTTP request was not equal to 200(OK). */
    CALLUnableToReadResponse                    = 3006,   /**< (3006) Unable to read HTTP response data. */
    CALLUnableToRetrieveResponse                = 3007,   /**< (3007) Unable to retrieve server response. */
    CALLUnableToWriteRequestXml                 = 3008,   /**< (3008) Unable to write request XML. */
    CALLUnableToParseResponseXml                = 3009,   /**< (3009) Unable to parse response XML. */
    CALLUnableToReadResponseXml                 = 3010,   /**< (3010) Unable to read HTTP response data. */
    CALLErrorParsingResponseXml                 = 3011,   /**< (3011) Error parsing response XML. */
    CALLResponseXmlNotFound                     = 3012,   /**< (3012) Response XML not found. */
    CALLEmptyPropertySet                        = 3013,   /**< (3013) No properties returned by TMS. */
    CALLErrorParsingPropertyXML                 = 3014,   /**< (3014) Error parsing properties in Property element in response XML. */
    CALLPinpadNotConfigured                     = 3015,   /**< (3015) PIN pad has not been configured for a configuration update from the TMS. */
    CALLSpecifiedUrlMalformed                   = 3016,    /**< (3016) Specified URL is malformed. */
    CALLDeviceNotPaired                         = 4001,   /**< (4001) The selected Bluetooth device is not paired. */
    CALLBluetoothNotSupported                   = 4002,   /**< (4002) Bluetooth is not supported on this mobile device. */
    CALLNoDeviceSelected                        = 4003,   /**< (4003) No supported Bluetooth device has been selected for connection. */
    CALLConnectionFailed                        = 4004,   /**< (4004) Connection failed. */
    CALLBluetoothNotEnabled                     = 4005,   /**< (4005) Bluetooth is not enabled on this mobile device. */
    CALLDeviceNotPairedAndConnected             = 4006,   /**< (4006) Bluetooth device is not paired and connected. */
    CALLUnsupportedCommunicationProtocol        = 4007,   /**< (4007) Bluetooth/EA Framework communication protocol is unsupported */

    CALLServerCommunicationError                 = 5002,   /**< (5002) The transaction failed due to a communication error with the server. */
    CALLServerRequestError                       = 5003,   /**< (5003) The transaction failed due to an error in the server request. */
    CALLServerResponseError                      = 5004,   /**< (5004) The transaction failed due to an error in the server response. */
    CALLNoResponseFromServer                     = 5005,   /**< (5005) The transaction failed as no response was received from the server. */
    CALLAmountInvalid                            = 5006,   /**< (5006) The amount is invalid. */
    CALLAmountMissing                            = 5007,   /**< (5007) The amount is missing. */
    CALLAmountTooLarge                           = 5008,   /**< (5008) The merchant is not set up to accept a payment this high. */
    CALLAmountTooSmall                           = 5009,   /**< (5009) The merchant is not set up to accept a payment this low. */
    CALLCardBanned                               = 5010,   /**< (5010) The card has been banned for use on this payment system. */
    CALLCardDetailsNotFound                      = 5011,   /**< (5011) The card details have not been found. */
    CALLCardDetailsUnavailable                   = 5012,   /**< (5012) The card details are unavailable. */
    CALLReferenceInvalid                        = 5013,   /**< (5013) The internal system reference is invalid. */
    CALLReferenceMissing                        = 5014,   /**< (5014) The internal system reference is missing. */
    CALLCardHashInvalid                          = 5015,   /**< (5015) The card hash is invalid. */
    CALLCardReferenceInvalid                     = 5016,   /**< (5016) The card reference is invalid. */
    CALLCardSchemeNotSupported                   = 5017,   /**< (5017) The merchant is not set up to accept a payment from this card scheme. */
    CALLCardUsageExceeded                        = 5018,   /**< (5018) The card has been used too many times on this payment system. */
    CALLExpiredCard                              = 5019,   /**< (5019) The expiry date is invalid; it cannot be in the past. */
    CALLExpiryDateInvalid                        = 5020,   /**< (5020) The expiry date is invalid. */
    CALLExpiryDateMissing                        = 5021,   /**< (5021) The expiry date is missing. */
    CALLInvalidData                              = 5022,   /**< (5022) The transaction failed due to invalid data. */
    CALLInvalidMessageType                       = 5023,   /**< (5023) The transaction failed due to an invalid message type. */
    CALLInvalidXMLRequest                        = 5024,   /**< (5024) The transaction failed due to an invalid XML request. */
    CALLIssueNoInvalid                           = 5025,   /**< (5025) The issue number is incorrect for this card. */
    CALLIssueNoMissing                           = 5026,   /**< (5026) The issue number must be supplied for this card. */
    CALLMessageTypeInvalid                       = 5027,   /**< (5027) The transaction failed due to an invalid message type. */
    CALLMessageTypeMissing                       = 5028,   /**< (5028) The transaction failed due to a missing message type. */
    CALLNotAllowed                               = 5029,   /**< (5029) The transaction request was not permitted. */
    CALLPANFailsLuhnCheck                        = 5030,   /**< (5030) The card number is invalid. */
    CALLPANInvalid                               = 5031,   /**< (5031) The card number is invalid. */
    CALLPANMissing                               = 5032,   /**< (5032) The card number is missing. */
    CALLPANTooLong                               = 5033,   /**< (5033) The card number is too long. */
    CALLPANTooShort                              = 5034,   /**< (5034) The card number is too short. */
    CALLPreValidCard                             = 5035,   /**< (5035) The start date is invalid; it cannot be in the future. */
    CALLStartDateInvalid                         = 5036,   /**< (5036) The start date must be specified for this card. */
    CALLStartDateMissing                         = 5037,   /**< (5037) The start date is missing. */
    CALLTemporarilyUnavailable                   = 5038,   /**< (5038) The payment system is temporarily unavailable. */
    CALLTerminalIDDisabled                       = 5039,   /**< (5039) The Terminal ID is disabled. */
    TCALLerminalIDInvalid                        = 5040,   /**< (5040) The Terminal ID is invalid. */
    CALLTerminalIDMissing                        = 5041,   /**< (5041) The Terminal ID is missing. */
    CALLTerminalIDUnknown                        = 5042,   /**< (5042) The Terminal ID is unknown. */
    CALLTerminalUsageExceeded                    = 5043,   /**< (5043) The terminal has been used too many times on this payment system. */
    CALLTransactionAlreadyRefunded               = 5044,   /**< (5044) The transaction has already been refunded or refund is greater than original amount. */
    CALLTransactionAlreadySettled                = 5045,   /**< (5045) The transaction has already been settled. */
    CALLTransactionAlreadyVoided                 = 5046,   /**< (5046) The transaction has already been voided. */
    CALLTransactionKeyIncorrect                  = 5047,   /**< (5047) The transaction key is incorrect. */
    CALLTransactionKeyInvalid                    = 5048,   /**< (5048) The transaction key is invalid. */
    CALLTransactionKeyMissing                    = 5049,   /**< (5049) The transaction key is missing. */
    CALLTransactionNotFound                      = 5050,   /**< (5050) The transaction has not been found. */
    CALLTransactionOriginallyDeclined            = 5051,   /**< (5051) The transaction was originally declined. */
    CALLTransactionNotCommitted                  = 5052,   /**< (5052) The transaction was approved but not committed. */
    CALLXMLDecryptionError                       = 5053,   /**< (5053) The transaction failed due to an XML decryption error. */
    CALLXMLElementMissing                        = 5054,   /**< (5054) The transaction failed due to a missing element. */
    CALLUnableToStartPinpadTransaction           = 5055,   /**< (5055) The transaction could not be started on the PIN pad. */
    CALLUnableToInitialisePinpad                 = 5056,   /**< (5056) Unable to initialise the PIN pad for operation. */
    CALLUnableToStartPinpadProcess               = 5057,   /**< (5057) The transaction process could not be started on the PIN pad. */
    CALLFailedToTransmitPinpadMessage            = 5058,   /**< (5058) Failed to transmit message to PIN pad. */
    CALLPinpadConnectionClosed                   = 5059,   /**< (5059) The Bluetooth connection to the PIN pad is closed. */
    CALLUnknownRequestFromPinpad                 = 5060,   /**< (5060) The request recieved from the PIN pad is unknown. */
    CALLUnexpectedRequestFromPinpad              = 5061,   /**< (5061) The request recieved from the PIN pad is not expected. */
    CALLTerminalConfigurationError               = 5062,   /**< (5062) Terminal has not been configured correctly to perform a transaction (a property is missing). */
    CALLInvalidIssuerResponse                    = 5063,   /**< (5063) The issuer response has an invalid format. */
    CALLInvalidPinpadRefundResult                = 5064,   /**< (5064) Unknown transaction result received from PIN pad. */
    CALLPinpadTransactionTerminated              = 5065,   /**< (5065) (PIN pad) Transaction Terminated. */
    CALLChipApplicationSelectionFailure          = 5066,   /**< (5066) (Chip) Application Selection Failure. */
    CALLChipInitiateApplicationProcessingFailure = 5067,   /**< (5067) (Chip) Initiate Application Processing Failure. */
    CALLChipReadApplicationDataFailure           = 5068,   /**< (5068) (Chip) Read Application Data Failure. */
    CALLChipOfflineDataAuthenticationFailure     = 5069,   /**< (5069) (Chip) Offline Data Authentication Failure. */
    CALLChipProcessRestrictionsFailure           = 5070,   /**< (5070) (Chip) Process Restrictions Failure. */
    CALLChipTerminalRiskManagementFailure        = 5071,   /**< (5071) (Chip) Terminal Risk Management Failure. */
    CALLChipCardholderVerificationMethodFailure  = 5072,   /**< (5072) (Chip) Cardholder Verification Method Failure. */
    CALLChipTerminalActionAnalysisFailure        = 5073,   /**< (5073) (Chip) Terminal Action Analysis. */
    CALLChipCardActionAnalysisFailure            = 5074,   /**< (5074) (Chip) Card Action Analysis Failure. */
    CALLChipCompletionFailure                    = 5075,   /**< (5075) (Chip) Completion Failure. */
    CALLEposTransactionTerminated                = 5076,   /**< (5076) (EPOS) Transaction Terminated. */
    CALLChipNoAnswerToReset                      = 5077,   /**< (5077) (Chip) No Answer to Reset. */
    CALLSwipeReadFailure                         = 5078,   /**< (5078) (Swipe) Read Failure. */
    CALLChipCardRemoved                          = 5079,   /**< (5079) (Chip) Card Removed. */
    CALLPinpadUserCancelled                      = 5080,   /**< (5080) (PIN pad) User Cancelled. */
    CALLChipNoSupportedApplications              = 5081,   /**< (5081) (Chip) No Supported Applications. */
    CALLChipCardBlocked                          = 5082,   /**< (5082) (Chip) Card Blocked. */
    CALLChipReadFailure                          = 5083,   /**< (5083) (Chip) Read Failure. */
    CALLApplicationNotSupported                  = 5084,   /**< (5084) Terminal has not been configured to support the selected application. */
    CALLVoiceReferralNotificationError           = 5085,   /**< (5085) An error occurred while notifying the server of the voice referral result. */
    CALLOfflineIccAuthorisationError             = 5086,   /**< (5086) An error occurred during authorisation of an off-line ICC transaction. */
    CALLAtmCashOnlyCard                          = 5087,   /**< (5087) The third digit of the service code indicates this is an ATM or cash only card and cannot be used for a transaction. */
    CALLCardHolderActionTimedOut                 = 5088,   /**< (5088) (PIN pad) CardHolder Action Timed Out. */
    CALLPinpadDukptKeyFailure                    = 5089,   /**< (5089) (PIN pad) DUKPT Key Failure. */
    CALLInvalidDataInCommandError                = 5090,   /**< (5090) Invalid Data in command APDU. */
    CALLTerminalNotReadyError                    = 5091,   /**< (5091) Terminal not ready (Continue before Start). */
    CALLNoSmartcardInSlotError                   = 5092,   /**< (5092) No smartcard in slot. */
    CALLInvalidCardResponseError                 = 5093,   /**< (5093) Invalid card, card responded incorrectly, no MSR fall back allowed. */
    CALLTransactionAlreadyInProgressError        = 5094,   /**< (5094) Transaction already in progress. */
    CALLMissingDataInCommandError                = 5095,   /**< (5095) Data missing from command APDU (data field should list missing object(s)). */
    CALLMissingFileError                         = 5096,   /**< (5096) Missing file (data field should list missing file). */
    CALLInvalidIssuerPublicKeyError              = 5097,   /**< (5097) Invalid issuer public key, hash check failed. */
    CALLTestCheckError                           = 5098,   /**< (5098) Test check failed with an unknown error.*/
    CALLGeneralEMVError                          = 5099,   /**< (5099) General EMV error occurred.*/
    CALLCardBlockedError                         = 5100,   /**< (5100) Card blocked.*/
    CALLTimeOutError                             = 5101,   /**< (5101) The transaction has timed out.*/
    CALLTransactionAbortedError                  = 5102,   /**< (5102) The transaction was aborted.*/
    CALLConfigurationError                       = 5103,   /**< (5103) Configuration files are not loaded.*/
    CALLInvalidApplicationError                  = 5104,   /**< (5104) Invalid application error.*/
    CALLPINError                                 = 5105,   /**< (5105) An error occurred during the PIN entry.*/
    CALLOperatorPinIncorrect                     = 5106,   /**< (5106) An operator PIN in incorrect. */
    CALLOfflineRequestTooOld                     = 5107,   /**< (5107) Offline stored request too old to be processed. */
    CALLTimeOutErrorContactless                  = 5108,   /**< (5108) Contactless transaction timed out. */
    CALLContactlessHardwareError                 = 5109,   /**< (5109) Contactless hardware error. */
    CALLNoInterfacesEnabled                      = 5110,   /**< (5110) There are no enabled interfaces for processing transactions. */
    CALLMagstripeInterfaceNotEnabled             = 5111,   /**< (5111)  Magstripe card has been swiped and magstripe interface is not enabled. */
    CALLEMVInterfaceNotEnabled                   = 5112,   /**< (5112) EMV interface is not enabled and the card cannot be processed using magstripe interface. */
    CALLMagstripeInterfaceNotEnabledEMVFallbackNotPossible                = 5113,   /**< (5113) EMV card requires a fallback to magstripe and magstripe interface is not enabled. */
    CALLEMVAndMagstripeInterfacesNotEnabledContactlessFallForwardNotPossible = 5114,   /**< (5114) Contactless card requires EMV or magstripe, EMV and magstripe interfaces are not enabled. */
    CALLEMVInterfaceNotEnabledContactlessFallbackNotPossible              = 5115,   /**< (5115) Contactless card requires EMV, EMV interface is not enabled. */
    CALLOnlinePINInternalError1                  = 5116,   /**< (5116) Online PIN internal error 1. */
    CALLOnlinePINInternalError2                  = 5117,   /**< (5117) Online PIN internal error 2. */
    CALLOnlinePINInternalError3                  = 5118,   /**< (5118) Online PIN internal error 3. */
    CALLOnlinePINKeyMissingForMagstripeDebit     = 5119,   /**< (5119) Online PIN key is missing, magstripe debit transaction cannot be carried out. */
    CALLTransactionTenderInvalid                  =5120,
    CALLMerchantTerminateTransaction
    
};


// In this header, you should import all the public headers of your framework using statements like #import <Slyce1/PublicHeader.h>


