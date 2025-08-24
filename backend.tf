# Опційно: локальний бекенд для кореневого стану (тут нічого критичного не зберігаємо)
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}
