<?php
/**
* The base configuration for WordPress
*
* You don't have to use the website, you can copy this file to "wp-config.php"
* and fill in the values.
*
* This file contains the following configurations:
*
* * Database settings
* * Secret keys
* * Database table prefix
* * ABSPATH
*
* @link https://wordpress.org/documentation/article/editing-wp-config-php/
*
* @package WordPress
*/

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpressdb01' );

/** Database username */
define( 'DB_USER', 'root' );

/** Database password */
define( 'DB_PASSWORD', 'root' );

/** Database hostname */
define( 'DB_HOST', 'localhost' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
* Authentication unique keys and salts.
*
* Change these to different unique phrases! You can generate these using
* the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
*
* You can change these at any point in time to invalidate all existing cookies.
* This will force all users to have to log in again.
*
* @since 2.6.0
*/
define( 'AUTH_KEY',         'l2Z+JK1v5}An-vMIfE21y,Jk: >[lHA2Pmv,Y%OB9S,9qiSt9_P=@&5 sHnuNUL.' );
define( 'SECURE_AUTH_KEY',  '``/|oVT0}>^(M3iO{NBV;*(AA|j>JnBnP6yD{7T}#9_f]ZqNMd+;!,ANvScK?~!r' );
define( 'LOGGED_IN_KEY',    'xaiPBX_k-L;hB7}Ata_dwg9:@v7rD5&t/zyHR0o{6?1_|7BQ@=>ede?#UY}K9`vt' );
define( 'NONCE_KEY',        '`QV-^L&X{voDUM$C?wI3ls)|:;4`W:1+V-M!92u29RWxnqyk*7gj]5[MRK!inS9D' );
define( 'AUTH_SALT',        'CgUCAWt?[9)R,WTTt%9,ZHv;*qVDY2Kd~H1(*o|=~Z(LjVJ;$EfA^p]poBL)y{7*' );
define( 'SECURE_AUTH_SALT', '=+C[Wdu/A8RxyceZ?Eqal}?x6r1>*~72<n@el8L|q#,x:m$7Wd/[zXcn=qU(kk#j' );
define( 'LOGGED_IN_SALT',   '+t:]F-9?&~g>sg6gmX[Sd`k|A#Id~ea5?Gb5!54w355T`]Q1d>&V_D0#8N+Fl_5R' );
define( 'NONCE_SALT',       'Z}1[JUsdjVzh7&V.cR/1rbzq?:d/[x %aR`t:|Hqwf=YF02=|_4b7.0$G N$MH3]' );

/**#@-*/

/**
* WordPress database table prefix.
*
* You can have multiple installations in one database if you give each
* a unique prefix. Only numbers, letters, and underscores please!
*/
$table_prefix = 'wp_';

/**
* For developers: WordPress debugging mode.
*
* Change this to true to enable the display of notices during development.
* It is strongly recommended that plugin and theme developers use WP_DEBUG
* in their development environments.
*
* For information on other constants that can be used for debugging,
* visit the documentation.
*
* @link https://wordpress.org/documentation/article/debugging-in-wordpress/
*/
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */


/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
