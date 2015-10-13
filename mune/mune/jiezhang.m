//
//  jiezhang.m
//  mune
//
//  Created by XZH on 15/10/10.
//  Copyright (c) 2015年 就不给你上. All rights reserved.
//
#import "list.h"
#import "jiezhang.h"

@interface jiezhang () {
    CGFloat total;
}
- (IBAction)jiezhang:(UIButton *)sender;

@end

@implementation jiezhang

- (void)viewDidLoad {
    [super viewDidLoad];
    total = 0;
    [self requestData];
}

- (void)requestData {
    PFUser *User = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"list"];
    [query whereKey:@"yonghu" equalTo:User];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *obj in objects) {
                PFRelation *incomingRelation = [obj relationForKey:@"cai"];
                [[incomingRelation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        CGFloat sum = 0;
                        for (PFObject *food in objects) {
                            NSLog(@"%@", food[@"price"]);
                            sum += [food[@"price"] floatValue];
                        }
                        total += sum;
                        NSString *totalPrice = [Utilities notRounding:total afterPoint:2];
                        NSLog(@"totalPrice = %@", totalPrice);
                        _JZ.text = totalPrice;
                    }
                    else {
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
- (IBAction)jiezhang:(UIButton *)sender {
    //当前用户
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"list"];
    [query whereKey:@"yonghu" equalTo:user];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *obj in objects) {
                [obj deleteInBackground];
            }
        }
    }];
}
   @end
