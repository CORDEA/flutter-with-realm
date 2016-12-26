//
//  Person.m
//  Runner
//
//  Created by Yoshihiro Tanaka on 2016/12/26.
//  Copyright © 2016年 The Chromium Authors. All rights reserved.
//

#import "Person.h"

@implementation Person

- (NSDictionary *) toDictionary {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"firstName"] = self.firstName;
    dict[@"lastName"] = self.lastName;
    dict[@"age"] = [NSNumber numberWithInt:self.age];
    dict[@"country"] = self.country;
    return dict;
}

@end
