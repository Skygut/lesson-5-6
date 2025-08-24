# AWS EKS Infrastructure with Terraform

Цей проєкт створює **VPC** та **EKS кластер** в AWS за допомогою Terraform.  
Інфраструктура мінімалістична:  
- VPC з публічними та приватними підмережами  
- EKS кластер з **двома node group**:
  - `main-ng` → `t3.medium`, **ON_DEMAND**
  - `cheap-ng` → `t3.micro`, **SPOT**  
- Увімкнено **IRSA** для майбутньої інтеграції IAM Roles for Service Accounts  

---

## 📂 Структура проєкту
    ```
    .
    ├── vpc/ # модуль для створення VPC 
    ├── eks/ # модуль для створення EKS
    ├── root/main.tf # підключає VPC та EKS разом
    ├── root/variables.tf # глобальні змінні
    ├── root/outputs.tf # ключові outputs (VPC + EKS + kubeconfig)
    └── README.md # цей файл

---

## Запуск

1. Підготовка

- Встанови [Terraform](https://developer.hashicorp.com/terraform/downloads) (>= 1.5.0).  
- Налаштуй AWS CLI з правами на створення ресурсів:  
   ```
   aws configure

2. Ініціалізація

    ```
    terraform init -upgrade

3. Перегляд плану

    ```
    terraform plan

4. Створення інфраструктури

    ```
    terraform apply -auto-approve

5. Перевірте, що кластер створено:

    ```
    aws eks --region <region> update-kubeconfig --name <your-cluster-name>`
    kubectl get nodes

6. Видалення інфраструктури

    ```
    terraform destroy -auto-approve

7. Видалення директорій і файлів рекурсивно, без підтвердження  

    ```
    rm -rf .terraform .terraform.lock.hcl    

Примітки:

Вартість інфраструктури залежить від вибраних інстансів.

Для економії cheap node group стартує з 0 нод.

IRSA вже увімкнено, можна додавати IAM Roles for Service Accounts.