//
//  list.m
//  mune
//
//  Created by XZH on 15/9/22.
//  Copyright (c) 2015年 就不给你上. All rights reserved.
//

#import "list.h"

@interface list ()

@end

@implementation list

- (void)viewDidLoad {
    [super viewDidLoad];
     [self requestData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData {
    PFQuery *query = [PFQuery queryWithClassName:@"list"];
    //关联表查询[例如abc三张表关联的方法(@"a2b.b2c")]
    [query includeKey:@"menu"];
    //获得保护膜
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        [aiv stopAnimating];
        if (!error) {
            _objectsForShow = returnedObjects;
            NSLog(@"%@", _objectsForShow);
            [_BD reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objectsForShow.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
    //关联表activity，拿到User表中Name
    PFObject *obj = object[@"menu"];
    cell.textLabel.text = obj[@"Name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", object[@"number"]];
    return cell;
}

@end
