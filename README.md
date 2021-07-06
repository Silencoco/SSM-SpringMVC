# 一、springmvc 概述



## 1.1 springmvc定义

​		基于spring的一个框架，实际上就是spring的一个模块，专门是做web开发的，理解为servlet的升级。web开发底层是servlet，框架是在servlet基础上面加入一些功能，让开发更方便。



## 1.2 spring和springmvc对比

​		spring：spring是容器，ioc能够管理对象，
​		使用< bean>，@Component，@Repository，@Service，@Controller 标签

​		springmvc：能够创建对象，放入到容器中（springmvc容器），spring容器中放的是控制器对象



## 1.3 springmvc简要流程

​		我们要做的是 使用 @Controller 创建控制器对象 ，把对象放入到springmvc 容器中，把创建的对象作为控制器使用。这个控制器对象能够接收用户的请求，显示处理结果，就当作是一个servlet使用。

​		使用 @Controller 注解创建的是一个普通的对象 ，不是servlet，springmvc赋予了控制器对象一些额外的功能。

​		web开发底层是servlet，springmvc中有一个对象是servlet：DispatcherServlet（中央调度器）
​		DispatcherServlet：负责接收用户的所有请求，用户把请求给了DispatcherServlet，之后DispatcherServlet把请求转发给我们的Controller对象，最后Controller对象处理请求。



# 二、开发步骤

​		index.jsp —> DispatcherServlet（中央调度器，类似servlet） ----> 转发，分配给Controller对象（@Controller 注解创建的对象）

开发流程：

- 发起some.do请求
- tomcat (web.xml	从url-pattern知道 *.do 的请求给DispatcherServlet)
- DispatcherServlet（根据spring.xml配置知道some.do，doSome()方法）
- DispatcherServlet把some.do转发给MyController.doSome()方法
- 框架执行doSome()把得到的ModelAndView进行处理，转发到show.jsp	

简化流程：

​	some.do -> DispatcherServlet -> MyController

