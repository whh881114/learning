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
