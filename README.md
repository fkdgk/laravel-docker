# LaravelをDockerで動かすための設定ファイル

 <pre> git clone https://github.com/fkdgk/laravel-docker.git
 <br> cd laravel-docker
 <br> docker-compose up -d --build site</pre>


## Laravelのインストール
<dl>
  <dt><h3>最新版  <small> （※ 末尾の” . ”を忘れずに）</small></h3></dt>
  <dd>
    <pre> docker-compose run --rm  composer create-project laravel/laravel . </pre>
  </dd>
  <dt><h3>バージョン指定  <small> （※ 末尾の” . ”を忘れずに）</small></h3></dt>
  <dd>
    <pre>  docker-compose run --rm  composer create-project "laravel/laravel=7.3.*" . </pre>
  </dd>
</dl>

<dl>
  <dt><h3>Laravelのバージョン確認</h3></dt>
  <dd>
    <pre> docker-compose run --rm artisan -V </pre>
  </dd>
</dl>


 ## 設定ファイル書き換え
 <pre> cp src/.env.example src/.env
 <br> vim src/.env</pre>

 ## .envの書き換え
<pre>
DB_CONNECTION=mysql <br>
DB_HOST=mysql <br>
DB_PORT=3306 <br>
DB_DATABASE=homestead <br>
DB_USERNAME=homestead <br>
DB_PASSWORD=secret
 </pre>

## App keyの生成
 <pre>docker-compose run --rm artisan key:generate</pre>

## WEBページの表示確認
[http://localhost/](http://localhost/)


## Migrations - DB接続確認
 <pre>docker-compose run --rm artisan migrate </pre>

## Dockerの終了
<pre>docker-compose down</pre>

## Dockerの起動
<pre>docker-compose up -d --build site</pre>


### Auth
<pre>docker-compose run --rm composer require laravel/ui 
<br> docker-compose run --rm artisan ui bootstrap --auth 
<br> docker-compose run --rm npm install 
<br> docker-compose run --rm npm run dev</pre>

## command
- `docker-compose run --rm composer install`
- `docker-compose run --rm npm run dev`
- `docker-compose run --rm artisan migrate` 

### Access MySql
` mysql -uhomestead -psecret -P4306 -h127.0.0.1 homestead`
<br>` > show tables`

---

### phpMyAdmin を使う場合
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
