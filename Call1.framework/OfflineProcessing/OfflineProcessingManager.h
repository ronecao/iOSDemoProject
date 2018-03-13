/**
 * @author Creditcall Ltd
 * @brief This class contains methods which allow retrieving the information about offline processing and managing the failed requests.
 * @class OfflineProcessingManager
 * @copyright Copyright Creditcall Limited 2010 - 2015.
 */

#import <Foundation/Foundation.h>
@class OfflineRequest;

@protocol OfflineDelegate <NSObject>

@required

/**
 * Invoked when the resending of the request is completed.
 *
 * @param request An original offline request. 
 * @param success YES if the request has been resent successfully, NO if the offline request failed.
 * @param errorCodes Error codes defining the reason for the failure. It will contain errors if the resend failed. It will be nil otherwise. An array contains NSError objects whose codes are defined in {@link TransactionErrorCode} or {@link StorageErrorCode}.
 */
-(void)offlineRequest:(OfflineRequest *)request resent:(BOOL)success errorCodes:(NSArray *)errorCodes;

@end

@interface OfflineProcessingManager : NSObject

/**
 * Returns an instance of OfflineProcessingManager. This method should only be called after CardEaseMobile
 * has been initialised using {@link CardEaseMobile::initialise:applicationIdentifier:}. {@link CardEaseMobile::isInitialised}
 * can be used to check whether CardEaseMobile has been initialised already.
 *
 * @return an instance of OfflineProcessingManager.
 * @exception CEMInitialisationException Thrown if the method is accessed before CardEaseMobile has been initialised.
 */
-(OfflineProcessingManager *)init;

/**
 * Returns the number of the offline requests currently stored by CardEase Mobile.
 * Only the requests currently in the processing queue are included in the count,
 * failed requests do not count towards the storage limit and are not included.
 *
 * @return The number of offline requests currently stored by CardEase Mobile.
 * @param error The error to be populated with {@link StorageErrorCode} if problems occur while accessing database.
 */
-(NSInteger)numberOfStoredRequestsError:(NSError **)error;

/**
 * Returns the number of the failed offline requests currently stored by CardEase Mobile.
 * Only the failed requests are included in the count, pending requests are not included.
 *
 * @return The number of failed offline requests currently stored by CardEase Mobile.
 * @param error The error to be populated with {@link StorageErrorCode} if problems occur while accessing database.
 */
-(NSInteger)numberOfFailedRequestsError:(NSError **)error;

/**
 * Returns the limit for the maximum requests which can be stored by CardEase Mobile.
 *
 * @return The number of offline requests currently stored by CardEase Mobile.
 */
-(NSInteger)storedRequestsLimit;

/**
 * Returns the total amount currently stored by CardEase Mobile in offline requests.
 * Only the amounts of the requests currently in the processing queue are included in the count,
 * the amounts fo the failed requests do not count towards the storage limit and are not included.
 *
 * The amounts processed in sales and refunds both count towards the total amount.
 *
 * @return The total amount currently stored by CardEase Mobile.
 * @param error The error to be populated with {@link StorageErrorCode} if problems occur while accessing database.
 */
-(NSInteger)totalAmountStoredError:(NSError **)error;

/**
 * Returns the total amount currently stored by CardEase Mobile in failed
 * offline requests. Only the amounts of the failed requests are included in
 * the count, the amounts in the pending requests are not included.
 *
 * The amounts processed in sales and refunds both count towards the total amount.
 *
 * @return The total amount currently stored by CardEase Mobile.
 * @param error The error to be populated with {@link StorageErrorCode} if problems occur while accessing database.
 */
-(NSInteger)totalAmountFailedError:(NSError **)error;

/**
 * Returns the maximum amount which can be stored by CardEase Mobile in offline requests.
 *
 * The amounts processed in sales and refunds both count towards the maximum amount.
 *
 * @return The maximum amount which can be stored by CardEase Mobile.
 */
-(NSInteger)amountLimit;

/**
 * Returns the date and time of the oldest request in the processing queue.
 *
 * It is in the "dd/MM/yyyy HH:mm:ss" format.
 *
 * @return The date and time of the oldest request in the processing queue, nil if the processing queue is empty.
 * @param error The error to be populated with {@link StorageErrorCode} if problems occur while accessing database.
 */
-(NSString *)dateTimeOfOldestStoredRequestError:(NSError **)error;

/**
 * Returns the volumes of the stored requests, grouped by the request type. Only the pending requests are included in the volumes count.
 *
 * The returned dictionary maps CEMOfflineRequestType to an NSNumber with the value
 * representing the number of the requests of that type in the processing queue.
 *
 * @return The volumes of the stored pending requests by type.
 * @param error The error to be populated with {@link StorageErrorCode} if problems occur while accessing database.
 */
-(NSDictionary *)pendingRequestVolumesError:(NSError **)error;

/**
 * Return the amount sum of the stored pending requests, grouped by the request type. Only the pending requests are included in the sum.
 *
 * The returned dictionary maps the CEMOfflineRequestType to an NSNumber with the value
 * representing the sum of the amount of that type of request in the failed queue.
 *
 * @return The sum of the failed requests amount by type.
 * @param error The error to be populated with {@link StorageErrorCode} if problems occur while accessing database.
 */
-(NSDictionary *)pendingRequestTotalsError:(NSError **)error;

/**
 * Returns the volumes of the stored failed requests, grouped by the request type. Only the failed requests are included in the volumes count.
 *
 * The returned dictionary maps CEMOfflineReuestType to an NSNumber witht the value
 * representing the number of the requests of that type in the failed queue.
 *
 * @return The volumes of failed requests by type.
 * @param error The error to be populated with {@link StorageErrorCode} if problems occur while accessing database.
 */
-(NSDictionary *)failedRequestVolumesError:(NSError **)error;

/**
 * Returns the amount sum of the stored failed requests, grouped by the request type. Only the failed requests are included in the sum.
 *
 * The returned dictionary maps the CEMOfflineRequestType to an NSNumber with the value
 * representing the sum of the amount of that type of request in the failed queue.
 *
 * @return The sum of failed requests amount by type.
 * @param error The error to be populated with {@link StorageErrorCode} if problems occur while accessing database.
 */
-(NSDictionary *)failedRequestTotalsError:(NSError **)error;

/**
 * Retrieves the records of failed offline requests. Empty array will be returned if there are currently no failed requests.
 *
 * @return an array of OfflineRequests objects.
 * @param error The error to be populated with {@link StorageErrorCode} if problems occur while accessing database.
 */
-(NSArray *)failedOfflineRequestsError:(NSError **)error;

/**
 * Removes the failed transaction request permanently.
 *
 * @param failedOfflineRequest The failed transaction request to remove.
 * @param error The error to be populated with {@link StorageErrorCode} if problems occur while accessing database.
 */
-(void)removeFailedTransactionRequest:(OfflineRequest *)failedOfflineRequest error:(NSError **)error;

/**
 * Resends the failed transaction request.
 *
 * @param failedOfflineRequest The failed transaction request to remove.
 * @param delegate The delegate to be informed when the resending has been completed.
 * @param error The error to be populated with {@link StorageErrorCode} if problems occur while accessing database.
 */
-(void)resendFailedTransactionRequest:(OfflineRequest *)failedOfflineRequest delegate:(id<OfflineDelegate>)delegate error:(NSError **)error;;

@end