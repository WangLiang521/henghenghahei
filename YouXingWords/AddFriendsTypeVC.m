//
//  AddFriendsTypeVC.m
//  YouXingWords
//
//  Created by Apple on 2017/5/5.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import "AddFriendsTypeVC.h"
#import "AddNewFriendVC.h"
#import "SGScanningQRCodeVC.h"
#import "NewFriendsInfoVC.h"

#import "CreatPayCodeVC.h"

#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>

@interface AddFriendsTypeVC ()<ABPeoplePickerNavigationControllerDelegate>


@end

@implementation AddFriendsTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.type == AddFriendTypeFamily) {
        self.title = @"添加陪伴号";
    }else{
        self.title = @"添加好友";
    }
}


#pragma mark 通过账号搜索
- (IBAction)tapSearchByAccount:(id)sender {
//    AddNewFriendVC *vc = [[AddNewFriendVC alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    [self pushToFriendInfoVC:nil];
}
#pragma mark 通过手机联系人
- (IBAction)tapBtnTel:(id)sender {
     NSLog(@"version = %@",[UIDevice currentDevice].systemVersion);
    ABPeoplePickerNavigationController *nav = [[ABPeoplePickerNavigationController alloc] init];
    nav.peoplePickerDelegate = self;

    if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0){
        nav.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
    }
   
    [self presentViewController:nav animated:YES completion:nil];
    
}

//取消选择
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

//iOS8下
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
    
    if ([phoneNO hasPrefix:@"+"]) {
        phoneNO = [phoneNO substringFromIndex:3];
    }
    [self pushToFriendInfoVC:phoneNO];
//    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    NSLog(@"%@", phoneNO);
//    if (phone && [ZXValidateHelper checkTel:phoneNO]) {
//        phoneNum = phoneNO;
//        [self.tableView reloadData];
//        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
//        return;
//    }
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person
{
    ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
    personViewController.displayedPerson = person;
    [peoplePicker pushViewController:personViewController animated:YES];
}


//iOS7下
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
    if ([phoneNO hasPrefix:@"+"]) {
        phoneNO = [phoneNO substringFromIndex:3];
    }
    
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    NSLog(@"%@", phoneNO);
//    if (phone && [ZXValidateHelper checkTel:phoneNO]) {
//        phoneNum = phoneNO;
//        [self.tableView reloadData];
//        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
//        return NO;
//    }
    [self pushToFriendInfoVC:phoneNO];
    return YES;
}




#pragma mark 扫一扫添加
- (IBAction)tapScanCode:(id)sender {
    SGScanningQRCodeVC *scanningQRCodeVC = [[SGScanningQRCodeVC alloc] init];
    WS(weakSelf);
    scanningQRCodeVC.scannFinishBlock = ^(NSString * codeString){
        [weakSelf pushToFriendInfoVC:codeString];
    };
    [self.navigationController pushViewController:scanningQRCodeVC animated:YES];
}


#pragma mark 我的二维码
- (IBAction)tapMyScanCode:(id)sender {
    CreatPayCodeVC * vc = [[CreatPayCodeVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushToFriendInfoVC:(NSString*)username{
    AddNewFriendVC *vc = [[AddNewFriendVC alloc] init];
    vc.preUserName = username;
    vc.addType = self.type;
    [self.navigationController pushViewController:vc animated:YES];
    
//    NewFriendsInfoVC *new=[[NewFriendsInfoVC alloc]init];
//    new.userName=username;
//    new.viewTag=300;
//    [self.navigationController pushViewController:new animated:YES];
}


@end
