requires 'Amon2', '6.00';
requires 'Amon2::DBI', '0.32';
requires 'DBD::SQLite', '1.33';
requires 'DBD::mysql', '4.026';
requires 'FormValidator::Lite', '0.37';
requires 'HTML::FillInForm::Lite', '1.11';
requires 'HTTP::Session2', '0.04';
requires 'JSON', '2.50';
requires 'Module::Functions', '2';
requires 'FindBin::libs', '1.8';
requires 'Plack::Middleware::ReverseProxy', '0.09';
requires 'Router::Boom', '0.06';
requires 'Starlet', '0.20';
requires 'Teng', '0.18';
requires 'Test::WWW::Mechanize::PSGI';
requires 'Text::Xslate', '2.0009';
requires 'Text::CSV_XS', '1.02';
requires 'Time::Piece', '1.20';
requires 'Time::Piece::Plus', '0.05';
requires 'Sub::Retry', '0.04';
requires 'String::Random', '0.20';
requires 'perl', '5.010_001';

on configure => sub {
    requires 'Module::Build', '0.38';
    requires 'Module::CPANfile', '0.9010';
};

on test => sub {
    requires 'Test::More', '0.98';
};
