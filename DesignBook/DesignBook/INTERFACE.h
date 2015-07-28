
//
//  INTERFACE.h
//  DesignBook
//
//  Created by Visitor on 14-11-9.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#define kURL_PHOTO (@"http://www.shejiben.com/mobileapp/works/case.php?id=%@&cid=%@&uid=0")

#define kURL_PERSON_INFO (@"http://www.shejiben.com/mobileapp/designer/index.php?uid=0&bid=%@&t=1&tt=1&p=1&pg=8")

#define kURL_DESIGN_CASE (@"http://www.shejiben.com/mobileapp/designer/index.php?uid=0&bid=%@&t=2&tt=1&p=1&pg=%d")

#define kURL_PERSON_NAME (@"http://www.shejiben.com/mobileapp/rank/rank.php?rt=0")

//博文
#define kURL_BLOG (@"http://www.shejiben.com/mobileapp/designer/index.php?uid=0&bid=%@&t=3&tt=1&p=1&pg=%d")

//博文内容
#define kURL_ARTICLE (@"http://www.shejiben.com/mobileapp/designer/log.php?uid=%@&lid=%@")

//交易评价
#define kURL_COMMENT (@"http://www.shejiben.com/mobileapp/designer/index.php?uid=0&bid=%@&t=4&tt=1&p=1&pg=%d")

//找设计师
#define kURL_FIND_SJS (@"http://www.shejiben.com/mobileapp/designer/designerapp.php?uid=0&orderid=%d&a2=%d&a3=%d&a4=0&a5=%d&a6=%d&a7=%d&p=1&pg=%d")
/*
 默认 0
 a2 cityid
 a3 擅长空间 id
 a4 = 0
 a5 设计年限 id
 a6 实例 id
 a7 擅长风格 id
 
 */
#define kFIND_SJS_RECTENT 0
#define kFIND_SJS_WONDER 4
#define kFIND_SJS_SAMECITY 0
#define kFIND_SJS_REPUTATION 3
//设计交易
#define kURL_DESIGN_TRADE (@"http://www.shejiben.com/mobileapp/zb/index.php?t=%d&city=%d&tt=%d&p=1&pg=%d")
#define kDESIGNTRADE_RECENT 1
#define kDESIGNTRADE_NOW 2
#define kDESIGNTRADE_END 3

//装修图片
#define kURL_ZX_PHOTO (@"http://www.shejiben.com/mobileapp/works/index.php?o=%d&t=0&tt=0&s=0&p=1&pg=%d")
#define kZX_RECENT 0
#define kZX_TODAY 1
#define kZX_TOTAL 2
#define kZX_NEW 3

//有问必答
#define kURL_ASKANSWER (@"http://www.shejiben.com/mobileapp/ask/index.php?t=0&o=%d&p=1&pg=%d")
#define kASKANSWER_RECTNT 0
#define kASKANSWER_HOT 2
#define kASKANSWER_NEW 3
#define kASKANSWER_WAIT 5
//有问必答下一层
#define kURL_ASKANSWER_SUB (@"http://www.shejiben.com/mobileapp/ask/question.php?id=%d&p=1&pg=%d")
//榜单
#define kURL_RANK (@"http://www.shejiben.com/mobileapp/rank/rank.php?uid=0&rt=%d&t=%d&p=1&pg=%d")
#define kRANK_RX_RT 1
#define kRANK_SC_RT 5
#define kRANK_KB_RT 3
#define kRANK_EX_RT 4
#define kRANK_RQ_RT 2
#define kRANK_TB_RT 6

//搜索
#define kURL_SEARCH_KEYWORD (@"http://www.shejiben.com/mobileapp/search/index.php")
#define kURL_SEARCH_TYPE (@"http://www.shejiben.com/mobileapp/search/index.php?w=%@")

#define kURL_SEARCH_SJS (@"http://www.shejiben.com/mobileapp/search/search.php?uid=0&t=7&q=%@&p=1&pg=%d")
#define kURL_SEARCH_PHOTO (@"http://www.shejiben.com/mobileapp/search/search.php?uid=0&t=1&q=%@&p=1&pg=%d")
#define kURL_SEARCH_ANSWER  (@"http://www.shejiben.com/mobileapp/search/search.php?uid=0&t=9&q=%@&p=1&pg=%d")

//登陆发送信息 post请求
#define kURL_LOGIN_POST (@"http://www.shejiben.com/mobileapp/login.php?from=sina&%@")


//我的个人信息
#define kURL_MY_INFO (@"http://www.shejiben.com/mobileapp/my/info.php?uid=%@")










