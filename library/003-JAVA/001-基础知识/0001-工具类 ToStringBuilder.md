## Java 工具类 ToStringBuilder
```java
System.out.println("-------------ToStringBuilder-------------------------");
    User u = new User();
    u.setAge(25);
    u.setName("wangsan");
    
  //对象及其属性一行显示
    System.out.println(ToStringBuilder.reflectionToString(u));
    System.out.println(ToStringBuilder.reflectionToString(u, ToStringStyle.DEFAULT_STYLE));
    //属性换行显示
    System.out.println(ToStringBuilder.reflectionToString(u, ToStringStyle.MULTI_LINE_STYLE));
    //不显示属性名，只显示属性值，在同一行显示
    System.out.println(ToStringBuilder.reflectionToString(u, ToStringStyle.NO_FIELD_NAMES_STYLE));
    //对象名称简写
    System.out.println(ToStringBuilder.reflectionToString(u, ToStringStyle.SHORT_PREFIX_STYLE));
    //只显示属性
    System.out.println(ToStringBuilder.reflectionToString(u, ToStringStyle.SIMPLE_STYLE));
结果显示：
-------------ToStringBuilder-------------------------
test.User@15[name=wangsan,age=25]
test.User@15[name=wangsan,age=25]
test.User@15[
  name=wangsan
  age=25
]
test.User@15[wangsan,25]
User[name=wangsan,age=25]
wangsan,25
//toStringBuilder比较适合在打印日志时，输出参数信息，特别是在参数为对象的时，该工具类能够很方便的自动打印对象的属性值。
logger.info("getUserInfo response : {}",
  new Object[] { ToStringBuilder.reflectionToString(res,ToStringStyle.MULTI_LINE_STYLE) });
```