//
//  LoanerMineCertificationTwoViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/14.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerMineCertificationTwoViewController.h"
#import "ClientMineRealNameTwoViewModel.h"
#import "MaskView.h"

#import "LoanerMineCertificationThreeViewController.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZLocationManager.h"

@interface LoanerMineCertificationTwoViewController ()<TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *listTab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;

@property (nonatomic, strong)ClientMineRealNameTwoViewModel *realNameTwoViewModel;
@property (nonatomic, strong)MaskView *card1;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (strong, nonatomic) CLLocation *location;

@property (weak, nonatomic) IBOutlet UIButton *submitBut;
@end

@implementation LoanerMineCertificationTwoViewController

- (void)dealloc{
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [_card1 removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    self.submitBut.userInteractionEnabled = NO;
    //x的适配
    if (MMJF_HEIGHT > 800) {
        _line.constant = 34;
        
    }
    [self setUpRealNameViewModel];
}

- (void)setUpmask{
    _card1 = [[[NSBundle mainBundle]loadNibNamed:@"MaskView" owner:self options:nil] lastObject];
    _card1.frame = CGRectMake(0, 64, MMJF_WIDTH, MMJF_HEIGHT);
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    [appWindow addSubview:_card1];
}

//设置viewModel
- (void)setUpRealNameViewModel{
    [self.realNameTwoViewModel bindViewToViewModel:self.listTab];
    __weak typeof(self)weakSelf = self;
    [self.realNameTwoViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
        weakSelf.realNameTwoViewModel.number = [x integerValue];
        [weakSelf pushTZImagePickerController];
    }];
    //上传图片后提交
    [self.realNameTwoViewModel.uploadSubject subscribeNext:^(id  _Nullable x) {
        NSDictionary *dic = @{@"true_name":weakSelf.dict[@"0"][@"name"],@"cert_number":weakSelf.dict[@"1"][@"name"],@"province_id":weakSelf.dict[@"2"][@"province_id"],@"city_id":weakSelf.dict[@"2"][@"city_id"],@"region_id":weakSelf.dict[@"2"][@"region_id"],@"mechanism_type":weakSelf.dict[@"3"][@"name"],@"mechanism":weakSelf.dict[@"4"][@"name"],@"department":weakSelf.dict[@"5"][@"name"],@"header_img":weakSelf.dict[@"6"][@"name"],@"front_cert":x[0],@"back_cert":x[1],@"lng":MMJF_ShareV.lng?MMJF_ShareV.lng:@"0",@"lat":MMJF_ShareV.lat?MMJF_ShareV.lat:@"0"};
        LoanerMineCertificationThreeViewController *vc = [[LoanerMineCertificationThreeViewController alloc]init];
        vc.dict = dic;
        [weakSelf.navigationController pushViewController:vc animated:YES]; 
    }];
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
    
    imagePickerVc.isStatusBarDefault = NO;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    __weak typeof(self)weakSelf = self;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [weakSelf.realNameTwoViewModel.mutImgArray setObject:photos[0] atIndexedSubscript:weakSelf.realNameTwoViewModel.number];
        MMJF_Log(@"%@",weakSelf.realNameTwoViewModel.mutImgArray);
        for (id str in weakSelf.realNameTwoViewModel.mutImgArray) {
            if (![str isKindOfClass:[NSString class]]) {
                weakSelf.submitBut.userInteractionEnabled = YES;
                weakSelf.submitBut.backgroundColor = MMJF_COLOR_Yellow;
            }else{
                weakSelf.submitBut.userInteractionEnabled = NO;
                weakSelf.submitBut.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
                break;
            }
        }
        [weakSelf.realNameTwoViewModel refresh];
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

- (ClientMineRealNameTwoViewModel *)realNameTwoViewModel{
    if (!_realNameTwoViewModel) {
        _realNameTwoViewModel = [[ClientMineRealNameTwoViewModel alloc]init];
    }
    return _realNameTwoViewModel;
}

- (IBAction)clickBut:(UIButton *)sender {
    NSArray *imgs = @[self.realNameTwoViewModel.mutImgArray[0]];
    [self.realNameTwoViewModel.publicbaseViewModel.imguploadCommand execute:imgs];
}

@end
