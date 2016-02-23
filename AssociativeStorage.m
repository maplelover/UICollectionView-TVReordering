//
//  AssociativeStorage.m
//  Sword
//
//  Created by zhoujinrui on 16/1/4.
//  Copyright © 2016年 Topvogues. All rights reserved.
//

#import "AssociativeStorage.h"
#import <objc/runtime.h>

@implementation AssociativeStorage

+ (void)setObject:(id)object forKey:(const void *)key withTarget:(id)target
{
    objc_setAssociatedObject(target, key, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (id)objectForKey:(const void *)key withTarget:(id)target
{
    return objc_getAssociatedObject(target, key);
}

+ (void)removeObjectForKey:(const void *)key withTarget:(id)target
{
    objc_setAssociatedObject(target, key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
