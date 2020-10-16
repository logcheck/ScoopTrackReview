//
//  Product+CoreDataProperties.h
//  
//
//  Created by Benjamin Ragheb on 9/17/20.
//
//  This file was automatically generated and should not be edited.
//

#import "Product+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Product (CoreDataProperties)

+ (NSFetchRequest<Product *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *rgbJSON;
@property (nullable, nonatomic, retain) NSSet<Transaction *> *transactions;

@end

@interface Product (CoreDataGeneratedAccessors)

- (void)addTransactionsObject:(Transaction *)value;
- (void)removeTransactionsObject:(Transaction *)value;
- (void)addTransactions:(NSSet<Transaction *> *)values;
- (void)removeTransactions:(NSSet<Transaction *> *)values;

@end

NS_ASSUME_NONNULL_END
