<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * Advanced search form
 *
 * PHP version 5
 *
 * Copyright © 2012-2013 The Galette Team
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
 * @copyright 2012-2013 The Galette Team
 * @license   http://www.gnu.org/licenses/gpl-3.0.html GPL License 3.0 or (at your option) any later version
 * @version   SVN: $Id$
 * @link      http://galette.tuxfamily.org
 * @since     Available since 0.7.3dev - 2012-10-11
 */

use Galette\Filters\MembersList as MembersList;
use Galette\Filters\AdvancedMembersList as AdvancedMembersList;
use Galette\Entity\Adherent as Adherent;
use Galette\Entity\DynamicFields as DynamicFields;

/** @ignore */
require_once 'includes/galette.inc.php';

if ( !$login->isLogged() ) {
    header('location: index.php');
    die();
}

if ( isset($session['filters']['members']) ) {
    $filters = unserialize($session['filters']['members']);
    if ( !$filters instanceof AdvancedMembersList ) {
        $filters = new AdvancedMembersList($filters);
    }
} else {
    $filters = new AdvancedMembersList();
}

$groups = new Galette\Repository\Groups();
$groups_list = $groups->getList();

$tpl->assign('page_title', _T("Advanced search"));
$tpl->assign('require_dialog', true);
$tpl->assign('require_calendar', true);
$tpl->assign('require_sorter', true);
$tpl->assign('filter_groups_options', $groups_list);
if ( isset($error_detected) ) {
    $tpl->assign('error_detected', $error_detected);
}
if (isset($warning_detected)) {
    $tpl->assign('warning_detected', $warning_detected);
}

//TODO: filter that? Only visibles?
$a = new Adherent();
$tpl->assign('search_fields', $a->fields);

//dynamic fields
$df = new DynamicFields();
$dynamic_fields = $df->prepareForDisplay(
    'adh',
    array(),
    array(),
    0
);
$tpl->assign('dynamic_fields', $dynamic_fields);

//Status
$statuts = new Galette\Entity\Status();
$tpl->assign('statuts', $statuts->getList());

$tpl->assign('filters', $filters);

$filters->setTplCommonsFilters($tpl);

$content = $tpl->fetch('advanced_search.tpl');
$tpl->assign('content', $content);
$tpl->display('page.tpl');
