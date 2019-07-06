---
title: 从函数 def 到类 Class 
date: 2018-12-7 16:16:24
id: web_scraping_withpython11
categories: Python爬虫
tags: [Python爬虫]
images: http://media.makcyun.top/18-12-6/38016170.jpg
keywords: [python class,python爬虫]
---

实例对比，快速上手 Python 类（Class）和 Pyspider 代码的写法。

<!-- more -->  

**摘要：**初学 Python 过程中，我们可能习惯了使用函数（def），在开始学习类（Class）的用法时，可能会觉得它的写法别扭，类的代码写法也不像函数那么简单直接，也会产生「有了函数为什么还需要类」的疑问。然而面向对象编程是 Python 最重要的思想，类（Class）又是面向对象最重要的概念之一，所以要想精通 Python ，则必须得会使用类（Class）来编写代码，而且 Pyspider 和 Scrapy 两大框架都使用了类的写法，基于此，本文将介绍如何从函数的写法顺利过渡到类的编写习惯。

关于类（Class）的教程，网上主要有两类，一类是廖雪峰大佬的，另一类是不加说明默认你已经会这种写法，而直接使用的。

廖雪峰的教程非常棒，但是更适合入门 Python 有一段时间或者看过一些更基础的教程之后再回过头来看，否则可能会觉得他的教程理论性重于实用性。我第一次看了他的教程中关于类的相关知识后，觉得理解了，但一尝试自己写时就不太会了。

第二类教程，网上有很多案例，这类教程存在的问题就是，你能看懂意思，但还是不太会运用到自己的案例中。

总结一下这两类教程对新手不友好的地方就是 **没有同时给出两种写法的实例**，这就没办法对比，而「对比学习」是一种学习新知识非常快的途径，简单来说就是学新知识的时候，先从我们已经掌握的知识出发，和新知识进行对比，快速找到共同点和不同点，共同点我们能很快掌握，针对不同点通过对比去感悟领会，从而快速学会新知识。

接下来，就举几个同时使用了函数写法和类的写法的案例，希望能够帮助你快速完成从函数到类的编程思想的过渡转换。

### ▌爬取豆瓣电影 TOP250



第一个案例：爬取豆瓣电影 TOP250，我们的目标是通过调用豆瓣 API 接口，获取电影名称、评分、演员等信息，然后存储到 CSV 文件中，部分代码如下：

```python
def get_content(start_page):
    url = 'https://api.douban.com/v2/movie/top250?'
    params = {
        'start':start_page,
        'count':50
        }
    response = requests.get(url,params=params).json()
    movies = response['subjects']
    data = [{
        'rating':item['rating']['average'],
        'genres':item['genres'],
        'name':item['title'],
        'actor':get_actor(item['casts']),
        'original_title':item['original_title'],
        'year':item['year'],
    } for item in movies]
    write_to_file(data)

def get_actor(actors):
    actor = [i['name'] for i in actors]
    return actor

def write_to_file(data):
    with open('douban_def.csv','a',encoding='utf_8_sig',newline='') as f:
        w = csv.writer(f)
        for item in data:
            w.writerow(item.values())

def get_douban(total_movie):
    # 每页50条，start_page循环5次
    for start_page in range(0,total_movie,50):
        get_content(start_page)
if __name__ == '__main__':
    get_douban(250)
```

打开 CSV 文件查看输出的结果：

