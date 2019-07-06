---
title: '4块钱,用Github+Hexo搭建你的个人博客：美化篇'
images: http://media.makcyun.top/18-8-16/81811452.jpg
date: 2018-07-17 18:17:10
id: hexo02
categories: hexo博客
tags: [hexo,个人博客,github]
keywords: hexo,搭建博客,github pages,next

---

上一篇文章，介绍了如何搭建个人博客。这一篇文章则以我的博客为例详细介绍博客的美化步骤。


<!-- more -->


**摘要：**搭建博客相对简单，而美化博客则要复杂一些，因为涉及到修改和增删源代码，对于没有前端基础的人来说，会比较费时间精力。为了尽可能在最短的时间里，打造一个总体看得过去的博客，本文以我的博客为例，介绍一些比较实用的博客美化操作和技巧。


## 1. 选择新的模板 ##

首先，是要更换非常难看的初始的博客界面。重新挑选一个好看的主题模板，然后在此基础上进行美化。
![](http://media.makcyun.top/18-7-14/90405263.jpg)

主题寻找：    
[https://github.com/search?o=desc&q=topic%3Ahexo-theme&s=stars&type=Repositories](https://github.com/search?o=desc&q=topic%3Ahexo-theme&s=stars&type=Repositories)

该网站按照模板的受欢迎程度进行排名，可以看到遥遥领先的第一名是一款叫作：**next**的主题，选用这款即可。进入到这个主题，可以阅读**README.md**模板使用说明，还可以查看模板示例网站。

![](http://media.makcyun.top/FsgZW6JnrTdKpylVLyEORZbKJr9f)

模板使用：  
打开博客根目录下的**themes文件夹**(注：后文所说的根目录指：`D:\blog`)，右键**Git Bash**运行下述命令：
`git clone https://github.com/iissnan/hexo-theme-next themes/next`
就可以把这款主题的安装文件下载到电脑中。接着，打开D:\blog\_config.yml文件，找到 theme字段，修改参数为：theme: hexo-theme-next，然后根目录运行下述命令：   
```js
hexo clean
hexo s -g  
```


这样，便成功应用新的**next**主题，浏览器访问 :[http://localhost:4000](http://localhost:4000)，查看一下新的博客页面。
![](http://media.makcyun.top/FpHLTzWWl-JiakApNlw4nTH4hiin)
可以看到，博客变得非常清爽了，（可能和你实际看到的，略有不同，没有关系）。
这款主题包含4种风格，默认的是**Muse**，也可以尝试其他风格。具体操作：
打开`D:\blog\_config.yml`，定位到Schemes，想要哪款主题就取消前面的**#**，我的博客使用的是**Pisces**风格。
```js  
# Schemes
#scheme: Muse
#scheme: Mist
scheme: Pisces
#scheme: Gemini
```
![](http://media.makcyun.top/18-8-22/78786445.jpg)

## 2. 模板美化 ##
接下来进行模板的美化。  
根据网页的结构布局，将从以下几个部分进行针对性地美化：
- 总体
- 侧边栏
- 页脚
- 文章


**重要的文件**  
美化需要主要是对几个模板文件进行修改和增删。为了便于后续进行操作，先列出文件名和所在的位置： 
- 站点文件。位于站点文件夹根目录内：  
  **D:/blog/_config.yml**
- 主题文件。位于主题文件夹根目录内：
  **D:/blog/themes/next/_config.yml**
- 自定义样式文件。位于主题文件夹内：  
  **D:\blog\themes\hexo-theme-next\source\css\_custom\custom.styl**

### 2.1. 总体布置 ###
![](http://media.makcyun.top/18-8-22/38494028.jpg)
#### 2.1.1. 设置中文界面 ####
**站点文件:** language: zh-Hans
如果中文乱码，记事本另存为utf-8，最好不要用记事本编辑，用notepad。

#### 2.1.2. 动态背景 ####
**主题文件：** canvas_nest: true
背景的几何线条是采用的nest效果，一个基于html5 canvas绘制的网页背景效果，非常赞！来自github的开源项目canvas-nest：[https://github.com/hustcc/canvas-nest.js/blob/master/README-zh.md](https://github.com/hustcc/canvas-nest.js/blob/master/README-zh.md)

如果感觉默认的线条太多的话，可以这么设置：
打开 `next/layout/_layout.swig`，在 < /body>之前添加代码(注意不要放在< /head>的后面)：

```
{% if theme.canvas_nest %}
<script type="text/javascript"
color="233,233,233" opacity='0.9' zIndex="-2" count="50" src="//cdn.bootcss.com/canvas-nest.js/1.0.0/canvas-nest.min.js"></script>
{% endif %}
```
说明：
color ：线条颜色, 默认: '0,0,0'；三个数字分别为(R,G,B)
opacity: 线条透明度（0~1）, 默认: 0.5
count: 线条的总数量, 默认: 150
zIndex: 背景的z-index属性，css属性用于控制所在层的位置, 默认: -1



### 2.2. 侧边栏美化 ###

![](http://media.makcyun.top/18-8-22/97716423.jpg)

#### 2.2.1. 添加博客名字和slogan ####
修改**站点文件**如下：
```js
# Hexo Configuration
## Docs: https://hexo.io/docs/configuration.html
## Source: https://github.com/hexojs/hexo/

# Site
title: 高级农民工            # 更改为你自己的
subtitle: Beginner's Mind   
description:
keywords: python,hexo,神器,软件
author: 高级农民工
language: zh-Hans
timezone:

```

#### 2.2.2. 菜单设置 ####
文件路径：`D:\blog\themes\hexo-theme-next\languages\zh-Hans.yml`
修改如下：  
```js
menu:
  home: 首&emsp;&emsp;页
  archives: 归&emsp;&emsp;档
  categories: 分&emsp;&emsp;类
  tags: 标&emsp;&emsp;签
  about: 关于博主
  search: 站内搜索
  top: 最受欢迎
  schedule: 日程表
  sitemap: 站点地图
  # commonweal: 公益404
```
注意：两字的中间添加`&emsp;&emsp;`可实现列对齐。


#### 2.2.3. 新建标签、分类、关于页面 ####
分别运行命令：
```
hexo new page "tags" 
hexo new page "categories"  
hexo new page "about"  
```
然后，打开`D:\blog\source`就可以看到上述三个文件夹。
要添加关于博主的介绍，只需要在`/about/index.md`文件中，用markdown书写内容即可，写完后运行：`hexo d -g`，便可看到效果。

#### 2.2.4. 侧栏社交链接图标设置 ####
可以添加你的github、Email、知乎、简书等社交网站账号。
**主题文件：**
```js
# ---------------------------------------------------------------
# Sidebar Settings 侧栏社交链接图标设置
# ---------------------------------------------------------------

# Social Links.
# Usage: `Key: permalink || icon`
# Key is the link label showing to end users.
# Value before `||` delimeter is the target permalink.
# Value after `||` delimeter is the name of FontAwesome icon. If icon (with or without delimeter) is not specified, globe icon will be loaded.
social:
  GitHub: https://github.com/makcyun || github
  E-Mail: mailto:johnny824lee@gmail.com || envelope
  #Google: https://plus.google.com/yourname || google
  #Twitter: https://twitter.com/yourname || twitter
  #FB Page: https://www.facebook.com/yourname || facebook
  #VK Group: https://vk.com/yourname || vk
  #StackOverflow: https://stackoverflow.com/yourname || stack-overflow
  #YouTube: https://youtube.com/yourname || youtube
  #Instagram: https://instagram.com/yourname || instagram
  #Skype: skype:yourname?call|chat || skype

social_icons:
  enable: true
  icons_only: false
  transition: false

```

#### 2.2.5. 添加头像并美化 ####
博客添加头像有两种方法：第一种是放在本地文件夹中：D:\blog\public\uploads，并且命名为**avatar.jpg**。第二种是将图片放在七牛云中，然后传入链接。推荐这种方式，可以加快网页打开速度。
**站点文件**任意行添加下面代码：
```js
# 添加头像
# avatar: /uploads/avatar.jpg   #方法1本地图片
avatar: http://media.makcyun.top/18-8-3/40685653.jpg  # 方法2网络图片

注意：uppoads文件夹是在主题里的文件夹，没有则新建
D:\blog\themes\hexo-theme-next\source\uploads\avatar.jpg
```
**头像变圆形**  
可参考：  
[http://shenzekun.cn/hexo%E7%9A%84next%E4%B8%BB%E9%A2%98%E4%B8%AA%E6%80%A7%E5%8C%96%E9%85%8D%E7%BD%AE%E6%95%99%E7%A8%8B.html](http://shenzekun.cn/hexo%E7%9A%84next%E4%B8%BB%E9%A2%98%E4%B8%AA%E6%80%A7%E5%8C%96%E9%85%8D%E7%BD%AE%E6%95%99%E7%A8%8B.html)  
`D:\blog\themes\next\source\css\_common\components\sidebar\sidebar-author.styl `，在里面添加如下代码：
```js
.site-author-image {
  display: block;
  margin: 0 auto;
  padding: $site-author-image-padding;
  max-width: $site-author-image-width;
  height: $site-author-image-height;
  border: $site-author-image-border-width solid $site-author-image-border-color;
  
  /* 头像圆形 */
  border-radius: 80px;
  -webkit-border-radius: 80px;
  -moz-border-radius: 80px;
  box-shadow: inset 0 -1px 0 #333sf;
  /* 设置循环动画 [animation: (play)动画名称 (2s)动画播放时长单位秒或微秒 (ase-out)动画播放的速度曲线为以低速结束 
    (1s)等待1秒然后开始动画 (1)动画播放次数(infinite为循环播放) ]*/
 
  /* 鼠标经过头像旋转360度 */
  -webkit-transition: -webkit-transform 1.0s ease-out;
  -moz-transition: -moz-transform 1.0s ease-out;
  transition: transform 1.0s ease-out;

}

/*再进一步想点击产生旋转效果，就继续在该文件下方添加代码：*/

img:hover {
  /* 鼠标经过停止头像旋转 
  -webkit-animation-play-state:paused;
  animation-play-state:paused;*/
  /* 鼠标经过头像旋转360度 */
  -webkit-transform: rotateZ(360deg);
  -moz-transform: rotateZ(360deg);
  transform: rotateZ(360deg);
}
/* Z 轴旋转动画 */
@-webkit-keyframes play {
  0% {
    -webkit-transform: rotateZ(0deg);
  }
  100% {
    -webkit-transform: rotateZ(-360deg);
  }
}
@-moz-keyframes play {
  0% {
    -moz-transform: rotateZ(0deg);
  }
  100% {
    -moz-transform: rotateZ(-360deg);
  }
}
@keyframes play {
  0% {
    transform: rotateZ(0deg);
  }
  100% {
    transform: rotateZ(-360deg);
  }
}
```


### 2.3. 页脚美化 ###
![](http://media.makcyun.top/18-8-22/89825453.jpg)
**建站时间设置**
```js
# Set rss to false to disable feed link.
# Leave rss as empty to use site's feed link.
# Set rss to specific value if you have burned your feed already.
rss:

footer:
  # Specify the date when the site was setup.
  # If not defined, current year will be used.
  # 建站年份
  since: 2018           #根据实际情况修改
```

#### 2.3.1. 隐藏powered By Hexo/主题 ####
文件路径： D:\blog\themes\hexo-theme-next\layout\_partials\ **footer.swig**
更改该文件下面的代码：
```js
<div class="theme-info">{#
  #}{{ __('footer.theme') }} &mdash; {#
  #}<a class="theme-link" target="_blank" href="https://github.com/iissnan/hexo-theme-next">{#
    #}NexT.{{ theme.scheme }}{#
  #}</a>{% if theme.footer.theme.version %} v{{ theme.version }}{% endif %}{#
#}</div>

```
用<!--  -->注释两行如下语句，也可以直接删除掉这段代码：
```js
<!--<div class="theme-info">{#
  #}{{ __('footer.theme') }} &mdash; {#
  #}<a class="theme-link" target="_blank" href="https://github.com/iissnan/hexo-theme-next">{#
    #}NexT.{{ theme.scheme }}{#
  #}</a>{% if theme.footer.theme.version %} v{{ theme.version }}{% endif %}{#
#}</div>-->

```
#### 2.3.2. next版本隐藏 ####
继续在上面文件中修改代码如下：
```js
# 用<!--注释语句-->
{% if theme.footer.theme.enable %}
  <!--<div class="theme-info">{#
  #}{{ __('footer.theme') }} &mdash; {#
  #}<a class="theme-link" target="_blank" href="https://github.com/iissnan/hexo-theme-next">{#
    #}NexT.{{ theme.scheme }}{#
  #}</a>{% if theme.footer.theme.version %} v{{ theme.version }}{% endif %}{#
#}</div>-->
{% endif %}

```

#### 2.3.3. 时间和用户名之间添加心形 ####
**主题文件：**建站时间下面修改`icon: heart`
```
footer:
  # Specify the date when the site was setup.
  # If not defined, current year will be used.
  # 建站年份
  since: 2018
  # Icon between year and copyright info.
  # 年份后面的图标，为 Font Awesome 图标
  # 自己去纠结 http://fontawesome.io/icons/
  # 然后更改名字就行，下面的有关图标的设置都一样

  # Icon between year and copyright info.
  #icon: user
  icon: heart
```
如果还想让心变成跳动的红心，则继续在:上面的**footer.swig**文件中修改：
`<span class="with-love">`为 `<span class="with-love" id="heart"> `  #一定要加id="heart"  
```js
<div class="copyright">{#
#}{% set current = date(Date.now(), "YYYY") %}{#
#}&copy; {% if theme.footer.since and theme.footer.since != current %}{{ theme.footer.since }} &mdash; {% endif %}{#
#}<span itemprop="copyrightYear">{{ current }}</span>
  <span class="with-love">
    <i class="fa fa-{{ theme.footer.icon }}"></i>
  </span>
  <span class="author" itemprop="copyrightHolder">{{ theme.footer.copyright || config.author }}</span>

```

在自定义文件中添加如下代码：
```js
// 1 页脚加闪烁红心
// 自定义页脚跳动的心样式
@keyframes heartAnimate {
    0%,100%{transform:scale(1);}
    10%,30%{transform:scale(0.9);}
    20%,40%,60%,80%{transform:scale(1.1);}
    50%,70%{transform:scale(1.1);}
}
#heart {
    animation: heartAnimate 1.33s ease-in-out infinite;
}
.with-love {
    color: rgb(192, 0, 39);
}
```
接着在自定义`custom.styl`文件中，添加以下代码：
```js
// 1 页脚加闪烁红心
// 自定义页脚跳动的心样式
@keyframes heartAnimate {
    0%,100%{transform:scale(1);}
    10%,30%{transform:scale(0.9);}
    20%,40%,60%,80%{transform:scale(1.1);}
    50%,70%{transform:scale(1.1);}
}
#heart {
    animation: heartAnimate 1.33s ease-in-out infinite;
}
.with-love {
    color: rgb(192, 0, 39);   # rgb可随意修改
}
```

#### 2.3.4. 页脚显示总访客数和总浏览量  ####
首先，在上述`footer.swig`文件首行添加如下代码：
```js
<script async src="https://dn-lbstatics.qbox.me/busuanzi/2.3/busuanzi.pure.mini.js"></script>

#接着修改相应代码：
# 添加总访客量
<span id="busuanzi_container_site_uv">
  访客数:<span id="busuanzi_value_site_uv"></span>人次
</span>

{% if theme.footer.powered %}
  <!--<div class="powered-by">{#
  #}{{ __('footer.powered', '<a class="theme-link" target="_blank" href="https://hexo.io">Hexo</a>') }}{#
#}</div>-->
{% endif %}

# 添加'|'符号
{% if theme.footer.powered and theme.footer.theme.enable %}
  <span class="post-meta-divider">|</span>
{% endif %}


{% if theme.footer.custom_text %}
  <div class="footer-custom">{#
  #}{{ theme.footer.custom_text }}{#
#}</div>
{% endif %}

# 添加总访问量
<span id="busuanzi_container_site_pv">
   总访问量:<span id="busuanzi_value_site_pv"></span>次
</span>

# 添加'|'符号
{% if theme.footer.powered and theme.footer.theme.enable %}
  <span class="post-meta-divider">|</span>
{% endif %}

# 添加博客全站共：
<div class="theme-info">
  <div class="powered-by"></div>
  <span class="post-count">博客全站共{{ totalcount(site) }}字</span>
</div>
```

### 2.4. 文章美化 ###
![](http://media.makcyun.top/18-8-22/74366995.jpg)
#### 2.4.1. 显示统计字数和估计阅读时长 ####
修改**主题文件：**
```js
# Post wordcount display settings
# Dependencies: https://github.com/willin/hexo-wordcount
# 显示统计字数和估计阅读时长
# 注意：这个要安装插件，先进入站点文件夹根目录
# 然后：npm install hexo-wordcount --save
post_wordcount:
  item_text: true
  wordcount: true
  min2read: true
  totalcount: false
  separated_meta: false
```
注意，做了以上修改后，发现字数只显示了数字并没有带相应的单位:**字**和**分钟**。因此，还需做如下修改：
打开`D:\blog\themes\hexo-theme-next\layout\_macro\ **post.swig**`文件，添加单位：
```js
{% if theme.post_wordcount.wordcount or theme.post_wordcount.min2read %}
            <div class="post-wordcount">
              {% if theme.post_wordcount.wordcount %}
                {% if not theme.post_wordcount.separated_meta %}
                  <span class="post-meta-divider">|</span>
                {% endif %}
                <span class="post-meta-item-icon">
                  <i class="fa fa-file-word-o"></i>
                </span>
                {% if theme.post_wordcount.item_text %}
                  <span class="post-meta-item-text">{{ __('post.wordcount') }}&#58;</span>
                {% endif %}
                <span title="{{ __('post.wordcount') }}">
                  {{ wordcount(post.content) }} 字
                </span>
              {% endif %}

              {% if theme.post_wordcount.wordcount and theme.post_wordcount.min2read %}
                <span class="post-meta-divider">|</span>
              {% endif %}

              {% if theme.post_wordcount.min2read %}
                <span class="post-meta-item-icon">
                  <i class="fa fa-clock-o"></i>
                </span>
                {% if theme.post_wordcount.item_text %}
                  <span class="post-meta-item-text">{{ __('post.min2read') }} &asymp;</span>
                {% endif %}
                <span title="{{ __('post.min2read') }}">
                  {{ min2read(post.content) }} 分钟 
                </span>
              {% endif %}
            </div>
          {% endif %}

          {% if post.description and (not theme.excerpt_description or not is_index) %}
              <div class="post-description">
                  {{ post.description }}
              </div>
          {% endif %}

        </div>
      </header>
    {% endif %}
```
#### 2.4.2. 添加阅读全文 ####
实现在主页只展示部分文字，其他文字隐藏起来，通过点击'阅读更多'来阅读全文。
方法就是写每一篇文章的时候，在必要的地方添加`<!-- more --> `即可。
例如：
```
---
title: 4块钱,用Github+Hexo搭建你的个人博客：搭建篇
id: hexo01
images: http://media.makcyun.top/18-8-3/89578286.jpg
categories: hexo博客
tags: [hexo,个人博客,github]
keywords: hexo,搭建博客,github pages,next
---

4块钱,你就能够在茫茫互联网中拥有一处专属于你的小天地，丈量你走过的每一个脚印。
  
<!-- more -->

摘要： 对于一个不懂任何前端的纯小白来说，搭建博客是件很有挑战的事。

```
#### 2.4.3. 显示每篇文章的阅读量 ####
参考这个教程即可：
[http://www.jeyzhang.com/hexo-next-add-post-views.html](http://www.jeyzhang.com/hexo-next-add-post-views.html)

在这个过程中发现了一个问题：pc端正常显示阅读量，但是移动端没有显示具体的阅读量。解决办法：
在leancloud网站上，进入安全中心，检查web安全域名列表中是否添加了**http：开头**的域名，如果没有，则添加上应该就能解决，例如，我的：
```
http://makcyun.top/
```

#### 2.4.4. 文章摘要配图 ####
参考这个教程即可：
[http://wellliu.com/2016/12/30/%E3%80%90%E8%BD%AC%E3%80%91Blog%E6%91%98%E8%A6%81%E9%85%8D%E5%9B%BE/](http://wellliu.com/2016/12/30/%E3%80%90%E8%BD%AC%E3%80%91Blog%E6%91%98%E8%A6%81%E9%85%8D%E5%9B%BE/)

附上我的设置：
在自定义文件中添加如下代码：
```js
// img.img-topic {
//    width: 100%;
//}

//图片外部的容器方框
.out-img-topic {
  display: block;
  max-height:350px;      //图片显示高度，如果不设置则每篇文章的图片高度会不一样，看起来不协调
  margin-bottom: 24px;
  overflow: hidden;
}
//图片
img.img-topic {
  display: block ;
  margin-left: .7em;
  margin-right: .7em;
  padding: 0;
  float: right;
  clear: right;
}

// 去掉图片边框
.posts-expand .post-body img {
    border: none;
    padding: 0px;
}
```


#### 2.4.5. 添加打赏功能 ####
参考下面的教程：
[https://www.cnblogs.com/mrwuzs/p/7943337.html](https://www.cnblogs.com/mrwuzs/p/7943337.html)
[https://blog.csdn.net/lcyaiym/article/details/76796545](https://blog.csdn.net/lcyaiym/article/details/76796545)

以上，包括了博客美化的大部分操作。  
如果，你觉得还不够，想做得更精致一些，那么推荐一个非常详细的美化教程：  
[https://reuixiy.github.io/technology/computer/computer-aided-art/2017/06/09/hexo-next-optimization.html#附上我的-custom-styl](https://reuixiy.github.io/technology/computer/computer-aided-art/2017/06/09/hexo-next-optimization.html#附上我的-custom-styl)

本文完。