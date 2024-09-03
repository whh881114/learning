template {
    source = "[[ root_dir ]]/01-k8s-apiserver.ctmpl"
    destination = "/etc/haproxy/conf.d/01-k8s-apiserver.cfg"
    command = "/usr/bin/systemctl reload haproxy"
    command_timeout = "60s"
    perms = 0644
    backup = true
    left_delimiter  = "{{"
    right_delimiter = "}}"
    wait {
        min = "30s"
        max = "120s"
    }
}

template {
    source = "[[ root_dir ]]/02-k8s-ingress-istio.ctmpl"
    destination = "/etc/haproxy/conf.d/02-k8s-ingress-istio.cfg"
    command = "/usr/bin/systemctl reload haproxy"
    command_timeout = "60s"
    perms = 0644
    backup = true
    left_delimiter  = "{{"
    right_delimiter = "}}"
    wait {
        min = "30s"
        max = "120s"
    }
}

template {
    source = "[[ root_dir ]]/03-k8s-ingress-nginx.ctmpl"
    destination = "/etc/haproxy/conf.d/03-k8s-ingress-nginx.cfg"
    command = "/usr/bin/systemctl reload haproxy"
    command_timeout = "60s"
    perms = 0644
    backup = true
    left_delimiter  = "{{"
    right_delimiter = "}}"
    wait {
        min = "30s"
        max = "120s"
    }
}
