//
//  Header.h
//  jindianyou
//
//  Created by qianfeng on 15/9/14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#ifndef jindianyou_Header_h
#define jindianyou_Header_h

//主页
#define HOME @"http://app.kindin.com.cn/appIF/indexjson.html?RequestJson=%7B%22city%22%3A%22%E6%B7%B1%E5%9C%B3%22%2C%22sizeTypeWidth%22%3A%22320.000000%22%2C%22sizeTypeHeight%22%3A%22115%22%7D"


//攻略
#define GONGLEI @"http://app.kindin.com.cn/appIF/guidesList.html"
#define GONGLEI_NEXT @"RequestJson={'city':'%@','pageSize':'6','pageIndex':'%d','scenicCode':''}"


//城市列表
#define CITY @"http://app.kindin.com.cn/appIF/cityGroupList.html"
#define CITY_NEXT @"RequestJson={'inOutsideFlg':'%d','pageType':'1'}"


//详情
#define DETAIL @"http://app.kindin.com.cn/appIF/guidesDetail.html"
#define DETAIL_NEXT @"RequestJson={'guidesId':'%@','memberId':'','scenicCode':''}"


//周边
#define NEAR @"http://app.kindin.com.cn/appIF/scenicProductListByType.html"
#define NEAR_NEXT @"RequestJson={'searchKey':'','pageSize':'10','pageIndex':'%d','scenic_type':'1','city':'%@','position-x':'113.939730','position-y':'22.537134'}"


//国内
#define GUONEI @"http://app.kindin.com.cn/appIF/scenicProductListByType.html"
#define GUONEI_NEXT @"RequestJson={'searchKey':'','pageSize':'10','pageIndex':'%d','scenic_type':'2','city':'%@','position-x':'113.939758','position-y':'22.537222'}"


//境外
#define GUOWAI @"http://app.kindin.com.cn/appIF/scenicProductListByType.html"
#define GUOWAI_NEXT @"RequestJson={'searchKey':'','pageSize':'10','pageIndex':'%d','scenic_type':'3','city':'%@','position-x':'113.939758','position-y':'22.537222'}"

//约你
#define YUENI @"http://app.kindin.com.cn/appVenting/rendezvousList.html"
#define YUENI_NEXT @"RequestJson={\"sex_type\":\"1\",\"page_size\":\"10\",\"current_rendezvous_id\":\"%@\",\"member_id\":\"\"}"

//约你详情
#define YUENI_DETAIL @"http://app.kindin.com.cn/appVenting/commentList.html"
#define YUENI_DETAIL_NEXT @"RequestJson={'comment_type':'1','object_id':'%@','page_size':'1000','current_comment_id':'','member_id':''}"



#endif
