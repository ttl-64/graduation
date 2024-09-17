# Описание дипломной работы

### Название магазина: Dumplings-Store aka Пельменная №2
#### Магазин доступен 24/7 по ссылке: https://pelmeniyaroslava.ru/
Внешний вид сайта.
<img width="900" alt="image" src="https://user-images.githubusercontent.com/9394918/167876466-2c530828-d658-4efe-9064-825626cc6db5.png">
>
> **Инфраструктура**
>
В качестве платформы размещения инфраструктуры пельменной выбрано облако провайдера Yandex Cloud.
Инфраструктура развернута с помощью таких сервисов провайдера как:
- ***Virtual Private Cloud***
- ***Managed Service for K8s***
- ***Compute Cloud***
- ***Network Load Balancer (NGINX Ingress controller)***
- ***Cloud DNS***
- ***Object Storage***

Инфраструктура была мною описана и развернута с помощью подхода IaC - манифестами Terraform. Состояние инфраструктуры хранится в S3-бакете у провайдера Yandex Cloud.
Манифесты, подробное описание и инструкции по разворачиванию инфраструктуры можно найти в директории "./terraform"
Разворачивание инфраструктуры выполняется в ручном режиме.
>
> **Программные компоненты приложения магазина**
>
Магазин состоит и двух частей:
* Frontend - визуальная часть магазина (html+js+css npm).
* Backend - отвечает за работу пользователей с базой магазина и оформление заказа. Написан на языке GoLang.

