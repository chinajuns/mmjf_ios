//
//  LoanerMineCertificationThreeViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/14.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerMineCertificationThreeViewController.h"
#import "LoanerMineRecertificationViewController.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZLocationManager.h"
#import "LoanerMineNetWorkViewModel.h"
#import "ClientMineWebPageViewController.h"

@interface LoanerMineCertificationThreeViewController ()<TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
/**
 同意协议按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *agreementBut;
@property (weak, nonatomic) IBOutlet UIView *backView1;
@property (weak, nonatomic) IBOutlet UIView *backView2;
@property (weak, nonatomic) IBOutlet UIView *backView3;
@property (weak, nonatomic) IBOutlet UIView *backView4;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet UIImageView *img4;

/**
 提交
 */
@property (weak, nonatomic) IBOutlet UIButton *submitBut;

/**
 记录选择的图片
 */
@property (nonatomic, strong)NSMutableArray *mutImgArray;
@property (nonatomic, strong)NSMutableArray *mutImgs;
/**
 记录选择图片下标
 */
@property (nonatomic, assign)NSInteger number;
/**
 记录上传下标
 */
@property (nonatomic, assign)NSInteger cotunt;
@property (nonatomic, strong)NSMutableArray *mutArray;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (strong, nonatomic) CLLocation *location;

@property (nonatomic, assign)BOOL isImg1;
@property (nonatomic, assign)BOOL isImg2;
@property (nonatomic, assign)BOOL isImg3;
@property (nonatomic, assign)BOOL isImg4;

@property (nonatomic, strong)LoanerMineNetWorkViewModel *netWorkViewModel;
@end

