{
  "log": {
    "level": "info",
    "output": "/var/lib/sing-box/sing-box.log",
    "timestamp": true
  },
  "inbounds": [
    {
      "type": "naive",
      "tag": "naive-in",
      "network": "tcp",
      "listen": "0.0.0.0",
      "listen_port": 1080,
      "users": [
        {
          "username": "${connection_login}",
          "password": "${connection_password}"
        }
      ]
    }
  ],
  "outbounds": [
    {
      "type": "direct",
      "tag": "direct"
    }
  ]
}
