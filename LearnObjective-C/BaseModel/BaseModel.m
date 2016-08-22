//
//  BaseModel.m
//  LearnObjective-C
//
//  Created by donghuan1 on 16/8/22.
//  Copyright © 2016年 Dwight. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>
static NSMutableDictionary * propertys = nil;

@implementation BaseModel

+ (dispatch_queue_t)propertysStoreQueue
{
    static dispatch_queue_t propertysQueue = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        propertysQueue = dispatch_queue_create("property store queue", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return propertysQueue;
}

+ (void)initialize
{
    if (!propertys) {
        propertys = [[NSMutableDictionary alloc] init];
    }
    NSMutableArray *names = [[NSMutableArray alloc] init];
    
    for (Class class = self; class != [BaseModel class]; class = [class superclass]) {
        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
        for (int i = 0; i < propertyCount; i ++) {
            objc_property_t property = properties[i];
            NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
            if (![names containsObject:name]) {
                [names addObject:name];
            }
        }
        free(properties);
    }
    
    void (^doSet)(void) = ^{
        [propertys setObject:names forKey:NSStringFromClass(self)];
    };
    
    dispatch_barrier_async([self propertysStoreQueue], doSet);
    
}

- (NSArray *)allKeys
{
    NSArray __block *_allKeys = nil;
    dispatch_sync([self.class propertysStoreQueue], ^{
        _allKeys = [propertys objectForKey:NSStringFromClass([self class])];
    });
    return _allKeys;
}


- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init]))
    {
        for (NSString *name in [self allKeys])
        {
            id value = [decoder decodeObjectForKey:name];
            if (!value) continue;
            [self setValue:value forKey:name];
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    for (NSString *name in [self allKeys])
    {
        id value = [self valueForKey:name];
        if (!value) continue;
        if ([value respondsToSelector:@selector(encodeWithCoder:)]) {
            [encoder encodeObject:value forKey:name];
        }
    }
}

@end
