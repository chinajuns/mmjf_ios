//
//  ClientMineViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/11/17.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineViewController.h"
#import "ClientMineListViewModel.h"
#import "ClientMineIntegralDetailsViewController.h"
#import "ClientMineSetUpViewController.h"
#import "ClientMineRealNameViewController.h"
#import "ClientMineCollectionViewController.h"
#import "ClientMineOrderViewController.h"
#import "ClientMineInviteFriendsViewController.h"
#import "ClientMineAccountBindingViewController.h"
#import "ClientUserModel.h"
#import "ClientMineRealNameThreeViewController.h"
#import "ClientMineWebPageViewController.h"
#import "LogHomeViewController.h"
#import "MMJFBaseNavigationViewController.h"

#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZLocationManager.h"

@interface ClientMineViewController ()<TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mineTab;
@property (nonatomic, strong)ClientMineListViewModel *mineListViewModel;


@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (strong, nonatomic) CLLocation *location;

/**
 头像url
 */
@property (nonatomic, copy)NSString *imageUrl;
@end

@implementation ClientMineViewController

- (void)dealloc{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    [self.mineListViewModel refresh];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
    [self.mineListViewModel top];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageUrl = @"";
    [self setUpMineListViewModel];
    [self littleEed];
}

- (void)setUpMineListViewModel{
    [self.mineListViewModel bindViewToViewModel:self.mineTab];
    __weak typeof(self)weakSelf = self;
    [weakSelf.mineListViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
        [weakSelf jump:x];
    }];
    
}

//设置
- (void)littleEed{
    __weak typeof(self)weakSelf = self;
    [self.mineListViewModel.networkViewModel.checkNoticeCommand.executionSignals.
     switchToLatest subscribeNext:^(id  _Nullable x) {
         MMJF_Log(@"%@",x);
         MMJF_ShareV.is_auth = [NSString stringWithFormat:@"%@",x[@"is_auth"]];
         if (![MMJF_ShareV.is_auth isEqualToString:@"1"]) {
             ClientMineRealNameThreeViewController *vc = [[ClientMineRealNameThreeViewController alloc]init];
             [weakSelf.navigationController pushViewController:vc animated:YES];
         }else{
             ClientMineRealNameViewController *VC= [[ClientMineRealNameViewController alloc]init];
             [weakSelf.navigationController pushViewController:VC animated:YES];
         }
    }];
    
}

- (void)jump:(NSString *)tag{
    ClientUserModel *user =[NSKeyedUnarchiver unarchiveObjectWithFile:MMJF_UserInfoPath];
    MMJF_Log(@"%@",user.mobile);
    if (!user) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LogonFailure" object:nil userInfo:@{}];
        return;
    }
    switch ([tag integerValue]) {
        case 0:
        {//实名认证
            ClientUserModel *user =[NSKeyedUnarchiver unarchiveObjectWithFile:MMJF_UserInfoPath];
            if (user) {
                [self.mineListViewModel.networkViewModel.checkNoticeCommand execute:nil];
            }
            
        }
            break;
        case 1:
        {//积分
            ClientMineIntegralDetailsViewController *VC = [[ClientMineIntegralDetailsViewController alloc]init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 2:
        {//我的订单
            ClientMineOrderViewController *vc = [[ClientMineOrderViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {//收藏
            ClientMineCollectionViewController *vc = [[ClientMineCollectionViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {//推荐有奖
            ClientMineInviteFriendsViewController *vc = [[ClientMineInviteFriendsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5://信贷经理入住
        {
            LogHomeViewController *log = [[LogHomeViewController alloc]init];
            MMJFBaseNavigationViewController *nav = [[MMJFBaseNavigationViewController alloc]initWithRootViewController:log];
            MMJF_ShareV.isCustomer = YES;
            [self presentViewController:nav animated:YES completion:nil];

        }
            break;
        case 6:
        {
            ClientMineAccountBindingViewController *vc = [[ClientMineAccountBindingViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7:
        {//设置
            ClientMineSetUpViewController *vc = [[ClientMineSetUpViewController alloc]init];
            vc.isC = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 8:
        {//选择头像
            [self pushTZImagePickerController];
        }
            break;
        case 9:
        {//我能贷多少
            ClientMineWebPageViewController *vc = [[ClientMineWebPageViewController alloc]init];
            vc.number = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 10:
        {//房贷计算器
            ClientMineWebPageViewController *vc = [[ClientMineWebPageViewController alloc]init];
            vc.number = 6;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - TZImagePickerController

- (void)pushTZImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:1 delegate:self pushPhotoPickerVc:YES];
    // imagePickerVc.navigationBar.translucent = NO;
        imagePickerVc.navigationBar.barTintColor = MMJF_COLOR_Yellow;
    //    if (iOS7Later) {
    //        imagePickerVc.navigationBar.barTintColor = [UIColor whiteColor];
    //    }
    //    imagePickerVc.navigationBar.tintColor =  [UIColor blackColor];
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingImage = YES;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = YES;
    imagePickerVc.needCircleCrop = YES;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 30;
    NSInteger widthHeight = MMJF_WIDTH - 2 * left;
    NSInteger top = (MMJF_HEIGHT - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    
    imagePickerVc.isStatusBarDefault = NO;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    __weak typeof(self)weakSelf = self;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [weakSelf.mineListViewModel.networkViewModel.imguploadCommand execute:photos];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(CLLocation *location, CLLocation *oldLocation) {
        weakSelf.location = location;
    } failureBlock:^(NSError *error) {
        weakSelf.location = nil;
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        weakSelf.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            weakSelf.imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [weakSelf presentViewController:weakSelf.imagePickerVc animated:YES completion:nil];
    } else {
        MMJF_Log(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

#pragma mark--getter
- (ClientMineListViewModel *)mineListViewModel{
    if (!_mineListViewModel) {
        _mineListViewModel = [[ClientMineListViewModel alloc]init];
    }
    return _mineListViewModel;
}


- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        if (iOS7Later) {
            _imagePickerVc.navigationBar.barTintColor = [UIColor whiteColor];
        }
        _imagePickerVc.navigationBar.tintColor =  MMJF_COLOR_Yellow;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVc;
}
@end