![img](https://img-blog.csdnimg.cn/20201112161121800.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MDM1MDk4MQ==,size_16,color_FFFFFF,t_70#pic_center)

在pom.xml中引入servlet和springmvc依赖

```xml
<!--servlet-->
<dependency>
  <groupId>javax.servlet</groupId>
  <artifactId>javax.servlet-api</artifactId>
  <version>3.1.0</version>
  <scope>provided</scope>
</dependency>

<!--spring mvc-->
<dependency>
  <groupId>org.springframework</groupId>
  <artifactId>spring-webmvc</artifactId>
  <version>5.2.5.RELEASE</version>
</dependency>
```

核心配置文件 web.xml  

- (自定义配置文件的位置<init-param>：在resources目录下创建配置文件，new->XML Configuration File->Spring Config，然后在web.xml下指定自定义配置文件的位置即可)
- 之前servlet-name报错是因为没有设置servlet-mapping映射，设置完就不报错了

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">

        <!--声明：注册springmvc的核心对象DispatcherServlet

        需要在tomcat服务器启动后，创建DispatcherServlet对象实例

        为什么要创建DispatcherServlet对象的实例呢？
        因为在DispatcherServlet创建过程中，会同时创建springmvc容器对象，
        读取springmvc的配置文件，把这个配置文件中的对象都配置好，
        当用户发起请求时就可以直接使用对象了。

        servlet的初始化会执行init()方法，DispatcherServlet在init()中{
            //创建容器，读取配置文件
            webApplicationContext ctx = new ClassPathXmlApplicationContext("springmvc.xml");
            //把容器对象放入到ServletContext中
            getServletContext().setAttribute(key,ctx);
         }
    -->
    <servlet>
        <servlet-name>springmvc</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>

        <!--自定义springmvc读取文件的位置-->
        <init-param>
            <!--springmvc配置文件的位置属性-->
            <param-name>contextConfigLocation</param-name>
            <!--指定自定义文件的位置-->
            <param-value>classpath:springmvc.xml</param-value>
        </init-param>

        <!--表示在tomcat启动后，创建servlet对象
            数字表示启动后创建对象的顺序，数值越小，tomcat创建对象越早，要求大于等于0的整数
        -->
        <load-on-startup>1</load-on-startup>

    </servlet>

        <servlet-mapping>
            <servlet-name>springmvc</servlet-name>
            <!--
                使用框架的时候，url-pattern可以使用两种值
                1.使用扩展名方式，语法 *.xxxx , xxxx时自定义扩展名。常用的方式 *.do, *.action, *.mvc等等
                    http://localhost:8080/myweb/some.do
                    http://localhost:8080?myweb/other.do
                2.使用斜杠"/"
            -->
            <url-pattern>*.do</url-pattern>
        </servlet-mapping>
</web-app>
```

上面已经指定了中央调度器的位置，那么我们现在就在指定的位置创建springmvc.xml

- 声明组件扫描器(controller)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/context https://www.springframework.org/schema/context/spring-context.xsd">

<!--    声明组件扫描器-->
    <context:component-scan base-package="com.laj.controller"/>
</beans>
```

声明了Controller后，我们就在com.laj.controller.MyController.java 创建控制类
- 设置映射请求，new ModelAndView(),根据K-V的形式存放数据
- 设置数据返回的视图，setViewName 

```java
package com.laj.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * @Controller 创建处理器对象，对象放在SpringMVC容器中
 */
@Controller
public class MyController {
    /*
        处理用户的请求，SpringMVC中是使用方法来处理的
        方法是自定义的，可以有多种返回值，多种参数，方法名称自定义
     */

    /**
     * 准备使用doSome 方法处理some.do请求
     * @return
     */
    @RequestMapping(value = "/some.do")
    public ModelAndView doSome(){
        //处理some.do的请求
        ModelAndView mv = new ModelAndView();
        //K-V形式
        mv.addObject("msg1","Hello World!");
        mv.addObject("msg2","Hello World!!");

        mv.setViewName("/show.jsp");
        return mv;
    }
    @RequestMapping(value = "anny.do")
    public ModelAndView anny(){
        //处理some.do的请求
        ModelAndView mv = new ModelAndView();
        //K-V形式
        mv.addObject("value1","我是编程天才！");
        mv.addObject("value2","是的！");

        mv.setViewName("/show.jsp");
        return mv;
    }
}
```

上面设置了数据返回的视图后，我们开始创建视图

（由于我们一开始没有创建主页面，现在这里补上index.jsp）

```jsp
<%--
  Created by IntelliJ IDEA.
  User: 11877
  Date: 2021/7/4
  Time: 1:17
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
    <p>第一个MVC的项目</p>
    <p><a href="some.do">发起一个some.do请求</a></p>
    <p><a href="anny.do">发起一个anny.do请求</a></p>
</body>
</html>
```

在主页面中，有两个不同的请求页面， 根据不同的请求页面中，有两个不同的Controller类中的方法返回的值可以获取到。

接下来我们创建超链接里面的视图        数据通过 **${}** 的格式进行书写

```jsp
<%--
  Created by IntelliJ IDEA.
  User: 11877
  Date: 2021/7/4
  Time: 1:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
  <h3>show.jsp从request作用域获取数据</h3><br />
  <h4>msg1数据：${msg1}</h4>
  <h4>msg2数据：${msg2}</h4>
  <h4>msg2数据：${value1}</h4>
  <h4>msg2数据：${value2}</h4>

</body>
</html>
```

如此一个完整的SpringMVC 的demo就完成啦！

注意：文件的路径图

![img](https://upload-images.jianshu.io/upload_images/21293435-a53ce28aa78c1276.png?imageMogr2/auto-orient/strip|imageView2/2/w/473/format/webp)

