/**
 * @author Creditcall Ltd
 * @brief This class represents the record of an offline stored transaction request which resulted in failure.
 * @class OfflineRequest
 * @copyright Copyright Creditcall Limited 2010 - 2015.
 */

#import <Foundation/Foundation.h>

@interface OfflineRequest : NSObject

/**
 * CEMOfflineRequestType An enumeration used to represent the type of request.
 */
typedef NSString* CEMOfflineRequestType;
extern NSString* const CEMOfflineRequestTypeSale;           /*!< A sale request. */
extern NSString* const CEMOfflineRequestTypeSaleConf;       /*!< A sale confirmation request. */
extern NSString* const CEMOfflineRequestTypeSaleVoid;       /*!< A sale void request. */
extern NSString* const CEMOfflineRequestTypeRefund;         /*!< A refund request. */
extern NSString* const CEMOfflineRequestTypeRefundConf;     /*!< A refund confirmation request. */
extern NSString* const CEMOfflineRequestTypeRefundVoid;     /*!< A refund void request. */

/**
 * Gets the amount of the transaction in minor units.
 *
 * This property is read-only.
 *
 * @return The amount, nil otherwise.
 */
@property (readonly) NSString *amount;

/**
 * Gets the user reference for the transaction.
 *
 * This property is read-only.
 *
 * @return The user reference.
 */
@property (readonly) NSString *userReference;

/**
 * Gets the date and time of the transaction.
 *
 * It is in the "dd/MM/yyyy HH:mm:ss" format.
 *
 * This property is read-only.
 *
 * @return The date and time of the transaction.
 */
@property (readonly) NSString *dateTime;

/**
 * Gets the type of the request.
 *
 * This property is read-only.
 *
 * @return The type of the request.
 */
@property (readonly) CEMOfflineRequestType type;

/**
 * Gets the error codes for the transaction. The array contains NSNumber objects representing
 * CardEase Mobile error codes.
 *
 * This property is read-only.
 *
 * @return The error codes for the transaction.
 */
@property (readonly) NSArray *errorCodes;

@end
