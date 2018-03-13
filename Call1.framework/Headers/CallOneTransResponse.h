//
//  CallOneTransResponse.h
//  Slyce1
//
//  Created by Christopher on 03/03/2017.
//  Copyright © 2017 chris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CallOneTransResponse : NSObject
typedef enum {
    CALLTransapproved,        /*!< An approved transaction. */
    CALLTransPartialapproved, /*!< A partially approved transaction. */
    CALLTransDeclined         /*!< A declined transaction. */
} CALLTransResult;
typedef enum
{
    CALLTransactionStateUncommitted,         /*!< An uncommitted transaction (the confirmation request failed). */
    CALLTransactionStateCommitted,           /*!< A committed transaction. */
    CALLTransactionStateVoid,                /*!< A void transaction. */
    CALLTransactionStateUncommittedVoid      /*!< An uncommitted void transaction (the void request failed). */
} CALLTransactionState;
//NSArray * arrayk=[[NSArray alloc]initWithObjects:@"AuthCode",@"Status",@"MaskPan",@"AuthorizedAmount",@"CardReference",@"CardHash", nil];
@property (nonatomic,retain,readonly) NSString * AuthCode;
@property (nonatomic,retain,readonly) NSString * MaskPan;
@property (nonatomic,retain,readonly) NSString * AuthorizedAmount;
@property (nonatomic,retain,readonly) NSString * CardReference;
@property (nonatomic,retain,readonly) NSString * CardHash;
@property (nonatomic,retain,readonly) NSString * DateTime;
@property (nonatomic,copy,readonly) NSArray  * ErrorCodes;
@property (readonly) CALLTransactionState state;

/**
 * Gets the result of the transaction.
 *
 * This property is read-only.
 *
 * @return The result of the transaction.
 */
@property (readonly) CALLTransResult transactionResult;

-(id)initwith:(NSString *)auth;
- (void)setAuthcode:(NSString *)Value;
- (void)setMaskPan:(NSString *)Value;
- (void)setAuthorizedAmount:(NSString *)Value;
- (void)setCardReference:(NSString *)Value;
- (void)setCardHash:(NSString *)Value;
- (void)setDateTime:(NSString *)Value;
- (void)setTransactionResult: (CALLTransResult) Value;
- (void)setErrorCodes:(NSArray *)ErrorCodeArray;
- (void)setState:(CALLTransactionState)state;
@end
