---
title: Python For 和 While 循环爬取不确定页数的网页
date: 2018-12-26 16:16:24
id: web_scraping_withpython16
categories: Python爬虫
tags: [Python爬虫]
images: http://media.makcyun.top/18-12-27/75472440.jpg
keywords: [python爬虫,for循环和while循环,python爬取多页网页]
---

Requests 和 Scrapy 中分别用 For 循环和 While 循环爬取不确定页数的网页。

<!-- more -->  

**摘要**：Requests 和 Scrapy 中分别用 For 循环和 While 循环爬取不确定页数的网页。

我们通常遇到的网站页数展现形式有这么几种：

第一种是直观地显示所有页数，比如此前爬过的酷安、东方财富网，
文章见：

[∞ Scrapy 爬取并分析酷安 6000 款 App，找到良心佳软](https://www.makcyun.top/web_scraping_withpython10.html)

[∞ 50 行代码爬取东方财富网百万行财务报表数据](https://www.makcyun.top/web_scraping_withpython6.html)

![](http://media.makcyun.top/18-12-26/49266613.jpg)

第二种是不直观显示网页总页数，需要在后台才可以查看到，比如之前爬过的虎嗅网，文章见：

[∞ pyspider 爬取并分析虎嗅网 5 万篇文章](https://www.makcyun.top/web_scraping_withpython9.html)

![](http://media.makcyun.top/18-12-26/4137026.jpg)

第三种是今天要说的，不知道具体有多少页的网页，比如豌豆荚：

![](http://media.makcyun.top/18-12-26/21074762.jpg)

对于，前两种形式的网页，爬取方法非常简单，使用 For 循环从首页爬到尾页就行了，第三种形式则不适用，因为不知道尾页的页数，所以循环到哪一页结束无法判断。

那如何解决呢？有两种方法。

第一种方式 **使用 For 循环配合 break 语句**，尾页的页数设置一个较大的参数，足够循环爬完所有页面，爬取完成时，break 跳出循环，结束爬取。

第二种方法 **使用 While 循环，可以结合 break 语句，也可以设起始循环判断条件为 True**，从头开始循环爬取直到爬完最后一页，然后更改判断条件为 False 跳出循环，结束爬取。

## 实际案例

下面，我们以 [豌豆荚](https://www.wandoujia.com/category/5029_716) 网站中「视频」类别下的 App 信息为例，使用上面两种方法抓取该分类下的所有 App 信息，包括 App 名称、评论、安装数量和体积。

首先，简要分析下网站，可以看到页面是通过 Ajax 加载的，GET 请求附带一些参数，可以使用 params 参数构造 URL 请求，但不知道一共有多少页，为了确保下载完所有页，设置较大的页数，比如 100页 甚至 1000 页都行。

下面我们尝试使用 For 和 While 循环爬取 。

![](http://media.makcyun.top/18-12-26/57399.jpg)

## Requests

### ▌For 循环

主要代码如下：

```python
class Get_page():
    def __init__(self):
        # ajax 请求url
        self.ajax_url = 'https://www.wandoujia.com/wdjweb/api/category/more'

    def get_page(self,page,cate_code,child_cate_code):
        params = {
            'catId': cate_code,
            'subCatId': child_cate_code,
            'page': page,
        }
        response = requests.get(self.ajax_url, headers=headers, params=params)
        content = response.json()['data']['content'] #提取json中的html页面数据
        return content

    def parse_page(self, content):
        # 解析网页内容
        contents = pq(content)('.card').items()
        data = []
        for content in contents:
            data1 = {
                'app_name': content('.name').text(),
                'install': content('.install-count').text(),
                'volume': content('.meta span:last-child').text(),
                'comment': content('.comment').text(),
            }
            data.append(data1)
        if data:
            # 写入MongoDB
            self.write_to_mongodb(data)
            
if __name__ == '__main__':
    # 实例化数据提取类
    wandou_page = Get_page()
    cate_code = 5029 # 影音播放大类别编号
    child_cate_code = 716 # 视频小类别编号
     for page in range(2, 100):
        print('*' * 50)
        print('正在爬取：第 %s 页' % page)
        content = wandou_page.get_page(page,cate_code,child_cate_code)
        # 添加循环判断，如果content 为空表示此页已经下载完成了,break 跳出循环
        if not content == '':
            wandou_page.parse_page(content)
            sleep = np.random.randint(3,6)
            time.sleep(sleep)
        else:
            print('该类别已下载完最后一页')
            break
```

这里，首先创建了一个 Get_page 类，get_page 方法用于获取 Response 返回的 json 数据，通过 [json.cn](https://www.json.cn/) 网站解析 json 解析后发现需要提取的内容是一段包裹在 data 字段下 content 键中的 html 文本，可以使用 parse_page 方法中的 pyquery 函数进行解析，最后提取出 App 名称、评论、安装数量和体积四项信息，完成抓取。

在主函数中，使用了 if 函数进行条件判断，若 content 不为空，表示该页有内容，则循环爬下去，若为空则表示此页面已完成了爬取，执行 else 分支下的 break 语句结束循环，完成爬取。

![](http://media.makcyun.top/18-12-27/15411909.jpg)

爬取结果如下，可以看到该分类下一共完成了全部 41 页的信息抓取。

![](http://media.makcyun.top/18-12-27/12704438.jpg)

### ▌While 循环

While 循环和 For 循环思路大致相同，不过有两种写法，一种仍然是结合 break 语句，一种则是更改判断条件。

总体代码不变，只需修改 For 循环部分：

```python
page = 2 # 设置爬取起始页数
while True:
    print('*' * 50)
    print('正在爬取：第 %s 页' %page)
    content = wandou_page.get_page(page,cate_code,child_cate_code)
    if not content == '':
        wandou_page.parse_page(content)
        page += 1
        sleep = np.random.randint(3,6)
        time.sleep(sleep)
    else:
        print('该类别已下载完最后一页')
        break
```

或者：

```python
page = 2 # 设置爬取起始页数
page_last = False # while 循环初始条件
while not page_last:
   #...
    else:
        # break
        page_last = True # 更改page_last 为 True 跳出循环
```

结果如下，可以看到和 For 循环的结果是一样的。

![](http://media.makcyun.top/18-12-27/38514291.jpg)

我们可以再测试一下其他类别下的网页，比如选择「K歌」类别，编码为：718，然后只需要对应修改主函数中的child_cate_code 即可，再次运行程序，可以看到该类别下一共爬取了 32 页。

![](http://media.makcyun.top/18-12-27/91221430.jpg)

由于 Scrapy 中的写法和 Requests 稍有不同，所以接下来，我们在 Scrapy 中再次实现两种循环的爬取方式 。

## Scrapy 

### ▌For 循环

Scrapy 中使用 For 循环递归爬取的思路非常简单，即先批量生成所有请求的 URL，包括最后无效的 URL，后续在 parse 方法中添加 if 判断过滤无效请求，然后爬取所有页面。**由于 Scrapy 依赖于Twisted框架，采用的是异步请求处理方式，也就是说 Scrapy 边发送请求边解析内容，所以这会发送很多无用请求。**

```python
def start_requests(self):
    pages=[]
    for i in range(1,10):
        url='http://www.example.com/?page=%s'%i
        page = scrapy.Request(url,callback==self.pare)
        pages.append(page)
    return pages
```

下面，我们选取豌豆荚「新闻阅读」分类下的「电子书」类 App 页面信息，使用 For 循环尝试爬取，主要代码如下：

```python
def start_requests(self):
    cate_code = 5019 # 新闻阅读
    child_cate_code = 940 # 电子书
    print('*' * 50)
    pages = []
    for page in range(2,50):
        print('正在爬取：第 %s 页 ' %page)
        params = {
        'catId': cate_code,
        'subCatId': child_cate_code,
        'page': page,
        }
        category_url = self.ajax_url + urlencode(params)
        pa = yield scrapy.Request(category_url,callback=self.parse)
        pages.append(pa)
    return pages

def parse(self, response):
    if len(response.body) >= 100:  # 判断该页是否爬完，数值定为100是因为response无内容时的长度是87
        jsonresponse = json.loads(response.body_as_unicode())
        contents = jsonresponse['data']['content']
        # response 是json,json内容是html，html 为文本不能直接使用.css 提取，要先转换
        contents = scrapy.Selector(text=contents, type="html")
        contents = contents.css('.card')
        for content in contents:
            item = WandoujiaItem()
            item['app_name'] = content.css('.name::text').extract_first()
            item['install'] = content.css('.install-count::text').extract_first()
            item['volume'] = content.css('.meta span:last-child::text').extract_first()
            item['comment'] = content.css('.comment::text').extract_first().strip()
            yield item
        
```

上面代码很好理解，简要说明几点：

第一、判断当前页是否爬取完成的判断条件改为了 response.body 的长度大于 100。

因为请求已爬取完成的页面，返回的 Response 结果是不为空的，而是有长度的 json 内容（长度为 87），其中 content 键值内容才为空，所以这里判断条件选择比 87 大的数值即可，比如 100，即大于 100 的表示此页有内容，小于 100 表示此页已爬取完成。

```python
{"state":{"code":2000000,"msg":"Ok","tips":""},"data":{"currPage":-1,"content":""}}
```

第二、**当需要从文本中解析内容时，不能直接解析，需要先转换。**

通常情况下，我们在解析内容时是直接对返回的 response 进行解析，比如使用 response.css() 方法，但此处，我们的解析对象不是 response，而是 response 返回的 json 内容中的 html 文本，文本是不能直接使用 .css() 方法解析的，所以在对 html 进行解析之前，需要添加下面一行代码转换后才能解析。

```python
 contents = scrapy.Selector(text=contents, type="html")
```

结果如下，可以看到发送了全部 48 个请求，实际上该分类只有 22 页内容，即多发送了无用的 26 个请求。

![](http://media.makcyun.top/18-12-27/96177340.jpg)

### ▌While 循环

接下来，我们使用 While 循环再次尝试抓取，代码省略了和 For 循环中相同的部分：

```python
def start_requests(self):
        page = 2 # 设置爬取起始页数
        dict = {'page':page,'cate_code':cate_code,'child_cate_code':child_cate_code} # meta传递参数
        yield scrapy.Request(category_url,callback=self.parse,meta=dict)

def parse(self, response):
    if len(response.body) >= 100:  # 判断该页是否爬完，数值定为100是因为无内容时长度是87
        page = response.meta['page']
        cate_code = response.meta['cate_code']
        child_cate_code = response.meta['child_cate_code']
	   #...
       for content in contents:
        	yield item
        
        # while循环构造url递归爬下一页
        page += 1
        params = {
                'catId': cate_code,
                'subCatId': child_cate_code,
                'page': page,
                }
        ajax_url = self.ajax_url + urlencode(params)
        dict = {'page':page,'cate_code':cate_code,'child_cate_code':child_cate_code}
        yield scrapy.Request(ajax_url,callback=self.parse,meta=dict)
```

这里，简要说明几点：

第一、While 循环的思路是先从头开始爬取，使用 parse() 方法进行解析，然后递增页数构造下一页的 URL 请求，再循环解析，直到爬取完最后一页即可，这样 **不会像 For 循环那样发送无用的请求**。

第二、parse() 方法构造下一页请求时需要利用 start_requests() 方法中的参数，可以 **使用 meta 方法来传递参数**。

运行结果如下，可以看到请求数量刚好是 22 个，也就完成了所有页面的 App 信息爬取。

![](http://media.makcyun.top/18-12-27/98316582.jpg)

以上，就是本文的所有内容，小结一下：

- 在爬取不确定页数的网页时，可以采取 For 循环和 While 循环两种思路，方法大致相同。
- 在 Requests 和 Scrapy 中使用 For 循环和 While 循环的方法稍有不同，因此本文以豌豆荚网站为例，详细介绍了循环构造方法。
- 之所以写本文内容和之前的几篇文章（设置随机 UA、代理 IP），**是为了下一篇文章「分析豌豆荚全网 70000+ App 信息」做铺垫，敬请期待。**

## 完整案例代码

如需本文完整的案例代码，可以扫描下方图片二维码加入我的知识星球：「**第2脑袋**」，里面有很多干货，期待你的到来。

![](http://media.makcyun.top/18-12-26/16445406.jpg)

本文完。

---

推荐阅读：

[∞ Python 爬虫的代理 IP 设置方法汇总](https://www.makcyun.top/web_scraping_withpython15.html)

[∞ Python爬虫的随机 User-Agent 设置方法汇总](https://www.makcyun.top/web_scraping_withpython14.html)

[∞ 爬虫断了？一招搞定 MongoDB 重复数据](https://www.makcyun.top/web_scraping_withpython13.html)

[∞ Scrapy 爬取并分析酷安 6000 款 App，找到良心佳软](https://www.makcyun.top/web_scraping_withpython10.html)

[∞ 50 行代码爬取东方财富网百万行财务报表数据](https://www.makcyun.top/web_scraping_withpython6.html)

[∞ pyspider 爬取并分析虎嗅网 5 万篇文章](https://www.makcyun.top/web_scraping_withpython9.html)