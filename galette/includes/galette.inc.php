<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * Main Galette initialisation
 *
 * PHP version 5
 *
 * Copyright © 2009-2013 The Galette Team
 *
 * This file is part of Galette (http://galette.tuxfamily.org).
 *
 * Galette is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Galette is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Galette. If not, see <http://www.gnu.org/licenses/>.
 *
 * @category  Main
 * @package   Galette
 *
 * @author    Johan Cwiklinski <johan@x-tnd.be>
 * @copyright 2007-2013 The Galette Team
 * @license   http://www.gnu.org/licenses/gpl-3.0.html GPL License 3.0 or (at your option) any later version
 * @version   SVN: $Id$
 * @link      http://galette.tuxfamily.org
 * @since     Available since 0.7-dev - 2007-10-07
 */

// check required PHP version...
if ( version_compare(PHP_VERSION, '5.3.0', '<') ) {
    echo 'Galette is NOT compliant with your current PHP version. ' .
        'Galette requires PHP 5.3 minimum, current version is ' . phpversion();
    die();
}

$time_start = microtime(true);

//define galette's root directory
if ( !defined('GALETTE_ROOT') ) {
    define('GALETTE_ROOT', __DIR__ . '/../');
}

// define relative base path templating can use
if ( !defined('GALETTE_BASE_PATH') ) {
    define('GALETTE_BASE_PATH', './');
}

require_once GALETTE_ROOT . 'config/versions.inc.php';
require_once GALETTE_ROOT . 'config/paths.inc.php';

//we'll only include relevant parts if we work from installer
if ( !isset($installer) ) {
    $installer = false;
}
// test if galette is already installed or if we're form installer
// and redirect to install page if not
$installed = file_exists(GALETTE_CONFIG_PATH . 'config.inc.php');
if ( !$installed && !$installer ) {
    header('location: install/index.php');
}

if ( file_exists(GALETTE_CONFIG_PATH . 'behavior.inc.php') ) {
    include_once GALETTE_CONFIG_PATH . 'behavior.inc.php';
}

if ( !$installer || $installed ) { //If we're not working from installer
    require_once GALETTE_CONFIG_PATH . 'config.inc.php';
}

use Galette\Common\ClassLoader;
use Analog\Analog as Analog;
use Galette\Core;
require_once GALETTE_ROOT . 'lib/Galette/Common/ClassLoader.php';
$galetteLoader = new ClassLoader('Galette', GALETTE_ROOT . 'lib');
$zendLoader = new ClassLoader('Zend', GALETTE_ZEND_PATH);
$zendLoader->setNamespaceSeparator('_');
$analogLoader = new ClassLoader('Analog', GALETTE_ANALOG_PATH);
$smartyLoader = new ClassLoader(null, GALETTE_SMARTY_PATH);
$smartyLoader->setFileExtension('.class.php');
//register loaders
$galetteLoader->register();
$zendLoader->register();
$analogLoader->register();
$smartyLoader->register();

//start profiling
if (defined('GALETTE_XHPROF_PATH')
    && function_exists('xhprof_enable')
) {
    include_once __DIR__ . '/../lib/Galette/Common/XHProf.php';
    $profiler = new Galette\Common\XHProf();
    $profiler->start();
}

//we start a php session
session_start();

define('GALETTE_VERSION', 'v0.7.3.2');
define('GALETTE_COMPAT_VERSION', '0.7.3');
define('GALETTE_DB_VERSION', '0.701');
if ( !defined('GALETTE_MODE') ) {
    define('GALETTE_MODE', 'PROD'); //DEV, PROD or DEMO
}
define('GALETTE_TWITTER', 'galette_soft');
define('GALETTE_GPLUS', '116977415489200387309');
define('GALETTE_GAPI_KEY', 'AIzaSyDT8Xkud_SdSHdvaagjePrpPoji2ySIZ7Q');

if ( !isset($_COOKIE['show_galette_dashboard']) ) {
    setcookie(
        'show_galette_dashboard',
        true,
        time()+31536000 //valid for a year
    );
}

if ( !defined('GALETTE_DISPLAY_ERRORS') ) {
    define('GALETTE_DISPLAY_ERRORS', 0);
}
ini_set('display_errors', GALETTE_DISPLAY_ERRORS);

set_include_path(
    GALETTE_ZEND_PATH . PATH_SEPARATOR .
    GALETTE_PHP_MAILER_PATH . PATH_SEPARATOR .
    GALETTE_SMARTY_PATH . PATH_SEPARATOR .
    get_include_path()
);

/*------------------------------------------------------------------------------
Logger stuff
------------------------------------------------------------------------------*/
if ( !defined('GALETTE_HANDLE_ERRORS')
    || GALETTE_HANDLE_ERRORS === true
) {
    //set custom error handler
    set_error_handler(
        array(
            "Galette\Core\Error",
            "errorHandler"
        )
    );
}

$now = new \DateTime();
$galette_run_log = null;
$galette_null_log = \Analog\Handler\Null::init();
$dbg_log_path = GALETTE_LOGS_PATH . 'galette_debug_' .
    $now->format('Y-m-d')  . '.log';
$galette_debug_log = \Analog\Handler\File::init($dbg_log_path);

if ( GALETTE_MODE === 'DEV'
    || ( defined('GALETTE_SYS_LOG') && GALETTE_SYS_LOG === true )
) {
    //logs everything in PHP logs (per chance /var/log/http/error_log)
    $galette_run_log = \Analog\Handler\Stderr::init();
} else {
    //logs everything in galette log file
    if ( !isset($logfile) ) {
        //if no filename has been setetd (ie. from install), set default one
        $logfile = 'galette_run';
    }
    $log_path = GALETTE_LOGS_PATH . $logfile . '_' .
        $now->format('Y-m-d')  . '.log';
    $galette_run_log = \Analog\Handler\File::init($log_path);
}

//Log level cannot be <= 3, would be ignored.
if ( !defined('GALETTE_LOG_LVL') ) {
    if ( GALETTE_MODE === 'DEV' ) {
        define('GALETTE_LOG_LVL', 10);
    } else {
        define('GALETTE_LOG_LVL', 5);
    }
}

Analog::handler(
    \Analog\Handler\Multi::init(
        array (
            Analog::URGENT      => $galette_run_log,
            Analog::ALERT       => $galette_run_log,
            Analog::CRITICAL    => $galette_run_log,
            Analog::ERROR       => $galette_run_log,
            Analog::WARNING     => (GALETTE_LOG_LVL >= Analog::WARNING)
                                        ? $galette_run_log : $galette_null_log,
            Analog::NOTICE      => (GALETTE_LOG_LVL >= Analog::NOTICE)
                                        ? $galette_run_log : $galette_null_log,
            Analog::INFO        => (GALETTE_LOG_LVL >= Analog::INFO)
                                        ? $galette_run_log : $galette_null_log,
            Analog::DEBUG       => (GALETTE_LOG_LVL >= Analog::DEBUG)
                                        ? $galette_debug_log : $galette_null_log
        )
    )
);

require_once GALETTE_ROOT . 'includes/functions.inc.php';

$session_name = null;
//since PREFIX_DB and NAME_DB are required to properly instanciate sessions,
// we have to check here if they're assigned
if ( $installer || !defined('PREFIX_DB') || !defined('NAME_DB') ) {
    $session_name = 'galette_install';
} else {
    $session_name = PREFIX_DB . '_' . NAME_DB;
}
$session = &$_SESSION['galette'][$session_name];


/**
* Language instantiation
*/
if ( isset($session['lang'])
    && GALETTE_MODE !== 'DEV'
) {
    $i18n = unserialize($session['lang']);
} else {
    $i18n = new Core\I18n();
}

if ( isset($_POST['pref_lang'])
    && (strpos($_SERVER['PHP_SELF'], 'self_adherent.php') !== false
    || strpos($_SERVER['PHP_SELF'], 'install/index.php') !== false)
) {
    $_GET['pref_lang'] = $_POST['pref_lang'];
}
if ( isset($_GET['pref_lang']) ) {
    $i18n->changeLanguage($_GET['pref_lang']);
}
$session['lang'] = serialize($i18n);
require_once GALETTE_ROOT . 'includes/i18n.inc.php';

// initialize messages arrays
$error_detected = array();
$warning_detected = array();
$success_detected = array();

if ( !$installer ) { //If we're not working from installer
    require_once GALETTE_CONFIG_PATH . 'config.inc.php';

    /**
    * Database instanciation
    */
    $zdb = new Core\Db();

    if ( $zdb->checkDbVersion()
        || strpos($_SERVER['PHP_SELF'], 'picture.php') !== false
    ) {

        /**
        * Load preferences
        */
        $preferences = new Core\Preferences();

        /**
        * Set the path to the current theme templates
        */
        define(
            '_CURRENT_TEMPLATE_PATH',
            GALETTE_TEMPLATES_PATH . $preferences->pref_theme . '/'
        );

        /**
        * Plugins
        */
        $plugins = new Core\Plugins();
        $plugins->loadModules(GALETTE_PLUGINS_PATH, $i18n->getFileName());

        /**
        * Authentication
        */
        if ( isset($session['login']) ) {
            $login = unserialize(
                $session['login']
            );
        } else {
            $login = new Core\Login();
        }

        /**
        * Instanciate history object
        */
        if ( isset($session['history'])
            && !GALETTE_MODE == 'DEV'
        ) {
            $hist = unserialize(
                $session['history']
            );
        } else {
            $hist = new Core\History();
        }

        /**
        * Logo
        */
        if ( isset($session['logo'])
            && !GALETTE_MODE == 'DEV'
        ) {
            $logo = unserialize(
                $session['logo']
            );
        } else {
            $logo = new Core\Logo();
        }

        /**
        * Now that all objects are correctly setted,
        * we can include files that need it
        */
        require_once GALETTE_ROOT . 'includes/session.inc.php';
        require_once GALETTE_ROOT . 'includes/smarty.inc.php';
        require_once GALETTE_ROOT . 'includes/members_fields.php';
    } else {
        header('location: needs_update.php');
        die();
    }
}
