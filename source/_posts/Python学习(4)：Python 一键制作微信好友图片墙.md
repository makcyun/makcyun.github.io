---

title: Python 一键制作微信好友图片墙
id: Python_learning04
date: 2019-4-19 16:16:16
categories: Python学习
tags: [Python入门]
images: http://media.makcyun.top/win/20190420/uKy4zwtphocb.jpg?imageslim
keywords: [Python制作微信好友图片墙]
---
wxpy、pyinstalller 库的使用。

<!-- more -->  

上午发了张我微信近 2000 位好友的头像拼图，让大伙儿看能不能快速找到自己的头像，没想到反响很强烈，引得阵阵惊呼与膜拜，没有料到。

![](http://media.makcyun.top/win/20190420/QHOQuMpm7gum.jpg?imageslim)

有没有犯密集恐惧症？这并不震撼，如果你有 5000 位好友的话，做出来的图看着会更刺激些。

看完了图，你可能想知道这个图咋做出来的，不会是我闲着无聊把把好友头像一个个保存下来再用 PS 拼的吧？

自然不是了，Python 做的，是不是觉得没有 Python 干不了的事儿。其实，这种图很早就有人玩过了，不过下面还是来说说怎么做出来，这样你也可以做一个自己微信好友的图片墙。

**有两种方法，一种简单的，不用接触 Python 代码，一种稍微复杂点，需要写代码。**

先说简单的方法，只需要两步：运行程序然后扫微信二维码就行了。剩下的交给程序自己蹦跶，泡杯茶在电脑前等待几分钟左右就可以得到图片，具体的等待时间视微信好友数量而不同，我近 2000 好友，用时 10 分钟左右。

一个简单的操作示意图：

![](http://media.makcyun.top/win/20190420/nv3gtyIaU7Pp.png?imageslim)

几分钟后就可以得到上面的图片了。

其实到这儿就完了，是不是很简单。

---

你要感兴趣怎么实现的，可以往下看用 Python 代码怎么实现的，代码不长，60 行就可以搞定。

核心是利用三个个库：

- wxpy 库，用于获取好友头像然后下载
- Pillow 库，用于拼接头像
- Pyinstaller 库，用来打包 Python 程序成 exe 文件

程序通过三个函数实现，第一个 creat_filepath 函数生成图片下载文件路径，第二个 save_avatar 函数循环获取微信好友头像然后保存到本地，第三个 joint_avatar 函数就是把头像拼接成一张大图。

完整代码如下：

```python
# -*- coding: utf-8 -*-
from wxpy import *
import math
from PIL import Image
import os

# 创建头像存放文件夹
def creat_filepath():
    avatar_dir = os.getcwd() + "\\wechat\\"
    if not os.path.exists(avatar_dir):
        os.mkdir(avatar_dir)
    return avatar_dir

# 保存好友头像
def save_avatar(avatar_dir):
    # 初始化机器人，扫码登陆
    bot = Bot()
    friends = bot.friends(update=True)
    num = 0
    for friend in friends:
        friend.get_avatar(avatar_dir + '\\' + str(num) + ".jpg")
        print('好友昵称:%s' % friend.nick_name)
        num = num + 1

# 拼接头像
def joint_avatar(path):
    # 获取文件夹内头像个数
    length = len(os.listdir(path))
    # 设置画布大小
    image_size = 2560
    # 设置每个头像大小
    each_size = math.ceil(2560 / math.floor(math.sqrt(length)))
    # 计算所需各行列的头像数量
    x_lines = math.ceil(math.sqrt(length))
    y_lines = math.ceil(math.sqrt(length))
    image = Image.new('RGB', (each_size * x_lines, each_size * y_lines))
    x = 0
    y = 0
    for (root, dirs, files) in os.walk(path):
        for pic_name in files:
            # 增加头像读取不出来的异常处理
                try:
                    with Image.open(path + pic_name) as img:
                        img = img.resize((each_size, each_size))
                        image.paste(img, (x * each_size, y * each_size))
                        x += 1
                        if x == x_lines:
                            x = 0
                            y += 1
                except IOError:
                    print("头像读取失败")

    img = image.save(os.getcwd() + "/wechat.png")
    print('微信好友头像拼接完成!')

if __name__ == '__main__':
    avatar_dir = creat_filepath()
    save_avatar(avatar_dir)
    joint_avatar(avatar_dir)
```

可以直接在运行程序文件，也可以用 Pyinstaller 文件打包后运行。这里额外说一下 pyinstaller 打包的方法和闭坑指南。

**不要直接在系统中用 pyinstaller 打包**，否则打包出来的 exe 文件会很大。建议在虚拟环境中打包，打包出来的 exe 文件会小很多， 10MB 左右。 

虚拟环境创建很简单，简单说一下步骤：

1 安装 pipenv 和 pyinstaller 包，用于后续创建虚拟环境和打包程序：

```python
pip install pipenv
pip install pyinstaller # 已安装就不用安装了
```

2 选择一个合适的目录作为 Python 虚拟环境，运行：

```python
pipenv install # 创建虚拟环境
pipenv shell # 创建好后，进入虚拟环境
```

3 安装程序引用的库，上面程序引用了四个库：wxpy、math、os 和 PIL，一行代码就可以完成安装。

```python
pipenv install wxpy math os
```

4 这里要额外注意 PIL 的安装，现在不用 PIL 库，而是用 Pillow 库取代，所以安装 Pillow 库就行。但不要安装最新的 6.0.0 版本，否则可能会遇到各种错误，例如：PIL 无法识别下载的 jpg 头像文件。

```python
OSError: cannot identify image file <ImageFieldFile: images
```

正确的安装方法是安装低版本，经尝试安装 4.2.1 版本没有问题，安装命令：

```python
pipenv install Pillow==4.2.1
```

5 然后打包程序就可以了：

```python
pyinstaller -F C:\Users\sony\Desktop\wechat_avatar.py 
# 程序路径要改成你电脑上的路径
# -F 表示生成单个 exe 文件，方便运行
```

运行如下：

![](http://media.makcyun.top/FuaHnCvoN-uAV3YX_15g4wC0R57I)

运行命令，1 分钟左右若显示 successfully 字样表示程序打包成功：

![](http://media.makcyun.top/FpX3sxGov7vDgblpB55KjBoF_2uF)

接着在程序目录下找到 `wechat_avatar.exe` 文件，然后按照第一种方法那样运行就行了。

以上就是用 Python 制作微信好友图片墙的方法。

完整代码和 exe 文件可以在我的公众号：**高级农民工，**后台回复「微信好友」得到。

---

参考：

[wxpy 库](https://github.com/youfou/wxpy)

[Pipenv – 超好用的 Python 包管理工具](https://segmentfault.com/a/1190000015389565)

[pyinstaller打包后程序体积太大，如何解决？](https://www.zhihu.com/question/268397385/answer/611317903)

