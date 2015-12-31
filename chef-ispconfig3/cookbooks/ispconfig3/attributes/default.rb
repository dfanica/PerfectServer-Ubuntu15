# ispcongif3

# phpmyadmin
default['phpmyadmin']['version'] = '4.2.12'
default['phpmyadmin']['checksum'] = 'e4a5fa55c26d'
default['phpmyadmin']['mirror'] = 'https://files.phpmyadmin.net/phpMyAdmin'

default['phpmyadmin']['home'] = '/opt/phpmyadmin'
default['phpmyadmin']['user'] = 'phpmyadmin'
default['phpmyadmin']['group'] = 'phpmyadmin'
default['phpmyadmin']['socket'] = '/tmp/phpmyadmin.sock'

default['phpmyadmin']['blowfish_secret'] = '7654588cf9f0f92f01a6aa361d02c0cf038'

default['phpmyadmin']['upload_dir'] = '/var/lib/php5/uploads'
default['phpmyadmin']['save_dir'] = '/var/lib/php5/uploads'

default['phpmyadmin']['maxrows'] = 100
default['phpmyadmin']['protect_binary'] = 'blob'
default['phpmyadmin']['default_lang'] = 'en'
default['phpmyadmin']['default_display'] = 'horizontal'
default['phpmyadmin']['query_history'] = true
default['phpmyadmin']['query_history_size'] = 100

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
