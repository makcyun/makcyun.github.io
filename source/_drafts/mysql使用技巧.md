---
title:  Mysql数据库使用总结
id: web_scraping_withpython1
date: {{ date }}
categories: python爬虫
tags: [python爬虫,requests,正则表达式,beautifulsoup,css,xpath,lxml]
images: http://pbscl931v.bkt.clouddn.com/18-8-16/81175827.jpg
keywords: 


---


<b>*mysql*</b>   


<!-- more -->  



**摘要：** 分享mysql使用的一些技巧。


>**本文知识点：**  
>Navicat的使用  
>beautiful+lxml两大解析库使用  
>正则表达式 、xpath、css选择器的使用  

新建数据库的3种方法

1 Navicat中直接建立
放截图
2 命令行中建立

- win+R 启动服务  
           - net start mysql
- 定位到程序文件夹
   - cd C:\Program Files\mysql\mysql-8.0.11-winx64\bin
- 输入密码
   - mysql  -u root -p --local-infile data(数据库名称)
- 输入创建表头语句，以创建包含userId,sex,birth三列的userinfo表为例：
    ```sql
    CREATE TABLE userinfo (
    userId int(11) not NULL,
    sex varchar(11) DEFAULT NULL,
    birth datetime(11) DEFAULT NULL,
    PRIMARY KEY (userId)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8
    ```
3 python程序中建立
```python
import pymysql

def generate_mysql(db = 'wade'):
	conn = pymysql.connect(
		host='localhost',
		user='root',
		password='wade123',
		port=3306,
		charset = 'utf8',
		db = 'wade')
	cursor = conn.cursor()
	
	sql = 'CREATE TABLE IF NOT EXISTS listed_company2 (serial_number INT(20) NOT NULL,stock_code INT(20) ,stock_abbre VARCHAR(20) ,company_name VARCHAR(20) ,province VARCHAR(20) ,city VARCHAR(20) ,main_bussiness_income VARCHAR(20) ,net_profit VARCHAR(20) ,employees INT(20) ,listing_date datetime(0) ,zhaogushu VARCHAR(20) ,financial_report VARCHAR(20) , industry_classification VARCHAR(20) ,industry_type VARCHAR(100) ,main_business VARCHAR(200) ,PRIMARY KEY (serial_number))'

	cursor.execute(sql)
	conn.close()

generate_mysql()
```
上市公司表格爬虫

Navicat是mysql常用的一款数据库管理工具。