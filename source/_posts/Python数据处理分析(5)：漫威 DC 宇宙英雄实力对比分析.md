---
title: 漫威 DC 宇宙英雄综合实力可视化对比分析
date: 2019-5-6 16:16:16
id: data_analysis&mining05
categories: Python数据分析
tags: [Python数据分析]
images: http://media.makcyun.top/win/20190506/Ps25dK3mxK0C.jpg?imageslim
keywords: [漫威电影宇宙, 漫威DC对比]
---

一生漫威粉。

<!-- more -->  

**摘要**：数据采集、分析实战。

![](http://media.makcyun.top/FjC-dqDPXyXpXv1Ai5RnaCT9SnTy)

昨天借最近持续火爆的的《复联4》说了说漫威电影宇宙票房话题，今天票房就上升到了全球第二，超越保持 20 多年记录的《泰坦尼克号》，有生之年能见到也是难得了。

另外，文末卖了个关子：**那么多英雄到底谁最强**？今天就来用 Python 对比分析一下各位英雄的综合实力，结果绝对超出你预料。

先说说下漫威电影和漫威漫画的关系。我们看的电影叫「漫改电影」，意思就是从漫画中改编过来搬上荧幕的。这些电影出现不过十年，而漫画五十年前就出现了，大多数数角色由斯坦·李创造，所以你可以看到每部漫威电影他都有客串。

电影中为了呈现更好的视觉效果以刺激观众感官，会刻意加强或者弱化某些英雄的能力，尤其是精彩的打斗场景，让我们以为这就是他们的真实实力。

比如：

- 美队跟谁都能五五分
- 最强之人是灭霸
- 正面对决猩红女巫能手撕灭霸
- 惊奇队长貌似是唯一一个能单挑不怵灭霸的

而在漫画中的实际情况并不完全是这样。漫画里对每个角色都设定了能力值，能力值包括六个方面，分别是

- Intelligence / 智力
- Power / 能量
- Strength /  力量
- Speed / 速度
- Durability / 耐力
- Combat / 格斗技

比如钢铁侠的能力值是这样的：

![](http://media.makcyun.top/FhY7WD-sRtGeZ_8LGxCZL_ZjLxBq)

可以看到他的智力和能量值是满分，很贴合电影中 Tony Stark 演的钢铁侠形象。而速度和格斗技巧不过刚及格，可电影中给我们看到的钢铁侠上天入地速度杠杠的，打斗也很强。唯一的解释就是，电影作了美化。

在权威漫画人物网站：[superherodb](https://www.superherodb.com/)上，给每位角色都标出了能力值。孰强孰弱一对比就一目了然。

![](http://media.makcyun.top/FsxAOxeYY4gfDfX3k3ByTer9iisM)

不只是上面这些热门角色，该网站拥有包括漫威 、DC 在内的上百家漫画公司的数千位漫画角色详细信息，可以说是非常强大。

![](http://media.makcyun.top/Flomh3235xRHHvQLj9R22RUmPZLe)

当然，一个个去对比很麻烦而且很难发现深层次关系，这时候就需要 Python 出场了。

首先需要获取这些数据，怎么获取呢？当然是爬虫。鉴于以前爬过类似的网站，这里就不爬了感兴趣可以自行尝试。

还有一种更为取巧的方法就是找现成的 API 接口然后调用即可。网上找了一圈，最终找到了 [superheroapi](https://superheroapi.com/ids.html) 这个网站。

该网站上提供了 700 多位角色的详细信息，数量虽不多但也够用。

![](http://media.makcyun.top/FgdQgYTBmCvmrYXm7fyoqGp3HlDk)

API 返回结果是 JSON 格式，包括能力值、身高体重等信息，例如：钢铁侠的信息如下：

```python
{
  "response": "success",
  "results-for": "Iron Man", 
  "results": [
    {
      "id": "346",
      "name": "Iron Man",
      "powerstats": {  # 能力值
        "intelligence": "100",
        "strength": "85",
        "speed": "58",
        "durability": "85",
        "power": "100",
        "combat": "64"
      },
...
}
```



### 数据采集

下面我们用 Python 先获取网站全部 700 多位角色信息然后保存到本地数据库。

代码见文末，几分钟就可以下载好结果如下：

![](http://media.makcyun.top/Ftiiar7HqVlsRWL9qp8JcXUZZzhn)

简单的清洗处理后就可以着手分析。

### 可视化分析

先看漫威复联系列。说起复联最重要的人物自然是六位初代英雄。

![](https://d13ezvd6yrslxm.cloudfront.net/wp/wp-content/images/avengers-1.jpg)



### 初代六人组实力对比

凭电影中的印象对这六人的实力排序的话，你会怎么排？

按图上从左到右的顺序来看看六人的实际实力。

#### **雷神**

通过雷达图可以看到雷神很全面，多项数据都是满分，几乎没有弱点，然而智力这块儿只有中等水平。如果你看过雷神系列就会知道他的智商的确很捉急。

![mark](http://media.makcyun.top/win/20190506/9sBJ4pn2mH8R.jpg?imageslim)

![](http://media.makcyun.top/Fqbxv19742r7vVK2SmquCmxywq3X)

#### **黑寡妇**

寡姐身为六人组里唯一的女性，不会飞也没有什么道具，最拿手的就是肉搏，《钢铁侠2》首次出场表现就奠定了她的风格。

![mark](http://media.makcyun.top/win/20190506/zuHERiqdeU17.jpg?imageslim)



#### 鹰眼

箭筒里永远射不完箭的鹰眼在《雷神1》中首次亮相，实力差不多是最弱的，感觉《复联1》中演反派更厉害。

![mark](http://media.makcyun.top/win/20190506/x4M3H7XX10qy.jpg?imageslim)



#### 绿巨人

终于出现个和雷神实力匹配的对手，三项能力满分，格斗技和速度中等，浩克的确格斗能力没那么强，在《复联3》开头分分钟被灭霸给收拾了。智商比雷神高，毕竟是拥有 7 个博士头衔的人。

![mark](http://media.makcyun.top/win/20190506/O9ARPl0fsRSh.jpg?imageslim)



#### 美国队长

整个系列一共说了三次「I can do this all day.」 的美队给人最大的错觉就是：和谁都能五五开，然而毕竟肉身，实际没有那么强。

![mark](http://media.makcyun.top/win/20190506/16ltFsW2syia.jpg?imageslim)

#### 钢铁侠

最后是最帅气最聪明的托尼了，感觉没有电影中想的那么强大，主要他演得好印象分高。

![mark](http://media.makcyun.top/win/20190506/hcoCCI9FGlKx.jpg?imageslim)

上面的雷达图绘制代码如下：

```python
import numpy as np
import matplotlib.pyplot as plt
plt.rcParams['font.sans-serif'] = ['SimHei']
plt.style.use('ggplot')
plt.figure(figsize=(5, 30))

names = ['Thor','Iron Man','Captain America','Hulk','Black Widow','Hawkeye']
names_cn = ['雷神','钢铁侠','美队','绿巨人','黑寡妇','鹰眼']   #标签
title = ['智力', '能量', '力量', '速度', '耐力', '格斗技']  # 标签

# 从data查询 A6 数据
scores = pd.DataFrame({'name':names})
scores = scores.merge(data,how='left',on='name')[['intelligence','power','strength','speed','durability','combat']]
# 转换为list
scores = scores.values.tolist()

zipped = zip(scores,names_cn)
# for循环生成A6成员雷达图
for i,(value, name) in enumerate(zipped): 
    ax= 'ax%s'%i
    theta = np.linspace(0, 2*np.pi, len(value), endpoint=False)  # 将圆根据标签的个数等比分
    theta = np.concatenate((theta, [theta[0]]))  # 闭合
    
    value = np.concatenate((value, [value[0]]))  # 闭合

    # 这里要设置为极坐标格式
    ax = plt.subplot2grid(shape=(6,1), loc=(i,0),polar=True)
    ax.plot(theta, value, lw=2, alpha=1,label=name)  # 绘图
    ax.fill(theta, value, alpha=0.25)  # 填充

    ax.set_thetagrids(theta*180/np.pi,title)         #替换标签
    ax.set_ylim(0,110)                          #设置极轴的区间
    ax.set_theta_zero_location('N')         #设置极轴方向
    ax.set_title('%s战力'%name,fontsize = 15)   #添加图描述
 
plt.tight_layout(h_pad=5.0)
plt.savefig('A6单人战力.jpg',dpi=200)
```



来个汇总看得更清楚，初代六人组孰强孰弱这下有答案了吧？

![](http://media.makcyun.top/Frz2Z8w3upqgF513Bai07N1gn9WD)

代码实现如下：

```python
for value, name in zipped: 
    theta = np.linspace(0, 2*np.pi, len(value), endpoint=False)  # 将圆根据标签的个数等比分
    theta = np.concatenate((theta, [theta[0]]))  # 闭合
    value = np.concatenate((value, [value[0]]))  # 闭合

    ax = fig.add_subplot(111, polar=True)
    ax.plot(theta, value, lw=2, alpha=1,label=name)  # 绘图
#     ax.fill(theta, value, alpha=0.25)  # 填充

ax.set_thetagrids(theta*180/np.pi,title)         #替换标签
ax.set_ylim(0,110)                          #设置极轴的区间
ax.set_theta_zero_location('N')         #设置极轴方向
ax.set_title('复联六位初代英雄战力对比',fontsize = 20)   #添加图描述
 
plt.legend(loc='lower center',ncol=6)
plt.tight_layout()
fig.savefig('A6.jpg',dpi=200)
```



### 十位重要英雄实力

除了六位初代英雄，陆陆续续还出现了很多其他英雄，挑选十位露脸最多的来看看。

#### 洛基

有「锤」必有「基」，虽然电影中洛基饰演的是反派，但其实不坏，跟雷神相爱相杀带来不少笑料，所以重要人物中必须「Loki」的名字。

![](http://media.makcyun.top/FrIBSBkG2ZEDB4gI8etjb_iLCVX6)

#### 惊奇队长

很多人都说惊奇队长应该是《复联》中最牛逼的人，在《复联4》打了个酱油。战斗力的确很惊人，但 DC 中还有一个比她还厉害的男性「惊奇队长」，一会儿说。

![](http://media.makcyun.top/FlqKG81F7XhsXQ1g7hQETmZbl9Ol)

#### 绯红女巫

不得不说绯红女巫是又美又能打，差点把灭霸撕了。我不会告诉你他们俩早在另外一部电影《老男孩》里也上演了一出别样「大战」。

![](http://media.makcyun.top/Ft7uRXY_GmMdPfyLsP-BgHYZRW8X)

#### 幻视

《复联2》中诞生就拥有心灵宝石的幻视着实牛逼，把奥创打得满地找牙，但到了后面怎么就沦落到被保护的境地了。

![](http://media.makcyun.top/FtRf6OOHQuPcTZuD66EBDzS2kxgA)

#### 奇异博士

卷福饰演的奇异博士还是很牛逼，有时间宝石、有斗篷还有酷炫的阿戈摩托之眼。《复联4》最后对着托尼竖起了一根手指，大概是说：「福尔摩斯，只能有一个。」

![](http://media.makcyun.top/FlJlgzR-2jPaKU6jVzQLR5QhtQLv)

#### 蚁人 & 蜘蛛侠

蚁人和蜘蛛侠差不多，飞来飞去。蚁人是复联少数几个绝顶聪明的人，可以说《复联4》能够逆转，蚁人功劳很大。蜘蛛侠实力均衡，早在《钢铁侠》系列中就出场了，虽然身为托尼的小跟班，但漫画中蜘蛛侠是漫威最大的 IP。

![](http://media.makcyun.top/Fux-4chHfN3ReqgzKP3VeiL4ukzi)

![](http://media.makcyun.top/Flz9tG5ZIGsVgP55K8UscNAj24_b)

#### 黑豹 & 冬兵

要问谁比钢铁侠还有钱，那必然是「振金王国」瓦坎达的国王黑豹了。在去年的独立电影中大放异彩，复联中到没有太多施展拳脚的机会。

要论复联有哪几对相爱相杀组合，除了雷神和洛基，就是美队和冬兵了，《美队1》中还是挺感人的。

![](http://media.makcyun.top/FmW545GSBfpQniJ30GQ8I8sC2iQG)

![](http://media.makcyun.top/FrKA8Mgu9HDCvN800z9Xv15gaUQF)

#### 星爵

最后隆重出场的是星爵，也是我本人最喜欢的复联英雄。《银河护卫队1》打养父，《银河护卫队2》打生父，《复联34》打岳父，他才是最牛逼的「灭爸」。现实中的岳父是位了不得的人物：施瓦辛格。

虽然综合实力不怎么样但银河系尬舞天团的能力不是吹的。

![](http://media.makcyun.top/FryCDYypeLH4YJ4DPhI9KBhQiz65)

来听听这首星伴随着 Walkman 尬舞的歌。

以上就介绍了十位重要英雄。

去掉四位稍弱人物，来对比下六人组综合实力。

![](http://media.makcyun.top/Fum9psp0q4EVjHbNwbxtgd4bXpZm)

惊队除了智商稍微弱点，其他基本无敌，这点和雷神很像，二者综合实力也差不多，可以说是新老成员中最厉害的了。



#### 灭霸

正派说完轮到大 BOSS 灭霸出场了。

![](http://media.makcyun.top/FvgtL_3FaForkLaIAlHHD30hFRyT)

看到灭霸就会想起电影中被他那宝石手套支配的恐惧，五一终于理解灭霸的初心了。而灭霸真实的实力如何呢，来看看他和雷神、惊奇队长三人对比。

![](http://media.makcyun.top/FuA-Pd6bhC-7WaXvy13XaFM7YnIl)

可以看到灭霸的优缺点非常明显，优点是和托尼一样绝顶聪明，缺点就是速度慢，难怪电影中要靠宝石跑到地球来。综合来看，三者单挑的话基本五五开，灭霸戴上手套的话就另算了。

### 漫威和 DC 英雄比

作为两大漫画巨头，漫威和 DC 一直在明争暗斗，早些年 DC 要比漫威混得好，漫威这十几年才起来。两大公司手上都握有大量漫画角色，对比一下这两家当家英雄应该会很有意思。

DC 比较熟知的就是超人了，这里来拿雷神和超人对比下看看。可以看到超人近乎完美，比雷神聪明速度也更快，除了格斗稍弱雷神，总体来说是碾压雷神的。

![](http://media.makcyun.top/FnOHbfcQY5Oz6vP8ncSLpLIhpH9N)

DC 其他英雄又如何呢，把 700 多位英雄六项能力值汇总得到综合实力，然后取前十名来看看。

- 标红色的是 DC 家的
- 浅灰色是其他公司的
- 深黑色的是漫威家的

![](http://media.makcyun.top/FjU7ItEKlPyv1bdqPK05nm6u_pdC)

完全没有想到，综合实力最强的 10 位竟然有 8 位都来自 DC，漫威完全被碾压，唯一登榜的是超越者（*Beyonder*），雷神都上不了榜。

然而问题来了，**拥有如此众多实力超强的英雄，DC 近些年为什么风头全被漫威压住了？**

榜单上排名第一得到了 600 满分无敌了，来揭晓下 TA 是谁。

就是这位 Man of Miracles，别名 Mother of Existence 宇宙的创造者，上帝是他儿子。

![](http://media.makcyun.top/FrcxMqaKrEADbIjL_kOGrDGhJwTG)



### 其他有意思的

#### 最高的人

很多漫威英雄五大三粗，就来扒一扒哪些角色最高。排第一的是 「Ymir」超过 300 米，他是冰霜巨人的祖先，即洛基的祖先。范迪塞尔配音的  Groot 在银护中非常高，也仅能排第 10。 

| num  | name          | height | total_score |
| ---- | ------------- | ------ | ----------- |
| 0    | Ymir          | 304.80 | 403.0       |
| 1    | Godzilla      | 108.00 | 418.0       |
| 2    | Giganta       | 62.50  | 352.0       |
| 3    | Anti-Monitor  | 61.00  | 528.0       |
| 4    | King Kong     | 30.50  | 424.0       |
| 5    | Bloodwraith   | 30.50  | 72.0        |
| 6    | Utgard-Loki   | 15.20  | 386.0       |
| 7    | Fin Fang Foom | 9.75   | 399.0       |
| 8    | Galactus      | 8.76   | 533.0       |
| 9    | Groot         | 7.01   | 427.0       |

#### 最壮的人

复联中浩克、灭霸都很壮，可在诸多大神面前就是小巫见大巫了。排第一的就是熟悉的哥斯拉，重达九万吨，不得不说日本人脑洞真大。第二的金刚也有九千吨。

| name | weight        | total_score |       |
| ---- | ------------- | ----------- | ----- |
| 0    | Godzilla      | 90000000    | 418.0 |
| 1    | King Kong     | 9000000     | 424.0 |
| 2    | Utgard-Loki   | 58000       | 386.0 |
| 3    | Fin Fang Foom | 18000       | 399.0 |
| 4    | Galactus      | 16000       | 533.0 |
| 5    | Groot         | 4000        | 427.0 |
| 6    | Iron Monger   | 2000        | 379.0 |
| 7    | Sasquatch     | 900         | 291.0 |
| 8    | Juggernaut    | 855         | 441.0 |
| 9    | Darkseid      | 817         | 566.0 |

以上就是对宇宙英雄的一些简单分析，感兴趣的话可以自己试试。Python 源代码和数据在公众号后台回复：「漫威」就可以得到。

数据采集部分的代码如下：

```python
# -*- coding: utf-8 -*-
"""
Created on Mon May 5 12:57:10 2019
@author: 高级农民工
"""
import requests
import pandas as pd
import re
from requests.exceptions import RequestException
import time
from multiprocessing import Process, Pool
import pymongo
import os

# https://superheroapi.com/，facebook 登陆即可自动获取token
token = '输入你的token' # 如果获取不到，可以微信找我提供给你

def getapi(i):
    url = 'https://superheroapi.com/api/%s/%s' % (token, i)
    data = requests.get(url).json()
    return data

def parseapi(item):
    lst = {
        'id': item['id'],
        'name': item['name'],
        # 提取人物战斗力值
        'intelligence': item['powerstats']['intelligence'],
        'strength': item['powerstats']['strength'],
        'speed': item['powerstats']['speed'],
        'durability': item['powerstats']['durability'],
        'power': item['powerstats']['power'],
        'combat': item['powerstats']['combat'],
        # 提取人物特征
        'gender': item['appearance']['gender'],
        'race': item['appearance']['race'],
        'height': item['appearance']['height'][1],  # 取cm
        'weight': item['appearance']['weight'][1],  # 取kg
        # 提取人物头像url
        'image': item['image']['url'],
        'publisher': item['biography']['publisher'],  # 出版方 Marvel/DC
        'alignment': item['biography']['alignment']  # 正派/反派
    }

    # 写入csv
    write_csv(lst)

    # 或者写入MongoDB
    # write_mongodb(lst)

    # # 下载图片拼图片墙
    image = item['image']['url']
    save(image)

def write_mongodb(lst):
    client = pymongo.MongoClient('localhost', 27017)
    db = client.marvel
    mongo_collection = db.marvel_stats

    if mongo_collection.update_one(lst, {'$set': lst}, upsert=True):
        pass
    else:
        print('存储失败')
    print('id:%s 存储完成' % lst['id'])

def write_csv(lst):
    content = pd.DataFrame([lst])
    content.to_csv('./marvel.csv', mode='a', encoding='utf_8_sig',
                   index=False, header=None)

def save(image):
    # 获取头像编号
    num = re.search('https:.*\/(.*?).jpg', image).group(1)
    dir = os.getcwd() + '\\marvel\\'
    if not os.path.exists(dir):
        os.mkdir(dir)
    file_path = '{0}\\{1}.{2}'.format(dir, num, 'jpg')
    try:
        response = requests.get(image)
        if response.status_code == 200:
            with open(file_path, 'wb') as f:
                f.write(response.content)
                print('编号：%s下载完成' % num)
    except exceptions:
        pass

def main(i):
    data = getapi(i)
    parseapi(data)

if __name__ == '__main__':
    start = time.time()
    pool = Pool()
    for i in range(1, 732):
        # 多进程
        pool.apply_async(main, args=[i, ])
    pool.close()
    pool.join()
    end = time.time()
    print('总共用时{}s'.format((end - start)))
```



最后，欢迎加入我的知识星球，还有更多干货。

![](http://media.makcyun.top/FmK9TW8XT7fcwSc1fQnlSixQUUpj)

