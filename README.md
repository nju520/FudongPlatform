# FudongPlatform

## 项目介绍

该项目是采用Ruby on Rails开发的电商平台
主要功能包括一下几个部分:

* 用户和商家注册登录
* 购物车
* 收货地址
* 订单
* 付款
* 收货

* 商家后台功能
  * 商品管理
  * 发货

* 平台管理功能
  * 分类管理
  * 商家商品管理
  * 打款

项目使用技术:

Ruby 2.3.2
Ruby on Rails 5.1.4
MySQL

涉及到的主要Gem:

sorcery
ancestry
paperclip
redis

### 运行
$ cd FudongPlatform
$ rails db:create
$ rails db:migrate
$ rails db:seed

### snips目录
* snips为网站流程截图
* product_images为商品的一些图片

### 注册登录链接说明

#### 用户
* 注册: localhost:3000/signup
* 登录: localhost:3000/login

#### 商家
* 注册: localhost:3000/seller/signup
* 登录: localhost:3000/seller/login

#### 平台管理员
* 注册: 无(系统后台自动分配账号)
* 登录: localhost:3000/admin/login


### 系统说明

此平台系统的商家实际上是包括两种商家: 一种就类似于京东自营类的商家,这类商家其实就是平台自身; 另外一种就是其他商家.
考虑到不管是商家和平台商家, 大部分业务逻辑都比较类似, 所以将其均表示为商家表, 通过表中的字段进行区分.
当平台给商家打款时, 如果是平台自己,就不需要打款.


### 数据表说明

####  1. users
users表根据is_admin和is_seller来区分普通用户, 商家和平台.
之所以放在一张表中是因为注册登录模块采用的 sorcery gem, 暂时不支持三个用户表注册登录实现.
如果采用devise gem或者以后自行开发的话, 需要分别采用users, sellers, admins三者表来关联不同身份的用户

|    type     | column            |
| ----------  | --------------    |
| string      |  email            |
| string      |  crypted_password |
| string      |  uuid             |
| boolean     |  is_admin         |
| boolean     |  is_seller        |

#### 2. products
商品表示电商系统中最基本的一个表.根据电商开发中的SKU概念
SKU=stock keeping unit(库存量单位), 本商品表特指一个SKU
所有的上层分类交给categories表.
products表有两个外键和其他表关联:
* category_id: 类型表
* seller_id: 卖家表(在本系统中就是users表)

PS: 每一种商品都对应一个商家, 用户挑选商品放入购物车的过程是不关心此商品属于哪个商家, 因此商家不会暴露给买家.

|    type      | column            |
| ----------   | --------------    |
| integer      |  category_id      |
| integer      |  seller_id        |
| string       |  title            |
| string       |  status           |
| integer      |  amount           |
| integer      |  uuid             |
| decimal      |  msrp             |
| decimal      |  price            |
| text         |  description      |
| string       |  status           |
| integer      |  main_order_id    |
| integer      |  pack_order_id    |

#### 3. product_images
商品图片表, 和某个商品关联

|    type      | column             |
| ----------   | --------------     |
| integer      |  category_id       |
| integer      |  weight            |
| string       |  image_file_name   |
| string       |  image_content_type|
| integer      |  image_file_size   |


#### 4. categories
参考Ruby-China中提到的几个开源电商系统, 采用ancestry gem进行分类划分, 可以往下进行一级分类, 二级分类, 三级分类.
最小分类下面就是一个SKU的商品

|    type     | column             |
| ----------  | --------------     |
| string      |  title             |
| integer     |  weight            |
| integer     |  products_counter  |
| string      |  ancestry          |

#### 5. shopping_carts
购物车表
有两个外键和其他表关联:
* user_id: 买家表
* product_id: 商品表(购物车的每条记录都是一种商品)

|    type     | column            |
| ----------  | --------------    |
| integer      |  user_id         |
| integer      |  product_id      |
| integer      |  amount          |
| string      |  user_uuid        |


#### 6. orders
订单表是电商平台最关键的一张表, 其中orders有以下几个外键和其他表关联:
* user_id: 关联买家用户
* product_id: 关联具体商品
* payment_id: 关联付款表
* address_id: 关联地址表
* main_order_id: 关联主订单(用户一次下单时的所有订单表)
* pack_order_id: 关联打包表(用于一次性购买时属于一个商家的所有订单)

orders中有一个关键的字段status指示此订单的各个状态:
状态都是结果状态, 暂时没有涉及到中间的状态变化, 比如用户支付完毕后, 状态变为paid.此时商家点击"发货", 订单的状态变为'shipping'.

```ruby
module OrderStatus
  Initial  = 'initial'    # 初始化(生成订单但是未支付)
  Paid     = 'paid'          # 已支付
  Shipping = 'shipping'  # 已发货
  Received = 'received'  # 已收货
  Finished = 'finished'  # 已结束
end
```

|    type     | column            |
| ----------  | --------------    |
| integer      |  user_id         |
| integer      |  product_id      |
| integer      |  address_id      |
| integer      |  payment_id      |
| integer      |  order_no        |
| integer      |  amount          |
| decimal      |  total_money     |
| datetime     |  payment_at      |
| string       |  status          |
| integer      |  main_order_id   |
| integer      |  pack_order_id   |


