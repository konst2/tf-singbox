# подключение к серверу
variable "server_ip" {
    description = "IP for ssh connection to deploy server"
}
variable "server_user" {
    description = "Linux user for ssh connection to deploy server"
    sensitive = true
}
variable "server_password" {
    description = "Password for linux user (default ssh connection method for my VPS hoster)"
    sensitive = true
}

# переменные для конфигов
variable "connection_login" {
    description = "Login for sing-box connection"
    sensitive = true
}
variable "connection_password" {
    description = "Password for sing-box connection"
    sensitive = true
}

# Certificate data
variable "cer_domain" {
    description = "domain for TLS connection"
}
variable "cer_email" {
    description = "email for let's encrypt registration"
}
