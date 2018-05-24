# 针对weex的简单iOS手势密码解锁插件


说明：
====================================
本插件是针对weex做的一个手势密码解锁插件，具体的效果可以查看[基于eros的手势密码Demo](https://github.com/shawn-tangsc/eros-gesture-demo)。


两种安装方式：
====================================

第一种，通过pod本地引入
------------------------------------

1. 首先，从git 下载到本地

``` bash
## 进入你weex项目中的ios目录，执行git clone
git clone https://github.com/shawn-tangsc/WeexPlugin-HMGesUnlock

```

2. 其次，修改你ios项目的`Podfile`文件，加入

``` bash
 pod 'WeexHMGesUnlock', :path=>'./WeexPlugin-HMGesUnlock/'
```

3. 从终端进入项目`Podfile`所在的文件夹，然后执行初始化命令

``` bash
pod update 
```

第二种，直接使用pod引入插件
------------------------------------

1. 在你的`Podfile` 文件中，添加

```
 pod 'WeexHMGesUnlock', :git => 'https://github.com/shawn-tangsc/WeexPlugin-HMGesUnlock.git', :tag => '1.0.0'
```

2. 从终端进入项目`Podfile`所在的文件夹，然后执行初始化命令

``` bash
pod update  
```


引入初始图片：
====================================
1. 首先，在你的工程中，新建一个Image.xcassets 的文件夹
2. 把我git工程中，image目录下的文件拖到你创建的Image.xcassets中
3. 你可以自己按照尺寸去修改成你想要的图片，名字不要变。

#### 具体步骤
![](https://ws2.sinaimg.cn/large/006tNc79gy1frmhxy97xoj31kw0we7c4.jpg)
![](https://ws3.sinaimg.cn/large/006tNc79gy1frmhyhy6nrj3134114408.jpg)
![](https://ws3.sinaimg.cn/large/006tNc79gy1frmhz4qm93j310c0vita6.jpg)
![](https://ws1.sinaimg.cn/large/006tNc79gy1frmhzj7g0hj31kw0spaf6.jpg)
![](https://ws2.sinaimg.cn/large/006tNc79gy1frmhupasnkj31gs0uidhk.jpg)


weex中的使用方式：
====================================

1. 在需要使用的文件中引入该mudule

	``` bash
	const hmGesUnlock = weex.requireModule('hmGesUnlock');
	```

2. 添加手势密码

	```
	## 在回调中会返回成功还是失败的Bool结果
	hmGesUnlock.addGesturePage(function (flag) {
	    ...
	});
	```
	
3. 验证手势密码

	```
	## 在回调中会返回成功还是失败的Bool结果
	hmGesUnlock.checkGesturePage(function (flag) {
        ...
    });
	```