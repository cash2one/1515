//
//  DownLoadManager.m
//  CarDemo
//
//  Created by Visitor on 14-11-5.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "DownLoadManager.h"

#import "AskModuleItem.h"
#import "AskItem.h"

#import "FamousSjsItem.h"
#import "BigItem.h"
#import "SjsItem.h"

#import "HotImgArrItem.h"
#import "NewZbItem.h"

#import "PhotoItem.h"
#import "PhotoDataItem.h"

#import "PersonInfo.h"
#import "PersonResult.h"

#import "DesignCase.h"
#import "PersonBlog.h"
#import "PersonComment.h"
#import "FindSjsResult.h"
#import "FindSjsData.h"

#import "DesignTradeData.h"
#import "ZXPhoto.h"
#import "AskAnswer.h"

#import "Question.h"
#import "Answer.h"
#import "MsgtoItem.h"
#import "RankList.h"

#import "SearchSjs.h"
#import "SearchPhoto.h"
#import "SearchAnswer.h"

#import "PersonName.h"
#import "MyInfo.h"
@implementation DownLoadManager
{
    NSMutableDictionary *_taskDict;
    NSMutableDictionary *_sourceDict;
}
- (id)init
{
    self = [super init];
    if (self) {
        _taskDict = [[NSMutableDictionary alloc]init];
        _sourceDict = [[NSMutableDictionary alloc]init];
    }
    return self;
}
+(DownLoadManager *)sharedDownLoadManager
{
    static DownLoadManager *_downLoadManager;
    if (!_downLoadManager) {
        _downLoadManager = [[DownLoadManager alloc]init];
    }
    return _downLoadManager;
}
-(void)addDownLoadWithDownStr:(NSString *)downLoadString andDownLoadType:(int)downLoadType andIsRefresh:(BOOL)isRefresh andDownLoadPage:(int)downLoadPage
{

    /*
     {{母串 字串} 数据}
     */
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
//    [dict setObject:[NSString stringWithFormat:@"%d",downLoadPage] forKey:downLoadString];
//    
//    NSMutableDictionary *dlDict = [[NSMutableDictionary alloc]init];
//    [dlDict setObject:@"数据" forKey:dict];

    //1 组织字串和母串;
    NSString *dlString;
    if (downLoadPage>=0) {
        dlString = [NSString stringWithFormat:downLoadString,downLoadPage];
    }
    else{
        dlString = downLoadString;
    }
    
    //2判断刷新
    if (isRefresh) {
        if (![_taskDict objectForKey:[NSString stringWithFormat:downLoadString,downLoadPage]]) {
            //刷新操作
            DownLoad *dl = [[DownLoad alloc]init];
            dl.downLoadString = downLoadString;
            dl.downLoadPage = downLoadPage;
            dl.downLoadType = downLoadType;
            dl.downLoadIsRefresh = YES;
            dl.delegate = self;
            [_taskDict setObject:dl forKey:dlString];
            [dl downLoad];
            
        }
        else{
            NSLog(@"正在刷新操作.....");
        }
    }
    else{
        BOOL isDownLoad = YES;
        for(NSDictionary *dict in [_sourceDict allKeys]) {
            if ([dict objectForKey:downLoadString]) {
                if ([[dict objectForKey:downLoadString] isEqualToString:[NSString stringWithFormat:@"%d",downLoadPage]]) {
                    isDownLoad = NO;
                    break;
                }
            }
        }
        if (isDownLoad) {
            //下载数据
            if (![_taskDict objectForKey:[NSString stringWithFormat:downLoadString,downLoadPage]]) {
                DownLoad *dl = [[DownLoad alloc]init];
                dl.downLoadString = downLoadString;
                dl.downLoadPage = downLoadPage;
                dl.downLoadType = downLoadType;
                dl.downLoadIsRefresh = isRefresh;
                dl.delegate = self;
                [dl downLoad];
                [_taskDict setObject:dl forKey:dlString];
            }else{
                NSLog(@"数据下载中.....");
            }
        }
        else{
            //存在缓存直接取得数据
            [[NSNotificationCenter defaultCenter] postNotificationName:downLoadString object:nil];
        }
    }
}
-(void)downLoadFinishWithClass:(DownLoad *)dl
{
    //移除任务队列
    NSString *dlString;
    if (dl.downLoadPage>=0) {
        dlString = [NSString stringWithFormat:dl.downLoadString,dl.downLoadPage];
    }
    else{
        dlString = dl.downLoadString;
    }
    [_taskDict removeObjectForKey:dlString];
    
    //解析的过程
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:dl.downLoadData options:NSJSONReadingMutableContainers error:nil];

    if (dl.downLoadType == kTYPE_HOME) {
        //askModule
        NSDictionary *askModuleDict = [rootDict objectForKey:@"askModule"];
        AskModuleItem *askMI = [[AskModuleItem alloc]init];
        askMI.askNum = askModuleDict[@"askNum"];

        NSArray *askArray = [askModuleDict objectForKey:@"ask"];
        for (NSDictionary *askSubDict in askArray) {
            AskItem *ai = [[AskItem alloc]init];
            ai.comment_nums = askSubDict[@"comment_nums"];
            ai.height = askSubDict[@"height"];
            ai.uid= askSubDict[@"id"];
            ai.image_src = askSubDict[@"image_src"];
            ai.last_acttime = askSubDict[@"last_acttime"];
            ai.title = askSubDict[@"title"];
            ai.view_nums = askSubDict[@"view_nums"];
            ai.width = askSubDict[@"width"];
            [askMI.ask addObject:ai];
        }
        [dataArray addObject:askMI];
        
        //famousSjs
        NSDictionary *famousSjsDict = [rootDict objectForKey:@"famousSjs"];
        FamousSjsItem *fsi = [[FamousSjsItem alloc]init];
        fsi.famousSjsNum = famousSjsDict[@"famousSjsNum"];
        
        NSDictionary *bigDict = [famousSjsDict objectForKey:@"big"];
        BigItem *bi = [[BigItem alloc]init];
        bi.added_by = bigDict[@"added_by"];
        bi.headphoto = bigDict[@"headphoto"];
        bi.uid = bigDict[@"id"];
        bi.nick = bigDict[@"nick"];
        bi.path = bigDict[@"path"];
        bi.yuyueNum = bigDict[@"yuyueNum"];
        fsi.big = bi;
        
        NSArray *sjsArray = [famousSjsDict objectForKey:@"sjs"];
        for (NSDictionary *sjsSubArray in sjsArray) {
            SjsItem *si = [[SjsItem alloc]init];
            si.headphoto = sjsSubArray[@"headphoto"];
            si.nick = sjsSubArray[@"nick"];
            si.uid = sjsSubArray[@"uid"];
            [fsi.sjs addObject:si];
        }
        [dataArray addObject:fsi];

        //hotImgArr
        NSArray *hotImgArray = [rootDict objectForKey:@"hotImgArr"];
        NSMutableArray *hotMuArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dict in hotImgArray) {
            HotImgArrItem *hiai = [[HotImgArrItem alloc]init];
            hiai.category = dict[@"category"];
            hiai.col_num = dict[@"col_num"];
            hiai.uid = dict[@"id"];
            hiai.img = dict[@"img"];
            hiai.title = dict[@"title"];
            hiai.url = dict[@"url"];
            
            [hotMuArray addObject:hiai];
        }
        [dataArray addObject:hotMuArray];
        
        NSDictionary *newZbDict = [rootDict objectForKey:@"newZb"];
        NewZbItem *nzi = [[NewZbItem alloc]init];
        nzi.zbNum = [newZbDict objectForKey:@"zbNum"];
        [dataArray addObject:nzi];
        
    }
    else if(dl.downLoadType == kTYPE_PHOTO){
        PhotoItem *pi = [[PhotoItem alloc]init];
        pi.rank = rootDict[@"rank"];
        pi.totalnum = rootDict[@"totalnum"];
        pi.userId = rootDict[@"userId"];
        for (NSDictionary *dict in rootDict[@"data"]) {
            PhotoDataItem *pdi = [[PhotoDataItem alloc]init];
            pdi.added_by = dict[@"added_by"];
            pdi.collection = dict[@"collection"];
            pdi.uid = dict[@"id"];
            pdi.name = dict[@"name"];
            pdi.nb_image = dict[@"nb_image"];
            pdi.path = dict[@"path"];
            pdi.path_s = dict[@"path_s"];
            pdi.question_num = dict[@"question_num"];
            pdi.sjs_name = dict[@"sjs_name"];
            pdi.uploadtype = dict[@"uploadtype"];
            [pi.data addObject:pdi];
        }
        [dataArray addObject:pi];
    }
    else if (dl.downLoadType == kTYPE_PERSON_INFO)
    {
        NSDictionary *resultDict = [rootDict objectForKey:@"result"];
        PersonResult *pr = [[PersonResult alloc]init];
        pr.data = resultDict[@"data"];
        pr.follow = resultDict[@"follow"];
        NSDictionary *infoDict = [resultDict objectForKey:@"info"];
        
        PersonInfo *pi = [[PersonInfo alloc]init];
        pi.city = infoDict[@"city"];
        pi.cxt_num = infoDict[@"cxt_num"];
        pi.goodlevel = infoDict[@"goodlevel"];
        pi.uid = infoDict[@"id"];
        pi.introduce = infoDict[@"introduce"];
        pi.mainfield = infoDict[@"mainfield"];
        pi.num1 = infoDict[@"num1"];
        pi.num2 = infoDict[@"num2"];
        pi.num3 = infoDict[@"num3"];
        pi.num4 = infoDict[@"num4"];
        pi.otherfield = infoDict[@"otherfield"];
        pi.otherstyle = infoDict[@"otherstyle"];
        pi.photo = infoDict[@"photo"];
        pi.shen = infoDict[@"shen"];
        pi.style = infoDict[@"style"];
        pi.truename = infoDict[@"truename"];
        pi.type = infoDict[@"type"];
        pi.vip = infoDict[@"vip"];
        pi.workyears = infoDict[@"workyears"];
        pi.yeji = infoDict[@"yeji"];
        pr.info = pi;
        [dataArray addObject:pr];
    }
    else if (dl.downLoadType == kTYPE_DESIGN_CASE)
    {
        NSDictionary *resultDict = [rootDict objectForKey:@"result"];
        NSDictionary *dataDict = [resultDict objectForKey:@"data"];
        NSArray  *listArr = [dataDict objectForKey:@"list"];
        for (NSDictionary *dict in listArr) {
            DesignCase *dc = [[DesignCase alloc]init];
            [dc setValuesForKeysWithDictionary:dict];
            [dataArray addObject:dc];
        }
        
    }
    else if (dl.downLoadType == kTYPE_BLOG)
    {
        NSDictionary *resultDict = [rootDict objectForKey:@"result"];
        NSDictionary *dataDict = [resultDict objectForKey:@"data"];
        NSArray  *listArr = [dataDict objectForKey:@"list"];
        for (NSDictionary *dict in listArr) {
            PersonBlog *pb = [[PersonBlog alloc]init];
            [pb setValuesForKeysWithDictionary:dict];
            [dataArray addObject:pb];
        }
    }
    else if(dl.downLoadType == kTYPE_COMMENT)
    {
        NSDictionary *resultDict = [rootDict objectForKey:@"result"];
        NSDictionary *dataDict = [resultDict objectForKey:@"data"];
        //NSArray  *listArr = [dataDict objectForKey:@"list"];
        PersonComment *pc = [[PersonComment alloc]init];
        pc.comment_num = dataDict[@"comment_num"];
        pc.cp_num = dataDict[@"cp_num"];
        pc.cxt_num = dataDict[@"cxt_num"];
        pc.haoping = dataDict[@"haoping"];
        pc.hp_num = dataDict[@"hp_num"];
        pc.project_num = dataDict[@"project_num"];
        [dataArray addObject:pc];
    }
    else if(dl.downLoadType == kTYPE_FIND_SJS)
    {
        /*
         dataArray = 0 login
                     1 result
                     2 total_sjs
         */
        [dataArray addObject:[[rootDict objectForKey:@"login"] stringValue]];
        [dataArray addObject:[rootDict objectForKey:@"total_sjs"]];
        
        NSDictionary *resultDict = [rootDict objectForKey:@"result"];
        FindSjsResult *fjr = [[FindSjsResult alloc]init];
        fjr.allNum = [resultDict objectForKey:@"allNum"];
        
        if (![resultDict[@"data"] isKindOfClass:[NSNull class]]) {
            for (NSDictionary *subDict in resultDict[@"data"]) {
                FindSjsData *fjs = [[FindSjsData alloc]init];
                fjs.city = subDict[@"city"];
                fjs.city_id = subDict[@"city_id"];
                fjs.cxt_num = subDict[@"cxt_num"];
                fjs.cxt_year = subDict[@"cxt_year"];
                fjs.elite_num = subDict[@"elite_num"];
                fjs.follow = subDict[@"follow"];
                fjs.headphoto = subDict[@"headphoto"];
                fjs.uid = subDict[@"id"];
                fjs.introduce = subDict[@"introduce"];
                fjs.pic_num = subDict[@"pic_num"];
                fjs.qiandanNum = subDict[@"qiandanNum"];
                fjs.shen = subDict[@"shen"];
                fjs.truename = subDict[@"truename"];
                fjs.yuyueNum = subDict[@"yuyueNum"];
                
                [fjr.data addObject:fjs];
            }
            [dataArray addObject:fjr];
        }
        else
        {
            [dataArray addObject:fjr];
        }
    }
    else if(dl.downLoadType == kTYPE_DESIGNTRADE)
    {
        for (NSDictionary *dict in [rootDict objectForKey:@"data"]) {
            DesignTradeData *dtd = [[DesignTradeData alloc]init];
            [dtd setValuesForKeysWithDictionary:dict];
            [dataArray addObject:dtd];
        }
    }
    else if (dl.downLoadType == kTYPE_ZX_PHOTO)
    {
        NSArray *dArr = [rootDict objectForKey:@"data"];
        
        NSMutableArray *aArray = [[NSMutableArray alloc]init];
        
        for (NSDictionary *dict in dArr) {
            ZXPhoto *zp = [[ZXPhoto alloc]init];
            [zp setValuesForKeysWithDictionary:dict];
            [aArray addObject:zp];
        }
        [dataArray addObject:aArray];
        [dataArray addObject:[rootDict objectForKey:@"picnum"]];
        [dataArray addObject:[rootDict objectForKey:@"totalnum"]];
    }
    else if (dl.downLoadType == kTYPE_ASKANSWER)
    {
        NSMutableArray *myArr = [[NSMutableArray alloc]init];
        NSArray *dArr = [rootDict objectForKey:@"data"];
        for (NSDictionary *dict in dArr) {
            AskAnswer *aa = [[AskAnswer alloc]init];
            [aa setValuesForKeysWithDictionary:dict];
            [myArr addObject:aa];
        }
        [dataArray addObject:myArr];
        [dataArray addObject:[rootDict objectForKey:@"totalnum"]];
    }
    else if (dl.downLoadType == kTYPE_SUBASKANSWER)
    {
        NSMutableArray *answerArray = [[NSMutableArray alloc]init];
        
        for (NSDictionary *dict in [rootDict objectForKey:@"answer"]) {
            Answer *as = [[Answer alloc]init];
            as.answer_uid = [dict objectForKey:@"answer_uid"];
            as.content = [dict objectForKey:@"content"];
            as.createtime = [dict objectForKey:@"createtime"];
            as.f_commentid = [dict objectForKey:@"f_commentid"];
            as.head_photo = [dict objectForKey:@"head_photo"];
            as.uid = [dict objectForKey:@"id"];
            as.indentity = [dict objectForKey:@"indentity"];
            as.nick = [dict objectForKey:@"nick"];
            as.pic = [dict objectForKey:@"pic"];
            as.praise = [dict objectForKey:@"praise"];
            as.praise_num = [dict objectForKey:@"praise_num"];
            
            NSDictionary *subDict = [dict objectForKey:@"msgto"];
            MsgtoItem *msg = [[MsgtoItem alloc]init];
            msg.indentity = [subDict objectForKey:@"indentity"];
            msg.uid = [subDict objectForKey:@"uid"];
            msg.username = [subDict objectForKey:@"username"];
            as.msgto = msg;
            [answerArray addObject:as];
        }
        [dataArray addObject:answerArray];
         
        NSDictionary *dict = [rootDict objectForKey:@"question"];
        Question *qs = [[Question alloc]init];
        qs.comment_nums = [dict objectForKey:@"comment_nums"];
        qs.content = [dict objectForKey:@"content"];
        qs.createtime = [dict objectForKey:@"createtime"];
        qs.aid = [dict objectForKey:@"id"];
        qs.image_id = [dict objectForKey:@"image_id"];
        qs.nick = [dict objectForKey:@"nick"];
        qs.title = [dict objectForKey:@"title"];
        qs.uid = [dict objectForKey:@"uid"];
        qs.view_nums = [dict objectForKey:@"view_nums"];
        for (NSString *path in [dict objectForKey:@"total_pic"] ) {
            [qs.total_pic addObject:path];
        }
        
        [dataArray addObject:qs];
    }
    else if (dl.downLoadType == kTYPE_RANK)
    {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        //myRank时NSNumber类型的
        [dataArray addObject:[rootDict objectForKey:@"myRank"]];
        NSArray *rankList = [rootDict objectForKey:@"rankList"];
        for (NSDictionary *dict in rankList) {
            RankList *rl = [[RankList alloc]init];
            rl.headphoto = [dict objectForKey:@"headphoto"];
            rl.nick = [dict objectForKey:@"nick"];
            rl.num = [dict objectForKey:@"num"];
            rl.rank = [dict objectForKey:@"rank"];
            rl.rankValue = [dict objectForKey:@"rankValue"];
            rl.uid = [dict objectForKey:@"uid"];
            [array addObject:rl];
        }
        
        
        
        [dataArray addObject:array];
        [dataArray addObject:[rootDict objectForKey:@"total"]];
    }
    else if(dl.downLoadType == kTYPE_SEARCH_KEYWORD)
    {
        [dataArray addObjectsFromArray:[rootDict objectForKey:@"keyword"]];
    }
    else if(dl.downLoadType == kTYPE_SEARCH_TYPE)
    {
        [dataArray addObject:[rootDict objectForKey:@"sjs_num"]];
        [dataArray addObject:[rootDict objectForKey:@"pic_num"]];
        [dataArray addObject:[rootDict objectForKey:@"ask_num"]];
    }
    else if(dl.downLoadType == kTYPE_SEARCH_SJS)
    {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (NSDictionary *subDict in [rootDict objectForKey:@"data"]) {
            SearchSjs *ss = [[SearchSjs alloc]init];
            [ss setValuesForKeysWithDictionary:subDict];
            [array addObject:ss];
        }
        [dataArray addObject:array];
        [dataArray addObject:[rootDict objectForKey:@"totalnum"]];
    }
    else if(dl.downLoadType == kTYPE_SEARCH_PHOTO)
    {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (NSDictionary *subDict in [rootDict objectForKey:@"data"]) {
            SearchPhoto *sp = [[SearchPhoto alloc]init];
            [sp setValuesForKeysWithDictionary:subDict];
            [array addObject:sp];
        }
        [dataArray addObject:array];
        [dataArray addObject:[rootDict objectForKey:@"totalnum"]];
    }
    else if(dl.downLoadType == kTYPE_SEARCH_ANSWER)
    {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (NSDictionary *subDict in [rootDict objectForKey:@"data"]) {
            SearchAnswer *sa = [[SearchAnswer alloc]init];
            [sa setValuesForKeysWithDictionary:subDict];
            [array addObject:sa];
        }
        [dataArray addObject:array];
        [dataArray addObject:[rootDict objectForKey:@"totalnum"]];
    }
    else if(dl.downLoadType == kTYPE_PERSON_NAME)
    {
        for (NSDictionary *dict in [rootDict objectForKey:@"rank"]) {
            PersonName *name = [[PersonName alloc]init];
            name.nick = dict[@"nick"];
            name.uid = dict[@"uid"];
            [dataArray addObject:name];
        }
    }
    else if(dl.downLoadType == kTYPE_MY_INFO)
    {
        NSDictionary *dict = [rootDict objectForKey:@"info"];
        MyInfo *myInfo = [[MyInfo alloc]init];
        myInfo.city = [dict objectForKey:@"city"];
        myInfo.email = [dict objectForKey:@"email"];
        myInfo.headphoto = [dict objectForKey:@"headphoto"];
        myInfo.uid = [dict objectForKey:@"id"];
        myInfo.shen = [dict objectForKey:@"shen"];
        myInfo.truename = [dict objectForKey:@"truename"];
        [dataArray addObject:myInfo];
        //nsnumber类型
        [dataArray addObject:[rootDict objectForKey:@"login"]];
    }
    
    //将解析的数据存入缓存字典里
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[NSString stringWithFormat:@"%d",dl.downLoadPage] forKey:dl.downLoadString];
    
    
    if (dl.downLoadIsRefresh) {
        //[_sourceDict setObject:dataArray forKey:dict];
        
        for (NSDictionary *subDict in _sourceDict.allKeys) {
            if ([subDict objectForKey:dl.downLoadString]) {
                [_sourceDict removeObjectForKey:subDict];
                break;
            }
        }
        [_sourceDict setObject:dataArray forKey:dict];
    }
    else
    {
        BOOL isExist = NO;
        for (NSMutableDictionary *subDict in _sourceDict.allKeys) {
            if ([subDict objectForKey:dl.downLoadString]) {
               NSMutableArray *oldArray = [NSMutableArray arrayWithArray:[_sourceDict objectForKey:subDict]];
                
                [oldArray addObjectsFromArray:dataArray];
                [_sourceDict setObject:oldArray forKey:subDict];
                
                [subDict setValue:[NSString stringWithFormat:@"%d",dl.downLoadPage] forKey:dl.downLoadString];
                isExist = YES;
                break;
            }
        }
        if (isExist == NO) {
            [_sourceDict setObject:dataArray forKey:dict];
        }
    }
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:dl.downLoadString object:nil];
}
-(NSMutableArray *)getDataWithDownLoadString:(NSString *)downLoadString
{
    NSMutableArray *dataArray;
    for (NSDictionary *dict in _sourceDict.allKeys) {
        if ([dict objectForKey:downLoadString]) {
            dataArray = [_sourceDict objectForKey:dict];
            break;
        }
    }
    return dataArray;
}
@end
