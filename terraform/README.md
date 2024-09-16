1. Получить токен работы с провайдером [YandexCloud](https://yandex.cloud/ru/docs/tutorials/infrastructure-management/terraform-quickstart) через CLI Terraform:
```bash
export YC_TOKEN=$(yc iam create-token)
```
2. Создать файл в корне каталога для переменных, например, vars.tfvars и заполнить следующим содержимым:
```bash
cloud_id  = ""
folder_id = ""
zone = ""
service_account_name = ""
k8s_cluster_name = ""
k8s_group_name = ""
dns_zone_name = ""
dns_zone = ""
dns_public_access = bool
nodes_scale_size = num
node_disk_size = num
```
Дополнительные переменные можно взять из файла variables.tf

3. Выполнить команды в консоли из директории terraform/
```bash
terraform validate
terraform plan -var-file="vars.tfvars"
terraform apply -var-file="vars.tfvars"
```
4. Получить конфигурационный файл ~/.kube/config для работы с инфраструктурой с помощью CLI kuberctl или helm
```bash
yc managed-kubernetes cluster get-credentials --id <cluster_id> --external
```
5. Проверить корректность работы:
```bash
kubectl get cluster-info
```
6. Получать удовольствие от работы с инфраструктурой с помощью доступных инструментов на вашем АРМ.

Структура директории terraform/
```
terraform/
├── main.tf
├── outputs.tf
├── provider.tf
├── README.md
├── terraform.tfvars
├── variables.tf
└── versions.tf
```