# Деплой на удалённый сервер

## 1. Генерируем SSH-ключи

```bash
ssh-keygen
``` 

## 2. Копируем публичный ключ на сервер

В конце выполнения команды из пункта 1 будет указано расположение публичного ssh-ключа. В моём случае используется команда:

```bash
ssh-copy-id -i ~/.ssh/id_ed.pub user@server_ip
```

Проверить, получилось ли, можно с помощью команды:

```bash
ssh user@server_ip
```

## 3. Передаём проект на сервер

```bash
tar -czf project.tar.gz --exclude=.git --exclude=access.log .  # собираем в архив без git и лога
scp project.tar.gz user@server_ip:/home/user/  # пересылаем по ssh собранный архив
ssh user@server_ip "mkdir -p ~/infra-monitoring && tar -xzf ~/project.tar.gz -C ~/infra-monitoring"  # распаковываем проект из архива на сервере 
```

## 4. Запускаем на сервере

```bash
docker compose up -d
```

Проверить можно командой:

```bash
curl http://localhost:80
```
