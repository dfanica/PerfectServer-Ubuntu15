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
