{
    email ${cer_email}
    auto_https disable_redirects
}

:443, https://${cer_domain} {
    tls {
        issuer acme {
            disable_http_challenge
        }
    }

    route {
        @naive {
            method CONNECT
            header Proxy-Authorization "Basic ${base64creds}"
        }

        handle @naive {
            reverse_proxy h2c://sing-box:1080 {
                header_up Proxy-Authorization {header.Proxy-Authorization}
            }
        }

        handle {
            root * /var/www/html
            file_server
        }
    }
}
