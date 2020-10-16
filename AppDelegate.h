//
//  AppDelegate.h
//  ScoopTrack
//
//  Created by Benjamin Ragheb on 9/16/20.
//  Copyright © 2020 Emergent Properties Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

