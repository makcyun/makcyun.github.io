---
title: 漫威电影宇宙，宇宙票房收割机
date: 2019-5-5 16:16:16
id: data_analysis&mining04
categories: Python数据分析
tags: [Python数据分析]
images: http://media.makcyun.top/win/20190505/8QdkthCAfxTH.jpg?imageslim
keywords: [漫威电影宇宙票房分析]
---

漫威电影宇宙已经无敌，霸占全球前十票房中的五席。

<!-- more -->  

**摘要**：看的不是电影是青春。

《复仇者联盟4：终局之战》上映已十天有余，刷了两遍 IMAX，在家又重温了之前的 21 部电影，感觉就是一个字：爽，两个字：难舍。

入坑漫威不早也不算晚，2011 年大一的时候偶然看了《钢铁侠》和《绿巨人》后被圈粉。12 年复联上映时和室友一起去了学校附近的影城看，晚上看完点个铁板烧边吃边讨论剧情。

八九年一晃而过，电影迎来了终局，人也从大一新生变成了社会狗。

其实，追漫威跟追星没什么区别，看电影跟看演唱会也没什么区别。

你要很早开始追周杰伦，就会期待他的新专辑和演唱会，曲子一出你可能就知道是什么歌名，出自哪张专辑，会想去看他的演唱会。如果你没有追过或者很晚才追他，那真的很遗憾，因为你错过的不仅是他，更是自己的青春。

多年下来，才发现一直不变的是唯有  NBA  和漫威电影。然而今年是悲伤的一年，喜欢的球星退役，喜欢的电影迎来终局。

一部「着看着就笑了，笑着笑着就泪了的电影」值得说道几句。

自上映之日起，这部电影就不断刷爆国内外各种记录，相信下映之时必将名留史册。

在国内，上映  12  天票房超过 38  亿，飙升到中国电影历史总票房第三位，离前不久才上升到第二位 的《流浪地球》只有 8 亿只差，目测最终二者排名会交换。

《复联4》上映之前，国内前五名都是国产电影，进入前十名的只有两部，由速度与激情系列包揽，影片一上映很快就飙到了前三甲。

