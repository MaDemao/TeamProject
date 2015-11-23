//
//  AppDelegate.m
//  DreamBeginProject
//
//  Created by 马德茂 on 15/11/9.
//  Copyright © 2015年 MaDemao. All rights reserved.
//

#import "AppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MDMMyUser.h"
#import "MDMUserInfo.h"
#import "MDMMyVC.h"
#import "MDMPostTVC.h"
#import "MDMPost.h"
#import "MDMCommend.h"
#import "UMSocial.h"
#import "MDMFans.h"
#import "MDMCollect.h"
//
#import "LANTableViewController.h"
#import "ZWIntroductionViewController.h"

#import "FXLabel.h"
@interface AppDelegate ()
@property (nonatomic, strong) FXLabel *firstLabel;
@property (nonatomic, strong) FXLabel *secondLabel;
@property (nonatomic, strong) FXLabel *thirdyLabel;
@property (nonatomic, strong) FXLabel *fourthLabel;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [MDMUserInfo registerSubclass];
    [MDMMyUser registerSubclass];
    [MDMPost registerSubclass];
    [MDMCommend registerSubclass];
    [MDMFans registerSubclass];
    [MDMCollect registerSubclass];
    
    
    [AVOSCloud setApplicationId:@"IB145PVnPxFGL9d7E9X8qXpP"
                      clientKey:@"D7RFqtYU62so3MHbW1V4kQMT"];
    
    
    [UMSocialData setAppKey:@"5646898a67e58e8c57002553"];
    //
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
   
    
    
    
    
    
    [self rootView];
    
//    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//    [self.window addSubview:view];
//    view.image = [UIImage imageNamed:@"hello"];
//    
//    [UIView animateWithDuration:2.0 animations:^{
//        view.alpha = 0.01;
//    } completion:^(BOOL finished) {
//        [view removeFromSuperview];
//    }];
//    
    
    
    return YES;
}
#pragma mark --判断个登陆 显示页

- (void)rootView{
    //添加判断是否首次登陆
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"everLaunched"]) {
        //userDefaults 存储判定信息
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"everLaunched"];
        
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"firstLaunch"];
    }
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"firstLaunch"]) {
        //改写判定首次等陆为NO  确保以后不再走 此分支
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
        
        // 设置介绍图片数组
        NSArray *coverImageNames = @[@"smlvcdShadow@2x", @"smlvcdShadow@2x", @"smlvcdShadow@2x", @"smlvcdShadow@2x"];
        NSArray *backgroundImageNames = @[@"bj_1.png", @"bj_3.jpg", @"2.jpg", @"hello.png"];
        //文本内容分数组
        NSArray *titles = @[@"健康最宝贵",@"疾病早预防",@"论坛来互动",@"健康快乐伴你行"];
        
        //初始化轮播介绍控制器
        __block ZWIntroductionViewController *introductionVC = [[ZWIntroductionViewController alloc] initWithCoverImageNames:coverImageNames backgroundImageNames:backgroundImageNames titleArray:titles];
        
        //添加为跟试图
        self.window.rootViewController = introductionVC;
        
        //按钮 或最后页的回调方法
        introductionVC.didSelectedEnter = ^() {
            //更换APP跟试图
            introductionVC = nil;
            
            UINavigationController *BJ_rootVC = [[UINavigationController alloc]initWithRootViewController:[BJ_tabBarViewController new]];
            
            
            UINavigationController *rootVC = [[UINavigationController alloc]initWithRootViewController:[LANTableViewController new]];
            
            MDMPostTVC *postVC = [[MDMPostTVC alloc] init];
            postVC.isRef = YES;
            UINavigationController *postNC = [[UINavigationController alloc] initWithRootViewController:postVC];
            
            MDMMyVC *mdmMyVC = [[MDMMyVC alloc] init];
            mdmMyVC.view.backgroundColor = [UIColor whiteColor];
            
            UITabBarController *rootTBC = [[UITabBarController alloc] init];
            rootTBC.viewControllers = @[BJ_rootVC, rootVC, postNC, mdmMyVC];
            self.window.rootViewController=rootTBC;
        };
    }else{
        //判断非首次登陆直接跳转 首页
        UINavigationController *BJ_rootVC = [[UINavigationController alloc]initWithRootViewController:[BJ_tabBarViewController new]];
        
        
        UINavigationController *rootVC = [[UINavigationController alloc]initWithRootViewController:[LANTableViewController new]];
        
        MDMPostTVC *postVC = [[MDMPostTVC alloc] init];
        postVC.isRef = YES;
        UINavigationController *postNC = [[UINavigationController alloc] initWithRootViewController:postVC];
        
        MDMMyVC *mdmMyVC = [[MDMMyVC alloc] init];
        mdmMyVC.view.backgroundColor = [UIColor whiteColor];
        
        UITabBarController *rootTBC = [[UITabBarController alloc] init];
        rootTBC.viewControllers = @[BJ_rootVC, rootVC, postNC, mdmMyVC];
        self.window.rootViewController=rootTBC;
    }
}


#pragma mark -- 启动动画
- (void)animationView
{
    //设置启动图 拉近效果
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:self.window.bounds];
    //图片设置与启动图片一致
    imgView.image = [UIImage imageNamed:@"hello.png"];
    
    [self.window addSubview:imgView];
    //拉近动画
    [UIView animateWithDuration:2 animations:^{
        
        imgView.transform = CGAffineTransformScale(imgView.transform, 1.2, 1.2);
        
    } completion:^(BOOL finished) {
        //将试图消除
        [imgView removeFromSuperview];
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [MDMMyUser logOut];
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.MDM.DreamBeginProject" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DreamBeginProject" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DreamBeginProject.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
