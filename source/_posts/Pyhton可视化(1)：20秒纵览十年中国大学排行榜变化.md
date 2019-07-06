---
title: 'Pyhton可视化(1): 20秒纵览十年中国大学排行榜变化'
date: 2018-09-05 13:27:22
id: Python_visualization01
categories: Python可视化
tags: Python可视化
images: http://media.makcyun.top/18-9-6/22140974.jpg
keywords: [Python可视化,Python爬虫]


---

Python爬取近十年中国大学Top20强并结合D3.js做动态数据可视化表。

<!-- more -->  

**摘要：**：最近在朋友圈看到一个很酷炫的动态数据可视化表，介绍了新中国成立后各省GDP的发展历程，非常惊叹竟然还有这种操作，也想试试。于是，照葫芦画瓢虎，在网上爬取了历年中国大学学术排行榜，制作了一个中国大学排名Top20强动态表。

## 1. 作品介绍

这里先放一下这个动态表是什么样的：
[https://www.bilibili.com/video/av24503002](https://www.bilibili.com/video/av24503002)

不知道你看完是什么感觉，至少我是挺震惊的，想看看作者是怎么做出来的，于是追到了作者的B站主页，发现了更多有意思的动态视频：
![](http://media.makcyun.top/18-9-6/84261830.jpg)  

这些作品的作者是：@Jannchie见齐，他的主页：
[https://space.bilibili.com/1850091/#/video](https://space.bilibili.com/1850091/#/video)

这些会动的图表是如何做出来的呢？他用到的是一个动态图形显示数据的JavaScript库：**D3.js**，一种前端技术。难怪不是一般地酷炫。 
那么，如果不会D3.js是不是就做不出来了呢？当然不是，Jannchie非常Open地给出了一个手把手简单教程：  
[https://www.bilibili.com/video/av28087807](https://www.bilibili.com/video/av28087807) 

他同时还开放了程序源码，你只需要做2步就能够实现：  
- 到他的Github主页下载源码到本地电脑：
[https://github.com/Jannchie/Historical-ranking-data-visualization-based-on-d3.js](https://github.com/Jannchie/Historical-ranking-data-visualization-based-on-d3.js)  
![](http://media.makcyun.top/18-9-6/38399216.jpg)

- 打开`dist`文件夹里面的`exampe.csv`文件，放进你想要展示的数据，再用浏览器打开`bargraph.html`网页，就可以实现动态效果了。

下面，我们稍微再说详细一点，实现这种效果的关键点。  
最重要的是要有数据。观察一下上面的作品可以看到，横向柱状图中的数据要满足两个条件：一是要有多个对比的对象，二是要在时间上连续。这样才可以做出动态效果来。

看完后我立马就有了一个想法：**想看看近十年中国的各个大学排名是个什么情况**。下面我们就通过实实例来操作下。

## 2. 案例操作：中国大学Top20强

### 2.1. 数据来源

世界上最权威的大学排名有4类，分别是：
- 原上海交通大学的ARWU
   [http://www.shanghairanking.com/ARWU2018.html](http://www.shanghairanking.com/ARWU2018.html)
- 英国教育组织的QS   
  [https://www.topuniversities.com/university-rankings/world-university-rankings/2018](https://www.topuniversities.com/university-rankings/world-university-rankings/2018)
- 泰晤士的THE  
  [https://www.timeshighereducation.com/world-university-rankings](https://www.timeshighereducation.com/world-university-rankings)  
- 美国的usnews   
  [https://www.usnews.com/best-colleges/rankings](https://www.usnews.com/best-colleges/rankings)

关于，这四类排名的更多介绍，可以看这个：  
[https://www.zhihu.com/question/20825030/answer/71336291](https://www.zhihu.com/question/20825030/answer/71336291)

这里，我们选取相对比较权威也比较符合国情的第一个ARWU的排名结果。打开官网，可以看到有英文版和中文版排名，这里选取中文版。 
排名非常齐全，从2003年到最新的2018年都有，非常好。
![](http://media.makcyun.top/18-9-6/79756091.jpg)

同时，可以看到这是世界500强的大学排名，而我们需要的是中国（包括港澳台）的大学排名。怎么办呢？ 当然不能一年年地复制然后再从500条数据里一条条筛选出中国的，这里就要用爬虫来实现了。可以参考不久前的一篇爬取表格的文章：
[https://www.makcyun.top/web_scraping_withpython2.html](https://www.makcyun.top/web_scraping_withpython2.html)

### 2.2. 抓取数据

#### 2.2.1. 分析url

首先，分析一下URL:

```html
http://www.zuihaodaxue.com/ARWU2018.html
http://www.zuihaodaxue.com/ARWU2017.html
...
http://www.zuihaodaxue.com/ARWU2009.html
```

可以看到，url非常有规律，只有年份数字在变，很简单就能构造出for循环。
格式如下：

```python
url = 'http://www.zuihaodaxue.com/ARWU%s.html' % (str(year))
```

下面就可以开始写爬虫了。  

#### 2.2.2. 获取网页内容

```python
import requests
try:
    url = 'http://www.zuihaodaxue.com/ARWU%s.html' % (str(year))
    response = requests.get(url,headers = headers)
    # 2009-2015用'gbk'，2016-2018用'utf-8'
    if response.status_code == 200:
        # return response.text  # text会乱码，content没有问题
        return response.content
    return None
except RequestException:
print('爬取失败')
```
上面需要注意的是，不同年份网页采用的编码不同，返回response.test会乱码，返回response.content则不会。关于编码乱码的问题，以后单独写一篇文章。

#### 2.2.3. 解析表格

用read_html函数一行代码来抓取表格，然后输出：
```python
tb = pd.read_html(html)[0]
print(tb)
```

可以看到，很顺利地表格就被抓取了下来：  
![http://media.makcyun.top/18-9-6/80641562.jpg](http://media.makcyun.top/18-9-6/80641562.jpg)
但是表格需要进行处理，比如删除掉不需要的评分列，增加年份列等，代码实现如下：

```python
tb = pd.read_html(html)[0]
# 重命名表格列，不需要的列用数字表示
tb.columns = ['world rank','university', 2,3, 'score',5,6,7,8,9,10]
tb.drop([2,3,5,6,7,8,9,10],axis = 1,inplace = True)
# 删除后面不需要的评分列
# rank列100名后是区间，需需唯一化，增加一列index作为排名
tb['index_rank'] = tb.index
tb['index_rank'] = tb['index_rank'].astype(int) + 1

# 增加一列年份列
tb['year'] = i
# read_html没有爬取country，需定义函数单独爬取
tb['country'] = get_country(html)
return tb
```
需要注意的是，国家没有被抓取下来，因为国家是用的图片表示的，定位到国家代码位置：
![http://media.makcyun.top/18-9-6/39145641.jpg](http://media.makcyun.top/18-9-6/39145641.jpg)

可以看到美国是用英文的USA表示的，那么我们可以单独提取出src属性，然后用正则提取出国家名称就可以了，代码实现如下：

```python
# 提取国家名称
def get_country(html):
    soup = BeautifulSoup(html,'lxml')
    countries = soup.select('td > a > img')
    lst = []
    for i in countries:
        src = i['src']
        pattern = re.compile('flag.*\/(.*?).png')
        country = re.findall(pattern,src)[0]
        lst.append(country)
    return lst
```

然后，我们就可以输出一下结果：

```python
    world rank    university  score  index_rank  year      country
0            1          哈佛大学  100.0           1  2018          USA
1            2         斯坦福大学   75.6           2  2018          USA
2            3          剑桥大学   71.8           3  2018           UK
3            4        麻省理工学院   69.9           4  2018          USA
4            5      加州大学-伯克利   68.3           5  2018          USA
5            6        普林斯顿大学   61.0           6  2018          USA
6            7          牛津大学   60.0           7  2018           UK
7            8        哥伦比亚大学   58.2           8  2018          USA
8            9        加州理工学院   57.4           9  2018          USA
9           10         芝加哥大学   55.5          10  2018          USA
10          11      加州大学-洛杉矶   51.2          11  2018          USA
11          12         康奈尔大学   50.7          12  2018          USA
12          12          耶鲁大学   50.7          13  2018          USA
13          14     华盛顿大学-西雅图   50.0          14  2018          USA
14          15     加州大学-圣地亚哥   47.8          15  2018          USA
15          16       宾夕法尼亚大学   46.4          16  2018          USA
16          17        伦敦大学学院   46.1          17  2018           UK
17          18      约翰霍普金斯大学   45.4          18  2018          USA
18          19     苏黎世联邦理工学院   43.9          19  2018  Switzerland
19          20    华盛顿大学-圣路易斯   42.1          20  2018          USA
20          21      加州大学-旧金山   41.9          21  2018          USA
```

数据很完美，接下来就可以按照D3.js模板中的example.csv文件的格式作进一步的处理了。  

### 2.3. 数据处理

这里先将数据输出为`university.csv`文件，结果见下表：

![http://media.makcyun.top/18-9-6/44505347.jpg](http://media.makcyun.top/18-9-6/44505347.jpg)

10年一共5011行×6列数据。接着，读入该表作进一步数据处理，代码如下：

```python
df = pd.read_csv('university.csv')
# 包含港澳台
# df = df.query("(country == 'China')|(country == 'China-hk')|(country == 'China-tw')|(country == 'China-HongKong')|(country == 'China-Taiwan')|(country == 'Taiwan,China')|(country == 'HongKong,China')")[['university','year','index_rank']]

# 只包括内地
df = df.query("(country == 'China')")
df['index_rank_score'] = df['index_rank']
# 将index_rank列转为整形
df['index_rank'] = df['index_rank'].astype(int)

# 美国
# df = df.query("(country == 'UnitedStates')|(country == 'USA')")
 
#求topn名
def topn(df):
    top = df.sort_values(['year','index_rank'],ascending = True)
    return top[:20].reset_index()
df = df.groupby(by =['year']).apply(topn)

# 更改列顺序
df = df[['university','index_rank_score','index_rank','year']]
# 重命名列
df.rename (columns = {'university':'name','index_rank_score':'type','index_rank':'value','year':'date'},inplace = True)

# 输出结果
df.to_csv('university_ranking.csv',mode ='w',encoding='utf_8_sig', header=True, index=False)
# index可以设置
```

上面需要注意两点：

- 可以提取包含港澳台在内的大中华区所有的大学，也可以只提取内地的大学，还可以提取世界、美国等各种排名。
- 定义了一个求Topn的函数，能够按年份分别求出各年的前20名大学名单。

打开输出的`university_ranking.csv`文件：
![http://media.makcyun.top/18-9-6/64400003.jpg](http://media.makcyun.top/18-9-6/64400003.jpg)

结果非常好，可以直接作为D3.js的导入文件了。

#### 2.3.1. 完整代码

将代码再稍微完善一下，完整地代码如下所示：

```python
import pandas as pd
import csv
import requests
from requests.exceptions import RequestException
from bs4 import BeautifulSoup
import time
import re

start_time = time.time()  #计算程序运行时间
# 获取网页内容
def get_one_page(year):
        try:
            headers = {
                'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36'
            }
            # 英文版
            # url = 'http://www.shanghairanking.com/ARWU%s.html' % (str(year))
            # 中文版
            url = 'http://www.zuihaodaxue.com/ARWU%s.html' % (str(year))
            response = requests.get(url,headers = headers)
            # 2009-2015用'gbk'，2016-2018用'utf-8'
            if response.status_code == 200:
                # return response.text  # text会乱码，content没有问题
                # https://stackoverflow.com/questions/17011357/what-is-the-difference-between-content-and-text
                return response.content
            return None
        except RequestException:
            print('爬取失败')

# 解析表格
def parse_one_page(html,i):
        tb = pd.read_html(html)[0]
        # 重命名表格列，不需要的列用数字表示
        tb.columns = ['world rank','university', 2,3, 'score',5,6,7,8,9,10]
        tb.drop([2,3,5,6,7,8,9,10],axis = 1,inplace = True)
        # 删除后面不需要的评分列

        # rank列100名后是区间，需需唯一化，增加一列index作为排名
        tb['index_rank'] = tb.index
        tb['index_rank'] = tb['index_rank'].astype(int) + 1
        # 增加一列年份列
        tb['year'] = i
        # read_html没有爬取country，需定义函数单独爬取
        tb['country'] = get_country(html)
        # print(tb) # 测试表格ok
        return tb
        # print(tb.info()) # 查看表信息
        # print(tb.columns.values) # 查看列表名称

# 提取国家名称
def get_country(html):
    soup = BeautifulSoup(html,'lxml')
    countries = soup.select('td > a > img')
    lst = []
    for i in countries:
        src = i['src']
        pattern = re.compile('flag.*\/(.*?).png')
        country = re.findall(pattern,src)[0]
        lst.append(country)
    return lst
    # print(lst) # 测试提取国家是否成功ok

# 保存表格为csv
def save_csv(tb):
    tb.to_csv(r'university.csv', mode='a', encoding='utf_8_sig', header=True, index=0)

    endtime = time.time()-start_time
    # print('程序运行了%.2f秒' %endtime)

def analysis():
    df = pd.read_csv('university.csv')
    # 包含港澳台
    # df = df.query("(country == 'China')|(country == 'China-hk')|(country == 'China-tw')|(country == 'China-HongKong')|(country == 'China-Taiwan')|(country == 'Taiwan,China')|(country == 'HongKong,China')")[['university','year','index_rank']]
    # 只包括内地
    df = df.query("(country == 'China')")[['university','year','index_rank']]

    df['index_rank_score'] = df['index_rank']
    # 将index_rank列转为整形
    df['index_rank'] = df['index_rank'].astype(int)
    # 美国
		# df = df.query("(country == 'UnitedStates')|(country == 'USA')")[['university','year','index_rank']]
    #求topn名
    def topn(df):
        top = df.sort_values(['year','index_rank'],ascending = True)
        return top[:20].reset_index()
    df = df.groupby(by =['year']).apply(topn)
    # 更改列顺序
    df = df[['university','index_rank_score','index_rank','year']]
    # 重命名列
    df.rename (columns = {'university':'name','index_rank_score':'type','index_rank':'value','year':'date'},inplace = True)

    # 输出结果
    df.to_csv('university_ranking.csv',mode ='w',encoding='utf_8_sig', header=True, index=False)
    # index可以设置

def main(year):
    # generate_mysql()
    for i in range(2009,year):  #抓取10年
        # get_one_page(i)
        html = get_one_page(i)
        # parse_one_page(html,i)  # 测试表格ok
        tb = parse_one_page(html,i)
        save_csv(tb)
        print(i,'年排名提取完成完成')
        analysis()
# # 单进程
if __name__ == '__main__':
    main(2019)
    # 2016-2018采用gb2312编码，2009-2015采用utf-8编码
```

至此，我们已经有`university_ranking.csv`基础数据，下面就可以进行可视化呈现了。

### 2.4. 可视化呈现

首先，到见齐的github主页：  
[https://github.com/Jannchie/Historical-ranking-data-visualization-based-on-d3.js](https://github.com/Jannchie/Historical-ranking-data-visualization-based-on-d3.js) 

#### 2.4.1. 克隆仓库文件

如果你平常使用github或者Git软件的话，那么就找个合适文件存放目录，然后直接在 GitBash里分别输入下面3条命令就搭建好环境了：

```js
# 克隆项目仓库
git clone https://github.com/Jannchie/Historical-ranking-data-visualization-based-on-d3.js
# 切换到项目根目录
cd Historical-ranking-data-visualization-based-on-d3.js
# 安装依赖
npm install
```
如果你此前没有用过上面的软件，你可以直接点击`Download Zip`下载下来然后解压即可，不过还是强烈建议使用第一种方法，因为后面如果要自定义可视化效果的话，需要修改代码然后执行`npm run build`命令才能够看到效果。

#### 2.4.2. 效果呈现

好，所有基本准备都已完成，下面就可以试试看效果了。
任意浏览器打开`bargraph.html`网页，点击选择文件，然后选择：前面输出的`university_ranking.csv`文件，看下效果吧：
[https://v.youku.com/v_show/id_XMzgxMjkzMzI4NA==.html?spm=a2hzp.8244740.0.0](https://v.youku.com/v_show/id_XMzgxMjkzMzI4NA==.html?spm=a2hzp.8244740.0.0)

可以看到，有了大致的可视化效果，但还存在很多瑕疵，比如：表顺序颠倒了、字体不合适、配色太花哨等。可不可以修改呢？  

当然是可以的，只需要分别修改文件夹中这几个文件的参数就可以了：  
- config.js 全局设置各项功能的开关，比如配色、字体、文字名称、反转图表等等功能；
- color.css 修改柱形图的配色；
- stylesheet.css 具体修改配色、字体、文字名称等的css样式；
- visual.js 更进一步的修改，比如图表的透明度等。

知道在哪里修改了以后，那么，如何修改呢？很简单，只需要简单的几步就可以实现：  
- 打开网页，`右键-检查`，箭头指向想要修改的元素，然后在右侧的css样式表里，双击各项参数修改参数，修改完元素就会发生变化，可以不断微调，直至满意为止。
![](http://media.makcyun.top/18-9-6/63524613.jpg)

- 把参数复制到四个文件中对应的文件里并保存。
- Git Bash不断重复运行`npm run build`，之后刷新网页就可以看到优化后的效果。

最后，再添加一个合适的BGM就可以了。以下是我优化之后的效果：
[https://v.youku.com/v_show/id_XMzgxMjgyNTE2OA==.html?spm=a2hzp.8244740.0.0](https://v.youku.com/v_show/id_XMzgxMjgyNTE2OA==.html?spm=a2hzp.8244740.0.0)  
*BGM：ツナ覚醒*

如果你不太会调整，没有关系，我会分享优化后的配置文件。

以上，就是实现动态可视化表的步骤。 同样地，只要更改数据源可以很方便地做出世界、美国等大学的动态效果，可以看看：  
中国（含港澳台）大学排名：
[http://media2.makcyun.top/Greater_China_uni_ranking.mp4](http://media2.makcyun.top/Greater_China_uni_ranking.mp4)  
美国大学排名：  
[http://media2.makcyun.top/USA_uni_ranking.mp4](http://media2.makcyun.top/USA_uni_ranking.mp4)

文章所有的素材，在公众号后台回复**大学排名**就可以得到，或者到我的github下载：
[https://github.com/makcyun/web_scraping_with_python](https://github.com/makcyun/web_scraping_with_python)  
感兴趣的话就动手试试吧。

本文完。