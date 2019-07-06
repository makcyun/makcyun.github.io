---

title: 4块钱,用Github+Hexo搭建你的个人博客：搭建篇
id: hexo01
images: http://media.makcyun.top/18-8-3/89578286.jpg
categories: hexo博客
tags: [hexo,个人博客,github]
keywords: hexo,搭建博客,github pages,next

---


<b>*4块钱,你就能够在茫茫互联网中拥有一处专属于你的小天地，丈量你走过的每一个脚印。*</b>  
之前，在网上看到过很多人拥有很酷的个人博客，很是羡慕，但感觉很难所以一直没敢去尝试。最近捣鼓了几天，发现搭建博客其实没有想象中的难。

<!-- more -->  


**【更新于2018/7/14】**


**摘要：** 对于一个不懂任何前端的纯小白来说，搭建博客是件很有挑战的事。好在参考了很多大佬的教程后顺利搭建完成，但过程中还是踩了一些坑。这里及时进行总结，作为博客的第一篇文章。

## 一、前言 ##


### 1 网上有很多现成的博客不用，为什么要自己搭建?
可能有人会说：很多网站都能写博客，而且博客现在其实都有点过时了，为什么还要自己去搞？  

这里我说一下我想自己搭建的两点原因：  
**一、**网上的多数博客大家都共用一套相同的模板界面，没有特点、界面也杂乱充斥着很多不相关的东西，不论是自己写还是给人看，体验都不好。  
**二、**拥有一个你自己可以起名字的博客网站，里面的任何内容完全由你自己决定，这感觉是件很酷的事。 

这些普通的网站博客和一些个人博客，哪个好看，高下立判吧。

