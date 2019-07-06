---
title:  Python爬虫(1):多种方法爬取猫眼top100电影
id: web_scraping_withpython1
date: {{ date }}
categories: Python爬虫
tags: [Python爬虫,requests,正则表达式,beautifulsoup,css,xpath,lxml]
images: http://media.makcyun.top/18-8-16/81175827.jpg
keywords: 


---


<b>*python爬虫第1篇*</b>   
利用Request请求库和4种内容提取方法：正则表达式、lxml+xpath、Beatutifulsoup+css选择器、Beatutifulsoup+find_all爬取网页内容。

<!-- more -->  



**摘要：** 作为小白，**爬虫可以说是入门python最快和最容易获得成就感的途径**。因为初级爬虫的套路相对固定，常见的方法只有几种，比较好上手。最近，跟着崔庆才大佬的书：*python3网络爬虫开发实战* 学习爬虫。选取网页结构较为简单的猫眼top100电影为案例进行练习。 **重点是用上述所说的4种方法提取出关键内容**。一个问题采用不同的解决方法有助于拓展思维，通过不断练习就能够灵活运用。


>**本文知识点：**  
>Requsts 请求库的使用  
>beautiful+lxml两大解析库使用  
>正则表达式 、xpath、css选择器的使用  


![](http://media.makcyun.top/18-8-19/49818413.jpg)

## 1. 为什么爬取该网页？ ##
- 比较懒，不想一页页地去翻100部电影的介绍，**想在一个页面内进行总体浏览**（比如在excel表格中）；

![](http://media.makcyun.top/18-8-19/28479553.jpg)

- 想**深入了解一些比较有意思的信息**，比如：哪部电影的评分最高？哪位演员的作品数量最多？哪个国家/地区上榜的电影数量最多？哪一年上榜的电影作品最多等。这些信息在网页上是不那么容易能直接获得的，所以需要爬虫。

![](http://media.makcyun.top/18-8-20/66062822.jpg)

## 2. 爬虫目标 ##
- 从网页中提取出top100电影的电影名称、封面图片、排名、评分、演员、上映国家/地区、评分等信息，并保存为csv文本文件。
- 根据爬取结果，进行简单的可视化分析。

平台：windows7 + SublimeText3


## 3. 爬取步骤 ##

### 3.1. 网址URL分析 ###
首先，打开猫眼Top100的url网址： [**http://maoyan.com/board/4?offset=0**](http://maoyan.com/board/4?offset=0)。页面非常简单，所包含的信息就是上述所说的爬虫目标。下拉页面到底部，点击第2页可以看到网址变为：**http://maoyan.com/board/4?offset=10**。因此，可以推断出url的变化规律：offset表示偏移，10代表一个页面的电影偏移数量，即：第一页电影是从0-10，第二页电影是从11-20。因此，获取全部100部电影，只需要构造出10个url，然后依次获取网页内容，再用不同的方法提取出所需内容就可以了。  
下面，用requests方法获取第一个页面。

### 3.2. Requests获取首页数据 ###
先定义一个获取单个页面的函数：get_one_page()，传入url参数。

```python
def get_one_page(url):
    try:
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36'}
        # 不加headers爬不了
        response = requests.get(url, headers=headers)
        if response.status_code == 200:
            return response.text
        else:
            return None
    except RequestException:
        return None
    # try-except语句捕获异常
```

接下来在main()函数中设置url。

```python  
def main():
    url = 'http://maoyan.com/board/4?offset=0'
    html = get_one_page(url)
    print(html)


if __name__ == '__main__':
    main()
 
```

运行上述程序后，首页的源代码就被爬取下来了。如下图所示：

![](http://media.makcyun.top/18-8-19/18415362.jpg)


接下来就需要从整个网页中提取出几项我们需要的内容，用到的方法就是上述所说的四种方法，下面分别进行说明。


### 3.3. 4种内容解析提取方法 ###

#### 3.3.1. 正则表达式提取 ####

第一种是利用**正则表达式**提取。  
什么是正则表达式？ 下面这串看起来乱七八糟的符号就是正则表达式的语法。

```
'<dd>.*?board-index.*?>(\d+)</i>.*?data-src="(.*?)".*?name"><a.*?>(.*?)</a>.*?'
```

它是一种强大的字符串处理工具。之所以叫正则表达式，是因为它们可以识别正则字符串（regular string）。可以这么定义：“ 如果你给我的字符串符合规则，我就返回它”；“如果字符串不符合规则，我就忽略它”。通过requests抓取下来的网页是一堆大量的字符串，用它处理后便可提取出我们想要的内容。

如果还不了解它，可以参考下面的教程：

> [http://www.runoob.com/regexp/regexp-syntax.html](http://www.runoob.com/regexp/regexp-syntax.html)
> [https://www.w3cschool.cn/regexp/zoxa1pq7.html](https://www.w3cschool.cn/regexp/zoxa1pq7.html)



**正则表达式常用语法：**
<style>
table th:nth-of-type(1) {
    width: 60px;
}

</style>


|  模式  |                          描述                          |
|:------:|:------------------------------------------------------:|
|   \w   |                  匹配字母数字及下划线                  |
|   \W   |                 匹配非字母数字及下划线                 |
|   \s   |          匹配任意空白字符，等价于 [\t\n\r\f]          |
|   \S   |                    匹配任意非空字符                    |
|   \d   |               匹配任意数字，等价于 [0-9]               |
|   \D   |                     匹配任意非数字                     |
|   \n   |                     匹配一个换行符                     |
|   \t   |                     匹配一个制表符                     |
|    ^   |                匹配字符串开始位置的字符                |
|    $   |                    匹配字符串的末尾                    |
|    .   |                匹配任意字符，除了换行符                |
|  [...] | 用来表示一组字符，单独列出：[amk] 匹配 'a'，'m' 或 'k' |
| [^...] |                    不在 [ ] 中的字符                   |
|    *   |    匹配前面的字符、子表达式或括号里的字符 0 次或多次   |
|    +   |                   同上，匹配至少一次                   |
|    ?   |                    同上，匹配0到1次                    |
|   {n}  |       匹配前面的字符、子表达式或括号里的字符 n 次      |
| {n, m} |           同上，匹配 m 到n 次（包含 m 或 n）           |
|   ( )  |            匹配括号内的表达式，也表示一个组            |



下面，开始提取关键内容。右键网页-检查-Network选项，选中左边第一个文件然后定位到电影信息的相应位置，如下图：

![](http://media.makcyun.top/18-8-19/84055565.jpg)


可以看到每部电影的相关信息都在**dd**这个节点之中。所以就可以从该节点运用正则进行提取。
第1个要提取的内容是电影的排名。它位于class="board-index"的**i**节点内。不需要提取的内容用'.*?'替代，需要提取的数字排名用（）括起来，（）里面的数字表示为（\d+）。正则表达式可以写为：

```
'<dd>.*?board-index.*?>(\d+)</i>'
```


接着，第2个需要提取的是封面图片，图片网址位于img节点的'data-src'属性中，正则表达式可写为：

```
'data-src="(.*?)".*?'
```

第1和第2个正则之间的代码是不需要的，用'.*?'替代，所以这两部分合起来写就是：

```
'<dd>.*?board-index.*?>(\d+)</i>.*?data-src="(.*?)"
```

同理，可以依次用正则写下主演、上映时间和评分等内容,完整的正则表达式如下：

```
'<dd>.*?board-index.*?>(\d+)</i>.*?data-src="(.*?)".*?name"><a.*?>(.*?)</a>.*?star">(.*?)</p>.*?releasetime">(.*?)</p.*?integer">(.*?)</i>.*?fraction">(.*?)</i>.*?</dd>'
```

正则表达式写好以后，可以定义一个页面解析提取方法：parse_one_page（），用来提取内容：

```python
def parse_one_page(html):
    pattern = re.compile(
        '<dd>.*?board-index.*?>(\d+)</i>.*?data-src="(.*?)".*?name"><a.*?>(.*?)</a>.*?star">(.*?)</p>.*?releasetime">(.*?)</p.*?integer">(.*?)</i>.*?fraction">(.*?)</i>.*?</dd>', re.S)
    # re.S表示匹配任意字符，如果不加，则无法匹配换行符
    items = re.findall(pattern, html)
    # print(items)
    for item in items:
        yield {
            'index': item[0],
            'thumb': get_thumb(item[1]),  # 定义get_thumb()方法进一步处理网址
            'name': item[2],
            'star': item[3].strip()[3:],
            # 'time': item[4].strip()[5:],
            # 用两个方法分别提取time里的日期和地区
            'time': get_release_time(item[4].strip()[5:]),
            'area': get_release_area(item[4].strip()[5:]),
            'score': item[5].strip() + item[6].strip()
            # 评分score由整数+小数两部分组成
        }

        
```
> **Tips:**  
> **re.S:**匹配任意字符，如果不加，则无法匹配换行符；  
> **yield:**使用yield的好处是作为生成器，可以遍历迭代，并且将数据整理形成字典，输出结果美观。具体用法可参考：https://blog.csdn.net/zhangpinghao/article/details/18716275；  
> **.strip():**用于去掉字符串中的空格。


上面程序为了便于提取内容，又定义了3个方法：get_thumb（）、get_release_time（）和 get_release_area（）：

```python
# 获取封面大图
def get_thumb(url):
    pattern = re.compile(r'(.*?)@.*?')
    thumb = re.search(pattern, url)
    return thumb.group(1)
# http://p0.meituan.net/movie/5420be40e3b755ffe04779b9b199e935256906.jpg@160w_220h_1e_1c
# 去掉@160w_220h_1e_1c就是大图    


# 提取上映时间函数
def get_release_time(data):
    pattern = re.compile(r'(.*?)(\(|$)')
    items = re.search(pattern, data)
    if items is None:
        return '未知'
    return items.group(1)  # 返回匹配到的第一个括号(.*?)中结果即时间


# 提取国家/地区函数
def get_release_area(data):
    pattern = re.compile(r'.*\((.*)\)')
    # $表示匹配一行字符串的结尾，这里就是(.*?)；\(|$,表示匹配字符串含有(,或者只有(.*?)
    items = re.search(pattern, data)
    if items is None:
        return '未知'
    return items.group(1)

```
> **Tips:**  
> **'r'：**正则前面加上'r' 是为了告诉编译器这个string是个raw string，不要转意'\'。当一个字符串使用了正则表达式后，最好在前面加上'r'；  
> **'|' '$'：**  正则'|'表示或'，'$'表示匹配一行字符串的结尾；  
> **.group(1)**：意思是返回search匹配的第一个括号中的结果，即(.*?)，gropup()则返回所有结果2013-12-18(，group(1)返回'（'。



接下来，修改main()函数来输出爬取的内容：

```python  
def main():
    url = 'http://maoyan.com/board/4?offset=0'
    html = get_one_page(url)
    
    for item in parse_one_page(html):  
        print(item)


if __name__ == '__main__':
    main()
 
```
> **Tips:**  
> **if __ name__ == '_ _main__':**当.py文件被直接运行时，if __ name__ == '_ _main__'之下的代码块将被运行；当.py文件以模块形式被导入时，if __ name__ == '_ _main__'之下的代码块不被运行。  
> 参考：https://blog.csdn.net/yjk13703623757/article/details/77918633。


运行程序，就可成功地提取出所需内容，结果如下：

```js
{'index': '1', 'thumb': 'http://p1.meituan.net/movie/20803f59291c47e1e116c11963ce019e68711.jpg', 'name': '霸王别姬', 'star': '张国荣,张丰毅,巩俐', 'time': '1993-01-01', 'area': '中国香港', 'score': '9.6'}
{'index': '2', 'thumb': 'http://p0.meituan.net/movie/54617769d96807e4d81804284ffe2a27239007.jpg', 'name': '罗马假日', 'star': '格利高里·派克,奥黛丽·赫本,埃迪·艾伯特', 'time': '1953-09-02', 'area': '美国', 'score': '9.1'}
{'index': '3', 'thumb': 'http://p0.meituan.net/movie/283292171619cdfd5b240c8fd093f1eb255670.jpg', 'name': '肖申克的救赎', 'star': '蒂姆·罗宾斯,摩根·弗里曼,鲍勃·冈顿', 'time': '1994-10-14', 'area': '美国', 'score': '9.5'}
{'index': '4', 'thumb': 'http://p0.meituan.net/movie/e55ec5d18ccc83ba7db68caae54f165f95924.jpg', 'name': '这个杀手不太冷', 'star': '让·雷诺,加里·奥德曼,娜塔莉·波特曼', 'time': '1994-09-14', 'area': '法国', 'score': '9.5'}
{'index': '5', 'thumb': 'http://p1.meituan.net/movie/f5a924f362f050881f2b8f82e852747c118515.jpg', 'name': '教父', 'star': '马龙·白兰度,阿尔·帕西诺,詹姆斯·肯恩', 'time': '1972-03-24', 'area': '美国', 'score': '9.3'}

...
}
[Finished in 1.9s]

```

以上是第1种提取方法，如果还不习惯正则表达式这种复杂的语法，可以试试下面的第2种方法。

#### 3.3.2. lxml结合xpath提取 ####
该方法需要用到**lxml**这款解析利器，同时搭配xpath语法，利用它的的路径选择表达式，来高效提取所需内容。lxml包为第三方包，需要自行安装。如果对xpath的语法还不太熟悉，可参考下面的教程：
[http://www.w3school.com.cn/xpath/xpath_syntax.asp](http://www.w3school.com.cn/xpath/xpath_syntax.asp)

**xpath常用的规则**    

|  表达式  |           描述           |
|:--------:|:------------------------:|
| nodename |  选取此节点的所有子节点  |
|     /    | 从当前节点选取直接子节点 |
|    //    |  从当前节点选取子孙节点  |
|     .    |       选取当前节点       |
|    ..    |   选取当前节点的父节点   |
|     @    |         选取属性         |



```html
</div>


    <div class="container" id="app" class="page-board/index" >

<div class="content">
    <div class="wrapper">
        <div class="main">
            <p class="update-time">2018-08-18<span class="has-fresh-text">已更新</span></p>
            <p class="board-content">榜单规则：将猫眼电影库中的经典影片，按照评分和评分人数从高到低综合排序取前100名，每天上午10点更新。相关数据来源于“猫眼电影库”。</p>
            <dl class="board-wrapper">
                <dd>
                        <i class="board-index board-index-1">1</i>
    <a href="/films/1203" title="霸王别姬" class="image-link" data-act="boarditem-click" data-val="{movieId:1203}">
      <img src="//ms0.meituan.net/mywww/image/loading_2.e3d934bf.png" alt="" class="poster-default" />
      <img data-src="http://p1.meituan.net/movie/20803f59291c47e1e116c11963ce019e68711.jpg@160w_220h_1e_1c" alt="霸王别姬" class="board-img" />
    </a>
    <div class="board-item-main">
      <div class="board-item-content">
              <div class="movie-item-info">
        <p class="name"><a href="/films/1203" title="霸王别姬" data-act="boarditem-click" data-val="{movieId:1203}">霸王别姬</a></p>
        <p class="star">
                主演：张国荣,张丰毅,巩俐
        </p>
<p class="releasetime">上映时间：1993-01-01(中国香港)</p>    </div>
    <div class="movie-item-number score-num">
<p class="score"><i class="integer">9.</i><i class="fraction">6</i></p>        
    </div>

      </div>
    </div>

                </dd>
                <dd>

```


根据截取的部分html网页，先来提取第1个电影排名信息，有两种方法。  
**第一种：**直接复制。
右键-Copy-Copy Xpath，得到xpath路径为：**//\*[@id="app"]/div/div/div[1]/dl/dd[1]/i**,为了能够提取到页面所有的排名信息，需进一步修改为：**//\*[@id="app"]/div/div/div[1]/dl/dd/i/text()**，如果想要再精简一点，可以省去中间部分绝对路径'/'然后用相对路径'//'代替，最后进一步修改为：**//\*[@id="app"]//div//dd/i/text()**。
![](http://media.makcyun.top/18-8-19/840042.jpg)


**第二种：**观察网页结构自己写。
首先注意到**id = app**的div节点，因为在整个网页结构id是唯一的不会有第二个相同的，所有可以将该div节点作为xpath语法的起点，然后往下观察分别是3级div节点，可以省略写为：**//div**,再往下分别是是两个并列的**p**节点、**dl**节点、**dd**节点和最后的**i**节点文本。中间可以随意省略，只要保证该路径能够选择到唯一的文本值**'1'**即可，例如省去p和dl节点，只保留后面的节点。这样，完整路径可以为：**//\*[@id="app"]//div//dd/i/text()**，和上式一样。

![](http://media.makcyun.top/18-8-19/87341266.jpg)

根据上述思路，可以写下其他内容的xpath路径。观察到路径的前一部分：**//\*[@id="app"]//div//dd**都是一样的，从后面才开始不同，因此为了能够精简代码，将前部分路径赋值为一个变量items，最终提取的代码如下：

```python
# 2 用lxml结合xpath提取内容
def parse_one_page2(html):
    parse = etree.HTML(html)
    items = parse.xpath('//*[@id="app"]//div//dd')
    # 完整的是//*[@id="app"]/div/div/div[1]/dl/dd
    # print(type(items))
    # *代表匹配所有节点，@表示属性
    # 第一个电影是dd[1],要提取页面所有电影则去掉[1]
    # xpath://*[@id="app"]/div/div/div[1]/dl/dd[1]    
    for item in items:
        yield{
            'index': item.xpath('./i/text()')[0],
            #./i/text()前面的点表示从items节点开始
            #/text()提取文本
            'thumb': get_thumb(str(item.xpath('./a/img[2]/@data-src')[0].strip())),
            # 'thumb': 要在network中定位，在elements里会写成@src而不是@data-src，从而会报list index out of range错误。
            'name': item.xpath('./a/@title')[0],
            'star': item.xpath('.//p[@class = "star"]/text()')[0].strip(),
            'time': get_release_time(item.xpath(
                './/p[@class = "releasetime"]/text()')[0].strip()[5:]),
            'area': get_release_area(item.xpath(
                './/p[@class = "releasetime"]/text()')[0].strip()[5:]),
            'score' : item.xpath('.//p[@class = "score"]/i[1]/text()')[0] + \
            item.xpath('.//p[@class = "score"]/i[2]/text()')[0]
        }


```
> **Tips:**  
> **[0]：**xpath后面添加了[0]是因为返回的是只有1个字符串的list，添加[0]是将list提取为字符串，使其简洁；
> **Network：**要在最原始的Network选项卡中定位，而不是Elements中，不然提取不到相关内容；
> **class属性：**p[@class = "star"]/text()表示提取class属性为"star"的p节点的文本值；
> **提取属性值：**img[2]/@data-src'：提取img节点的data-src属性值，属性值后面无需添加'/text()'


运行程序，就可成功地提取出所需内容，结果和第一种方法一样。

以上是第2种提取方法，如果也不太习惯xpath语法，可以试试下面的第3种方法。


#### 3.3.3. Beautiful Soup + css选择器 ####
Beautiful Soup 同lxml一样，是一个非常强大的python解析库，可以从HTML或XML文件中提取效率非常高。关于它的用法，可参考下面的教程：
[https://www.crummy.com/software/BeautifulSoup/bs4/doc.zh/](https://www.crummy.com/software/BeautifulSoup/bs4/doc.zh/)

 
css选择器选是一种模式，用于选择需要添加样式的元素，使用它的语法同样能够快速定位到所需节点，然后提取相应内容。使用方法可参考下面的教程：
[http://www.w3school.com.cn/cssref/css_selectors.asp](http://www.w3school.com.cn/cssref/css_selectors.asp)

**css选择器常用的规则**  

<style>
table th:nth-of-type(1) {
    width: 30%;
}

</style>

|       选择器      |       例子      |                  例子描述                  |
|:-----------------:|:---------------:|:------------------------------------------:|
|       .class      |      .intro     |       选择 class="intro" 的所有元素。      |
|        #id        |    #firstname   |      选择 id="firstname" 的所有元素。      |
|         *         |        *        |               选择所有元素。               |
|      element      |        p        |             选择所有p元素。            |
|  element,element  |      div,p      |    选择所有div元素和所有p元素。    |
|  element?element  |      div p      |    选择div元素内部的所有p元素。    |
|  element>element  |      div>p      |  选择父元素为div元素的所有p元素。  |
|  element+element  |      div+p      | 选择紧接在div元素之后的所有p元素。 |
|    [attribute]    |     [target]    |       选择带有 target 属性所有元素。       |
| [attribute=value] | [target=_blank] |      选择 target="_blank" 的所有元素。     |


下面就利用这种方法进行提取：
```python
# 3 用beautifulsoup + css选择器提取
def parse_one_page3(html):
    soup = BeautifulSoup(html, 'lxml')
    # print(content)
    # print(type(content))
    # print('------------')
    items = range(10)
    for item in items:
        yield{

            'index': soup.select('dd i.board-index')[item].string,
            # iclass节点完整地为'board-index board-index-1',写board-index即可
            'thumb': get_thumb(soup.select('a > img.board-img')[item]["data-src"]),
            # 表示a节点下面的class = board-img的img节点,注意浏览器eelement里面是src节点，而network里面是data-src节点，要用这个才能正确返回值

            'name': soup.select('.name a')[item].string,
            'star': soup.select('.star')[item].string.strip()[3:],
            'time': get_release_time(soup.select('.releasetime')[item].string.strip()[5:]),
            'area': get_release_area(soup.select('.releasetime')[item].string.strip()[5:]),
            'score': soup.select('.integer')[item].string + soup.select('.fraction')[item].string

        }

```
运行上述程序，结果同第1种方法一样。


#### 3.3.4. Beautiful Soup + find_all函数提取 ####
Beautifulsoup除了和css选择器搭配，还可以直接用它自带的find_all函数进行提取。
**find_all**，顾名思义，就是查询所有符合条件的元素，可以给它传入一些属性或文本来得到符合条件的元素，功能十分强大。
它的API如下：

```
find_all(name , attrs , recursive , text , **kwargs)
```

> **常用的语法规则如下：**  
> soup.find_all(name='ul')： 查找所有**ul**节点，ul节点内还可以嵌套；  
> li.string和li.get_text()：都是获取**li**节点的文本，但推荐使用后者；
> soup.find_all(attrs={'id': 'list-1'}))：传入 attrs 参数，参数的类型是字典类型，表示查询 **id** 为 **list-1** 的节点；
> 常用的属性比如 id、class 等，可以省略attrs采用更简洁的形式，例如：
> soup.find_all(id='list-1')  
> soup.find_all(class_='element')

根据上述常用语法，可以提取网页中所需内容：

```python
def parse_one_page4(html):
    soup = BeautifulSoup(html,'lxml')
    items = range(10)
    for item in items:
        yield{

            'index': soup.find_all(class_='board-index')[item].string,
            'thumb': soup.find_all(class_ = 'board-img')[item].attrs['data-src'],
            # 用.get('data-src')获取图片src链接，或者用attrs['data-src']
            'name': soup.find_all(name = 'p',attrs = {'class' : 'name'})[item].string,
            'star': soup.find_all(name = 'p',attrs = {'class':'star'})[item].string.strip()[3:],
            'time': get_release_time(soup.find_all(class_ ='releasetime')[item].string.strip()[5:]),
            'area': get_release_time(soup.find_all(class_ ='releasetime')[item].string.strip()[5:]),
            'score':soup.find_all(name = 'i',attrs = {'class':'integer'})[item].string.strip() + soup.find_all(name = 'i',attrs = {'class':'fraction'})[item].string.strip()

        }

```
以上就是4种不同的内容提取方法。


### 3.4. 数据存储 ###
上述输出的结果为字典格式，可利用csv包的DictWriter函数将字典格式数据存储到csv文件中。

```python
# 数据存储到csv
def write_to_file3(item):
    with open('猫眼top100.csv', 'a', encoding='utf_8_sig',newline='') as f:
        # 'a'为追加模式（添加）
        # utf_8_sig格式导出csv不乱码 
        fieldnames = ['index', 'thumb', 'name', 'star', 'time', 'area', 'score']
        w = csv.DictWriter(f,fieldnames = fieldnames)
        # w.writeheader()
        w.writerow(item)
```
然后修改一下main()方法：
```python  
def main():
    url = 'http://maoyan.com/board/4?offset=0'
    html = get_one_page(url)
    
    for item in parse_one_page(html):  
        # print(item)
        write_to_csv(item)


if __name__ == '__main__':
    main()
 
```

结果如下图：
![](http://media.makcyun.top/18-8-20/66910595.jpg)

再将封面的图片下载下来：

```python
def download_thumb(name, url,num):
    try:
        response = requests.get(url)
        with open('封面图/' + name + '.jpg', 'wb') as f:
            f.write(response.content)
            print('第%s部电影封面下载完毕' %num)
            print('------')
    except RequestException as e:
        print(e)
        pass
     # 不能是w，否则会报错，因为图片是二进制数据所以要用wb
```


### 3.5. 分页爬取 ###
上面完成了一页电影数据的提取，接下来还需提取剩下9页共90部电影的数据。对网址进行遍历，给网址传入一个offset参数即可，修改如下：

```python  
def main(offset):
    url = 'http://maoyan.com/board/4?offset=' + str(offset)
    html = get_one_page(url)
    
    for item in parse_one_page(html):  
        # print(item)
        write_to_csv(item)


if __name__ == '__main__':
    for i in range(10):
        main(offset = i*10)
 
```
这样就完成了所有电影的爬取。结果如下：

![](http://media.makcyun.top/18-8-19/28479553.jpg)

![](http://media.makcyun.top/18-8-19/34117279.jpg)



## 4. 可视化分析 ##
俗话说“文不如表，表不如图”。下面根据excel的数据结果，进行简单的数据可视化分析，并用图表呈现。


### 4.1. 电影评分最高top10 ###
首先，想看一看评分最高的前10部电影是哪些？

程序如下：
```python
import pandas as pd
import matplotlib.pyplot as plt
import pylab as pl  #用于修改x轴坐标

plt.style.use('ggplot')   #默认绘图风格很难看，替换为好看的ggplot风格
fig = plt.figure(figsize=(8,5))   #设置图片大小
colors1 = '#6D6D6D'  #设置图表title、text标注的颜色

columns = ['index', 'thumb', 'name', 'star', 'time', 'area', 'score']  #设置表头
df = pd.read_csv('maoyan_top100.csv',encoding = "utf-8",header = None,names =columns,index_col = 'index')  #打开表格
# index_col = 'index' 将索引设为index

df_score = df.sort_values('score',ascending = False)  #按得分降序排列

name1 = df_score.name[:10]      #x轴坐标
score1 = df_score.score[:10]    #y轴坐标  
plt.bar(range(10),score1,tick_label = name1)  #绘制条形图，用range()能搞保持x轴正确顺序
plt.ylim ((9,9.8))  #设置纵坐标轴范围
plt.title('电影评分最高top10',color = colors1) #标题
plt.xlabel('电影名称')      #x轴标题
plt.ylabel('评分')          #y轴标题

# 为每个条形图添加数值标签
for x,y in enumerate(list(score1)):
    plt.text(x,y+0.01,'%s' %round(y,1),ha = 'center',color = colors1)

pl.xticks(rotation=270)   #x轴名称太长发生重叠，旋转为纵向显示
plt.tight_layout()    #自动控制空白边缘，以全部显示x轴名称
# plt.savefig('电影评分最高top10.png')   #保存图片
plt.show()
```

结果如下图：
![](http://media.makcyun.top/18-8-20/80083042.jpg)
可以看到：排名最高的分别是两部国产片"霸王别姬"和"大话西游"，其他还包括"肖申克的救赎"、"教父"等。
嗯，还好基本上都看过。

### 4.2. 各国家的电影数量比较 ###
然后，想看看100部电影都是来自哪些国家？
程序如下：
```python
area_count = df.groupby(by = 'area').area.count().sort_values(ascending = False)

# 绘图方法1
area_count.plot.bar(color = '#4652B1')  #设置为蓝紫色
pl.xticks(rotation=0)   #x轴名称太长重叠，旋转为纵向


# 绘图方法2
# plt.bar(range(11),area_count.values,tick_label = area_count.index)

for x,y in enumerate(list(area_count.values)):
    plt.text(x,y+0.5,'%s' %round(y,1),ha = 'center',color = colors1)
plt.title('各国/地区电影数量排名',color = colors1)
plt.xlabel('国家/地区')
plt.ylabel('数量(部)')
plt.show()
# plt.savefig('各国(地区)电影数量排名.png')
```
结果如下图：
![](http://media.makcyun.top/18-8-21/57684234.jpg)
可以看到，除去网站自身没有显示国家的电影以外，上榜电影被10个国家/地区"承包"了。其中，美国以30部电影的绝对优势占据第1名，其次是8部的日本，韩国第3，居然有7部上榜。
不得不说的是香港有5部，而内地一部都没有。。。


### 4.3. 电影作品数量集中的年份 ###
接下来站在漫长的百年电影史的时间角度上，分析一下哪些年份"贡献了"最多的电影数量，也可以说是"电影大年"。
```python
# 从日期中提取年份
df['year'] = df['time'].map(lambda x:x.split('/')[0])
# print(df.info())
# print(df.head())

# 统计各年上映的电影数量
grouped_year = df.groupby('year')
grouped_year_amount = grouped_year.year.count()
top_year = grouped_year_amount.sort_values(ascending = False)


# 绘图
top_year.plot(kind = 'bar',color = 'orangered') #颜色设置为橙红色
for x,y in enumerate(list(top_year.values)):
    plt.text(x,y+0.1,'%s' %round(y,1),ha = 'center',color = colors1)
plt.title('电影数量年份排名',color = colors1)
plt.xlabel('年份(年)')
plt.ylabel('数量(部)')

plt.tight_layout()
# plt.savefig('电影数量年份排名.png')

plt.show()
```
结果如下图：
![](http://media.makcyun.top/18-8-20/32342735.jpg)

可以看到，100部电影来自37个年份。其中2011年上榜电影数量最多，达到9部；其次是前一年的7部。回忆一下，那会儿正是上大学的头两年，可怎么感觉除了阿凡达之外，没有什么其他有印象的电影了。。。
另外，网上传的号称"电影史奇迹年"的1994年仅排名第6。这让我进一步对猫眼榜单的权威性产生了质疑。
再往后看，发现遥远的1939和1940年也有电影上榜。那会儿应该还是黑白电影时代吧，看来电影的口碑好坏跟外在的技术没有绝对的关系，质量才是王道。

### 4.4 拥有电影作品数量最多的演员 ###
最后，看看前100部电影中哪些演员的作品数量最多。
程序如下：
```python
#表中的演员位于同一列，用逗号分割符隔开。需进行分割然后全部提取到list中
starlist = []
star_total = df.star
for i in df.star.str.replace(' ','').str.split(','):
    starlist.extend(i)  
# print(starlist)
# print(len(starlist))

# set去除重复的演员名
starall = set(starlist)
# print(starall)
# print(len(starall))

starall2 = {}
for i in starall:
    if starlist.count(i)>1:
        # 筛选出电影数量超过1部的演员
        starall2[i] = starlist.count(i)

starall2 = sorted(starall2.items(),key = lambda starlist:starlist[1] ,reverse = True)

starall2 = dict(starall2[:10])  #将元组转为字典格式

# 绘图
x_star = list(starall2.keys())      #x轴坐标
y_star = list(starall2.values())    #y轴坐标

plt.bar(range(10),y_star,tick_label = x_star)
pl.xticks(rotation = 270)
for x,y in enumerate(y_star):
    plt.text(x,y+0.1,'%s' %round(y,1),ha = 'center',color = colors1)

plt.title('演员电影作品数量排名',color = colors1)
plt.xlabel('演员')
plt.ylabel('数量(部)')
plt.tight_layout()
plt.show()    
# plt.savefig('演员电影作品数量排名.png')
```
结果如下图：
![](http://media.makcyun.top/18-8-20/66062822.jpg)

张国荣排在了第一位，这是之前没有猜到的。其次是梁朝伟和星爷，再之后是布拉德·皮特。惊奇地发现，前十名影星中，香港影星居然占了6位。有点严重怀疑这是不是香港版的top100电影。。。

对张国荣以7部影片的巨大优势雄霸榜单第一位感到好奇，想看看是哪7部电影。
```python
df['star1'] = df['star'].map(lambda x:x.split(',')[0])  #提取1号演员
df['star2'] = df['star'].map(lambda x:x.split(',')[1])  #提取2号演员
star_most = df[(df.star1 == '张国荣') | (df.star2 == '张国荣')][['star','name']].reset_index('index')
# |表示两个条件或查询，之后重置索引
print(star_most)
```
可以看到包括排名第1的"霸王别姬"、第17名的"春光乍泄"、第27名的"射雕英雄传之东成西就"等。
突然发现，好像只看过"英雄本色"。。。有时间，去看看他其他的作品。

```
     index        star              name
0      1   张国荣,张丰毅,巩俐        霸王别姬
1     17   张国荣,梁朝伟,张震        春光乍泄
2     27  张国荣,梁朝伟,张学友  射雕英雄传之东成西就
3     37  张国荣,梁朝伟,刘嘉玲        东邪西毒
4     70   张国荣,王祖贤,午马        倩女幽魂
5     99  张国荣,张曼玉,刘德华        阿飞正传
6    100   狄龙,张国荣,周润发        英雄本色
```
由于数据量有限，故仅作了上述简要的分析。

## 5. 完整程序 ##
最后，将前面爬虫的所有代码整理一下，完整的代码如下：   
一、爬虫部分
```python
import urllib
import requests
from requests.exceptions import RequestException
import re
from bs4 import BeautifulSoup
import json
import time
from lxml import etree

# -----------------------------------------------------------------------------

def get_one_page(url):
    try:
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36'}
        # 不加headers爬不了
        response = requests.get(url, headers=headers)
        if response.status_code == 200:
            return response.text
        else:
            return None
    except RequestException:
        return None


# 1 用正则提取内容
def parse_one_page(html):
    pattern = re.compile(
        '<dd>.*?board-index.*?>(\d+)</i>.*?data-src="(.*?)".*?name"><a.*?>(.*?)</a>.*?star">(.*?)</p>.*?releasetime">(.*?)</p.*?integer">(.*?)</i>.*?fraction">(.*?)</i>.*?</dd>', re.S)
    # re.S表示匹配任意字符，如果不加.无法匹配换行符
    items = re.findall(pattern, html)
    # print(items)
    for item in items:
        yield {
            'index': item[0],
            'thumb': get_thumb(item[1]),
            'name': item[2],
            'star': item[3].strip()[3:],
            # 'time': item[4].strip()[5:],
            # 用函数分别提取time里的日期和地区
            'time': get_release_time(item[4].strip()[5:]),
            'area': get_release_area(item[4].strip()[5:]),
            'score': item[5].strip() + item[6].strip()
        }
      
# 2 用lxml结合xpath提取内容
def parse_one_page2(html):
    parse = etree.HTML(html)
    items = parse.xpath('//*[@id="app"]//div//dd')
    # 完整的是//*[@id="app"]/div/div/div[1]/dl/dd
    # print(type(items))
    # *代表匹配所有节点，@表示属性
    # 第一个电影是dd[1],要提取页面所有电影则去掉[1]
    # xpath://*[@id="app"]/div/div/div[1]/dl/dd[1]
    # lst = []
    for item in items:
        yield{
            'index': item.xpath('./i/text()')[0],
            #./i/text()前面的点表示从items节点开始
            #/text()提取文本
            'thumb': get_thumb(str(item.xpath('./a/img[2]/@data-src')[0].strip())),
            # 'thumb': 要在network中定位，在elements里会写成@src而不是@data-src，从而会报list index out of range错误。
            'name': item.xpath('./a/@title')[0],
            'star': item.xpath('.//p[@class = "star"]/text()')[0].strip(),
            'time': get_release_time(item.xpath(
                './/p[@class = "releasetime"]/text()')[0].strip()[5:]),
            'area': get_release_area(item.xpath(
                './/p[@class = "releasetime"]/text()')[0].strip()[5:]),
            'score' : item.xpath('.//p[@class = "score"]/i[1]/text()')[0] + \
            item.xpath('.//p[@class = "score"]/i[2]/text()')[0]
        }

 
# 3 用beautifulsoup + css选择器提取
def parse_one_page3(html):
    soup = BeautifulSoup(html, 'lxml')
    # print(content)
    # print(type(content))
    # print('------------')
    items = range(10)
    for item in items:
        yield{

            'index': soup.select('dd i.board-index')[item].string,
            # iclass节点完整地为'board-index board-index-1',写board-inde即可
            'thumb': get_thumb(soup.select('a > img.board-img')[item]["data-src"]),
            # 表示a节点下面的class = board-img的img节点,注意浏览器eelement里面是src节点，而network里面是data-src节点，要用这个才能正确返回值

            'name': soup.select('.name a')[item].string,
            'star': soup.select('.star')[item].string.strip()[3:],
            'time': get_release_time(soup.select('.releasetime')[item].string.strip()[5:]),
            'area': get_release_area(soup.select('.releasetime')[item].string.strip()[5:]),
            'score': soup.select('.integer')[item].string + soup.select('.fraction')[item].string
        }


# 4 用beautifulsoup + find_all提取
def parse_one_page4(html):
    soup = BeautifulSoup(html,'lxml')
    items = range(10)
    for item in items:
        yield{

            'index': soup.find_all(class_='board-index')[item].string,
            'thumb': soup.find_all(class_ = 'board-img')[item].attrs['data-src'],
            # 用.get('data-src')获取图片src链接，或者用attrs['data-src']
            'name': soup.find_all(name = 'p',attrs = {'class' : 'name'})[item].string,
            'star': soup.find_all(name = 'p',attrs = {'class':'star'})[item].string.strip()[3:],
            'time': get_release_time(soup.find_all(class_ ='releasetime')[item].string.strip()[5:]),
            'area': get_release_time(soup.find_all(class_ ='releasetime')[item].string.strip()[5:]),
            'score':soup.find_all(name = 'i',attrs = {'class':'integer'})[item].string.strip() + soup.find_all(name = 'i',attrs = {'class':'fraction'})[item].string.strip()
        }

# -----------------------------------------------------------------------------

# 提取时间函数
def get_release_time(data):
    pattern = re.compile(r'(.*?)(\(|$)')
    items = re.search(pattern, data)
    if items is None:
        return '未知'
    return items.group(1)  # 返回匹配到的第一个括号(.*?)中结果即时间


# 提取国家/地区函数
def get_release_area(data):
    pattern = re.compile(r'.*\((.*)\)')
    # $表示匹配一行字符串的结尾，这里就是(.*?)；\(|$,表示匹配字符串含有(,或者只有(.*?)
    items = re.search(pattern, data)
    if items is None:
        return '未知'
    return items.group(1)


# 获取封面大图
# http://p0.meituan.net/movie/5420be40e3b755ffe04779b9b199e935256906.jpg@160w_220h_1e_1c
# 去掉@160w_220h_1e_1c就是大图
def get_thumb(url):
    pattern = re.compile(r'(.*?)@.*?')
    thumb = re.search(pattern, url)
    return thumb.group(1)


# 数据存储到csv
def write_to_file3(item):
    with open('猫眼top100.csv', 'a', encoding='utf_8_sig',newline='') as f:
        # 'a'为追加模式（添加）
        # utf_8_sig格式导出csv不乱码 
        fieldnames = ['index', 'thumb', 'name', 'star', 'time', 'area', 'score']
        w = csv.DictWriter(f,fieldnames = fieldnames)
        # w.writeheader()
        w.writerow(item)

# 封面下载
def download_thumb(name, url,num):
    try:
        response = requests.get(url)
        with open('封面图/' + name + '.jpg', 'wb') as f:
            f.write(response.content)
            print('第%s部电影封面下载完毕' %num)
            print('------')
    except RequestException as e:
        print(e)
        pass
     # 存储格式是wb,因为图片是二进制数格式，不能用w，否则会报错

# -----------------------------------------------------------------------------

def main(offset):
    url = 'http://maoyan.com/board/4?offset=' + str(offset)
    html = get_one_page(url)
    # print(html)
    # parse_one_page2(html)

    for item in parse_one_page(html):  # 切换内容提取方法
        print(item)
        write_to_file(item)

        # 下载封面图
        download_thumb(item['name'], item['thumb'],item['index'])


# if __name__ == '__main__':
#     for i in range(10):
#         main(i * 10)
        # time.sleep(0.5)
        # 猫眼增加了反爬虫，设置0.5s的延迟时间

# 2 使用多进程提升抓取效率
from multiprocessing import Pool
if __name__ == '__main__':
    pool = Pool()
    pool.map(main, [i * 10 for i in range(10)])

```

二、可视化部分  
```python
#-*- coding: utf-8 -*-
# 可视化分析
# -------------------------------
import pandas as pd
import matplotlib.pyplot as plt
import pylab as pl  # 用于修改x轴坐标

plt.style.use('ggplot')  # 默认绘图风格很难看，替换为好看的ggplot风格
fig = plt.figure(figsize=(8, 5))  # 设置图片大小
colors1 = '#6D6D6D'  # 设置图表title、text标注的颜色
columns = ['index', 'thumb', 'name', 'star', 'time', 'area', 'score']  # 设置表头
df = pd.read_csv('maoyan_top100.csv', encoding="utf-8",
                 header=None, names=columns, index_col='index')  # 打开表格
# index_col = 'index' 将索引设为index

# 1电影评分最高top10
def annalysis_1():
    df_score = df.sort_values('score', ascending=False)  # 按得分降序排列

    name1 = df_score.name[:10]  # x轴坐标
    score1 = df_score.score[:10]  # y轴坐标
    plt.bar(range(10), score1, tick_label=name1)  # 绘制条形图，用range()能搞保持x轴正确顺序
    plt.ylim((9, 9.8))  # 设置纵坐标轴范围
    plt.title('电影评分最高top10', color=colors1)  # 标题
    plt.xlabel('电影名称')  # x轴标题
    plt.ylabel('评分')  # y轴标题

    # 为每个条形图添加数值标签
    for x, y in enumerate(list(score1)):
        plt.text(x, y + 0.01, '%s' % round(y, 1), ha='center', color=colors1)

    pl.xticks(rotation=270)  # x轴名称太长发生重叠，旋转为纵向显示
    plt.tight_layout()  # 自动控制空白边缘，以全部显示x轴名称
    # plt.savefig('电影评分最高top10.png')   #保存图片
    plt.show()


# ------------------------------
# 2各国家的电影数量比较
def annalysis_2():
    area_count = df.groupby(
        by='area').area.count().sort_values(ascending=False)

    # 绘图方法1
    area_count.plot.bar(color='#4652B1')  # 设置为蓝紫色
    pl.xticks(rotation=0)  # x轴名称太长重叠，旋转为纵向

    # 绘图方法2
    # plt.bar(range(11),area_count.values,tick_label = area_count.index,color
    # = '#4652B1')

    for x, y in enumerate(list(area_count.values)):
        plt.text(x, y + 0.5, '%s' % round(y, 1), ha='center', color=colors1)
    plt.title('各国/地区电影数量排名', color=colors1)
    plt.xlabel('国家/地区')
    plt.ylabel('数量(部)')
    plt.show()
# plt.savefig('各国(地区)电影数量排名.png')


# ------------------------------
# 3电影作品数量集中的年份
# 从日期中提取年份
def annalysis_3():
    df['year'] = df['time'].map(lambda x: x.split('/')[0])
    # print(df.info())
    # print(df.head())

    # 统计各年上映的电影数量
    grouped_year = df.groupby('year')
    grouped_year_amount = grouped_year.year.count()
    top_year = grouped_year_amount.sort_values(ascending=False)

    # 绘图
    top_year.plot(kind='bar', color='orangered')  # 颜色设置为橙红色
    for x, y in enumerate(list(top_year.values)):
        plt.text(x, y + 0.1, '%s' % round(y, 1), ha='center', color=colors1)
    plt.title('电影数量年份排名', color=colors1)
    plt.xlabel('年份(年)')
    plt.ylabel('数量(部)')

    plt.tight_layout()
    # plt.savefig('电影数量年份排名.png')

    plt.show()

# ------------------------------
# 4拥有电影作品数量最多的演员
# 表中的演员位于同一列，用逗号分割符隔开。需进行分割然后全部提取到list中
def annalysis_4():
    starlist = []
    star_total = df.star
    for i in df.star.str.replace(' ', '').str.split(','):
        starlist.extend(i)
    # print(starlist)
    # print(len(starlist))

    # set去除重复的演员名
    starall = set(starlist)
    # print(starall)
    # print(len(starall))

    starall2 = {}
    for i in starall:
        if starlist.count(i) > 1:
            # 筛选出电影数量超过1部的演员
            starall2[i] = starlist.count(i)

    starall2 = sorted(starall2.items(),
                      key=lambda starlist: starlist[1], reverse=True)

    starall2 = dict(starall2[:10])  # 将元组转为字典格式

    # 绘图
    x_star = list(starall2.keys())  # x轴坐标
    y_star = list(starall2.values())  # y轴坐标

    plt.bar(range(10), y_star, tick_label=x_star)
    pl.xticks(rotation=270)
    for x, y in enumerate(y_star):
        plt.text(x, y + 0.1, '%s' % round(y, 1), ha='center', color=colors1)

    plt.title('演员电影作品数量排名', color=colors1)
    plt.xlabel('演员')
    plt.ylabel('数量(部)')
    plt.tight_layout()
    plt.show()
# plt.savefig('演员电影作品数量排名.png')


def main():
    annalysis_1()
    annalysis_2()
    annalysis_3()
    annalysis_4()

if __name__ == '__main__':
    main()

```