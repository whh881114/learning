package greetings

import (
	"errors"
	"fmt"
	"math/rand"
	"time"
)

// Hello 为指定的人返回问候语
func Hello(name string) (string, error) {
	// 如果没有给出名字，返回一个带有错误的消息。
	if name == "" {
		return "", errors.New("empty name")
	}

	// 使用随机格式创建消息。
	message := fmt.Sprintf(randomFormat(), name)
	return message, nil
}

// Hellos 返回一个map，该map将每个已命名的人员与问候消息相关联。
func Hellos(names []string) (map[string]string, error) {
	// 将名称与消息关联的map。
	messages := make(map[string]string)

	// 遍历接收到的名称切片，调用Hello函数为每个名字获取一条消息。
	for _, name := range names {
		message, err := Hello(name)
		if err != nil {
			return nil, err
		}

		// 在map中，将检索到的消息与名称相关联。
		messages[name] = message
	}
	return messages, nil

}

// init为函数中使用的变量设置初始值。
func init() {
	rand.Seed(time.Now().UnixNano())
}

func randomFormat() string {
	formats := []string{
		"Hi, %v. Welcome!",
		"Great to see you, %v!",
		"Hail, %v! Well met!",
	}

	return formats[rand.Intn(len(formats))]
}
