//
//  SalesTableViewCell.m
//  ScoopTrack
//
//  Created by Benjamin Ragheb on 9/16/20.
//  Copyright © 2020 Emergent Properties Inc. All rights reserved.
//

#import "SalesTableViewCell.h"
#import "AppDelegate.h"
#import "ScoopTrack+CoreDataModel.h"

@implementation SalesTableViewCell
{
    BOOL _didSetUpConstraints;
}


- (void)awakeFromNib {
    [super awakeFromNib];

    // Headline Label shows the date range for this cell

    _headlineLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _headlineLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _headlineLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    _headlineLabel.numberOfLines = 1;
    _bodyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_headlineLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                    forAxis:UILayoutConstraintAxisVertical];
    [_headlineLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh
                                      forAxis:UILayoutConstraintAxisVertical];
    [self.contentView addSubview:_headlineLabel];

    // Graph Image View displays a pie chart of revenue by product

    _graphImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _graphImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [_graphImageView setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                     forAxis:UILayoutConstraintAxisHorizontal];
    [_graphImageView setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                     forAxis:UILayoutConstraintAxisVertical];
    [_graphImageView setContentHuggingPriority:UILayoutPriorityRequired
                                       forAxis:UILayoutConstraintAxisHorizontal];
    [_graphImageView setContentHuggingPriority:UILayoutPriorityRequired
                                       forAxis:UILayoutConstraintAxisVertical];
    [self.contentView addSubview:_graphImageView];

    // Body Label displays the top five products

    _bodyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _bodyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _bodyLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _bodyLabel.numberOfLines = 0;
    _bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_bodyLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh
                                                forAxis:UILayoutConstraintAxisVertical];
    [_bodyLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh
                                  forAxis:UILayoutConstraintAxisVertical];
    [self.contentView addSubview:_bodyLabel];

//    _headlineLabel.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
//    _bodyLabel.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.1];
//    _graphImageView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.1];

    [self setNeedsUpdateConstraints];
}


- (void)updateConstraints {
    BOOL needToUpdateConstraints;

    @synchronized (self) {
        needToUpdateConstraints = ! _didSetUpConstraints;
        _didSetUpConstraints = YES;
    }

    if (needToUpdateConstraints) {
        UILayoutGuide *guide = self.contentView.safeAreaLayoutGuide;

        // Headline Label at the top

        [[self.headlineLabel.topAnchor
          constraintEqualToSystemSpacingBelowAnchor:guide.topAnchor
          multiplier:1] setActive:YES];
        [[self.headlineLabel.leadingAnchor
          constraintEqualToSystemSpacingAfterAnchor:guide.leadingAnchor
          multiplier:1] setActive:YES];
        [[guide.trailingAnchor
          constraintEqualToSystemSpacingAfterAnchor:self.headlineLabel.trailingAnchor
          multiplier:1] setActive:YES];
        [[guide.bottomAnchor
          constraintGreaterThanOrEqualToSystemSpacingBelowAnchor:self.headlineLabel.bottomAnchor
          multiplier:1] setActive:YES];

        // Graph Image View is below Headline to the left

        [[self.graphImageView.topAnchor
          constraintEqualToSystemSpacingBelowAnchor:self.headlineLabel.bottomAnchor
          multiplier:1] setActive:YES];
        [[self.graphImageView.leadingAnchor
          constraintEqualToSystemSpacingAfterAnchor:guide.leadingAnchor
          multiplier:1] setActive:YES];
        [[guide.bottomAnchor
          constraintGreaterThanOrEqualToSystemSpacingBelowAnchor:self.graphImageView.bottomAnchor
          multiplier:1] setActive:YES];

        // Body Label is below Headline on the right

        [[self.bodyLabel.leadingAnchor
          constraintEqualToSystemSpacingAfterAnchor:self.graphImageView.trailingAnchor
          multiplier:1] setActive:YES];

        [[self.bodyLabel.topAnchor
          constraintEqualToSystemSpacingBelowAnchor:self.headlineLabel.bottomAnchor
          multiplier:1] setActive:YES];
        [[guide.trailingAnchor
          constraintGreaterThanOrEqualToSystemSpacingAfterAnchor:self.bodyLabel.trailingAnchor
          multiplier:1] setActive:YES];
        [[guide.bottomAnchor
          constraintGreaterThanOrEqualToSystemSpacingBelowAnchor:self.bodyLabel.bottomAnchor
          multiplier:1] setActive:YES];
    }

    [super updateConstraints];
}


