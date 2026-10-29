# QUICTun OpenWrt Package

OpenWrt packaging for [QUICTun](https://github.com/karen07/QUICTun), a WireGuard-oriented
UDP tunnel with a QUIC control plane and a session-bound custom data plane. It installs
the daemon, init script, and UCI configuration.

Пакет OpenWrt для [QUICTun](https://github.com/karen07/QUICTun), UDP-туннеля WireGuard с
плоскостью управления QUIC и отдельной собственной плоскостью данных, привязанной к сессии.
Пакет устанавливает демон, init-скрипт и конфигурацию UCI.

## Описание

Пакет связывает конфигурацию UCI с запуском демона QUICTun через сервис OpenWrt.
Настройки хранятся в `/etc/config/QUICTun`; для работы пакета необходим OpenSSL.

При разработке Makefile может собирать исходники из соседнего каталога `../QUICTun`. Если такого каталога нет, OpenWrt загружает версию исходников по тегу, заданному в `PKG_VERSION`.

## Разработка и проверка изменений

**Основные точки изменения:**

- `QUICTun/Makefile` - зависимости, версия и правила установки (демон и UCI-конфигурация);
- `QUICTun/files/etc/init.d/QUICTun` - автозапуск и управление сервисом OpenWrt;
- `QUICTun/files/etc/config/QUICTun` - UCI-конфигурация сервиса;
- `openwrt-build.env` - параметры сборки для общего CI;
- `.github/workflows/openwrt-build.yml` - вызов переиспользуемого OpenWrt workflow.

**Проверка изменений:** Изменения функциональности: исходный протокол и тесты находятся в отдельном `QUICTun`. Для упаковки проверяйте `Makefile`, `openwrt-build.env` и CI вместе; тестируйте итоговый пакет на нужной версии OpenWrt, поскольку сборка приложения сама по себе не проверяет установку и зависимости.

**Выбор исходников:** `QUICTun/Makefile` копирует соседние исходники `QUICTun` при наличии их `CMakeLists.txt`, иначе получает Git-тег `v$(PKG_VERSION)`. При проверке нового релиза отличайте локальную сборку от сборки по тегу; пакет устанавливает бинарник, init-скрипт и `/etc/config/QUICTun`.

**Контракт UCI и демона:** `QUICTun/files/etc/init.d/QUICTun` читает секции
`instance` из `/etc/config/QUICTun`, пропускает экземпляры с `enabled=0`
и создаёт временный конфиг `/tmp/QUICTun/<имя-секции>.conf` с `[Interface]`.
Непустые опции `QuicEndpoint`, `WgListen`, `QuicListen`, `CertsPath`,
`SNI`, `LogPath` и `StatPath` записываются в этот конфиг. Секции `peer`
включаются как `[Peer]` только при совпадении `instance` с именем
экземпляра и наличии одновременно `PeerCertSHA256` и `WgEndpoint`.
После этого procd запускает `/usr/bin/QUICTun` с путём конфигурации.

**Типовые изменения:** при добавлении UCI-поля синхронизируйте шаблон
`QUICTun/files/etc/config/QUICTun`, `write_opt()` в init-скрипте и парсер
конфигурации в основном проекте `QUICTun`. Для новых полей `peer`
изменяйте `write_peer_section()` и серверный парсер совместно. Изменения
имени UCI-сервиса должны затрагивать `config_load`, reload-trigger и путь
конфигурации; сам протокол не реализован в этом репозитории.

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
