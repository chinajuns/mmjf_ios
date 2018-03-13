//
//  LoanerMineCertificationViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/14.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerMineCertificationViewController.h"
#import "LoanerMineCertificationViewModel.h"
#import "LoanerMineNetWorkViewModel.h"
#import "LoanerMineCertificationTwoViewController.h"

#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZLocationManager.h"

@interface LoanerMineCertificationViewController ()<TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *listTab;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (strong, nonatomic) CLLocation *location;

@property (nonatomic, strong)LoanerMineNetWorkViewModel *netWorkViewModel;
/**
 头像url
 */
@property (nonatomic, copy)NSString *imageUrl;
@property (nonatomic, strong)LoanerMineCertificationViewModel *certificationViewModel;
@end

@implementation LoanerMineCertificationViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    [self setUpCertificationViewModel];
}

- (void)setUpCertificationViewModel{
    [self.certificationViewModel bindViewToViewModel:self.listTab];
    __weak typeof(self)weakSelf = self;
    [self.certificationViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
        if (![x isKindOfClass:[NSDictionary class]]) {
            [weakSelf pushTZImagePickerController];
        }else{
            MMJF_Log(@"%@",x);
            LoanerMineCertificationTwoViewController *vc = [[LoanerMineCertificationTwoViewController alloc]init];
            vc.dict = x;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
}

#pragma mark - TZImagePickerController

- (void)pushTZImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:1 delegate:self pushPhotoPickerVc:YES];
    // imagePickerVc.navigationBar.translucent = NO;
    //    imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    //    if (iOS7Later) {
    //        imagePickerVc.navigationBar.barTintColor = [UIColor whiteColor];
    //    }
    //    imagePickerVc.navigationBar.tintColor =  [UIColor blackColor];
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = NO;
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
        weakSelf.certificationViewModel.img = photos[0];
        [weakSelf.netWorkViewModel.imguploadCommand execute:photos];
    }];
    ///上传图片成功
    [weakSelf.netWorkViewModel.imguploadCommand.executionSignals.
     switchToLatest subscribeNext:^(id  _Nullable x) {
         weakSelf.imageUrl = x[@"src"];
         [weakSelf.certificationViewModel refresh:x[@"src"]];
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

- (LoanerMineCertificationViewModel *)certificationViewModel{
    if (!_certificationViewModel) {
        _certificationViewModel = [[LoanerMineCertificationViewModel alloc]init];
    }
    return _certificationViewModel;
}

- (LoanerMineNetWorkViewModel *)netWorkViewModel{
    if (!_netWorkViewModel) {
        _netWorkViewModel = [[LoanerMineNetWorkViewModel alloc]init];
    }
    return _netWorkViewModel;
}
@end