![数据来源：猫眼票房](http://media.makcyun.top/FhU95o66886hjPsxIKabDPenCxt1)

国际上，目前票房超过了 19 亿美元，上升到第五名，大概率会超过  21  亿的《泰坦尼克号》，勇夺全球票房亚军，甚至能挑战票房纪录保持了十年之久的《阿凡达》。

作为漫威电影宇宙布局  11  年、22  部电影的最后一部，以这样的成绩结束太完美了。

![最爱银河护卫队和雷神3](https://uploader.shimo.im/f/hzjkp78NOK0cVHWe!thumbnail)

这 22 部电影很恐怖，**票房最高的 5 部进入了全球历史总票房的前  10  名，占据半壁江山。**

| **排名** |         **电影 **         | **票房(亿美元)** |        **发行商**         |
| :------- | :-----------------------: | :--------------: | :-----------------------: |
| 1        |          阿凡达           |      27.88       |       二十世纪福斯        |
| 2        |        泰坦尼克号         |      21.87       | 派拉蒙影业 / 二十世纪福斯 |
| 3        |    星球大战：原力觉醒     |      20.68       |      华特迪士尼影业       |
| 4        | **复仇者联盟3：无限战争** |      20.48       |      华特迪士尼影业       |
| 5        | **复仇者联盟4：终局之战** |      17.86       |      华特迪士尼影业       |
| 6        |        侏罗纪世界         |      16.72       |         环球影业          |
| 7        |      **复仇者联盟**       |      15.19       |      华特迪士尼影业       |
| 8        |        速度与激情7        |      15.16       |         环球影业          |
| 9        | **复仇者联盟2：奥创纪元** |      14.05       |      华特迪士尼影业       |
| 10       |         **黑豹**          |      13.47       |      华特迪士尼影业       |

条形图看着更清楚：

![数据来源：Box Office Mojo](http://media.makcyun.top/FnazAQOqIOxqmQ4iHV8xRPsFqLsy)

上面的条形图为了突出漫威电影和非漫威电影，设置了两种颜色。而通常的图形是默认一种颜色，或者通过 cmap 光谱参数各一种颜色。有两种方法可以实现自定义设置柱状颜色。

一种是通过`barh[i].set_color(colors)`单独设置，适合要设置的颜色比较少的情况，当数量比较多的时候，可以采取第二种方法就是先设置好颜色。

这里，使用了第二种方法，代码实现如下：

```python
# 全球票房 
plt.style.use('ggplot')
movies = ['阿凡达','泰坦尼克号','星球大战：原力觉醒','复仇者联盟3','复仇者联盟4','侏罗纪世界','复仇者联盟','速度与激情7','复仇者联盟2','黑豹']

income = [27.88,21.87,20.68,20.48,19.14,16.72,15.19,15.16,14.05,13.47,]
data_movies = pd.DataFrame({'movie':movies,'income':income})[::-1]#倒序
# 绘制票房条形图
# https://stackoverflow.com/questions/37447056/different-colors-for-rows-in-barh-chart-from-pandas-dataframe-python

fig, ax = plt.subplots(figsize=(8, 6))
grey = '#969696'  # 深灰
red = '#E24A33'  # 红色
# 批量设置颜色
color = [red, red, grey, red, grey, red, red, grey, grey, grey]
barh = ax.barh(np.arange(10),data_movies['income'],color=color)
# 或者单独设置颜色
# barh[2].set_color = [grey]
for y, x in enumerate(data_movies['income'].values.tolist()):
    ax.text(x-1, y-0.1, '%s' % round(x, 1),
            ha='right',
            size=15,
            color='#FFFFFF')

ax.set_yticks(np.arange(10)) # 设置y轴标签数量
ax.set_yticklabels(data_movies['movie'].tolist(), size=15) # 设置y轴标签
ax.set_xlim(0, 32)

ax.legend(['票房(亿美元)'], loc='best')
plt.tight_layout()
plt.savefig('global.jpg', dpi=200)
```



**22 部电影总票房超过  200  亿美元**，这个数字有多牛逼，用国产电影的数据来对比一下就知道了，过去 2015-2018 这四年一共上映了超过 1400 部国产电影，总票房是 1277 亿元。

![数据来源：国家新闻出版广电*总局电影局](http://media.makcyun.top/FnZQ-FFx43bDp2EOhSlFHWnk5tWY)

条形图：

| **年份** | **国产电影票房(亿元）** | **国产电影数量** |
| :------: | :---------------------: | :--------------: |
|   2015   |          297.0          |       278        |
|   2016   |          288.4          |       383        |
|   2017   |          312.1          |       375        |
|   2018   |          379.3          |       393        |
|   汇总   |         1276.8          |       1429       |

所以，**漫威的 22 部电影票房等于过去四年全部国产电影票房的总和**。

![](http://media.makcyun.top/ForKoS3G-udmrZNEoQHNMHAxJMg5)

上面条形图设置的代码如下：

```python
year = ['2015年','2016年','2017年','2018年'] 
income = [297.0,288.4,312.1,379.3]
quantity= [278,383,375,393]
movie_cn = pd.DataFrame({'year':year,'income':income,'quantity':quantity})
width = 0.3

fig, ax = plt.subplots(figsize=(8, 6))
barh = ax.barh(np.arange(4),
               movie_cn['income'],
               width,
               color=grey
               )
barh2 = ax.barh(np.arange(4)+0.3,
                movie_cn['quantity'],
                width, color=red
                )

# 设置添加数值
def autolabel(bars):
    for bar in bars:
        width = bar.get_width()
        ax.text(width*0.97, bar.get_y() + bar.get_height()/2,
                '%d' % int(width),
                ha='right', va='center',
                color='#FFFFFF',
                size=15)

ax.set_yticks(np.arange(4)+0.2)
ax.set_yticklabels(movie_cn['year'].tolist(), size=15)
ax.set_xlim(0, 430)

ax.legend(['票房(亿元)', '影片数量(部)'], loc='best')

autolabel(barh)
autolabel(barh2)
```

无数的英雄出现在了这些电影中，钢铁侠、雷神、浩克、惊奇队长、灭霸等人各显神通，个人最喜欢星爵。

英雄一多就出现了一个很有意思的问题：**这些人中到底谁最厉害？**

答案仁者见仁，智者见智。不过在漫画中每位英雄都给出了详细的战斗力指数，之后会写一篇  Python  分析宇宙英雄数据，对比英雄综合实力。

![](http://media.makcyun.top/FjC-dqDPXyXpXv1Ai5RnaCT9SnTy)


资料：

[猫眼 2018 票房分析报告](https://www.useit.com.cn/thread-21819-1-1.html)

[中国电影票房分析](http://www.chyxx.com/industry/201901/705193.html)