![](http://media.makcyun.top/18-12-6/61971916.jpg)

以上，我们通过四个函数就完成了数据的爬取和存储，逻辑很清晰，下面我们使用类的写法实现同样的功能，部分代码如下：

```python
class Douban(object):
    def __init__(self):
        self.url = 'https://api.douban.com/v2/movie/top250?'
    def get_content(self,start_page):
        params = {
            'start':start_page,
            'count':50
            }
        response = requests.get(self.url,params=params).json()
        movies = response['subjects']
        data = [{
            'rating':item['rating']['average'],
            'genres':item['genres'],
            'name':item['title'],
            'actor':self.get_actor(item['casts']),
            'original_title':item['original_title'],
            'year':item['year'],
        } for item in movies]
        self.write_to_file(data)
        
    def get_actor(self,actors):
        actor = [i['name'] for i in actors]
        return actor
    
    def write_to_file(self,data):
        with open('douban_class.csv','a',encoding='utf_8_sig',newline='') as f:
            w = csv.writer(f)
            for item in data:
                w.writerow(item.values())
    def get_douban(self,total_movie):
        # 每页50条，start_page循环5次
        for start_page in range(0,total_movie,50):
            self.get_content(start_page)

if __name__ == '__main__':
    douban = Douban()
    douban.get_douban(250)
```

可以看到，上面的案例中，类的写法和函数的写法大部分都是一样的，仅少数部分存在差异。主要有这么几点差异：

- 增加了一个 `__init__ `函数。

  这是一个特殊的函数，它的作用主要是事先把一些重要的属性填写进来，它的特点是第一个参数永远是`self`，表示创建的实例本身，这里的实例就是最下面的 `douban`（实例通过类名+() 创建）。

- 类中的函数和普通的函数相比，只有一点不同。

  类中的函数（也称为方法）的第一个参数永远是实例变量`self`，并且调用时，不用传递该参数。除此之外，类的方法和普通函数没有什么区别。

- 在执行类的时候需要先实例化

  这里我们定义了一个类，类名是 Douban（首字母要大写），在运行类的时候，需要先实例化，这里实例化为 `douban`，然后调用 get_douban（）方法完成数据的爬取和存储。

下面，我们再来看看第二个例子。

### ▌模拟登陆 IT 桔子

![](http://media.makcyun.top/18-12-6/12211046.jpg)

我们使用 Selenium 模拟登陆 IT 桔子网并输出网页源码，使用函数的部分代码如下：

```python
def login():
    browser = webdriver.Chrome()
    browser.get('https://www.itjuzi.com/user/login')
    account = browser.find_element(By.ID, "create_account_email")
    password = browser.find_element(By.ID, "create_account_password")
    account.send_keys('irw27812@awsoo.com') # 输入账号和密码
    password.send_keys('test2018') # 输入账号密码
    submit = browser.find_element(By.ID,"login_btn")
    submit.click() # 点击登录按钮
    get_content()

def get_content():
    browser.get('http://radar.itjuzi.com/investevent')
    print(browser.page_source)  # 输出网页源码

if __name__ == '__main__':
	login()
```

以上代码实现了自动输入账号密码然后进入 IT 桔子网，下面我们再来看看类的写法：

```python
class Spider(object):
    def __init__(self,account,password):
        self.login_url = 'https://www.itjuzi.com/user/login'
        self.get_url = 'http://radar.itjuzi.com/investevent'
        self.account = account
        self.password = password

    def login(self):
        browser.get(self.login_url)
        account = browser.find_element(By.ID, "create_account_email")
        password = browser.find_element(By.ID, "create_account_password")
        account.send_keys(self.account) # 输入账号和密码
        password.send_keys(self.password)
        submit = browser.find_element(By.ID,"login_btn")
        submit.click() # 点击登录按钮
        self.get_content()   # 调用下面的方法

    def get_content(self):
        browser.get(self.get_url)
        print(browser.page_source)  # 输出网页源码

if __name__ == '__main__':
    spider = Spider(account='irw27812@awsoo.com',password='test2018')
    # 当有其他账号时，在这里更改即可,很方便
    # spider = Spider('fru68354@nbzmr.com','test2018')
    spider.login()
```

这里，我们将一些固定的参数，比如 URL、Headers 都放在 `__init__` 方法中，需要的时候在各个函数中进行调用，这样的写法逻辑更加清晰。

下面，我们再看看第三个例子爬取虎嗅文章，从普通类的写法过渡到 pyspider 框架中类的写法，这样有助于快速上手 pyspider 框架。

### ▌爬取虎嗅文章

![](http://media.makcyun.top/18-12-6/73018539.jpg)

我们目标是通过分析 AJAX 请求，遍历爬取虎嗅网的文章信息，先来看看普通类的写法，部分代码如下：

```python
client = pymongo.MongoClient('localhost',27017)
db = client.Huxiu
mongo_collection = db.huxiu_news

class Huxiu(object):
    def __init__(self):
        self.headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36',
            'X-Requested-With': 'XMLHttpRequest'
            }
        self.url = 'https://www.huxiu.com/v2_action/article_list'

    def get_content(self,page):
        data = {
            'page': page,
            }
        response = requests.post(self.url,data=data,headers=self.headers)
        self.parse_content(response)

    def parse_content(self,response):
        content = response.json()['data']
        doc = pq(content)
        lis = doc('.mod-art').items()
        data =[{
        'title': item('.msubstr-row2').text(),
        'url':'https://www.huxiu.com'+ str(item('.msubstr-row2').attr('href')),
        'name': item('.author-name').text(),
        'write_time':item('.time').text(),
        'comment':item('.icon-cmt+ em').text(),
        'favorites':item('.icon-fvr+ em').text(),
        'abstract':item('.mob-sub').text()
        } for item in lis] 
        self.save_to_file(data)
    # 存储到 mongodb
    def save_to_file(self,data):
        df = pd.DataFrame(data)
        content = json.loads(df.T.to_json()).values()
        if mongo_collection.insert_many(content):
            print('存储到 mongondb 成功')
        else:
            print('存储失败')

    def get_huxiu(self,start_page,end_page):
        for page in range(start_page,end_page) :
            print('正在爬取第 %s 页' % page)
            self.get_content(page)

if __name__ == '__main__':
    huxiu = Huxiu()
    huxiu.get_huxiu(1,2000)
```

然后再看看在 Pyspider 中的写法：

```python
class Handler(BaseHandler):
    crawl_config:{
        "headers":{
            'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36',
            'X-Requested-With': 'XMLHttpRequest'
            }
    }
    
    # 修改taskid，避免只下载一个post请求
    def get_taskid(self,task):
        return md5string(task['url']+json.dumps(task['fetch'].get('data','')))
     
    def on_start(self):
        for page in range(1,2000):
            print('正在爬取第 %s 页' % page)
            self.crawl('https://www.huxiu.com/v2_action/article_list',method='POST',data={'page':page}, callback=self.index_page)
    
    def index_page(self, response):
        content = response.json['data']
        # 注意，在上面的class写法中，json后面需要添加()，pyspider中则不用
        doc = pq(content)
        lis = doc('.mod-art').items()
        data = [{
            'title': item('.msubstr-row2').text(),
            'url':'https://www.huxiu.com'+ str(item('.msubstr-row2').attr('href')),
            'name': item('.author-name').text(),
            'write_time':item('.time').text(),
            'comment':item('.icon-cmt+ em').text(),
            'favorites':item('.icon-fvr+ em').text(),
            'abstract':item('.mob-sub').text()
            } for item in lis ] 
        return data
 
    def on_result(self,result):
        if result:
            self.save_to_mongo(result)
  
    def save_to_mongo(self,result):
        df = pd.DataFrame(result)
        content = json.loads(df.T.to_json()).values()
        if mongo_collection.insert_many(content):
            print('存储到 mongondb 成功')
```

可以看到，pyspider 中主体部分和普通类的写法差不多，不同的地方在于 pyspider 中有一些固定的语法，这可以通过参考 pyspider 教程快速掌握。

通过以上三个例子的对比，我们可以感受到函数（def）、 类（Class）和 pyspider 三种代码写法的异同点，采取这样对比式的学习能够快速掌握新的知识。

如需完整代码，可以加入我的知识星球「**第2脑袋**」获取，里面有很多干货，期待你的到来。

![](http://media.makcyun.top/18-12-1/95375420.jpg)

本文完。

---


推荐阅读：

[Selenium 爬取 IT 桔子创业公司信息](https://www.makcyun.top/web_scraping_withpython7.html)

[pyspider 爬取并分析虎嗅网 5 万篇文章](https://www.makcyun.top/web_scraping_withpython9.html)