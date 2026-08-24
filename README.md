# QUICTun OpenWrt package

This repository contains the OpenWrt package definition for [QUICTun](https://github.com/karen07/QUICTun), a WireGuard-oriented UDP tunnel with a QUIC control plane and a session-bound custom data plane.

The package installs the QUICTun binary together with an OpenWrt init script and persistent UCI configuration in `/etc/config/QUICTun`. It depends on OpenSSL.

For development, the Makefile can build from a sibling `../QUICTun` checkout. Otherwise OpenWrt fetches the tagged upstream source specified by `PKG_VERSION`.

## Описание

Этот репозиторий содержит описание пакета OpenWrt для [QUICTun](https://github.com/karen07/QUICTun), UDP-туннеля для WireGuard с плоскостью управления QUIC и собственной плоскостью данных, привязанной к сессии.

Пакет устанавливает бинарный файл QUICTun вместе со скриптом запуска OpenWrt и постоянной конфигурацией UCI `/etc/config/QUICTun`. Пакет зависит от OpenSSL.

При разработке Makefile может собирать исходники из соседнего каталога `../QUICTun`. Если такого каталога нет, OpenWrt загружает версию исходников по тегу, заданному в `PKG_VERSION`.

## Что находится в репозитории

- `QUICTun/Makefile` - описание OpenWrt package;
- `QUICTun/files/etc/init.d/QUICTun` - init script;
- `QUICTun/files/etc/config/QUICTun` - UCI configuration;
- `openwrt-build.env` - параметры пакета для общего CI;
- `.github/workflows/openwrt-build.yml` - вызов общего reusable workflow.

## Сборка

Сборка выполняется через GitHub Actions. Workflow этого репозитория вызывает общий reusable workflow из [openwrt-package-ci](https://github.com/karen07/openwrt-package-ci).

CI можно запустить:

- push тега вида `vX.Y.Z` - значение тега используется как версия OpenWrt;
- вручную через `workflow_dispatch`, указав версию OpenWrt и при необходимости фильтры target/subtarget.

Параметры этого пакета хранятся в `openwrt-build.env`. Общие `openwrt-build.sh`, `openwrt-matrix.py` и логика сборки через OpenWrt SDK находятся в `openwrt-package-ci`.

Для ручной сборки каталог `QUICTun/` можно использовать как обычный package directory внутри OpenWrt buildroot/SDK.

## Связанные проекты

- [QUICTun](https://github.com/karen07/QUICTun) - основной проект, архитектура протокола, конфигурация и тестовый стенд.
