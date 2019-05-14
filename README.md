# CCNetworkKit

[![CI Status](https://img.shields.io/travis/chencheng2046@126.com/CCNetworkKit.svg?style=flat)](https://travis-ci.org/chencheng2046@126.com/CCNetworkKit)
[![Version](https://img.shields.io/cocoapods/v/CCNetworkKit.svg?style=flat)](https://cocoapods.org/pods/CCNetworkKit)
[![License](https://img.shields.io/cocoapods/l/CCNetworkKit.svg?style=flat)](https://cocoapods.org/pods/CCNetworkKit)
[![Platform](https://img.shields.io/cocoapods/p/CCNetworkKit.svg?style=flat)](https://cocoapods.org/pods/CCNetworkKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

CCNetworkKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CCNetworkKit'
```

## Author

chencheng2046@126.com, chencheng2046@126.com

## License

CCNetworkKit is available under the MIT license. See the LICENSE file for more info.

## 使用方法
1. 在- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions中注册json解析的映射字段
如下所示： 
//以下注册用例可用于解析此格式的json数据：{code:1,msg:"未知错误",data:[]或{},currenttime:"时间字符串"}
[CCNetworkKitManager registerCodeName:@"code" errMsgName:@"msg" serverTimeName:@"currenttime" dataName:@"data" baseUrl:@"https://www.test.com/"];
默认只能接收根结构为 {错误码:"",错误信息:"",有效数据源:"",服务器时间:""} 这样的接口返回格式
2. 创建CCBaseApi的子类，用于接口请求实例
如example中CCTestApi所示
```
+ (CCBaseApi *)getWeatherDataWithVersion:(NSString *)version cityId:(NSString *)cityId {
NSMutableDictionary *dic = [NSMutableDictionary new];
if (version) {
[dic setObject:version forKey:@"version"];
}
if (cityId) {
[dic setObject:cityId forKey:@"cityid"];
}
return  self.apiInitURLFull(@"https://www.tianqiapi.com/api/").l_params(dic).l_resArrayModelClass(NSArray.class);
}
```
由于CCBaseApi采用链式编程和协议编程的思想，在调用时可直接使用点语法，
apiInitURLFull方法的参数表示接口路由（如果含有http，则不使用第一步中注册的baseURL），
l_params方法参数为接口参数字典，
l_loadOnView参数为指定的loading视图的父视图，
l_delegate参数为当前持有接口请求的对象（用于在该对象销毁时终止接口请求）；
l_resModelClass为以上注册的json结构中有效数据源（data）字段对应的对象类型，
l_resArrayModelClass为效数据源（data）字段对应的数组类型，两者属于协议调用，只可取一种；
l_successCode方法参数用于设置接口请求成功时code的值；
l_successCodeArray方法参数用于设置接口请求成功时code的值（多个数值的数组）；
l_filesCount方法参数表示上传文件的个数；
l_multipartBlock此回调方法用于上传文件时组装format-data数据；

apiCall用于接口返回结果后的处理操作（该方法后不能再使用点语法）；
apiCallSuccess用于接口请求成功返回结果后的处理操作（该方法后不能再使用点语法）；

3. 经过上一步接口封装之后，就可以在任何需要请求接口的地方调用；调用方法如下
```
[CCTestApi getWeatherDataWithVersion:@"v1" cityId:@"101110101"].l_loadOnView(self.view).apiCall(^(id result,NSError* err){
NSLog(@"%@",result);
});
```
