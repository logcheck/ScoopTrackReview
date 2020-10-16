//
//  Transaction+CoreDataProperties.h
//  
//
//  Created by Benjamin Ragheb on 9/17/20.
//
//  This file was automatically generated and should not be edited.
//

#import "Transaction+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Transaction (CoreDataProperties)

+ (NSFetchRequest<Transaction *> *)fetchRequest;

@property (nonatomic) int32_t amount;
@property (nullable, nonatomic, copy) NSDate *timestamp;
@property (nullable, nonatomic, retain) Product *product;

@end

NS_ASSUME_NONNULL_END
