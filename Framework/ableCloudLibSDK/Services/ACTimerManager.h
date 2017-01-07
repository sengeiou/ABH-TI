//
//  ACTimerManager.h
//  AbleCloudLib
//
//  Created by zhourx5211 on 7/17/15.
//  Copyright (c) 2015 ACloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACTimerTask.h"
#import "ACDeviceMsg.h"
#import "ACKLVDeviceMsg.h"

#define TIMER_TASK_SERVICE @"zc-timer-task"

@interface ACTimerManager : NSObject

@property (strong, nonatomic) NSTimeZone *timeZone;

- (id)initWithTimeZone:(NSTimeZone *)timeZone;

/**
 * 创建定时任务(使用二进制模型)
 *
 * @param deviceId    设备id（这里的id，是调用list接口返回的id，不是制造商提供的id）
 * @param timePoint   任务时间点，时间格式为："yyyy-MM-dd HH:mm:ss",比如2015-08-08 16:39:03
 * @param timeCycle   单次定时任务：once
 *                    循环定时任务：按分重复：min
 *                    按小时重复：hour
 *                    按天重复：day
 *                    按月重复：month
 *                    按年复复：year
 *                    星期循环任务：week[0，1，2，3，4，5，6]如周一，周五重复，则表示为week[1，5]
 * @param description 自定义的任务描述
 * @param msg         具体的消息内容
 * @param callback    返回结果的监听回调
 */
- (void)addTaskWithDeviceId:(NSInteger)deviceId
                       name:(NSString *)name
                  timePoint:(NSString *)timePoint
                  timeCycle:(NSString *)timeCycle
                description:(NSString *)description
                  deviceMsg:(ACDeviceMsg *)deviceMsg
                   callback:(void (^)(NSError *error))callback;

/**
 * 创建定时任务(使用KLV模型)
 *
 * @param deviceId    设备id（这里的id，是调用list接口返回的id，不是制造商提供的id）
 * @param timePoint   任务时间点，时间格式为："yyyy-MM-dd HH:mm:ss",比如2015-08-08 16:39:03
 * @param timeCycle   单次定时任务：once
 *                    循环定时任务：按分重复：min
 *                    按小时重复：hour
 *                    按天重复：day
 *                    按月重复：month
 *                    按年复复：year
 *                    星期循环任务：week[0，1，2，3，4，5，6]如周一，周五重复，则表示为week[1，5]
 * @param description 自定义的任务描述
 * @param msg         具体的消息内容(使用KLV格式，具体代表含义需到官网上定义)
 * @param callback    返回结果的监听回调
 */
- (void)addTaskWithDeviceId:(NSInteger)deviceId
                       name:(NSString *)name
                  timePoint:(NSString *)timePoint
                  timeCycle:(NSString *)timeCycle
                description:(NSString *)description
               KLVDeviceMsg:(ACKLVDeviceMsg *)KLVDeviceMsg
                   callback:(void (^)(NSError *error))callback;

/**
 * 修改定时任务(使用二进制模型)
 *
 * @param deviceId    设备id（这里的id，是调用list接口返回的id，不是制造商提供的id）
 * @param taskId      任务id
 * @param timePoint   任务时间点，时间格式为："yyyy-MM-dd HH:mm:ss",比如2015-08-08 16:39:03
 * @param timeCycle   单次定时任务：once
 *                    循环定时任务：按分重复：min
 *                    按小时重复：hour
 *                    按天重复：day
 *                    按月重复：month
 *                    按年复复：year
 *                    星期循环任务：week[0，1，2，3，4，5，6]如周一，周五重复，则表示为week[1，5]
 * @param description 自定义的任务描述
 * @param msg         具体的消息内容
 * @param callback    返回结果的监听回调
 */
- (void)modifyTaskWithDeviceId:(NSInteger)deviceId
                        taskId:(NSInteger)taskId
                          name:(NSString *)name
                     timePoint:(NSString *)timePoint
                     timeCycle:(NSString *)timeCycle
                   description:(NSString *)description
                     deviceMsg:(ACDeviceMsg *)deviceMsg
                      callback:(void (^)(NSError *error))callback;

/**
 * 修改定时任务(使用KLV模型)
 *
 * @param deviceId    设备id（这里的id，是调用list接口返回的id，不是制造商提供的id）
 * @param taskId      任务id
 * @param timePoint   任务时间点，时间格式为："yyyy-MM-dd HH:mm:ss",比如2015-08-08 16:39:03
 * @param timeCycle   单次定时任务：once
 *                    循环定时任务：按分重复：min
 *                    按小时重复：hour
 *                    按天重复：day
 *                    按月重复：month
 *                    按年复复：year
 *                    星期循环任务：week[0，1，2，3，4，5，6]如周一，周五重复，则表示为week[1，5]
 * @param description 自定义的任务描述
 * @param msg         具体的消息内容(使用KLV格式，具体代表含义需到官网上定义)
 * @param callback    返回结果的监听回调
 */
- (void)modifyTaskWithDeviceId:(NSInteger)deviceId
                        taskId:(NSInteger)taskId
                          name:(NSString *)name
                     timePoint:(NSString *)timePoint
                     timeCycle:(NSString *)timeCycle
                   description:(NSString *)description
                  KLVDeviceMsg:(ACKLVDeviceMsg *)KLVDeviceMsg
                      callback:(void (^)(NSError *error))callback;

/**
 * 开启定时任务
 *
 * @param deviceId 设备id（这里的id，是调用list接口返回的id，不是制造商提供的id）
 * @param taskId   任务id
 * @param callback 返回结果的监听回调
 */
- (void)openTaskWithDeviceId:(NSInteger)deviceId
                      taskId:(NSInteger)taskId
                    callback:(void (^)(NSError *error))callback;

/**
 * 关闭定时任务
 *
 * @param deviceId 设备id（这里的id，是调用list接口返回的id，不是制造商提供的id）
 * @param taskId   任务id
 * @param callback 返回结果的监听回调
 */
- (void)closeTaskWithDeviceId:(NSInteger)deviceId
                       taskId:(NSInteger)taskId
                     callback:(void (^)(NSError *error))callback;

/**
 * 删除定时任务
 *
 * @param deviceId 设备id（这里的id，是调用list接口返回的id，不是制造商提供的id）
 * @param taskId   任务id
 * @param callback 返回结果的监听回调
 */
- (void)deleteTaskWithDeviceId:(NSInteger)deviceId
                        taskId:(NSInteger)taskId
                      callback:(void (^)(NSError *error))callback;

/**
 * 获取定时任务列表
 *
 * @param deviceId 设备id（这里的id，是调用list接口返回的id，不是制造商提供的id）
 * @param callback 返回结果的监听回调
 */
- (void)listTasksWithDeviceId:(NSInteger)deviceId
                     callback:(void (^)(NSArray *timerTaskArray, NSError *error))callback;

@end
