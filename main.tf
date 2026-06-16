# делаем клиентский конфиг
resource "local_file" "client_json" {
    content  = templatefile("${path.module}/sing-box/client/client.json.tpl", {
        connection_login = var.connection_login
        connection_password = var.connection_password
        cer_domain = var.cer_domain
    })
    filename = "${path.module}/client_config/client.json"
}

# создаём серверные конфиги из шаблонов
resource "local_file" "caddyfile" {
    content  = templatefile("${path.module}/sing-box/caddy/Caddyfile.tpl", {
        cer_email  = var.cer_email
        cer_domain = var.cer_domain
        base64creds = base64encode("${var.connection_login}:${var.connection_password}")
    })
    filename = "${path.module}/.tmp/Caddyfile"
}
resource "local_file" "sb_config_json" {
    content  = templatefile("${path.module}/sing-box/sing-box/config.json.tpl", {
        connection_login = var.connection_login
        connection_password = var.connection_password
    })
    filename = "${path.module}/.tmp/config.json"
}

resource "null_resource" "deploy" {
    depends_on = [
        local_file.caddyfile,
        local_file.sb_config_json
    ]

    # Подключение к физическому серверу
    connection {
        type = "ssh"
        host = var.server_ip
        user = var.server_user
        password = var.server_password
        timeout = "90s"
    }

    # копируем конфиги
    provisioner "remote-exec" {
        inline = [
            # Создаём все необходимые директории
            "mkdir -p /opt/sing-box/caddy",
            "mkdir -p /opt/sing-box/sing-box",
            "mkdir -p /opt/sing-box/site",
            # на всякий случай сохраним текущие конфиги
            "cp /opt/sing-box/sing-box/config.json /opt/sing-box/sing-box/config.json.bak || true",
            "cp /opt/sing-box/caddy/Caddyfile /opt/sing-box/caddy/Caddyfile.bak || true",
        ]
    }

    # Копирование файлов
    provisioner "file" {
        source      = "${path.module}/sing-box/docker-compose.yml"
        destination = "/opt/sing-box/docker-compose.yml"
    }
    provisioner "file" {
        source      = "${path.module}/.tmp/Caddyfile"
        destination = "/opt/sing-box/caddy/Caddyfile"
    }
    provisioner "file" {
        source      = "${path.module}/.tmp/config.json"
        destination = "/opt/sing-box/sing-box/config.json"
    }
    provisioner "file" {
        source      = "${path.module}/sing-box/site/index.html"
        destination = "/opt/sing-box/site/index.html"
    }

    # перезапуск контейнеров
    provisioner "remote-exec" {
        inline = [
            # перейдём в каталог 
            "cd /opt/sing-box",
            # перезапустим docker
            "docker-compose up -d --force-recreate",
            # на всякий случай покажем последние логи из docker
            "docker-compose logs --tail=50",
            # чистим мусор
            "docker system prune -f"
        ]
    }
}
