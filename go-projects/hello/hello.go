package main

import (
	"fmt"
	"greetings"
	"log"
)

func main() {
	// 设置预定义Logger的属性，包括日志条目前缀和禁用打印的标志时间、源文件和行号。
	log.SetPrefix("greetings: ")
	log.SetFlags(0)

	// 一个名字切片
	names := []string{"Gladys", "Samantha", "Darrin"}

	message, err := greetings.Hellos(names)
	// 如果返回错误，则将期打印到控制台并退出程序。
	if err != nil {
		log.Fatal(err)
	}

	// 如果没有返回错误，则打印返回的消息到控制台。
	fmt.Println(message)
}
