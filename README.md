# LaravelをDockerで動かすための設定ファイル

 <pre> git clone https://github.com/fkdgk/laravel-docker.git
 cd laravel-docker
 docker-compose up -d --build site</pre>


## Laravelのインストール
<dl>
  <dt><h3>最新版のLaravelを使う場合  <small> （※ 末尾の” . ”を忘れずに）</small></h3></dt>
  <dd>
    <pre> docker-compose run --rm  composer create-project laravel/laravel . </pre>
  </dd>
  <dt><h3>バージョン指定してLaravelを使う場合  <small> （※ 末尾の” . ”を忘れずに）</small></h3></dt>
  <dd>
    <pre>  docker-compose run --rm  composer create-project "laravel/laravel=7.3.*" . </pre>
  </dd>
</dl>

## WEBページの表示確認
[http://localhost/](http://localhost/)


<!-- <dl>
  <dt><h3>Laravelのバージョン確認</h3></dt>
  <dd>
    <pre> docker-compose run --rm artisan -V </pre>
  </dd>
</dl> -->

<!-- ## App keyの生成
 <pre>docker-compose run --rm artisan key:generate</pre>
 -->

 ## 設定ファイル書き換え
 <pre>vim src/.env</pre>

 ## .envのmysqlの箇所を書き換え
<pre>
 DB_CONNECTION=mysql
 DB_HOST=mysql
 DB_PORT=3306
 DB_DATABASE=homestead
 DB_USERNAME=homestead
 DB_PASSWORD=secret
 </pre>

## Migrations - DB接続確認
 <pre>docker-compose run --rm artisan migrate </pre>

## Dockerのインスタンスからcomposerを使えるようにする
 <pre>mv composer_install.sh src</pre>

### Dockerへログイン
<pre>docker-compose exec php sh</pre>

### composer install
<pre>sh composer_install.sh</pre>

### Dockerからcomposerとartisanを実行する
<pre>php composer -V</pre>
<pre>php artisan -V</pre>

## Mysql接続情報
|内容|項目|
|--|--|
|ユーザ|homestead|
|パスワード|secret|
|ポート|4306|
|DB名|homestead|
|ホスト|127.0.0.1|

### MySqlへコマンドラインからアクセス
<pre>mysql -uhomestead -psecret -P4306 -h127.0.0.1 homestead
> show tables</pre>

## Dockerの終了
<pre>docker-compose stop</pre>

## Dockerの起動
<pre>docker-compose up -d --build site</pre>

### Auth
<pre>docker-compose run --rm composer require laravel/ui 
docker-compose run --rm artisan ui bootstrap --auth 
docker-compose run --rm npm install 
docker-compose run --rm npm run dev</pre>

## command
- `composer：docker-compose run --rm composer install`
- `artisan：docker-compose run --rm artisan migrate` 
- `npm：docker-compose run --rm npm run dev`

---

### phpMyAdmin を使う場合 docker-compose.ymlに以下を追加
<pre>
phpmyadmin:
  image: phpmyadmin/phpmyadmin
  environment:
    - PMA_ARBITRARY=1
    - PMA_HOST=mysql
    - PMA_USER=homestead
    - PMA_PASSWORD=secret
  links:
    - mysql
  ports:
    - 8080:80
  volumes:
    - /sessions
  networks:
    - laravel
</pre>

[http://localhost:8080](http://localhost:8080)

---

### Port
- **nginx** - `:80`
- **mysql** - `4306:3306`
- **phpmyadmin** - `8080:80`
- **php** - `:9000`
- **redis** - `:6379`
- **mailhog** - `:8025` 

# docker-compose-laravel
A pretty simplified Docker Compose workflow that sets up a LEMP network of containers for local Laravel development. You can view the full article that inspired this repo [here](https://dev.to/aschmelyun/the-beauty-of-docker-for-local-laravel-development-13c0).


## Usage

To get started, make sure you have [Docker installed](https://docs.docker.com/docker-for-mac/install/) on your system, and then clone this repository.

Next, navigate in your terminal to the directory you cloned this, and spin up the containers for the web server by running `docker-compose up -d --build site`.

After that completes, follow the steps from the [src/README.md](src/README.md) file to get your Laravel project added in (or create a new blank one).

Bringing up the Docker Compose network with `site` instead of just using `up`, ensures that only our site's containers are brought up at the start, instead of all of the command containers as well. The following are built for our web server, with their exposed ports detailed:


Three additional containers are included that handle Composer, NPM, and Artisan commands *without* having to have these platforms installed on your local computer. Use the following command examples from your project root, modifying them to fit your particular use case.

## Persistent MySQL Storage

By default, whenever you bring down the Docker network, your MySQL data will be removed after the containers are destroyed. If you would like to have persistent data that remains after bringing containers down and back up, do the following:

1. Create a `mysql` folder in the project root, alongside the `nginx` and `src` folders.
2. Under the mysql service in your `docker-compose.yml` file, add the following lines:

```
volumes:
  - ./mysql:/var/lib/mysql
```

## MailHog

The current version of Laravel (8 as of today) uses MailHog as the default application for testing email sending and general SMTP work during local development. Using the provided Docker Hub image, getting an instance set up and ready is simple and straight-forward. The service is included in the `docker-compose.yml` file, and spins up alongside the webserver and database services.

To see the dashboard and view any emails coming through the system, visit [localhost:8025](http://localhost:8025) after running `docker-compose up -d site`.