@implementation LoanerMineCertificationThreeViewController
- (void)dealloc{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    [self setUpNetWork];
    self.mutImgArray = [NSMutableArray array];
    
    for (int i = 0; i < 4; i ++) {
        [self.mutImgArray addObject:@""];
    }
    self.backView1.layer.borderWidth = self.backView2.layer.borderWidth = self.backView3.layer.borderWidth = self.backView4.layer.borderWidth = 1;
    self.backView1.layer.borderColor = self.backView2.layer.borderColor = self.backView3.layer.borderColor = self.backView4.layer.borderColor = MMJF_COLOR_Gray.CGColor;
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
        [weakSelf setUpPicture:photos[0]];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
//设置图片
- (void)setUpPicture:(UIImage *)img{
    [self.mutImgArray setObject:img atIndexedSubscript:self.number];
    MMJF_Log(@"%@",self.mutImgArray);
    for (int i = 0; i < self.mutImgArray.count; i ++) {
        id img = self.mutImgArray[i];
        if ([img isKindOfClass:[UIImage class]]) {
            switch (i) {
                case 0:
                {
                    self.img1.image = img;
                    self.img1.contentMode = UIViewContentModeScaleAspectFit;
                    self.isImg1 = YES;
                }
                    break;
                case 1:
                {
                    self.img2.image = img;
                    self.img2.contentMode = UIViewContentModeScaleAspectFit;
                    self.isImg2 = YES;
                }
                    break;
                case 2:
                {
                    self.img3.image = img;
                    self.img3.contentMode = UIViewContentModeScaleAspectFit;
                    self.isImg3 = YES;
                }
                    break;
                case 3:
                {
                    self.img4.image = img;
                    self.img4.contentMode = UIViewContentModeScaleAspectFit;
                    self.isImg4 = YES;
                }
                    break;
                default:
                    break;
            }
        }
    }
    [self setUpSubmitBut];
}
//设置提交按钮
- (void)setUpSubmitBut{
    if (((self.isImg1 && self.isImg2) || (self.isImg1 && self.isImg3) || (self.isImg1 && self.isImg4) || (self.isImg2 && self.isImg3) || (self.isImg2 && self.isImg4) || (self.isImg3 && self.isImg4)) && self.agreementBut.selected) {
        self.submitBut.backgroundColor = MMJF_COLOR_Yellow;
    }else{
        self.submitBut.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    }
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

- (void)setUpNetWork{
    __weak typeof(self)weakSelf = self;
    [self.netWorkViewModel.imguploadCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        [weakSelf.mutArray addObject:x[@"src"]];
        if (weakSelf.mutArray.count < weakSelf.mutImgs.count) {
            weakSelf.cotunt ++;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSArray *imgs = @[weakSelf.mutImgs[weakSelf.cotunt]];
                [weakSelf.netWorkViewModel.imguploadCommand execute:imgs];
            });
        }else{
            [weakSelf submitData];
        }
        MMJF_Log(@"%@",weakSelf.mutArray);
    }];
    [self.netWorkViewModel.submitProfileCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        LoanerMineRecertificationViewController *vc = [[LoanerMineRecertificationViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}
//提交
- (void)submitData{
    self.cotunt = 0;
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    for (int i = 0; i < self.mutImgArray.count; i ++) {
        id mut = self.mutImgArray[i];
        NSDictionary *dic1;
        NSDictionary *dic2;
        NSDictionary *dic3;
        NSDictionary *dic4;
        if ([mut isKindOfClass:[UIImage class]]) {
            switch (i) {
                case 0:
                {
                    dic1 = @{@"work_card":self.mutArray[0]};
                }
                    break;
                case 1:
                {
                    if (self.isImg1) {
                        dic2 = @{@"card":self.mutArray[1]};
                    }else{
                        dic2 = @{@"card":self.mutArray[0]};
                    }
                }
                    break;
                case 2:
                {
                    if (self.isImg1 && self.isImg2) {
                        dic3 = @{@"contract_page":self.mutArray[2]};
                    }else if (self.isImg1 || self.isImg2){
                        dic3 = @{@"contract_page":self.mutArray[1]};
                    }else{
                        dic3 = @{@"contract_page":self.mutArray[0]};
                    }
                }
                    break;
                case 3:
                {
                    if (self.isImg1 && self.isImg2 && self.isImg3) {
                        dic4 = @{@"logo_personal":self.mutArray[3]};
                    }else if ((self.isImg1 && self.isImg2) || (self.isImg1 && self.isImg3) || (self.isImg2 && self.isImg3)){
                        dic4 = @{@"logo_personal":self.mutArray[2]};
                    }else if (self.isImg1 || self.isImg2 || self.isImg3){
                        dic4 = @{@"logo_personal":self.mutArray[1]};
                    }else{
                        dic4 = @{@"logo_personal":self.mutArray[0]};
                    }
                }
                    break;
                default:
                    break;
            }
        }else{
            if (i == 0) {
                dic1 = @{@"work_card":@""};
            }else if (i == 1){
                dic2 = @{@"card":@""};
            }else if (i == 2){
                dic3 = @{@"contract_page":@""};
            }else{
               dic4 = @{@"logo_personal":@""};
            } 
        }
        [mutDic addEntriesFromDictionary:self.dict];
        [mutDic addEntriesFromDictionary:dic1];
        [mutDic addEntriesFromDictionary:dic2];
        [mutDic addEntriesFromDictionary:dic3];
        [mutDic addEntriesFromDictionary:dic4];
    }
    MMJF_Log(@"%@",mutDic);
    [self.netWorkViewModel.submitProfileCommand execute:mutDic];
}

//提交
- (IBAction)submitBut:(UIButton *)sender {
    self.mutImgs = [NSMutableArray array];
    for (id img in self.mutImgArray) {
        if ([img isKindOfClass:[UIImage class]]) {
            [self.mutImgs addObject:img];
        }
    }
    NSArray *imgs = @[self.mutImgs[0]];
    self.mutArray = [NSMutableArray array];
    [self.netWorkViewModel.imguploadCommand execute:imgs];
}
//选择图片
- (IBAction)choosePictureBut:(UIButton *)sender {
    self.number = sender.tag;
    [self pushTZImagePickerController];
}
//协议按钮
- (IBAction)agreementBut:(UIButton *)sender {
    if (sender.tag == 0) {
        self.agreementBut.selected = !self.agreementBut.selected;
        [self setUpSubmitBut];
    }else{//跳转协议H5
        ClientMineWebPageViewController *vc = [[ClientMineWebPageViewController alloc]init];
        vc.number = 7;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (LoanerMineNetWorkViewModel *)netWorkViewModel{
    if (!_netWorkViewModel) {
        _netWorkViewModel = [[LoanerMineNetWorkViewModel alloc]init];
    }
    return _netWorkViewModel;
}

@end
