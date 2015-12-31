//
//  URLHeader.h
//  FunnyTime
//
//  Created by luxt on 15/9/19.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

//UrlHeader（我们的接口数据宏）

#ifndef FunnyTime_URLHeader_h
#define FunnyTime_URLHeader_h

//经典搞笑图片页面接口
#define kClassicFunnyPicForBeginURL @"http://neihanmanhua.sinaapp.com/online/index.php/ManhuaApi361/index/cid/qutu/p/1/markId/0"
//加载更多接口 需要拼接lastTime
#define kClassicFunnyPicForMoreURL @"http://neihanmanhua.sinaapp.com/online/index.php/ManhuaApi361/index/cid/qutu/lastTime/"

//推荐  趣图 接口
#define kRecommentPicForBeginURL @"http://xiaoliao.sinaapp.com/index.php/Api381/index/pad/0/sw/1/cid/qutu/p/1/markId/0/date/"

//加载更多接口 需要拼接lastTime
#define kRecommentPicForMoreURL @"http://xiaoliao.sinaapp.com/index.php/Api381/index/pad/0/sw/1/cid/qutu/lastTime/"

//精彩  趣图 接口:
#define kWonderfulPicForBeginRUL @"http://120.55.151.67/weibofun/weibo_list.php?apiver=10701&category=weibo_pics&page=0&page_size=30&max_timestamp=-1&latest_viewed_ts=1442460600&platform=iphone&appver=1.9&buildver=1.9.4&udid=0E989C74-D06D-4C15-A684-F3DCA853B283&sysver=8.3"
//更多精彩接口
#define kWonderfulPicForMorePartOneURL @"http://120.55.151.67/weibofun/weibo_list.php?apiver=10701&category=weibo_pics&page=0&page_size=30&max_timestamp="
#define kWonderfulPicForMorePartTwoURL @"&latest_viewed_ts=1442460600&platform=iphone&appver=1.9&buildver=1.9.4&udid=0E989C74-D06D-4C15-A684-F3DCA853B283&sysver=8.3"




//搞笑段子
#define kFunnyJockesForBeginUrl         @"http://xiaoliao.sinaapp.com/index.php/Api381/index/pad/0/sw/1/cid/joke/p/1/markId/0/date/"


//加载更多接口
#define kFunnyJockesForMoreUrl   @"http://xiaoliao.sinaapp.com/index.php/Api381/index/pad/0/sw/1/cid/joke/lastTime/"


//内涵段子
#define kMeaningJockesForBeginUrl   @"http://120.55.151.67/weibofun/weibo_list.php?apiver=10701&category=weibo_jokes&page=0&page_size=30&max_timestamp=-1&latest_viewed_ts=-1&platform=iphone&appver=1.9&buildver=1.9.4&udid=0E989C74-D06D-4C15-A684-F3DCA853B283&sysver=8.3"
//加载更多接口 需要拼接上一个字典中最后一个对应的update_time
#define kMeaningJockesForMoreOneUrl @"http://120.55.151.67/weibofun/weibo_list.php?apiver=10701&category=weibo_jokes&page=1&page_size=15&max_timestamp="
#define kMeaningJockesForMoreTwoUrl  @"&latest_viewed_ts=-1&platform=iphone&appver=1.9&buildver=1.9.4&udid=0E989C74-D06D-4C15-A684-F3DCA853B283&sysver=8.3"



//视频接口
#define kVideoForBeginUrl @"http://xiaoliao.sinaapp.com/index.php/Api381/index/pad/0/sw/1/cid/video/p/1/markId/0/date/"
//更多视频
#define kVideoForMoreUrl @"http://xiaoliao.sinaapp.com/index.php/Api381/index/pad/0/sw/1/cid/video/lastTime/"

//音频
//开始,用最新时间,pagenum = 1
#define kVoiceListUrl @"http://api.kaolafm.com/api/v4/resource/search?pagesize=10&rtype=20000&sorttype=HOT_RANK_DESC&pagenum=1&cid=648&appid=0&installid=0000scT9&udid=E3E450865FFB3132BA9BAA358B0F04FB&devicetype=1&version=4.1.2&channel=appstore&timestamp=%@&sessionid=48F67293481142BEB4064BDB29D3F9E1&operator=1&network=1&page=200009&resolution=640*1136&sign=9A63C7F4C8FA9EA9E609BA7B053C1909"
//更多 用最新时间,pagenum = 2,3,4 可以用上一个数据的NextPage
#define kVoicePullUrl @"http://api.kaolafm.com/api/v4/resource/search?pagesize=10&rtype=20000&sorttype=HOT_RANK_DESC&pagenum=%@&cid=648&appid=0&installid=0000scT9&udid=E3E450865FFB3132BA9BAA358B0F04FB&devicetype=1&version=4.1.2&channel=appstore&timestamp=%@&sessionid=48F67293481142BEB4064BDB29D3F9E1&operator=1&network=1&page=200009&resolution=640*1136&sign=9A63C7F4C8FA9EA9E609BA7B053C1909"


#define kVoicePlayUrl @"http://api.kaolafm.com/api/v4/audios/list?id=%@&sorttype=1&pagesize=10&pagenum=1&appid=0&installid=0000scT9&udid=E3E450865FFB3132BA9BAA358B0F04FB&devicetype=1&version=4.1.2&channel=appstore&timestamp=1442629516&sessionid=6E27AEC4F1754227A9B0BA1AC546AA7E&operator=1&network=1&page=200003&resolution=640*1136&sign=9A63C7F4C8FA9EA9E609BA7B053C1909"

#define kVoicePlayPull @"http://api.kaolafm.com/api/v4/audios/list?id=%@&sorttype=1&pagesize=10&pagenum=%@&appid=0&installid=0000scT9&udid=E3E450865FFB3132BA9BAA358B0F04FB&devicetype=1&version=4.1.2&channel=appstore&timestamp=%@&sessionid=6E27AEC4F1754227A9B0BA1AC546AA7E&operator=1&network=1&page=200003&resolution=640*1136&sign=9A63C7F4C8FA9EA9E609BA7B053C1909"

//新的图片URL
#define kNewPicURL @"http://xb.huabao.me/?json=gender/category_article_list&beforeDate=2015-10-24&categoryId=16&timestamp=%@&v=1027&sign=94CF8D32F2D0F06ACCE85C5A9BA1A040"

#endif
