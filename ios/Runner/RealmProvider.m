//
//  RealmProvider.m
//  Runner
//
//  Created by Yoshihiro Tanaka on 2016/12/22.
//  Copyright © 2016年 The Chromium Authors. All rights reserved.
//

#import "RealmProvider.h"
#import "Person.h"

@implementation RealmProvider

@synthesize messageName = _messageName;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self->_messageName = @"realm";
    }
    return self;
}

- (NSString *)didReceiveString:(NSString *)message {
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingAllowFragments
                                                           error:nil];
    
    if (!dict) {
        return @"{}";
    }
    
    NSString *method = dict[@"method"];
    if ([method  isEqualToString: @"load"]) {
        NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
        result[@"result"] = [self loadAll];
        return [self dictToString:result];
    } else if ([method isEqualToString:@"save"]) {
        [self save:dict[@"params"]];
    } else if ([method isEqualToString:@"search"]) {
        NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
        result[@"result"] = [self search:dict[@"params"]];
        return [self dictToString:result];
    } else if ([method isEqualToString:@"delete"]) {
        [self deleteAll];
    }
    return @"{}";
}

- (NSString *) dictToString:(NSDictionary *)dict {
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:0
                                                     error:nil];
    if (data) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return @"{}";
}

- (NSArray *) loadAll {
    RLMResults *results = [Person allObjects];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < results.count; i++) {
        [arr addObject:[((Person *)results[i]) toDictionary]];
    }
    return arr;
}

- (NSArray *) search:(NSDictionary *)queries {
    NSString *queryString = @"";
    if (queries[@"firstName"]) {
        queryString = [queryString stringByAppendingString:
                       [NSString stringWithFormat:@"firstName CONTAINS '%@'", queries[@"firstName"]]];
    }
    if (queries[@"lastName"]) {
        if (queryString.length > 0) {
            queryString = [queryString stringByAppendingString:@" AND"];
        }
        queryString = [queryString stringByAppendingString:
                       [NSString stringWithFormat:@" lastName CONTAINS '%@'", queries[@"lastName"]]];
    }
    if (queries[@"age"]) {
        int age = [queries[@"age"] intValue];
        if (age != -1) {
        if (queryString.length > 0) {
            queryString = [queryString stringByAppendingString:@" AND"];
        }
        queryString = [queryString stringByAppendingString:
                       [NSString stringWithFormat:@" age == %d", age]];
        }
    }
    if (queries[@"country"]) {
        if (queryString.length > 0) {
            queryString = [queryString stringByAppendingString:@" AND"];
        }
        queryString = [queryString stringByAppendingString:
                       [NSString stringWithFormat:@" country CONTAINS '%@'", queries[@"country"]]];
    }
    RLMResults *results = [Person objectsWhere:queryString];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < results.count; i++) {
        [arr addObject:[((Person *)results[i]) toDictionary]];
    }
    return arr;
}

- (void) save:(NSDictionary *)dict {
    Person *person = [[Person alloc] init];
    person.firstName = dict[@"firstName"];
    person.lastName = dict[@"lastName"];
    person.age = [dict[@"age"] intValue];
    person.country = dict[@"country"];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:person];
    [realm commitWriteTransaction];
}

- (void) deleteAll {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm commitWriteTransaction];
}

@end
