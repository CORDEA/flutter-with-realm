//
//  Person.h
//  Runner
//
//  Created by Yoshihiro Tanaka on 2016/12/22.
//  Copyright © 2016年 The Chromium Authors. All rights reserved.
//

#import <Realm/Realm.h>

@interface Person : RLMObject

@property (nonatomic, strong) NSString *firstName;

@property (nonatomic, strong) NSString *lastName;

@property (nonatomic, assign) int age;

@property (nonatomic, strong) NSString *country;

- (NSDictionary *) toDictionary;

@end