#### 7. main_orders
主订单表, 也就是用户的购物车的中所有商品对应的订单.


|    type      | column            |
| ----------   | --------------    |
| integer      |  user_id          |
| integer      |  main_order_id    |
| decimal      |  main_total_money |
| datetime     |  payment_at       |


#### 8. pack_orders
打包表. 设计此表的最初目的就是考虑到我们的电商平台商家是不会暴露给用户的.
用户购买商品时, 只需要往购物车中添加他想要的商品即可.
此表包含了用户一次性生成订单时属于某个商家的商品订单表, 是一个中间表.
商家处理发货和退货时会用到此表.

|    type      | column            |
| ----------   | --------------    |
| integer      |  user_id          |
| integer      |  pack_order_id    |
| decimal      |  pack_total_money |
| datetime     |  payment_at       |


#### 9. payments
付款表就是用户一次性支付购物车商品时生成的表.
其中包括以下外键和其他表关联:
* user_id: 用户表(此处为买家表)
* main_order_id: 主订单表

|    type     | column            |
| ----------  | --------------    |
| integer      |  user_id         |
| integer      |  main_order_id   |
| integer      |  payment_no      |
| integer      |  transaction_no  |
| string       |  status          |
| decimal      |  total_money     |
| datetime     |  payment_at      |


#### 10. buyer_accounts
买家账户表,其中balance为账户资金余额. 此表为结果表, 也就是记录买家的账户的余额情况.
每个买家只能拥有一个账户

|    type      | column       |
| ----------   | -------------|
| integer      |  user_id     |
| string       |  name        |
| integer      |  account_no  |
| decimal      |  balance     |


#### 11. buyer_transactions
买家账户流水记录表, 此表为过程表, 记录每次订单的资金流动情况,
其中有两个外键和其他表关联:
* user_id: 订单表
* buyer_account_id: 买家账户表

|    type     | column            |
| ----------  | --------------    |
| integer      |  order_id        |
| integer      |  buyer_account_id|
| string       |  buyer_name      |
| integer      |  transction_no   |
| string       |  transction_type |
| integer      |  transaction_no  |
| decimal      |  trade_amount    |
| decimal      |  total_money     |
| datetime     |  payment_at      |


#### 12. seller_accounts
卖家账户表,其中balance为账户资金余额. 此表为结果表, 也就是记录卖家的账户的余额情况.
每个卖家同样只能拥有一个账户

|    type      | column       |
| ----------   | -------------|
| integer      |  user_id     |
| string       |  name        |
| integer      |  account_no  |
| decimal      |  balance     |


#### 13. seller_transactions
卖家账户流水记录表, 此表为过程表, 记录每次属于此商家的订单的资金流动情况,
其中有两个外键和其他表关联:
* user_id: 订单表
* seller_account_id: 卖家账户表

|    type      | column            |
| ----------   | --------------    |
| integer      |  order_id         |
| integer      |  seller_account_id|
| string       |  seller_name      |
| integer      |  transction_no    |
| string       |  transction_type  |
| integer      |  transaction_no   |
| decimal      |  trade_amount     |
| decimal      |  total_money      |
| datetime     |  payment_at       |


#### 14. admin_accounts
平台账户表.
目前设计的平台账户表只有一个总的记录.
买家付款的资金都流入此账户, 给商家打款的资金都来源于此账户.


|    type      | column       |
| ----------   | -------------|
| integer      |  user_id     |
| string       |  name        |
| integer      |  account_no  |
| decimal      |  balance     |

#### 15. admin_transactions
平台资金流动表. 其中资金流动包括两个方面:
* 用户付款给平台
* 平台打款给商家


|    type      | column            |
| ----------   | --------------    |
| integer      |  order_id         |
| integer      |  seller_account_id|
| string       |  seller_name      |
| integer      |  transction_no    |
| string       |  transction_type  |
| integer      |  transaction_no   |
| decimal      |  trade_amount     |
| decimal      |  total_money      |
| datetime     |  payment_at       |


### 系统流程

#### 1. 正常付款收货等流程

买家挑选商品放入购物车 --> 生成订单 --> 付款 --> 等待商家发货 --> 商家发货 --> 用户确认收货 --> 平台打款给商家

#### 2. 退款/退款

暂时没有完成


### 系统消息通知

通过Raills中的ActionCable实现买家/商家/平台之间的消息通知.
通知的产生情况有以下几种情况:
* 买家生成订单
* 买家付款
* 商家发货
* 买家确认收货
* 平台打款给商家


### 开发感想

目前存在很多电商平台模型, 究竟哪一种模式适合我们自己的平台, 还需要根据具体业务逻辑来设计.
设计系统期间我结合各大电商平台的使用流程, 结合我们平台的特殊性,同时参考了很多开源的Rails电商平台的设计逻辑, 最终设计出这个初步的平台系统.
由于时间紧张, 很多功能未完成, 逻辑的处理也是尽量简单化.
