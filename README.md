# QUICTun OpenWrt Package

OpenWrt packaging for [QUICTun](https://github.com/karen07/QUICTun), a WireGuard-oriented
UDP tunnel with a QUIC control plane and a session-bound custom data plane. It installs
the daemon, init script, and UCI configuration.

Пакет OpenWrt для [QUICTun](https://github.com/karen07/QUICTun), UDP-туннеля WireGuard с
плоскостью управления QUIC и отдельной плоскостью данных, привязанной к сессии. Пакет
устанавливает демон, init-скрипт и конфигурацию UCI.

## Описание

Конфигурация UCI хранится в `/etc/config/QUICTun`. Для работы пакета необходим OpenSSL.

При разработке Makefile может собирать исходники из соседнего каталога `../QUICTun`. Если такого каталога нет, OpenWrt загружает версию исходников по тегу, заданному в `PKG_VERSION`.

## Разработка и проверка изменений

**Основные точки изменения:**

- `QUICTun/Makefile` - зависимости, версия и правила установки (демон и UCI-конфигурация);
- `QUICTun/files/etc/init.d/QUICTun` - автозапуск и управление сервисом OpenWrt;
- `QUICTun/files/etc/config/QUICTun` - UCI-конфигурация сервиса;
- `openwrt-build.env` - параметры сборки для общего CI;
- `.github/workflows/openwrt-build.yml` - вызов переиспользуемого OpenWrt workflow.

**Проверка изменений:** Изменения функциональности: исходный протокол и тесты находятся в отдельном `QUICTun`. Для упаковки проверяйте `Makefile`, `openwrt-build.env` и CI вместе; тестируйте итоговый пакет на нужной версии OpenWrt, поскольку сборка приложения сама по себе не проверяет установку и зависимости.

## Сборка

Сборка выполняется через GitHub Actions. Workflow этого репозитория вызывает общий reusable workflow из [openwrt-package-ci](https://github.com/karen07/openwrt-package-ci).

CI можно запустить:

- push тега вида `vX.Y.Z` - значение тега используется как версия OpenWrt;
- вручную через `workflow_dispatch`, указав версию OpenWrt и при необходимости фильтры target/subtarget.

Параметры этого пакета хранятся в `openwrt-build.env`. Общие `openwrt-build.sh`, `openwrt-matrix.py` и логика сборки через OpenWrt SDK находятся в `openwrt-package-ci`.

Для ручной сборки каталог `QUICTun/` можно использовать как обычный package directory внутри OpenWrt buildroot/SDK.

## Структура проекта

- `QUICTun/Makefile` - описание OpenWrt package;
- `QUICTun/files/etc/init.d/QUICTun` - init script;
- `QUICTun/files/etc/config/QUICTun` - UCI configuration;
- `openwrt-build.env` - параметры пакета для общего CI;
- `.github/workflows/openwrt-build.yml` - вызов общего reusable workflow.

## Связанные проекты

- [QUICTun](https://github.com/karen07/QUICTun) - основной проект, архитектура протокола, конфигурация и тестовый стенд.

## Лицензия

Проект распространяется под лицензией GNU Affero General Public License v3.0. Подробности см. в файле [LICENSE](LICENSE).
