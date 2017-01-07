//
//  ACBindManager.h
//  AbleCloudLib
//
//  Created by OK on 15/3/24.
//  Copyright (c) 2015年 ACloud. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ACDeviceMsg.h"
#import "ACMsg.h"
#import "ACUserDevice.h"

#define BIND_SERVICE @"zc-bind"

@interface ACBindManager : NSObject

#pragma mark 设备权限管理
/**
 *  获取设备列表,不包含设备状态信息
 *  
 *  @param callback     数组：devices保存的对象是ACUserDevice的对象
 */
+ (void)listDevicesWithCallback:(void(^)(NSArray *devices,NSError *error))callback;

/**
 *  获取设备列表,包含设备在线状态信息
 *
 *  @param callback     数组：devices保存的对象是ACUserDevice的对象
 */
+ (void)listDevicesWithStatusCallback:(void(^)(NSArray *devices,NSError *error))callback;

/**
 *  获取用户列表
 *
 *  @param deviceId 设备唯一标识
 *  @param callback 数组：users保存的对象是ACBindUser的对象
 */
+ (void)listUsersWithSubDomain:(NSString *)subDomain
                      deviceId:(NSInteger)deviceId
                     calllback:(void(^)(NSArray *users,NSError *error))callback;

/**
 *  绑定设备
 *
 *  @param physicalDeviceId 设备物理ID
 *  @param name             设备名称
 *  @param callback         回调 deviceId 设备的逻辑Id
 */
+ (void)bindDeviceWithSubDomain:(NSString *)subDomain
               physicalDeviceId:(NSString *)physicalDeviceId
                           name:(NSString *)name
                       callback:(void(^)(ACUserDevice *userDevice,NSError *error))callback;

/**
 * 修改设备扩展属性
 */
+ (void) setDeviceProfileWithSubDomain:(NSString *)subDomain
                              deviceId:(NSInteger)deviceId
                               profile:(ACObject *)profile
                              callback:(void (^) (NSError *error))callback;

/**
 * 获取设备扩展属性
 */
+ (void) getDeviceProfileWithSubDomain:(NSString*)subDomain
                              deviceId:(NSInteger)deviceId
                              callback:(void (^) (ACObject*profile, NSError *error))callback;

/**
 *  根据分享码 绑定设备
 *
 *  @param shareCode        分享码
 *  @param subDomain        主域名
 *  @param deviceId         逻辑  ID
 *  @param callback         回调 ACUserDevice 设备的对象
 */
+ (void)bindDeviceWithShareCode:(NSString *)shareCode
                      subDomain:(NSString *)subDomain
                       deviceId:(NSInteger )deviceId
                       callback:(void(^)(ACUserDevice *userDevice,NSError *error))callback;

/**
 *  根据账户绑定设备
 *
 *  @param subDomain 子域
 *  @param deviceId  设备ID
 *  @param phone     电话号码
 */
+ (void)bindDeviceWithUserSubdomain:(NSString *)subDomain
                           deviceId:(NSInteger)deviceId
                            account:(NSString *)account
                           callback:(void(^)(NSError *error))callback;
/**
 *  解绑设备
 *
 *  @param subDomain    子域名称
 *  @param deviceId     设备唯一标识
 */
+ (void)unbindDeviceWithSubDomain:(NSString *)subDomain
                         deviceId:(NSInteger)deviceId
                         callback:(void(^)(NSError *error))callback;


/**
 *  管理员取消 某个用户的绑定  （管理员接口）
 *
 *  @param subDomain 子域
 *  @param userId    用户ID
 *  @param deviceId  设备逻辑ID
 *  @param callback  回调
 */
+ (void)unbindDeviceWithUserSubDomain:(NSString *)subDomain
                               userId:(NSInteger)userId
                             deviceId:(NSInteger)deviceId
                             callback:(void(^)(NSError *error))callback;


/**
 *  设备管理员权限转让 （管理员接口）
 *
 *  @param subDomain    子域名称
 *  @param deviceId     设备逻辑ID
 *  @param userId       新的管理员ID
 */
