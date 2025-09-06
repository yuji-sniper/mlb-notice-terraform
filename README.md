### 各環境のディレクトリに移動
```sh
$ cd {環境ディレクトリ}
```

### 各環境のディレクトリでbackend.tfとprovider.tfのシンボリックリンクを貼る
```sh
$ ln -sf ../../backend.tf backend.tf
$ ln -sf ../../provider.tf provider.tf
```

### init
```sh
$ terraform init -backend-config=backend.config
```

### plan、apply
```sh
$ terraform plan
$ terraform apply
```
