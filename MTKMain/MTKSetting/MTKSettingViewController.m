//
//  MTKSettingViewController.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/22.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "MTKSettingViewController.h"
#import "MTKUnPairViewController.h"
#import "FmpGattClient.h"
@interface MTKSettingViewController ()<UITableViewDelegate,UITableViewDataSource,CachedBLEDeviceDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    NSArray *settingArr;
    BOOL searchDevice;
    NSTimer *searchTimer;
}
@property (weak, nonatomic) CachedBLEDevice *mDevice;
@property (strong, nonatomic) AVPlayer *avPlayer;
@end

@implementation MTKSettingViewController
@synthesize mDevice;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    mDevice = [CachedBLEDevice defaultInstance];
//    [mDevice registerAttributeChangedListener:self];
    [self initializeMethod];
    [self createUI];
     [self.setTab reloadData];
    
//    NSURL *url=[[NSBundle mainBundle]URLForResource:@"Alarm.mp3" withExtension:Nil];
//    
//    //2.实例化播放器
//   AVAudioPlayer *_player=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
//
//    //3.缓冲
//    [_player prepareToPlay];
//     [_player play];
//     _avPlayer = [[AVPlayer alloc] initWithURL:url];
//    [_avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 30) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
//        float seconds = CMTimeGetSeconds(time);
//        NSLog(@"wofgijgiorij  %f",seconds);
//    }];
//    [_avPlayer play];
//    [_player ]
}

- (void)viewWillDisappear:(BOOL)animated{
   
//     [mDevice unregisterAttributeChangedListener:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark *****初始化
- (void)initializeMethod{
    
    settingArr = @[MtkLocalizedString(@"setting_myinfo")/*,MtkLocalizedString(@"setting_myplan")*/,MtkLocalizedString(@"setting_boundsmawatch"),MtkLocalizedString(@"setting_unbindbound"),MtkLocalizedString(@"setting_lost"),MtkLocalizedString(@"setting_findDevice")];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(chectBLstate) userInfo:nil repeats:YES];
}

#pragma mark *****创建UI
- (void)createUI{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[MTKArchiveTool getUserInfo].userID]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString *preferredLan = [[allLanguages objectAtIndex:0] substringToIndex:2];
    if (![preferredLan isEqualToString:@"zh"]){
        [self.imageBut setBackgroundImage:[UIImage imageNamed:@"default_head_img_en"] forState:UIControlStateNormal];
    }
    else{
        [self.imageBut setBackgroundImage:[UIImage imageNamed:@"default_head_img"] forState:UIControlStateNormal];
    }
    NSData *data = [NSData dataWithContentsOfFile:uniquePath];
    UIImage *img = [[UIImage alloc] initWithData:data];
    if(img)
       [self.imageBut setBackgroundImage:img forState:UIControlStateNormal];

    [self chectBLstate];
    self.setTab.tableFooterView = [[UIView alloc] init];
    self.setTab.delegate = self;
    self.setTab.dataSource = self;
    _nameLab.text = [MTKArchiveTool getUserInfo].userName;
}

- (void)chectBLstate{
     CachedBLEDevice* device = [CachedBLEDevice defaultInstance];
    if (device.mConnectionState == 2) {
        _BLIndexView.image = [UIImage imageNamed:@"bluetooth_link_img"];
    }
    else{
        _BLIndexView.image = [UIImage imageNamed:@"bluetooth_disconnect_img"];
    }
}

#pragma mark *****UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELL"];
    }
    cell.accessoryView = nil;
    cell.textLabel.text = settingArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 3) {
        UISwitch *lostSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        cell.accessoryView = lostSwitch;
        [lostSwitch addTarget:self action:@selector(lostSet:) forControlEvents:UIControlEventValueChanged];
        lostSwitch.on = mDevice.mDisconnectEnabled;
        lostSwitch.onTintColor = [UIColor colorWithRed:55/255.0 green:139/255.0 blue:254/255.0 alpha:1];
    }
    return cell;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return settingArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:[MainStoryBoard instantiateViewControllerWithIdentifier:@"MTKUserTableViewController"] animated:YES];
    }
