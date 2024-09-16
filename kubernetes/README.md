### Таблетка для памяти

* Генерация конфига для работы с GitLab Registy

  https://chris-vermeulen.com/using-gitlab-registry-with-kubernetes/

Кодирование в base64
```bash
cat .dockerconfigjson | base64
```
Создание ключа для работы сервисного аккаунта:
```bash
yc iam key create \
  --service-account-name <имя_сервисного_аккаунта> \
  --format json \
  --output key.json
```
Установка в кластер VPA
```bash
git clone https://github.com/kubernetes/autoscaler.git && \
cd autoscaler/vertical-pod-autoscaler/hack && \
./vpa-up.sh 
```

Установка в кластер cert-manager для работы с сертификатами SSL:
```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.15.3/cert-manager.yaml
kubectl apply -f http01-clusterissuer.yaml
```

Установка приложения:
```bash
kubectl apply -f ./http01-clusterissuer.yaml
kubectl apply -f backend
kubectl apply -f frontend
```