package greetings

import "fmt"
import "errors"

// Hello 为指定的人返回问候语
func Hello(name string) (string, error) {
	if name == "" {
		return "", errors.New("empty name")
	}
	message := fmt.Sprintf("Hello, %v. Welcome!", name)
	return message, nil
}