//    else if (indexPath.row == 1) {
//        [self.navigationController pushViewController:[MainStoryBoard instantiateViewControllerWithIdentifier:@"MTKSportPlanViewController"] animated:YES];
//    }
    else if (indexPath.row == 1) {
        NSMutableArray* array = [MTKDeviceParameterRecorder getDeviceParameters];
        if (array.count ==0) {
            MTKPairViewController *pairVC = [MainStoryBoard instantiateViewControllerWithIdentifier:@"MTKPairViewController"];
            pairVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pairVC animated:YES];
        }
        else{
            [MBProgressHUD showError:MtkLocalizedString(@"alert_alreadyband")];
        }
    }
    else if (indexPath.row == 2) {
//        if ([MTKBleMgr checkBleStatus]) {
        CachedBLEDevice* device = [CachedBLEDevice defaultInstance];
        if (!device.mDeviceIdentifier || [device.mDeviceIdentifier isEqualToString:@""]) {
            [MBProgressHUD showError:MtkLocalizedString(@"alert_nobang")];
            return;
        }
            UIAlertController *aler = [UIAlertController alertControllerWithTitle:MtkLocalizedString(@"alert_relieveband") message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:MtkLocalizedString(@"aler_can") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction *confim = [UIAlertAction actionWithTitle:MtkLocalizedString(@"aler_confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                MTKUnPairViewController *unPairVC = [MainStoryBoard instantiateViewControllerWithIdentifier:@"MTKUnPairViewController"];
                 unPairVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:unPairVC animated:YES];
            }];
            [aler addAction:cancelAct];
            [aler addAction:confim];
            [self presentViewController:aler animated:YES completion:^{
                
            }];
        }
    else if (indexPath.row == 4){
        if ([MTKBleMgr checkBleStatus]) {
            NSString *str = SEARCHDEVICE(!searchDevice);
            searchDevice = !searchDevice;
            [[MyController getMyControllerInstance] sendDataWithCmd:str mode:SEARCHDEVICE];
            if (searchTimer) {
                [searchTimer invalidate];
                searchTimer = nil;
            }
            searchTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(searchDeviceTimeOut) userInfo:nil repeats:NO];
            if (mDevice.mFindingState == FINDING_STATE_ON || mDevice.mAlertState == ALERT_STATE_ON)
            {
                if (mDevice.mFindingState == FINDING_STATE_ON)
                {
                    BOOL b = [[FmpGattClient getInstance] findTarget: 0];
                    if (b == YES)
                    {
                        NSLog(@"[MainTableViewController] [findAndConnectAction] do stop find action");
                        [mDevice setDeviceFindingState:FINDING_STATE_OFF];
                    }
                    else
                    {
                        NSLog(@"[MainTableViewController] [findAndConnectAction] stop action failed");
                    }
                }
                if (mDevice.mAlertState == ALERT_STATE_ON)
                {
                    NSLog(@"[MainTableViewController] [findAndConnectAction] do send stop remote alert action");
                    [mDevice updateAlertState:ALERT_STATE_OFF];
                }
            }
            else
            {
                BOOL b = [[FmpGattClient getInstance] findTarget: 2];
                if (b == YES)
                {
                    NSLog(@"[MainTableViewController] [findAndConnectAction] do find action");
                    [mDevice setDeviceFindingState:FINDING_STATE_ON];
                }
                else
                {
                    NSLog(@"[MainTableViewController] [findAndConnectAction] start find action failed");
                }
            }
        }
        else{
            searchDevice = NO;
        }
    }
}

- (void)searchDeviceTimeOut{
    if (searchTimer) {
        [searchTimer invalidate];
        searchTimer = nil;
    }
    NSString *str = SEARCHDEVICE(!searchDevice);
    searchDevice = !searchDevice;
    [[MyController getMyControllerInstance] sendDataWithCmd:str mode:SEARCHDEVICE];
}

- (void)lostSet:(UISwitch *)sender{
   
    if ([MTKBleMgr checkBleStatus]) {
//       [mDevice updateDeviceConfiguration:CONFIG_ALERT_SWITCH_STATE_CHANGE changedValue:YES];
         [mDevice updateDeviceConfiguration:CONFIG_DISCONNECT_ALERT_SWITCH_STATE_CHANGE changedValue:sender.isOn];
    }
   sender.on = mDevice.mDisconnectEnabled;
}

- (IBAction)imaSelector:(id)sender{
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing=YES;
    picker.sourceType=UIModalTransitionStyleCoverVertical;
    [self presentViewController:picker animated:YES completion:^{
        
    }];

}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage * image=[info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(selectPic:) withObject:image afterDelay:0.1];
}

-(void)selectPic:(UIImage*)image{
    [self.imageBut setBackgroundImage:image forState:UIControlStateNormal];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[MTKArchiveTool getUserInfo].userID]];
    BOOL result = [[self scaleToSize:image] writeToFile: filePath  atomically:YES];
    if(result){
        
    }
}

static float i = 0.1; float A = 0;
- (NSData *)scaleToSize:(UIImage *)imge{
    
    
    NSData *data;
    data= UIImageJPEGRepresentation(imge, 1);
    
    if (data.length > 70000) {
        [self zoomImaData:imge];
        data = UIImageJPEGRepresentation(imge,1-A);
        A = 0;
    }
    return data;
    
}

- (void)zoomImaData:(UIImage *)image{
    A = A + i;
    NSData *data = UIImageJPEGRepresentation(image,1-A);
    if (data.length > 70000) {
        [self zoomImaData:image];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)onDeviceAttributeChanged:(int)which{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
