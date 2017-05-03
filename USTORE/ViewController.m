//
//  ViewController.m
//  USTORE
//
//  Created by ZhangWei-SpaceHome on 2017/5/3.
//  Copyright © 2017年 zhangwei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSFileManager *fileManager;
    NSArray *fileArray;
}
@property (weak, nonatomic) IBOutlet UITableView *fileListTableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    fileManager = [NSFileManager defaultManager];
    fileArray = [[NSArray alloc] init];
    
    fileArray = [self getfileList];
    NSLog(@"%@",[fileArray firstObject]);
    NSLog(@"%@",[self getFilePathWithFileName:[fileArray firstObject]]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)getfileList
{
    NSError *error = nil;
    NSArray *files = [fileManager contentsOfDirectoryAtPath:[self documentDir] error:&error];
    return files;
}
- (IBAction)refreshFileList:(id)sender {
    fileArray = [self getfileList];
    [self.fileListTableView reloadData];
}

-(NSString *)documentDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return docDir;
}

-(NSString *)getFilePathWithFileName:(NSString *)fileName
{
    NSString *filePath = [[self documentDir] stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
    return filePath;
}

-(void)deleteFile:(NSString *)filePath
{
    NSError *error = nil;
    if ([fileManager removeItemAtPath:filePath error:&error]) {
        NSLog(@"delete file %@ success ",filePath);
    }else{
        NSLog(@"delete file %@ failed, %@",filePath, error.description);
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return fileArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *fileCell = [tableView dequeueReusableCellWithIdentifier:@"filecell"];
    if (!fileCell) {
        fileCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"filecell"];
    }
    fileCell.textLabel.text = fileArray[indexPath.row];
    return fileCell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteFile:[self getFilePathWithFileName:[fileArray objectAtIndex:indexPath.row]]];
        [self refreshFileList:nil];
    }
}

@end