![新浪博客](http://media.makcyun.top/18-7-14/94423333.jpg)  

<center>**vs**</center>   
![个人博客](http://media.makcyun.top/18-7-14/12736339.jpg)

&nbsp;
![CSDN博客](http://media.makcyun.top/18-7-14/26966.jpg)  

<center>**vs**</center> 
![个人博客](http://media.makcyun.top/18-7-14/73613801.jpg)

更多个人博客：  
**litten** &nbsp; [http://litten.me/](http://litten.me/)  
**Ryan** &nbsp; [http://ryane.top/](http://ryane.top/)  
**liyin** &nbsp; [https://liyin.date/](https://liyin.date/)  
**reuixiy** &nbsp; [https://reuixiy.github.io/](https://reuixiy.github.io/)  
**Tranquilpeak** &nbsp; [https://louisbarranqueiro.github.io/hexo-theme-tranquilpeak/](https://louisbarranqueiro.github.io/hexo-theme-tranquilpeak/)

<br>

### 2 搭建博客难不难？
我之前认为搭建博客是一件只有能程序猿才能做出来的高大上的活。其实，只要跟着网上的教程一步步做下去，一个小时不到就可以搭建好你自己的个人博客。所以，搭建博客其实很简单。只不过，如果你想把博客做得好看一些的话，才会花费一些精力。

<br>


## 二、开始搭建博客
**如果看到上面那些精美的博客，你已经心动了，那就开始动手吧。下面正式开始博客搭建步骤。**  

**搭建教程参考**  
搭建博客的教程网上一搜一大堆，为了节省你的搜索时间，这里我筛选出了下面几篇很棒的教程，我基本都是跟着一步步做下来的。


1. [小白独立搭建博客](https://my.oschina.net/ryaneLee/blog/638440)   
2. [2018，你该搭建自己的博客了！](http://ryane.top/2018/01/10/2018%EF%BC%8C%E4%BD%A0%E8%AF%A5%E6%90%AD%E5%BB%BA%E8%87%AA%E5%B7%B1%E7%9A%84%E5%8D%9A%E5%AE%A2%E4%BA%86%EF%BC%81/)
3. [手把手教你用Hexo+Github 搭建属于自己的博客](https://blog.csdn.net/gdutxiaoxu/article/details/53576018)

操作平台:Win7 64位。

<br />

**相关名词解释：**  
**Hexo：**一种常用的博客框架，有了它建立博客非常简单。你可以认为它是一种博客模板，只不过它比普通网站的那种博客模板要好看地多，并且有很高度的自定义性，只要你愿意，你可以建立一个独一无二的博客来。  
若想详细了解Hexo的使用，移步 **Hexo官方网站** [https://hexo.io/zh-cn/docs/](https://hexo.io/zh-cn/docs/)。  

**Github：**一个全世界程序猿聚集的知名网站。免费的远程仓库和开源协作社区。我们需要利用网站里的Github Pages功能来托管需发布到网上的博客的相关文件和代码。

**Git：** 一种版本控制系统。我们在自己的本地电脑写博客，如何把博客同步到Github，然后发布到网上去？就需要用这个软件去写几行代码然后就能搞定，后期用的最多的就是它。

**Node.js：** 提供JavaScript的开发环境，安装好以后就不用跟它再打交道，所以不用太关注它。


### 1 软件安装配置
搭建博客需要先下载2个软件：Git和Nodejs。
软件安装过程很简单，一直点击Next默认直到安装完成就行了。

**Git**   
官网：[https://git-scm.com/download/win](https://git-scm.com/download/win)  
安装完，打开cmd窗口运行下面命令，如果有返回版本信息说明安装成功。

    git –version 

**Nodejs**  
官网：[https://nodejs.org/en/download/](https://nodejs.org/en/download/)  
同样，安装完有返回版本信息说明安装成功，见下图。

    node -v  
    npm -v  

![cmd命令](http://media.makcyun.top/18-7-14/43008634.jpg)


至此，软件安装步骤完成。

### 2 安装Hexo博客框架
- 安装hexo  

这里开始就要用到使用频率最高的Git软件了。


桌面右键点击**git bash here**选项，会打开Git软件界面，输入下面每行命令并回车：  

```java
npm install hexo-cli -g
npm install hexo-deployer-git --save  
```

第一句是安装hexo，第二句是安装hexo部署到git page的deployer。代码命令看不懂没关系，一是这些命令之后几乎不再用到，二是用多了你会慢慢记住。
![](http://media.makcyun.top/18-7-14/18599032.jpg)  


- 设置博客存放文件夹  
  

你需要预想一下你要把博客文件新建在哪个盘下的文件夹里，除了c盘都可以，例如d盘根目录下的blog文件夹，紧接着在桌面输入下面命令并回车：  


    hexo init /d/blog
    cd /d/blog
    npm install
    *注：/d/bog可以更改为你自己的文件夹*


 	
有的教程是先新建博客文件夹，在该文件夹下右键鼠标，点击Git Bash Here，进入Git命令框，再执行以下操作。但是我操作过程中出现过这样的失败提示：`hexo:conmand not found`，但我执行上面的命令时就没有出现该问题。
​	
	hexo init 
	npm install


- 查看博客效果  

至此，博客初步搭建好，输入下面一行本地部署生成的命令：  

    hexo s -g 

然后打开浏览器在网址栏输入：`localhost:4000`就可以看到博客的样子，如果无法打开，则继续输入下面命令：    


    npm install hexo-deployer-git --save
    hexo clean
    hexo s -g 


![](http://media.makcyun.top/18-7-14/90405263.jpg)  

打开该网址，你可以看到第一篇默认的博客：**Hello World**。但看起来很难看，后续会通过重新选择模板来对博客进行美化。  

<div class = "note primary"><p>现在你就可以开始写博客了，但是博客只能在你自己的电脑上看到，别人无法在网上看到你的博客。接下来需要利用前面提到的的Github Pages功能进行设置，设置完成之后别人通过搜索就可以看到你的博客。</p></div>

### 3 把你的博客部署到Github Pages上去

这是搭建博客相对比较复杂也是容易出错的一部分。

**1. Github账号注册及配置**  

如果你没有github帐号，就新建一个，然后去邮箱进行验证；如果你有帐号则直接登录。  
官网：[https://github.com/](https://github.com/) 

配置步骤：  

- 建立new repository

只填写username.github.io即可，然后点击`create repositrory`。
注意：`username.github.io` 的`username`要和用户名保持一致，不然后面会失败。以我的为例：  

![1](http://media.makcyun.top/18-7-14/98355992.jpg)

![2](http://media.makcyun.top/18-7-14/62084844.jpg)


- 开启gh-pages功能  

点击github主页点击头像下面的profile,找到新建立的username.github.io文件打开，点击settings，往下拉动鼠标到GitHub Pages。  
如果你看到上方出现以下警告：  

<div class="note warning">
GitHub Pages is currently disabled. You must first add content to your repository before you can publish a GitHub Pages site  
</div>

不用管他，点击选择`choose a theme`，随便选择一个，（之后我们要更改这些丑陋的模板），然后select theme保存就行了。

![3](http://media.makcyun.top/18-7-14/79896859.jpg)


![5](http://media.makcyun.top/18-7-14/1269326.jpg) 



接下来的几个步骤参考[教程1](https://my.oschina.net/ryaneLee/blog/638440)即可。  


主要步骤包括：  

- git创建SSH密钥  
- 在GitHub账户中添加你的公钥  
- 测试成功并设置用户信息  
- 将本地的Hexo文件更新到Github库中  
- hexo部署更新博客  


经过以上几步的操作，顺利的话，你的博客可以发布到网上，其他人也可以通过你的网址`username.github.io`（我的是`makcyun.github.io`）
访问到你的博客。  


### 4 赶紧新建个博客试试
接下来你可以自己新建一个文档来写下你的第一篇博客并在网页上测试。

同样在根目录`D:\blog`中运行下面命令：  

	hexo new 第一篇博客
	*注：第一篇博客名称可以随便修改*

然后打开`D:\blog\source\_posts`文件夹，就可以看到一个`第一篇博客.md`的文件。用支持markdown语法的软件打开该文件进行编辑即可。

编辑好以后，运行下述命令：
​	
	hexo clean
	hexo d -g

然后，在网址中输入`username.github.io`即可看到你的博客上，出现**第一篇博客**这篇新的文章。

**至此，你的个人博客初步搭建过程就完成了。**

<br />

但是，现在还存在两个问题你可能想解决：

- markdown语法是什么，如何用软件编写博客？
- 网址是`username.github.io`，感觉很奇怪，而我的博客网址怎么是**www**开头的？


好，下面来讲解一下。

<br />

**第一个问题**

关于markdown语法介绍：  
[markdown——入门指南](https://www.jianshu.com/p/1e402922ee32/)

当你大致了解markdown语法后，如何用markdown写博客呢？不妨参考这两篇详细教程：  

>[Markdown語法說明](https://markdown.tw/)  
[HEXO下的Markdown语法(GFM)写博客](https://www.ofind.cn/archives/)


接下来你要一个可以写markdown语法的软件，这里推荐两款软件。  

Windows下使用[Markdown Pad2](http://markdownpad.com/), Mac下使用[Mou](http://25.io/mou/)。 

我用的是Markdown Pad2，这款软件是付费软件，但网上有很多破解版，我这里将软件上传到了百度网盘，如需请取。  
MarkdownPad2： [https://pan.baidu.com/s/1NHA-E83pxKfm2he0WJxXPA](https://pan.baidu.com/s/1NHA-E83pxKfm2he0WJxXPA)   密码：y9zh

安装好后，就可以打开刚才的`第一篇博客.md`，开始尝试写你的第一篇博客了。  

比如这是我用markdownpad写的博客原稿。  
![](http://media.makcyun.top/FpU5NFP6QFdTwqjStlUrBNk2GPDK)

可以看到文档里面都是字符，没有图片这些。所以只需要用键盘专注于打字就行了，不需要像word那么复杂，还要用鼠标插入标题样式、图片这些操作。

<br />

**第二个问题**

我的网址不是默认的`username.github.io`，是因为我购买了一个域名，然后和`username.github.io`进行了关联，这样我的博客网址变成了我的域名。

在哪里购买域名呢？  
首推去 [阿里云官网](https://wanwang.aliyun.com/domain/?spm=5176.383338.1907008.1.LWIFhw) 购买。

你可以随意起你喜欢的名字，然后在该网站进行搜索，没有人占用的话你就可以购买该域名。不同的后缀价格不同。可以看到**.com**、 **.net**等会比较贵，最便宜的这两年新出的**.top域名**，只要4块钱一年，我购买的就是这种。

购买完域名以后，需要做以下几个步骤：  

- 实名认证
- 修改DNS
- 域名解析
- 新建CNAME文件


**1 实名认证**
在修改DNS之前，必须要阿里云官网实名认证成功，用淘宝账户登录然后填写相关信息即可。


**2 修改DNS**  
实名认证成功后，进入管理界面，依次点击： 
![](http://media.makcyun.top/Ft9CnDVTNm1WFZMegkca8SaOokfW)

![](http://media.makcyun.top/FtOks38CUKdJga4Q-rlSXjcdezPs)


修改DNS为：  
**f1g1ns1.dnspod.net  
f1g1ns2.dnspod.net**


**3 域名解析**
DNS修改好以后，到**DNSPOD**这个网站去解析你的域名。  

首先，微信登录并注册 [https://www.dnspod.cn/](https://www.dnspod.cn/)，点击域名解析，添加上你的域名。  
![](http://media.makcyun.top/FuS2HLF9F9v9wvYiloqF8kpWMh8V)

接着，添加以下两条记录即可。

![](http://media.makcyun.top/FojJP59gDAOuk41RMtCvEkuKijo2)


注意：**makcyun.github.io.**需换成你自己的名称，另外最后有一个**"."**

**4 新建CNAME文件**
在博客根目录文件夹下,例如我的`D:\blog\source`，新建名为**CNAME**的记事本文件，去掉后缀。
在里面输入你的域名，例如我的：**www.makcyun.top**即可，保存并关闭。

![](http://media.makcyun.top/FmmCR8YMx-heNEiN9RFb4MkEbFA0)

**注意： **  
这里填不填写**www**前缀都是可以的，区别在于填写www，那么博客网址就会以www开头，例如：**www.makcyun.top**；如果不填写，博客网址是：**makcyun.top**，二者都可以，看你喜欢。

完成以上4步之后，根目录下再次运行：  

	hexo d -g  

这时，输入你在记事本里的域名网址，即可打开你的博客。  
至此，你的博客就换成了你想要的网址，别人也可以通过这个网址访问到你的博客。 

<br />

到这里，博客的初步搭建就算完成了，顺利的话不到1小时就能完成，如果中间出现差错，保持耐心多试几次应该就没问题。  

此时，还有一个比较重要的问题就是，你可能会觉得你的博客不够美观，不如我博客里前面提到的那几个博客，甚至也没有我的好看。  

如果你还愿意折腾的话，下一篇文章，我会以我的博客为例，讲一讲如何进行博客的美化。




<hr />





