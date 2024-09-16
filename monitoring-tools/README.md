# Мониторинг
Подготовка, если установка происходит в default namespace:
```
kubectl apply -f clusterrole.yaml
```
```
kubectl create clusterrolebinding service-reader-pod \
  --clusterrole=service-reader  \
  --serviceaccount=default:default
```

Установка prometheus, grafana, alertmanager
```
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm upgrade --install loki grafana/loki-stack --namespace {{ название неймспейса }} 
helm upgrade --atomic --install prometheus --namespace {{ название неймспейса }} prometheus
helm upgrade --atomic--install grafana --namespace {{ название неймспейса }} grafana
helm upgrade --atomic --install alertmanager --namespace {{ название неймспейса }} alertmanager
```
Пароль по умолчанию от Grafana
admin\admin


* Формирование урлов для внешнего подключения
* prometheus-monitoring.{{ .Values.global.frontend.fqdn }} - prometheus
* grafana-monitoring.{{ .Values.global.frontend.fqdn }} - grafana
* alertmanager-monitoring.{{ .Values.global.frontend.fqdn }} - alertmanager

Структура чартов

```
├── alertmanager
│   ├── Chart.yaml
│   ├── templates
│   │   ├── _helpers.tpl
│   │   ├── configmap.yaml
│   │   ├── deployment.yaml
│   │   ├── ingress.yaml
│   │   └── services.yaml
│   └── values.yaml
├── grafana
│   ├── Chart.yaml
│   ├── templates
│   │   ├── _helpers.tpl
│   │   ├── deployment.yaml
│   │   ├── ingress.yaml
│   │   ├── pvc.yaml
│   │   └── services.yaml
│   └── values.yaml
└── prometheus
    ├── Chart.yaml
    ├── prom-app-example.yaml
    ├── rules
    │   └── test.rules
    ├── templates
    │   ├── configmap.yaml
    │   ├── deployment.yaml
    │   ├── ingress.yaml
    │   ├── rules.yaml
    │   └── services.yaml
    └── values.yaml
```



