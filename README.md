# abc_plugin
农行支付sdk

# 初始化

## Android端
无需配置

## IOS端
- Info.plist下添加

```plist
	<key>LSApplicationQueriesSchemes</key>
	<array>
		<string>bankabc</string>
	</array>
```

- 添加Url Scheme

1. 在项目中找到ios文件夹，点击右键，在弹出的选项中找到 `Flutter`-`Open IOS module in Xcode`

2. 添加url Scheme,如下图所示

![](/img/img1.jpg)


# 使用

- 1.检查是否可以调起农行app

```dart

bool isSuccess=await AbcPlugin.canPay();

```

- 2. 请求支付

```dart

String result = await AbcPlugin.requestPay(
                          'com.rhyme.abc_plugin_example',
                          Platform.isIOS ? 'abc_example' : 'MainActivity',
                          'pay',
                          'ON20140954103');
                      print(result);
```
各参数介绍:

`com.rhyme.abc_plugin_example`为你android的包名

`abc_example`和`MainActivity`如果是IOS则是UrlScheme，如果是Android则是对应的Activity

`pay` 目前只支持pay方法,所以固定的

`ON20140954103` 为你的tokenId，通过服务器获取

返回参数内容介绍:
```
STT=XX & Msg=XXX & TokenID=XXXX
```
STT:支付状态码。

Msg:支付状态说明。

注意:STT 和 Msg 由于是从掌银 APP 端传递给第三方的，可靠性无法保 证，其值仅供参考。

![](/img/img2.jpg)