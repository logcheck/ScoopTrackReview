//
//  SalesTableViewCell.h
//  ScoopTrack
//
//  Created by Benjamin Ragheb on 9/16/20.
//  Copyright © 2020 Emergent Properties Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SalesTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *headlineLabel;
@property (strong, nonatomic) IBOutlet UIImageView *graphImageView;
@property (strong, nonatomic) IBOutlet UILabel *bodyLabel;

- (void)configureWithEarliestDate:(NSDate *)earliestDate latestDate:(NSDate *)latestDate;

@end

NS_ASSUME_NONNULL_END
