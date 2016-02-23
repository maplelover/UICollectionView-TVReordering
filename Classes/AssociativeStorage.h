//
//  AssociativeStorage.h
//  Sword
//
//  Created by zhoujinrui on 16/1/4.
//  Copyright © 2016年 Topvogues. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 使用联合存储为对象增加数据成员，新增加的数据成员会在使用者析构时自行销毁
 */
@interface AssociativeStorage : NSObject

// 为target对象保存key关联的数据成员object，会对object添加引用，不会对target添加引用
+ (void)setObject:(id)object forKey:(const void *)key withTarget:(id)target;

/// 获取target对象中key关联的数据成员，多线程中是安全的
+ (id)objectForKey:(const void *)key withTarget:(id)target;

/// 移除数据成员
+ (void)removeObjectForKey:(const void *)key withTarget:(id)target;

@end
