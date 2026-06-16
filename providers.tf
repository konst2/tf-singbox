terraform {
    required_version = ">= 1.13,<=2"

    
    required_providers {
        # провайдер null будет использован для прямого подключения к физическому серверу
        null = {
            source  = "hashicorp/null"
            version = "~> 3.2"
        }

        # local -- провайдер для рвботы с локальными файлами (чтобы заполнить шаблоны)
        local = {
            source  = "hashicorp/local"
            version = "~> 2.4"
        }

    }

}