+ (void)changeOwnerWithSubDomain:(NSString *)subDomain
                        deviceId:(NSInteger)deviceId
                          userId:(NSInteger)userId
                        callback:(void(^)(NSError *error))callback;
/**
 *  更换物理设备 （管理员接口）
 *
 *  @param subDomain        子域名称
 *  @param physicalDeviceId 设备物理ID
 *  @param deviceId         设备逻辑ID
 *  @param bindCode         绑定码(可选)
 */
+ (void)changeDeviceWithSubDomain:(NSString *)subDomain
                 physicalDeviceId:(NSString *)physicalDeviceId
                         deviceId:(NSInteger)deviceId
                         callback:(void(^)(NSError *error))callback;


/**
 *  修改设备名称 （管理员接口）
 *
 *  @param subDomain    子域名称
 *  @param deviceId     设备逻辑ID
 *  @param name         设备的新名称
 */
+ (void)changNameWithSubDomain:(NSString *)subDomain
                      deviceId:(NSInteger)deviceId
                          name:(NSString *)name
                      callback:(void(^)(NSError *error))callback;


/**
 *  获取分享码  （管理员接口）
 *
 *  @param subDomain 子域名称
 *  @param deviceId  设备唯一标识
 *  @param timeout   超时时间（秒）
 *  @callback        shareCode 分享码
 */
+ (void)getShareCodeWithSubDomain:(NSString *)subDomain
                         deviceId:(NSInteger)deviceId
                          timeout:(NSTimeInterval)timeout
                         callback:(void(^)(NSString *shareCode,NSError *error))callback;

#pragma mark 网关绑定

/**
 * 绑定网关
 *
 * @param subDomain        子域名，如djj（豆浆机）
 * @param physicalDeviceId 设备id（制造商提供的）
 * @param name             设备名字
 * @param callback         返回结果的监听回调
 */
+ (void)bindGatewayWithSubDomain:(NSString *)subDomain
                physicalDeviceId:(NSString *)physicalDeviceId
                            name:(NSString *)name
                        callback:(void (^)(ACUserDevice *device, NSError *error))callback;

/**
 * 解绑网关
 *
 * @param subDomain 子域名，如djj（豆浆机）
 * @param deviceId  设备id（这里的id，是调用list接口返回的id，不是制造商提供的id）
 * @param callback  返回结果的监听回调
 */
+ (void)unbindGatewayWithSubDomain:(NSString *)subDomain
                          deviceId:(NSInteger)deviceId
                          callback:(void (^)(NSError *error))callback;

/**
 * 添加子设备
 *
 * @param subDomain        子域名，如djj（豆浆机）
 * @param gatewayDeviceId  网关逻辑id
 * @param physicalDeviceId 设备id（制造商提供的）
 * @param name             子设备名称
 * @param callback         返回结果的监听回调
 */
+ (void)addSubDeviceWithSubDomain:(NSString *)subDomain
                  gatewayDeviceId:(NSInteger)gatewayDeviceId
                 physicalDeviceId:(NSString *)physicalDeviceId
                             name:(NSString *)name
                         callback:(void (^)(ACUserDevice *device, NSError *error))callback;

/**
 * 删除子设备
 *
 * @param subDomain 子域名，如djj（豆浆机）
 * @param deviceId  设备id（这里的id，是调用list接口返回的id，不是制造商提供的id）
 * @param callback  返回结果的监听回调
 */
+ (void)deleteSubDeviceWithSubDomain:(NSString *)subDomain
                            deviceId:(NSInteger)deviceId
                            callback:(void (^)(NSError *error))callback;

/**
 * 获取用户网关列表
 *
 * @param subDomain 子域名，如djj（豆浆机）
 * @param callback  返回结果的监听回调
 */
+ (void)listGatewaysWithSubDomain:(NSString *)subDomain
                         callback:(void (^)(NSArray *devices, NSError *error))callback;

/**
 * 获取用户子设备列表
 *
 * @param subDomain       子域名，如djj（豆浆机）
 * @param gatewayDeviceId 网关逻辑id
 * @param callback        返回结果的监听回调
 */
