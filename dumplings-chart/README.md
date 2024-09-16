Установка инструмента HELM
```
$ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
$ chmod 700 get_helm.sh
$ ./get_helm.sh
```

Структура dumplings-chart:
```
dumplings-chart/
├── charts
│   ├── backend
│   │   ├── Chart.yaml
│   │   └── templates
│   │       ├── deployment.yaml
│   │       ├── secrets.yaml
│   │       └── service.yaml
│   └── frontend
│       ├── Chart.yaml
│       └── templates
│           ├── configmap.yaml
│           ├── deployment.yaml
│           ├── secrets.yaml
│           └── service_and_ingress.yaml
├── Chart.yaml
├── README.md
└── values.yaml
```

Установка приложения из консоли:
```bash
helm upgrade --install dumplings-store \ 
--set global.dockerconfigjson=${DOCKER_CONFIG} \
--set global.frontend.AppVersion=latest \
--set global.backend.AppVersion=latest \
--set global.frontend.fqdn=${FQDN} \
--atomic \
./dumplings-chart/
```