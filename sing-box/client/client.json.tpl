{
  "log": {
    "level": "info"
  },
  "dns": {
    "servers": [
      { 
	"tag": "google", 
	"type": "udp",
	"server": "8.8.8.8",
        "server_port": 53	
      }
    ],
    "independent_cache": true
  },
  "inbounds": [
    {
      "type": "mixed",
      "tag": "mixed-in",
      "listen": "127.0.0.1",
      "listen_port": 1080
    }
  ],
  "outbounds": [
    {
      "type": "naive",
      "tag": "proxy",
      "server": "${cer_domain}",
      "server_port": 443,
      "username": "${connection_login}",
      "password": "${connection_password}",
      "insecure_concurrency": 1,
      "udp_over_tcp": {
        "enabled": true
      },
      "quic": false,
      "tls": {
        "enabled": true,
        "server_name": "${cer_domain}"
      }
    },
    {
      "type": "direct",
      "tag": "direct"
    }
  ],
  "route": {
    "rules": [
	{
	  "inbound": "tun-in",
	  "action": "sniff"
	},
	{
	  "protocol": "dns",
	  "action": "hijack-dns"
	},
	{
	  "outbound": "proxy",
	  "clash_mode": "Global"
	},
	{
	  "outbound": "direct",
	  "clash_mode": "Direct"
	}
    ],
    "auto_detect_interface": true
  }
}

