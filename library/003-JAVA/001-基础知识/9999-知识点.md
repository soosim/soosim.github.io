## StringUnits 的 isBlank() 与 isEmpty() 的区别：
```java
System.out.println(StringUtils.isEmpty(null));        //true
System.out.println(StringUtils.isEmpty(""));          //true
System.out.println(StringUtils.isEmpty("   "));       //false
System.out.println(StringUtils.isEmpty("dd"));        //false

// 区别主要在于 " "的判断上

System.out.println(StringUtils.isBlank(null));        //true
System.out.println(StringUtils.isBlank(""));          //true
System.out.println(StringUtils.isBlank("   "));       //true
System.out.println(StringUtils.isBlank("dd"));        //false
```