- (void)configureWithEarliestDate:(NSDate *)earliestDate latestDate:(NSDate *)latestDate {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.calendar = [NSCalendar currentCalendar];
    df.dateStyle = NSDateFormatterShortStyle;
    df.timeStyle = NSDateFormatterNoStyle;

    NSUInteger year = [df.calendar ordinalityOfUnit:NSCalendarUnitYearForWeekOfYear
                                             inUnit:NSCalendarUnitEra
                                            forDate:earliestDate];
    NSUInteger week = [df.calendar ordinalityOfUnit:NSCalendarUnitWeekOfYear
                                             inUnit:NSCalendarUnitYearForWeekOfYear
                                            forDate:earliestDate];

    self.headlineLabel.text = [NSString stringWithFormat:@"%04dW%02d: %@ to %@",
                               (int)year, (int)week,
                               [df stringFromDate:earliestDate], [df stringFromDate:latestDate]];

    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDel.persistentContainer.viewContext;
    [context performBlockAndWait:^{
        NSError *error = nil;

        NSFetchRequest *q = [NSFetchRequest fetchRequestWithEntityName:@"Transaction"];
        q.predicate = [NSPredicate predicateWithFormat:@"timestamp BETWEEN {%@, %@}", earliestDate, latestDate];

        NSArray *transactions = [context executeFetchRequest:q error:&error];
        if (transactions) {
            NSMutableDictionary *totalByProduct = [NSMutableDictionary dictionary];
            for (Transaction *t in transactions) {
                int oldTotal = [totalByProduct[t.product.name] intValue];
                totalByProduct[t.product.name] = @(oldTotal + t.amount);
            }

            [self updateTopItemsList:totalByProduct];
            self.graphImageView.image = [self pieChartImageForData:totalByProduct];
        } else {
            self.bodyLabel.text = [error description];
        }
    }];
}


- (UIImage *)pieChartImageForData:(NSMutableDictionary<NSString *,NSNumber *> *)totalByProduct {
    const CGFloat radius = 45;
    const CGSize imageSize = CGSizeMake(radius * 2, radius * 2);
    const CGPoint center = CGPointMake(radius, radius);

    CGFloat grandTotal = 0;
    for (NSNumber *total in [totalByProduct allValues]) {
        grandTotal += [total floatValue];
    }

    @try {
        __block CGFloat angleStart = 0;

        UIGraphicsBeginImageContextWithOptions(imageSize, NO, self.window.screen.scale);
        [totalByProduct enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull name,
                                                            NSNumber * _Nonnull total,
                                                            BOOL * _Nonnull stop) {
            [[self colorForProductNamed:name] setFill];

            CGFloat angle = ([total doubleValue] / grandTotal) * (2.0 * M_PI);
            if (angle > 0) {
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path moveToPoint:center];
                [path addArcWithCenter:center radius:radius startAngle:angleStart endAngle:(angleStart + angle) clockwise:YES];
                [path closePath];
                [path fill];
                angleStart += angle;
            }
        }];
        return UIGraphicsGetImageFromCurrentImageContext();
    } @finally {
        UIGraphicsEndImageContext();
    }
}


- (void)updateTopItemsList:(NSMutableDictionary *)totalByProduct {
    NSArray<NSString *> *sortedNames = [totalByProduct keysSortedByValueUsingSelector:@selector(compare:)];
    NSEnumerator *topNamesEnumerator = [sortedNames reverseObjectEnumerator];
    NSMutableAttributedString *topNames = [[NSMutableAttributedString alloc] init];
    NSString *name;
    for (int i = 1; i <= 5; i++) {
        if (i > 1) {
            [topNames appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        }
        if ((name = [topNamesEnumerator nextObject])) {
            float total = [totalByProduct[name] floatValue] / 100.0;
            UIColor *color = [[self colorForProductNamed:name] colorWithAlphaComponent:0.1];
            [topNames appendAttributedString:
             [[NSAttributedString alloc]
              initWithString:[NSString stringWithFormat:@"#%d. %@ ($%.2f)", i, name, total]
              attributes:@{NSBackgroundColorAttributeName: color}]];
        }
    }
    self.bodyLabel.attributedText = topNames;
}


- (UIColor *)colorForProductNamed:(NSString *)name
{
    __block UIColor *color;

    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDel.persistentContainer.newBackgroundContext;
    [context performBlockAndWait:^{
        NSFetchRequest *q = [NSFetchRequest fetchRequestWithEntityName:@"Product"];
        q.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];

        NSArray<Product *> *results = [context executeFetchRequest:q error:NULL];
        Product *product = [results firstObject];
        NSData *data = [[product rgbJSON] dataUsingEncoding:NSUTF8StringEncoding];
        NSArray<NSNumber *> *rgbValues = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        color = [UIColor colorWithRed:[[rgbValues objectAtIndex:0] floatValue]
                                green:[[rgbValues objectAtIndex:1] floatValue]
                                 blue:[[rgbValues objectAtIndex:2] floatValue]
                                alpha:1];
    }];
    return color;
}


@end
