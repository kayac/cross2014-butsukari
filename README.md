cross2014-butsukari
===================

コードレビューCROSS〜ぶつかり稽古2014 初場所〜


# プロジェクトのセットアップ方法

* move repository root

`cd {repository_root}`

* install dependency module

`cpanm --installdeps .`

* create database

`mysqladmin create idol`

* insert Table information

`mysql -uroot idol < sql/mysql.sql`

* launch application

`carton exec perl -Ilib script/idol-server`
