# ispcongif3

# mysql
default['mysql_user']['root']['password'] = 't896547h69'

# PHP.ini Settings
default['php']['ini_settings'] = {
    'short_open_tag' => 'On',
    'open_basedir' => '',
    'max_execution_time' => '300',
    'max_input_time' => '300',
    'memory_limit' => '128M',
    'error_reporting' => 'E_ALL & ~E_DEPRECATED & ~E_NOTICE',
    'display_errors' => 'Off',
    'error_log' => '',
    'register_globals' => 'Off',
    'register_long_arrays' => 'Off',
    'post_max_size' => '32M',
    'magic_quotes_gpc' => 'Off',
    'allow_url_fopen' => 'On',
    'allow_url_include' => 'Off',
    'always_populate_raw_post_data' => 'Off',
    'cgi.fix_pathinfo' => '1',
    'upload_max_filesize' => '32M',
    'date.timezone' => 'UTC',
    'session.cookie_httponly' => '0'
}

# phpmyadmin
default['phpmyadmin'] = {
    'version' => '4.2.12',
    'checksum' => 'e4a5fa55c26d0447e5acb216cf14cbde665a69c64db94d2727ba8041788d309f',
    'mirror' => 'https://files.phpmyadmin.net/phpMyAdmin',

    'home' => '/opt/phpmyadmin',
    'user' => 'phpmyadmin',
    'group' => 'phpmyadmin',
    'socket' => '/tmp/phpmyadmin.sock',

    'blowfish_secret' => '7654588cf9f0f92f01a6aa361d02c0cf038',

    'upload_dir' => '/var/lib/php5/uploads',
    'save_dir' => '/var/lib/php5/uploads',

    'maxrows' => 100,
    'protect_binary' => 'blob',
    'default_lang' => 'en',
    'default_display' => 'horizontal',
    'query_history' => true,
    'query_history_size' => 100
}