Доставка изменений в компонентах на готовую инфраструктуру автоматизирована с помощью инструментов CI/CD GitLab.
При внесения изменений происходит инициализация работы CI/CD через Pipeline компоненты, которая включает в себя следующие этапы:
- сборка из исходного кода для сохранения артефакта в GitLab ([ссылка](https://nexus.praktikum-services.tech/service/rest/repository/browse/yarsvat-backend-raw/) на пример)
- создание Docker-образа. Docker-файлы находятся в соответсвующих каталогах компонентов.
- тестирование на уязвимости и ошибки по SAST через SonarQube ([ссылка](https://sonarqube.praktikum-services.ru/dashboard?id=YARSVAT_DIPLOM_BACKEND) на пример)
- релиз Docker-образа и доставка его в GitLab Registry. Docker-образ тегируется в соответствии с политикой SemVer и начинается с 1.0.${CI_PIPELINE_ID}
- доставка нового образа контейнера на инфраструктуру в YandexCloud в поды под управлением оркестратора Kubernetes через инструмент развертывания Helm. Helm Chart`ы находятся в директории "./dumplings-chart". Непосредственно деплой осуществляется через helm upgrade. Обновление подов с контейнером с помощью политики RollingUpdate.

Подробное описание работы сцераниев CI/CD можно найти:
    - ./.gitlab-ci.yml
    - ./backend/.gitlab-ci.yml
    - ./frontend/.gitlab-ci.yml
>
> **Доступность магазина из сети Интернет**
>
Для работы магазина в сети Интернет выполнена установка ingress-nginx-controller от Yandex Cloud, запрос статического внешнего IP адреса и делегирование домена DNS серверам Яндекса, а для безопасной работы с пользователями по протоколу https была настроена процедура автоматического подписания сертификата методом http01 с ЦС "Let's Encrypt".
>
> **Мониторинг работы инфраструктуры и приложения магазина**
>
Успешно внедрен мониторинг работы инфраструктуры и приложения магазина с помощью инструментов:
* Grafana - визуализация процессов ([ссылка](https://grafana-monitoring.pelmeniyaroslava.ru/))
admin / 83bzxHvbrytKjQ7
* Loki - сбор логов с контейнеров платформы
* Prometheus - сбор метрик с приложения Backend`а с помощью Auto-Discovery ([ссылка](https://prometheus-monitoring.pelmeniyaroslava.ru))

>
> **Локальная установка и отладка для разработчиков**
>

##### Frontend

```bash
cd frontend
npm install
NODE_ENV=production VUE_APP_API_URL=http://localhost:8081 npm run serve
```

##### Backend

```bash
cd backend
go run ./cmd/api
go test -v ./... 
```

### Структура проекта:
```
dumplings/
├── backend
│   ├── cmd
│   │   └── api
│   │       ├── app
│   │       │   ├── app.go
│   │       │   ├── app_test.go
│   │       │   ├── controller_auth.go
│   │       │   ├── controller_create_order.go
│   │       │   ├── controller_list_categories.go
│   │       │   ├── controller_list_dumplings.go
│   │       │   └── middleware.go
│   │       ├── dependencies
│   │       │   └── store.go
│   │       ├── main.go
│   │       └── router.go
│   ├── Dockerfile
│   ├── go.mod
│   ├── go.sum
│   └── internal
│       ├── logger
│       │   └── logger.go
│       └── store
│           └── dumplings
│               ├── fake
│               │   └── store.go
│               ├── mock
│               │   └── store.gen.go
│               ├── models.go
│               └── store.go
├── dumplings-chart
│   ├── charts
│   │   ├── backend
│   │   │   ├── Chart.yaml
│   │   │   └── templates
│   │   │       ├── deployment.yaml
│   │   │       ├── secrets.yaml
│   │   │       └── service.yaml
│   │   └── frontend
│   │       ├── Chart.yaml
│   │       └── templates
│   │           ├── configmap.yaml
│   │           ├── deployment.yaml
│   │           ├── secrets.yaml
│   │           └── service_and_ingress.yaml
│   ├── Chart.yaml
│   └── values.yaml
├── frontend
│   ├── babel.config.js
│   ├── Dockerfile
│   ├── package.json
│   ├── package-lock.json
│   ├── public
│   │   ├── favicon.ico
│   │   ├── index.html
│   │   └── _redirects
│   ├── src
│   │   ├── App.vue
│   │   ├── assets
│   │   │   └── logo.png
│   │   ├── components
│   │   │   ├── cart
│   │   │   │   ├── CartTableRow.vue
│   │   │   │   └── CartTable.vue
│   │   │   ├── catalog
│   │   │   │   ├── CartCardRow.vue
│   │   │   │   ├── CartCard.vue
│   │   │   │   ├── Filters.vue
│   │   │   │   ├── Pagination.vue
│   │   │   │   ├── Products.vue
│   │   │   │   ├── Product.vue
│   │   │   │   └── Search.vue
│   │   │   ├── misc
│   │   │   │   ├── Alert.vue
│   │   │   │   ├── Center.vue
│   │   │   │   └── Spinner.vue
│   │   │   ├── navbar
│   │   │   │   ├── CartIcon.vue
│   │   │   │   ├── index.ts
│   │   │   │   └── Navbar.vue
│   │   │   └── profile
│   │   │       └── ChangePassword.vue
│   │   ├── main.ts
│   │   ├── models
│   │   │   ├── category.model.ts
│   │   │   ├── pagination.model.ts
│   │   │   └── product.model.ts
│   │   ├── router
│   │   │   └── index.ts
│   │   ├── services
│   │   │   ├── api.service.ts
│   │   │   └── resources
│   │   │       ├── base.service.ts
│   │   │       ├── categories.service.ts
│   │   │       ├── non_paginated.service.ts
│   │   │       ├── paginated.service.ts
│   │   │       └── products.service.ts
│   │   ├── shims-vue.d.ts
│   │   ├── shims-vuex.d.ts
│   │   ├── store
│   │   │   └── index.ts
│   │   ├── typings
│   │   │   └── index.ts
│   │   └── views
│   │       ├── 404.vue
│   │       ├── Cart.vue
│   │       ├── Catalog.vue
│   │       ├── Login.vue
│   │       └── Profile.vue
│   ├── tsconfig.json
│   └── vue.config.js
├── kubernetes
│   ├── backend
│   │   ├── deployment.yaml
│   │   ├── secrets.yaml
│   │   └── service.yaml
│   ├── frontend
│   │   ├── configmap.yaml
│   │   ├── deployment.yaml
│   │   ├── ingress.yaml
│   │   ├── secrets.yaml
│   │   └── service.yaml
│   ├── http01-clusterissuer.yaml
│   └── readme
├── monitoring-tools
│   ├── alertmanager
│   │   ├── Chart.yaml
│   │   ├── templates
│   │   │   ├── configmap.yaml
│   │   │   ├── deployment.yaml
│   │   │   ├── _helpers.tpl
│   │   │   ├── ingress.yaml
│   │   │   └── services.yaml
│   │   └── values.yaml
│   ├── grafana
│   │   ├── Chart.yaml
│   │   ├── dashboards
│   │   │   └── Kubernetes___Compute_Resources___Pod.json
│   │   ├── templates
│   │   │   ├── deployment.yaml
│   │   │   ├── _helpers.tpl
│   │   │   ├── pvc.yaml
│   │   │   └── services.yaml
│   │   └── values.yaml
│   ├── prometheus
│   │   ├── Chart.yaml
│   │   ├── clusterrole.yaml
│   │   ├── rules
│   │   │   └── dumplings-store.yaml
│   │   ├── templates
│   │   │   ├── configmap.yaml
│   │   │   ├── deployment.yaml
│   │   │   ├── rules.yaml
│   │   │   └── services.yaml
│   │   └── values.yaml
│   └── README.md
├── README.md
└── terraform
    ├── main.tf
    ├── outputs.tf
    ├── provider.tf
    ├── README.md
    ├── terraform.tfvars
    ├── variables.tf
    └── versions.tf
```

P.S. Все секреты добавлены в Variables CI/CD GitLab
P.S.S. С 12.09.2024 магазин не работает
