//
//  UserRegisteredViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/11/22.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientRegisteredViewController.h"
#import "RegisteredCardView.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZLocationManager.h"
#import "AgreementViewController.h"
#import "ClientRegisteredViewModel.h"
#import "ClientMineWebPageViewController.h"

@interface ClientRegisteredViewController ()<TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
}
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic, strong)RegisteredCardView * card;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (strong, nonatomic) CLLocation *location;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLine;

/**
 头像url
 */
@property (nonatomic, copy)NSString *imageUrl;
@property (nonatomic, strong)ClientPublicBaseViewModel *publicbaseViewModel;
@property (nonatomic, strong)ClientRegisteredViewModel *registeredViewModel;
@end

@implementation ClientRegisteredViewController

- (void)dealloc{
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    //rac点击事件
    [self setUpClick];
    if (MMJF_HEIGHT > 800) {
        self.topLine.constant = 52;
    }
    
}
//设置UI
- (void)setUpUI{
    self.imageUrl = @"";
    [self.backView.layer setShadow:6 opacity:1 color:[UIColor colorWithRed:245.0f/255.0f green:143.0f/255.0f blue:0.0f/255.0f alpha:0.7f] shadowRadius:12 shadowOffset:CGSizeMake(2, 3)];
    self.card = [[[NSBundle mainBundle]loadNibNamed:@"RegisteredCardView" owner:self options:nil] lastObject];
    self.card.frame = self.backView.bounds;
    [self.backView addSubview:self.card];
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
        weakSelf.card.headImage.image = photos[0];
        [weakSelf.publicbaseViewModel.imguploadCommand execute:photos];
    }];
    ///上传图片成功
    [weakSelf.publicbaseViewModel.imguploadCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        weakSelf.imageUrl = x[@"src"];
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
#pragma mark--点击事件
//设置点击
- (void)setUpClick{
    @weakify(self);
    //返回登录
    [[self.card.logBut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    //验证验证码成功
    [self.publicbaseViewModel.checkCodeCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSDictionary *dic;
        if (self.isC == YES) {
            dic = @{@"mobile":self.card.phoneText.text,@"password":self.card.passWordText.text,@"platform":@"3",@"type":@"1"};
        }else{
            dic = @{@"mobile":self.card.phoneText.text,@"password":self.card.passWordText.text,@"platform":@"3",@"type":@"2"};
        }
        [self.registeredViewModel.registereCommand execute:dic];
    }];
    //注册
    [[self.card.registeredBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        NSDictionary *dic = @{@"mobile":self.card.phoneText.text,@"code":self.card.codeText.text};
        [self.publicbaseViewModel.checkCodeCommand execute:dic];
    }];
    //注册成功
    [self.registeredViewModel.registereCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [MMJF_DEFAULTS setObject:self.imageUrl forKey:self.card.phoneText.text];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    //选择头像
    [[self.card.headImageBut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self pushTZImagePickerController];
    }];
    //点击协议
    [[self.card.agreementBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        ClientMineWebPageViewController *vc = [[ClientMineWebPageViewController alloc]init];
        vc.number = 2;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

//返回
- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

- (ClientRegisteredViewModel *)registeredViewModel{
    if (!_registeredViewModel) {
        _registeredViewModel = [[ClientRegisteredViewModel alloc]init];
    }
    return _registeredViewModel;
}

- (ClientPublicBaseViewModel *)publicbaseViewModel{
    if (!_publicbaseViewModel) {
        _publicbaseViewModel = [[ClientPublicBaseViewModel alloc]init];
    }
    return _publicbaseViewModel;
}
@end
