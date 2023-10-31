resource "yandex_iam_service_account" "this" {
  name        = "sa-vmgroup"
  description = "Service Account to manage VM Instance Group"
}

data "yandex_resourcemanager_folder" "this" {
  folder_id = "b1g186e1hu9ti1gg53rf"
}

resource "yandex_resourcemanager_folder_iam_binding" "this" {
  folder_id = "${data.yandex_resourcemanager_folder.this.id}"

  role = "editor"

  members = [
    "serviceAccount:${yandex_iam_service_account.this.id}",
  ]
}
