# GitHub代理设置方法


## 参考资料
- https://www.cnblogs.com/China-Dream/p/16476775.html
- https://gist.github.com/laispace/666dd7b27e9116faece6


## 配置
- https访问，仅对`git clone https://www.github.com/xxxx/xxxx.git`生效。

  - 全局代理
    ```shell
    git config --global http.proxy http://127.0.0.1:8001
    git config --global https.proxy https://127.0.0.1:8001
    ```
    
  - 只对GitHub进行代理
    ```shell
    git config --global http.https://github.com.proxy https://127.0.0.1:8001
    git config --global https.https://github.com.proxy https://127.0.0.1:8001
    ```


- ssh访问（使用Socks5协议），同样仅为github.com设置代理。

    - linux，配置文件`~/.ssh/config`, 没有的话新建一个。
      ```shell
      Host github.com
        User git
        ProxyCommand nc -v -x 127.0.0.1:1081 %h %p
      ```
    
    - windows，配置文件`%home%.ssh\config`, 没有的话新建一个。
      ```
      Host github.com
        User git
        Hostname ssh.github.com
        PreferredAuthentications publickey
        IdentityFile ~/.ssh/id_rsa
        Port 22
        ProxyCommand connect -S 127.0.0.1:1081 %h %p
      ```

## 说明
我没有配置过ssh的访问方式，我只配置过https的访问方式，发现配置后，挺稳定的。