+ (void)listSubDevicesWithSubDomain:(NSString *)subDomain
                    gatewayDeviceId:(NSInteger)gatewayDeviceId
                           callback:(void (^)(NSArray *devices, NSError *error))callback;

/**
 * 获取网关新设备列表
 *
 * @param subDomain       子域名，如djj（豆浆机）
 * @param gatewayDeviceId 网关逻辑id
 * @param callback        返回结果的监听回调
 */
+ (void)listNewDevicesWithSubDomain:(NSString *)subDomain
                    gatewayDeviceId:(NSInteger)gatewayDeviceId
                           callback:(void (^)(NSArray *devices, NSError *error))callback;

/**
 * 开启网关接入
 *
 * @param subDomain       子域名，如djj（豆浆机）
 * @param gatewayDeviceId 网关逻辑id
 * @param time            开启时间
 * @param callback        返回结果的监听回调
 */
+ (void)openGatewayMatchWithSubDomain:(NSString *)subDomain
                      gatewayDeviceId:(NSInteger)gatewayDeviceId
                                 time:(NSInteger)time
                             callback:(void (^)(NSError *error))callback;

/**
 * 关闭网关接入
 *
 * @param subDomain       子域名，如djj（豆浆机）
 * @param gatewayDeviceId 网关逻辑id
 * @param callback        返回结果的监听回调
 */
+ (void)closeGatewayMathWithSubDomain:(NSString *)subDomain
                      gatewayDeviceId:(NSInteger)gatewayDeviceId
                             callback:(void (^)(NSError *error))callback;

/**
 * 剔除子设备
 *
 * @param subDomain       子域名，如djj（豆浆机）
 * @param gatewayDeviceId 网关逻辑id
 * @param physicalDeviceId 设备id（制造商提供的）
 * @param callback        返回结果的监听回调
 */
+ (void)evictSubDeviceWithSubDomain:(NSString *)subDomain
                    gatewayDeviceId:(NSInteger)gatewayDeviceId
                   physicalDeviceId:(NSString *)physicalDeviceId
                           callback:(void (^)(NSError *error))callback;

#pragma mark 设备查询控制接口
/**
 *  查询设备在线状态
 *
 *  @param subDomain        子域名称
 *  @param deviceId         设备逻辑ID
 *  @param subDomain        子域名称
 *  @param callback         online  是否在线
 */
+ (void)isDeviceOnlineWithSubDomain:(NSString *)subDomain
                           deviceId:(NSInteger)deviceId
                   physicalDeviceId:(NSString *)physicalDeviceId
                           callback:(void(^)(Boolean online,NSError *error))callback;

/**
 *  向设备发送消息
 *
 *  @param subDomain 子域名
 *  @param deviceId  设备逻辑ID
 *  @param msg       发送的消息
 */
+ (void)sendToDevice:(NSString *)subDomain
            deviceId:(NSInteger)deviceId
                 msg:(ACDeviceMsg *)msg
            callback:(void (^)(ACDeviceMsg *responseMsg, NSError *error))callback;
/**
 *  向设备发送消息
 *
 *  @param option    与设备交互的方式  1:仅通过局域网 2:仅通过云 3:通过云优先 4:通过局域网优先
 *  @param subDomain 子域名
 *  @param deviceId  设备逻辑ID
 *  @param msg       发送的消息
 *  @param callback  返回结果的监听
 */
+(void)sendToDeviceWithOption:(int)option SubDomain:(NSString *)subDomain
           deviceId:(NSInteger)deviceId
                msg:(ACDeviceMsg *)msg
           callback:(void (^)(ACDeviceMsg *responseMsg, NSError *error))callback;
/**
 *  监听网络变化并且更新设备信息
 *
 *  @param timeout     超时时间
 *  @param subDomainId 子域ID
 *  @param callback    返回结果的回调
 */
+(void)networkChangeHanderWithTimeout:(NSInteger)timeout SubDomainId:(NSInteger)subDomainId  Callback:(void(^)(NSArray * deviceArray,NSError *error))callback;
@end
