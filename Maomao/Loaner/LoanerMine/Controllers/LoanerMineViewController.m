//
//  LoanerMineViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/11/17.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerMineViewController.h"
#import "LoanerMineViewModel.h"
#import "ClientMineIntegralDetailsViewController.h"
#import "ClientMineSetUpViewController.h"
#import "ClientMineInviteFriendsViewController.h"
#import "LoanerHomeWalletViewController.h"
#import "LoanerStoreCustomerOrderViewController.h"
#import "LoanerMineCertificationViewController.h"
#import "LoanerMineRecertificationViewController.h"
#import "LoanerMineNetWorkViewModel.h"
#import "LoanerJiltSingleContainerViewController.h"

#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZLocationManager.h"

@interface LoanerMineViewController ()<TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *listTab;

@property (nonatomic, strong)LoanerMineNetWorkViewModel *netWorkViewModel;
@property (nonatomic, strong)LoanerMineViewModel *mineViewModel;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (strong, nonatomic) CLLocation *location;
/**
 头像url
 */
@property (nonatomic, copy)NSString *imageUrl;
@end

@implementation LoanerMineViewController

- (void)dealloc{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    [self.mineViewModel refresh];
    [self.netWorkViewModel.profileCommand execute:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
    [self.mineViewModel top];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageUrl = @"";
    [self setUpPublic];
    [self setUpMineViewModel];
    [self setUpNetwork];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:nil];
    });
}

- (void)setUpMineViewModel{
    [self.mineViewModel bindViewToViewModel:self.listTab];
    __weak typeof(self)weakSelf = self;
    [self.mineViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
        [weakSelf jumps:x];
    }];
}

- (void)setUpNetwork{
    [self.netWorkViewModel.profileCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        MMJF_ShareV.is_auth = [NSString stringWithFormat:@"%@",x[@"is_pass"]];
    }];
    
}

- (void)jumps:(NSString *)str{
    ClientUserModel *user =[NSKeyedUnarchiver unarchiveObjectWithFile:MMJF_UserInfoPath];
    MMJF_Log(@"%@",user.mobile);
    if (!user) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LogonFailure" object:nil userInfo:@{}];
        return;
    }
    switch ([str integerValue]) {
        case 0:
        {
            if ([MMJF_ShareV.is_auth isEqualToString:@"1"]) {
                LoanerMineCertificationViewController *vc = [[LoanerMineCertificationViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                LoanerMineRecertificationViewController *vc = [[LoanerMineRecertificationViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
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
        {//钱包
            LoanerHomeWalletViewController *vc = [[LoanerHomeWalletViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {//我的订单
            LoanerStoreCustomerOrderViewController *vc = [[LoanerStoreCustomerOrderViewController alloc]init];
            vc.isRefer = NO;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {//甩单记录
            LoanerJiltSingleContainerViewController *VC = [[LoanerJiltSingleContainerViewController alloc]init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 5:
        {//推荐有奖
            ClientMineInviteFriendsViewController *vc = [[ClientMineInviteFriendsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:
        {//设置
            ClientMineSetUpViewController *vc = [[ClientMineSetUpViewController alloc]init];
            vc.isC = NO;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7:
        {
            //选择头像
            [self pushTZImagePickerController];
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
        [weakSelf.netWorkViewModel.imguploadCommand execute:photos];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)setUpPublic{
    ///上传图片成功
    __weak typeof(self)weakSelf = self;
    [weakSelf.netWorkViewModel.imguploadCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        weakSelf.imageUrl = x[@"src"];
        NSDictionary *dic = @{@"url":weakSelf.imageUrl};
        [weakSelf.netWorkViewModel.userAvatarCommand execute:dic];
    }];
    //修改头像
    [weakSelf.netWorkViewModel.userAvatarCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        ClientUserModel *user =[NSKeyedUnarchiver unarchiveObjectWithFile:MMJF_UserInfoPath];
        user.header_img = weakSelf.imageUrl;
        BOOL ret =  [NSKeyedArchiver archiveRootObject:user toFile:MMJF_UserInfoPath];
        if (ret) {
            MMJF_Log(@"归档成功");
        }else{
            MMJF_Log(@"归档失败");
        }
        [weakSelf.mineViewModel refresh];
    }];
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

- (LoanerMineViewModel *)mineViewModel{
    if (!_mineViewModel) {
        _mineViewModel = [[LoanerMineViewModel alloc]init];
    }
    return _mineViewModel;
}

- (LoanerMineNetWorkViewModel *)netWorkViewModel{
    if (!_netWorkViewModel) {
        _netWorkViewModel = [[LoanerMineNetWorkViewModel alloc]init];
    }
    return _netWorkViewModel;
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
