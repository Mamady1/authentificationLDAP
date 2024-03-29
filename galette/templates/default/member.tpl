        <form action="{if $login->isLogged()}ajouter_adherent.php{else}self_adherent.php{/if}" method="post" enctype="multipart/form-data" id="form">
        <div class="bigtable">
{if $self_adh and $head_redirect}
            <div id="infobox">
                <h1>{_T string="Account registered!"}</h1>
                <p>
    {if $pref_mail_method == constant('Galette\Core\GaletteMail::METHOD_DISABLED') or $member->email eq ""}
                    {_T string="Your subscription has been registered."}
    {else}
                    {_T string="Your subscription has been registered, you will receive a recapitulative email soon (remember to check your spam box ;) )."}
    {/if}
                    <br/>{_T string="You'll be redirected to the login page in a few seconds"}
                </p>
            </div>
{else}
            <p>{_T string="NB : The mandatory fields are in"} <span class="required">{_T string="red"}</span></p>
            <fieldset class="cssform">
                <legend class="ui-state-active ui-corner-top">{_T string="Identity:"}</legend>
                <div>
    {if !$self_adh}
                    <p>
                        <span class="bline">{_T string="Picture:"}</span>
                        <img id="photo_adh" src="{$galette_base_path}picture.php?id_adh={$member->id}&amp;rand={$time}" class="picture" width="{$member->picture->getOptimalWidth()}" height="{$member->picture->getOptimalHeight()}" alt="{_T string="Picture"}"/><br/>
        {if $member->hasPicture() eq 1 }
                        <span class="labelalign"><label for="del_photo">{_T string="Delete image"}</label></span><input type="checkbox" name="del_photo" id="del_photo" value="1"/><br/>
        {/if}
                        <input class="labelalign" type="file" name="photo"/>
                    </p>
    {/if}
                    <p>
                        <span class="bline">{_T string="Title:"}</span>
                        {if isset($disabled.titre_adh) and $disabled.titre_adh != ''}
                            {html_radios name="titre_adh" options=$radio_titres checked=$member->politeness separator="&nbsp;" disabled="disabled"}
                        {else}
                            {html_radios name="titre_adh" options=$radio_titres checked=$member->politeness separator="&nbsp;"}
                        {/if}
                    </p>
    {if $visibles.nom_adh eq constant('Galette\Entity\FieldsConfig::VISIBLE') or ($visibles.nom_adh eq constant('Galette\Entity\FieldsConfig::ADMIN') and ($login->isStaff() or $login->isAdmin() or $login->isSuperAdmin()))}
                    <p>
                        <label for="nom_adh" class="bline">{_T string="Name:"}</label>
                        <input type="text" name="nom_adh" id="nom_adh" value="{$member->name|escape}" maxlength="50" {$disabled.nom_adh}{if $required.nom_adh eq 1} required{/if}/>
                    </p>
    {else}
                    <input type="hidden" name="nom_adh" value="{$member->name|escape}"/>
    {/if}
    {if $visibles.prenom_adh eq constant('Galette\Entity\FieldsConfig::VISIBLE') or ($visibles.prenom_adh eq constant('Galette\Entity\FieldsConfig::ADMIN') and ($login->isStaff() or $login->isAdmin() or $login->isSuperAdmin()))}
                    <p>
                        <label for="prenom_adh" class="bline">{_T string="First name:"}</label>
                        <input type="text" name="prenom_adh" id="prenom_adh" value="{$member->surname}" maxlength="50" {$disabled.prenom_adh}{if $required.prenom_adh eq 1} required{/if}/>
                    </p>
    {else}
                    <input type="hidden" name="prenom_adh" value="{$member->surname}"/>
    {/if}
    {if $visibles.societe_adh eq constant('Galette\Entity\FieldsConfig::VISIBLE') or ($visibles.societe_adh eq constant('Galette\Entity\FieldsConfig::ADMIN') and ($login->isStaff() or $login->isAdmin() or $login->isSuperAdmin()))}
                    <p>
                        <label for="is_company" class="bline">{_T string="Is company?"}</label>
                        <input type="checkbox" name="is_company" id="is_company" value="1"{if $member->isCompany()} checked="checked"{/if}/>
                    </p>
                    <p id="company_field"{if !$member->isCompany()} class="hidden"{/if}>
                        <label for="societe_adh" class="bline">{_T string="Company:"}</label>
                        <input type="text" name="societe_adh" id="societe_adh" value="{$member->company_name}" maxlength="200" {$disabled.societe_adh}{if $required.societe_adh eq 1} required{/if}/>
                    </p>
    {else}
                    <input type="hidden" name="societe_adh" value="{$member->company_name}"/>
    {/if}
    {if $visibles.pseudo_adh eq constant('Galette\Entity\FieldsConfig::VISIBLE') or ($visibles.pseudo_adh eq constant('Galette\Entity\FieldsConfig::ADMIN') and ($login->isStaff() or $login->isAdmin() or $login->isSuperAdmin()))}
                    <p>
                        <label for="pseudo_adh" class="bline">{_T string="Nickname:"}</label>
                        <input type="text" name="pseudo_adh" id="pseudo_adh" value="{$member->nickname|htmlspecialchars}" maxlength="20" {$disabled.pseudo_adh}{if $required.pseudo_adh eq 1} required{/if}/>
                    </p>
    {else}
                    <input type="hidden" name="pseudo_adh" value="{$member->nickname|htmlspecialchars}"/>
    {/if}
    {if $visibles.ddn_adh eq constant('Galette\Entity\FieldsConfig::VISIBLE') or ($visibles.ddn_adh eq constant('Galette\Entity\FieldsConfig::ADMIN') and ($login->isStaff() or $login->isAdmin() or $login->isSuperAdmin()))}
                    <p>
                        <label for="ddn_adh" class="bline">{_T string="Birth date:"}</label>
                        <input type="text" name="ddn_adh" id="ddn_adh" value="{$member->birthdate}" maxlength="10" {$disabled.ddn_adh}{if $required.ddn_adh eq 1} required{/if}/> <span class="exemple">{_T string="(yyyy-mm-dd format)"}</span>
                    </p>
    {else}
                    <input type="hidden" name="ddn_adh" value="{$member->birthdate}"/>
    {/if}
    {if $visibles.lieu_naissance eq constant('Galette\Entity\FieldsConfig::VISIBLE') or ($visibles.lieu_naissance eq constant('Galette\Entity\FieldsConfig::ADMIN') and ($login->isStaff() or $login->isAdmin() or $login->isSuperAdmin()))}
                    <p>
                        <label for="lieu_naissance" class="bline">{_T string="Birthplace:"}</label>
                        <input type="text" name="lieu_naissance" id="lieu_naissance" value="{$member->birth_place}" {$disabled.lieu_naissance}{if $required.lieu_naissance eq 1} required{/if}/>
                    </p>
    {else}
                    <input type="hidden" name="lieu_naissance" value="{$member->birth_place}"/>
    {/if}
    {if $visibles.prof_adh eq constant('Galette\Entity\FieldsConfig::VISIBLE') or ($visibles.prof_adh eq constant('Galette\Entity\FieldsConfig::ADMIN') and ($login->isStaff() or $login->isAdmin() or $login->isSuperAdmin()))}
                    <p>
                        <label for="prof_adh" class="bline">{_T string="Profession:"}</label>
                        <input type="text" name="prof_adh" id="prof_adh" value="{$member->job|htmlspecialchars}" maxlength="150" {$disabled.prof_adh}{if $required.prof_adh eq 1} required{/if}/>
                    </p>
    {else}
                    <input type="hidden" name="prof_adh" value="{$member->job|htmlspecialchars}"/>
    {/if}
    {if $visibles.pref_lang eq constant('Galette\Entity\FieldsConfig::VISIBLE') or ($visibles.pref_lang eq constant('Galette\Entity\FieldsConfig::ADMIN') and ($login->isStaff() or $login->isAdmin() or $login->isSuperAdmin()))}
                    <p>
                        <label for="pref_lang" class="bline">{_T string="Language:"}</label>
                        <select name="pref_lang" id="pref_lang" {$disabled.pref_lang}{if $required.pref_lang eq 1} required{/if}>
                            {foreach item=langue from=$languages}
                                <option value="{$langue->getID()}"{if $member->language eq $langue->getID()} selected="selected"{/if} style="background:url({$langue->getFlag()}) no-repeat;padding-left:30px;">{$langue->getName()|ucfirst}</option>
                            {/foreach}
                        </select>
                    </p>
    {else}
                    <input type="hidden" name="pref_lang" value="{$member->language}"/>
    {/if}
                </div>
            </fieldset>

            <fieldset class="cssform">
                <legend class="ui-state-active ui-corner-top">{_T string="Contact information:"}</legend>
                <div>
    {if $visibles.adresse_adh eq constant('Galette\Entity\FieldsConfig::VISIBLE') or ($visibles.adresse_adh eq constant('Galette\Entity\FieldsConfig::ADMIN') and ($login->isStaff() or $login->isAdmin() or $login->isSuperAdmin()))}
                    <p>
                        <label for="adresse_adh" class="bline">{_T string="Address:"}</label>
                        <input type="text" class="large" name="adresse_adh" id="adresse_adh" value="{$member->adress|htmlspecialchars}" maxlength="150" {$disabled.adresse_adh}{if $required.adresse_adh eq 1} required{/if}/><br/>
                        {* FIXME: A-t-on réellement besoin de deux lignes pour une adresse ? *}
                        <label for="adresse2_adh" class="bline libelle">{_T string="Address:"} {_T string=" (continuation)"}</label>
                        <input type="text" class="large" name="adresse2_adh" id="adresse2_adh" value="{$member->adress_continuation|htmlspecialchars}" maxlength="150" {$disabled.adresse2_adh}{if $required.adresse2_adh eq 1} required{/if}/>
                    </p>
    {else}
                    <input type="hidden" name="adresse_adh" value="{$member->adress|htmlspecialchars}"/>
                    <input type="hidden" name="adresse2_adh" value="{$member->adress_continuation|htmlspecialchars}"/>
    {/if}
    {if $visibles.cp_adh eq constant('Galette\Entity\FieldsConfig::VISIBLE') or ($visibles.cp_adh eq constant('Galette\Entity\FieldsConfig::ADMIN') and ($login->isStaff() or $login->isAdmin() or $login->isSuperAdmin()))}
                    <p>
                        <label for="cp_adh" class="bline">{_T string="Zip Code:"}</label>
                        <input type="text" name="cp_adh" id="cp_adh" value="{$member->zipcode}" maxlength="10" {$disabled.cp_adh}{if $required.cp_adh eq 1} required{/if}/>
                    </p>
    {else}
                    <input type="hidden" name="cp_adh" value="{$member->zipcode}"/>
    {/if}
    {if $visibles.ville_adh eq constant('Galette\Entity\FieldsConfig::VISIBLE') or ($visibles.ville_adh eq constant('Galette\Entity\FieldsConfig::ADMIN') and ($login->isStaff() or $login->isAdmin() or $login->isSuperAdmin()))}
                    <p>
                        <label for="ville_adh" class="bline">{_T string="City:"}</label>
                        <input type="text" name="ville_adh" id="ville_adh" value="{$member->town|htmlspecialchars}" maxlength="50" {$disabled.ville_adh}{if $required.ville_adh eq 1} required{/if}/>
                    </p>
    {else}
                    <input type="hidden" name="ville_adh" value="{$member->town|htmlspecialchars}"/>
    {/if}
    {if $visibles.pays_adh eq constant('Galette\Entity\FieldsConfig::VISIBLE') or ($visibles.pays_adh eq constant('Galette\Entity\FieldsConfig::ADMIN') and ($login->isStaff() or $login->isAdmin() or $login->isSuperAdmin()))}
                    <p>
                        <label for="pays_adh" class="bline">{_T string="Country:"}</label>
                        <input type="text" name="pays_adh" id="pays_adh" value="{$member->country|htmlspecialchars}" maxlength="50" {$disabled.pays_adh}{if $required.pays_adh eq 1} required{/if}/>
                    </p>
    {else}
                    <input type="hidden" name="pays_adh" value="{$member->country|htmlspecialchars}"/>
    {/if}
    {if $visibles.tel_adh eq constant('Galette\Entity\FieldsConfig::VISIBLE') or ($visibles.tel_adh eq constant('Galette\Entity\FieldsConfig::ADMIN') and ($login->isStaff() or $login->isAdmin() or $login->isSuperAdmin()))}
                    <p>
                        <label for="tel_adh" class="bline">{_T string="Phone:"}</label>
                        <input type="text" name="tel_adh" id="tel_adh" value="{$member->phone}" maxlength="20" {$disabled.tel_adh}{if $required.tel_adh eq 1} required{/if}/>
                    </p>
    {else}
                    <input type="hidden" name="tel_adh" value="{$member->phone}"/>
    {/if}
    {if $visibles.gsm_adh eq constant('Galette\Entity\FieldsConfig::VISIBLE') or ($visibles.gsm_adh eq constant('Galette\Entity\FieldsConfig::ADMIN') and ($login->isStaff() or $login->isAdmin() or $login->isSuperAdmin()))}
                    <p>
                        <label for="gsm_adh" class="bline">{_T string="Mobile phone:"}</label>
                        <input type="text" name="gsm_adh" id="gsm_adh" value="{$member->gsm}" maxlength="20" {$disabled.gsm_adh}{if $required.gsm_adh eq 1} required{/if}/>
                    </p>
    {else}
                    <input type="hidden" name="gsm_adh" value="{$member->gsm}"/>
    {/if}
    {if $visibles.email_adh eq constant('Galette\Entity\FieldsConfig::VISIBLE') or ($visibles.email_adh eq constant('Galette\Entity\FieldsConfig::ADMIN') and ($login->isStaff() or $login->isAdmin() or $login->isSuperAdmin()))}
                    <p>
                        <label for="email_adh" class="bline">{_T string="E-Mail:"}</label>
                        <input type="text" name="email_adh" id="email_adh" value="{$member->email}" maxlength="150" size="30" {$disabled.email_adh}{if $required.email_adh eq 1} required{/if}/>
                    </p>
    {else}
                    <input type="hidden" name="email_adh" value="{$member->email}"/>
    {/if}
    {if $visibles.url_adh eq constant('Galette\Entity\FieldsConfig::VISIBLE') or ($visibles.url_adh eq constant('Galette\Entity\FieldsConfig::ADMIN') and ($login->isStaff() or $login->isAdmin() or $login->isSuperAdmin()))}
                    <p>
                        <label for="url_adh" class="bline">{_T string="Website:"}</label>
                        <input type="text" name="url_adh" id="url_adh" value="{$member->website}" maxlength="200" size="30" {$disabled.url_adh}{if $required.url_adh eq 1} required{/if}/>
                    </p>
    {else}
                    <input type="hidden" name="url_adh" value="{$member->website}"/>
    {/if}
    {if $visibles.icq_adh eq constant('Galette\Entity\FieldsConfig::VISIBLE') or ($visibles.icq_adh eq constant('Galette\Entity\FieldsConfig::ADMIN') and ($login->isStaff() or $login->isAdmin() or $login->isSuperAdmin()))}
                    <p>
                        <label for="icq_adh" class="bline">{_T string="ICQ:"}</label>
                        <input type="text" name="icq_adh" id="icq_adh" value="{$member->icq}" maxlength="20" {$disabled.icq_adh}{if $required.icq_adh eq 1}required{/if}/>
                    </p>
    {else}
                    <input type="hidden" name="icq_adh" value="{$member->icq}"/>
    {/if}
    {if $visibles.jabber_adh eq constant('Galette\Entity\FieldsConfig::VISIBLE') or ($visibles.jabber_adh eq constant('Galette\Entity\FieldsConfig::ADMIN') and ($login->isStaff() or $login->isAdmin() or $login->isSuperAdmin()))}
                    <p>
                        <label for="jabber_adh" class="bline">{_T string="Jabber:"}</label>
                        <input type="text" name="jabber_adh" id="jabber_adh" value="{$member->jabber}" maxlength="150" size="30" {$disabled.jabber_adh}{if $required.jabber_adh eq 1} required{/if}/>
                    </p>
    {else}
                    <input type="hidden" name="jabber_adh" value="{$member->jabber}"/>
    {/if}
    {if $visibles.msn_adh eq constant('Galette\Entity\FieldsConfig::VISIBLE') or ($visibles.msn_adh eq constant('Galette\Entity\FieldsConfig::ADMIN') and ($login->isStaff() or $login->isAdmin() or $login->isSuperAdmin()))}
                    <p>
                        <label for="msn_adh" class="bline">{_T string="MSN:"}</label>
                        <input type="text" name="msn_adh" id="msn_adh" value="{$member->msn}" maxlength="150" size="30" {$disabled.msn_adh}{if $required.msn_adh eq 1} required{/if}/>
                    </p>
    {else}
                    <input type="hidden" name="msn_adh" value="{$member->msn}"/>
    {/if}
    {if $visibles.gpgid eq constant('Galette\Entity\FieldsConfig::VISIBLE') or ($visibles.gpgid eq constant('Galette\Entity\FieldsConfig::ADMIN') and ($login->isStaff() or $login->isAdmin() or $login->isSuperAdmin()))}
                    <p>
                        <label for="gpgid" class="bline">{_T string="Id GNUpg (GPG):"}</label>
                        <input type="text" name="gpgid" id="gpgid" value="{$member->gnupgid}" maxlength="8" size="8" {$disabled.gpgid}{if $required.gpgid eq 1} required{/if}/>
                    </p>
    {else}
                    <input type="hidden" name="gpgid" value="{$member->gnupgid}"/>
    {/if}
    {if $visibles.fingerprint eq constant('Galette\Entity\FieldsConfig::VISIBLE') or ($visibles.fingerprint eq constant('Galette\Entity\FieldsConfig::ADMIN') and ($login->isStaff() or $login->isAdmin() or $login->isSuperAdmin()))}
                    <p>
                        <label for="fingerprint" class="bline">{_T string="fingerprint:"}</label>
                        <input type="text" name="fingerprint" id="fingerprint" value="{$member->fingerprint}" maxlength="40" size="40" {$disabled.fingerprint}{if $required.fingerprint eq 1}required{/if}/>
                    </p>
    {else}
                    <input type="hidden" name="fingerprint" value="{$member->fingerprint}"/>
    {/if}
                </div>
            </fieldset>

            <fieldset class="cssform">
                <legend class="ui-state-active ui-corner-top">{_T string="Galette-related data:"}</legend>
                <div>
    {if $visibles.bool_display_info eq constant('Galette\Entity\FieldsConfig::VISIBLE') or ($visibles.bool_display_info eq constant('Galette\Entity\FieldsConfig::ADMIN') and ($login->isStaff() or $login->isAdmin() or $login->isSuperAdmin()))}
                    <p>
                        <label for="bool_display_info" class="bline tooltip">{_T string="Be visible in the members list:"}</label>
                        <span class="tip">{_T string="If you check this box (and if you are up to date with your contributions), your full name, website adress ad other informations will be publically visilbe on the members list.<br/>If you've uploaded a photo, it will be displayed on the trombinoscope page.<br/>Note that administrators can disabled public pages, this setting will have no effect in that case."}</span>
                        <input type="checkbox" name="bool_display_info" id="bool_display_info" value="1" {if $member->appearsInMembersList() eq 1}checked="checked"{/if} {$disabled.bool_display_info}{if $required.bool_display_info eq 1} required{/if}/>
                    </p>
    {else}
                    <input type="hidden" name="bool_display_info" value="{if $member->appearsInMembersList() eq 1}1{else}0{/if}"/>
    {/if}
    {if !$self_adh}
        {if $login->isAdmin() or $login->isStaff()}
            {if $visibles.activite_adh eq constant('Galette\Entity\FieldsConfig::VISIBLE') or $visibles.activite_adh eq constant('Galette\Entity\FieldsConfig::ADMIN')}
                    <p>
                        <label for="activite_adh" class="bline">{_T string="Account:"}</label>
                        <select name="activite_adh" id="activite_adh" {$disabled.activite_adh}{if $required.activite_adh eq 1} required{/if}>
                            <option value="1" {if $member->isActive() eq 1}selected="selected"{/if}>{_T string="Active"}</option>
                            <option value="0" {if $member->isActive() eq 0}selected="selected"{/if}>{_T string="Inactive"}</option>
                        </select>
                    </p>
            {else}
                    <input type="hidden" name="activite_adh" value="{if $member->isActive()}1{else}0{/if}"/>
            {/if}
            {if $visibles.id_statut eq constant('Galette\Entity\FieldsConfig::VISIBLE') or $visibles.id_statut eq constant('Galette\Entity\FieldsConfig::ADMIN')}
                    <p>
                        <label for="id_statut" class="bline">{_T string="Status:"}</label>
                        <select name="id_statut" id="id_statut" {$disabled.id_statut}{if $required.id_statut eq 1} required{/if}>
                            {html_options options=$statuts selected=$member->status}
                        </select>
                    </p>
            {else}
                    <input type="hidden" name="id_statut" value="{$member->status}"/>
            {/if}
            {if $login->isAdmin()}
                {if $visibles.bool_admin_adh eq constant('Galette\Entity\FieldsConfig::VISIBLE') or $visibles.bool_admin_adh eq constant('Galette\Entity\FieldsConfig::ADMIN')}
                    <p>
                        <label for="bool_admin_adh" class="bline">{_T string="Galette Admin:"}</label>
                        <input type="checkbox" name="bool_admin_adh" id="bool_admin_adh" value="1" {if $member->isAdmin()}checked="checked"{/if} {$disabled.bool_admin_adh}{if $required.bool_admin_adh eq 1} required{/if}/>
                    </p>
                {else}
                    <input type="hidden" name="bool_admin_adh" value="{if $member->isAdmin()}1{else}0{/if}"/>
            {/if}
            {/if}
            {if $visibles.bool_exempt_adh eq constant('Galette\Entity\FieldsConfig::VISIBLE') or $visibles.bool_exempt_adh eq constant('Galette\Entity\FieldsConfig::ADMIN')}
                    <p>
                        <label for="bool_exempt_adh" class="bline">{_T string="Freed of dues:"}</label>
                        <input type="checkbox" name="bool_exempt_adh" id="bool_exempt_adh" value="1" {if $member->isDueFree() eq 1}checked="checked"{/if} {$disabled.bool_exempt_adh}{if $required.bool_exempt_adh eq 1} required{/if}/>
                    </p>
            {else}
                <input type="hidden" name="bool_exempt_adh" value="{if $member->isDueFree()}1{else}0{/if}"/>
        {/if}
    {/if}
    {/if}
    {if $visibles.login_adh eq constant('Galette\Entity\FieldsConfig::VISIBLE') or ($visibles.login_adh eq constant('Galette\Entity\FieldsConfig::ADMIN') and ($login->isStaff() or $login->isAdmin() or $login->isSuperAdmin()))}
                    <p>
                        <label for="login_adh" class="bline">{_T string="Username:"}</label>
                        <input type="text" name="login_adh" id="login_adh" value="{$member->login}" maxlength="20" {$disabled.login_adh}{if $required.login_adh eq 1} required{/if}/>
                        {* FIXME: use parameter in prefs *}
                        <span class="exemple">{_T string="(at least %i characters)" pattern="/%i/" replace=2}</span>
                    </p>
    {else}
                    <input type="hidden" name="login_adh" value="{$member->login}"/>
    {/if}
    {if !$self_adh}
        {if $visibles.mdp_adh eq constant('Galette\Entity\FieldsConfig::VISIBLE') or ($visibles.mdp_adh eq constant('Galette\Entity\FieldsConfig::ADMIN') and ($login->isStaff() or $login->isAdmin() or $login->isSuperAdmin()))}
                    <p>
                        <label for="mdp_adh" class="bline">{_T string="Password:"}</label>
                        <input type="password" name="mdp_adh" id="mdp_adh" value="" maxlength="20" autocomplete="off" {$disabled.mdp_adh}{if $required.mdp_adh eq 1} required{/if}/>
                        {* FIXME: use parameter in prefs *}
                        <span class="exemple">{_T string="(at least %i characters)" pattern="/%i/" replace=6}</span>
                    </p>
                    <p>
                        <input class="labelalign" type="password" name="mdp_adh2" value="" maxlength="20" autocomplete="off" {$disabled.mdp_adh}{if $required.mdp_adh eq 1} required{/if}/>
                        <span class="exemple">{_T string="(Confirmation)"}</span>
                    </p>
        {/if}
    {else}
                    <p>
                        <label for="mdp_adh" class="bline libelle">{_T string="Password:"}</label>
                        <input type="hidden" name="mdp_crypt" value="{$spam_pass}" />
                        <img src="{$spam_img}" alt="{_T string="Password image"}" />
                        <input type="text" name="mdp_adh" id="mdp_adh" value="" maxlength="20" {$disabled.mdp_adh}{if $required.mdp_adh eq 1} required{/if}/>
                        <span class="exemple">{_T string="Please repeat in the field the password shown in the image."}</span>
                    </p>
    {/if}

    {if !$self_adh and ($login->isAdmin() or $login->isStaff())}
        {if $visibles.date_crea_adh eq constant('Galette\Entity\FieldsConfig::VISIBLE') or $visibles.date_crea_adh eq constant('Galette\Entity\FieldsConfig::ADMIN')}
                    <p>
                        <label for="date_crea_adh" class="bline">{_T string="Creation date:"}</label>
                        <input type="text" name="date_crea_adh" id="date_crea_adh" value="{$member->creation_date}" maxlength="10" {$disabled.date_crea_adh}{if $required.date_crea_adh eq 1} required{/if}/>
                        <span class="exemple">{_T string="(yyyy-mm-dd format)"}</span>
                    </p>
        {else}
                    <input type="hidden" name="date_crea_adh" value="{$member->creation_date}"/>
        {/if}
        {if $visibles.info_adh eq constant('Galette\Entity\FieldsConfig::VISIBLE') or $visibles.info_adh eq constant('Galette\Entity\FieldsConfig::ADMIN')}
                    <p>
                        <label for="info_adh" class="bline">{_T string="Other informations (admin):"}</label>
                        <textarea name="info_adh" id="info_adh" cols="50" rows="6" {$disabled.info_adh}{if $required.info_adh eq 1} required{/if}>{$member->others_infos_admin|htmlspecialchars}</textarea><br/>
                        <span class="exemple labelalign">{_T string="This comment is only displayed for admins and staff members."}</span>
                    </p>
        {else}
                    <input type="hidden" name="info_adh" value="{$member->others_infos_admin|htmlspecialchars}"/>
    {/if}
    {/if}
    {if $visibles.info_public_adh eq constant('Galette\Entity\FieldsConfig::VISIBLE') or ($visibles.info_public_adh eq constant('Galette\Entity\FieldsConfig::ADMIN') and ($login->isStaff() or $login->isAdmin() or $login->isSuperAdmin()))}
                    <p>
                        <label for="info_public_adh" class="bline">{_T string="Other informations:"}</label> 
                        <textarea name="info_public_adh" id="info_public_adh" cols="61" rows="6" {$disabled.info_public_adh}{if $required.info_public_adh eq 1} required{/if}>{$member->others_infos|htmlspecialchars}</textarea>
    {if $login->isAdmin() or $login->isStaff()}
                        <br/><span class="exemple labelalign">{_T string="This comment is reserved to the member."}</span>
    {/if}
                    </p>
    {else}
                    <input type="hidden" name="info_public_adh" value="{$member->others_infos|htmlspecialchars}"/>
    {/if}
    {if $groups|@count != 0}
                    <p>
                        <span class="bline">{_T string="Groups:"}</span>
        {if $login->isGroupManager()}
                        <a class="button" id="btngroups">{_T string="Manage user's groups"}</a>
        {/if}
        {if $login->isAdmin() or $login->isStaff()}
                        <a class="button" id="btnmanagedgroups">{_T string="Manage user's managed groups"}</a>
        {/if}
                        <span id="usergroups_form">
        {foreach from=$groups item=group}
            {if $member->isGroupMember($group->getName())}
                            <input type="hidden" name="groups_adh[]" value="{$group->getId()}|{$group->getName()}"/>
            {/if}
        {/foreach}
                        </span>
        {if $login->isAdmin() or $login->isStaff()}
                        <span id="managedgroups_form">
            {foreach from=$groups item=group}
                {if $member->isGroupManager($group->getName())}
                            <input type="hidden" name="groups_managed_adh[]" value="{$group->getId()}|{$group->getName()}"/>
                {/if}
            {/foreach}
                        </span>
        {/if}
                        <span id="usergroups">
        {foreach from=$groups item=group name=groupsiterate}
            {if $member->isGroupMember($group->getName())}
                {if not $smarty.foreach.groupsiterate.first}, {/if}
                {_T string="Member of '%groupname'" pattern="/%groupname/" replace=$group->getName()}
            {/if}
        {/foreach}
                        </span>
                        <span id="usermanagedgroups">
        {foreach from=$groups item=group name=groupsmiterate}
            {if $member->isGroupManager($group->getName())}
                {if not $smarty.foreach.groupsmiterate.first}, {/if}
                {_T string="Manager for '%groupname'" pattern="/%groupname/" replace=$group->getName()}
            {/if}
        {/foreach}
                        </span>
                    </p>
    {/if}
                </div>
            </fieldset>

    {include file="edit_dynamic_fields.tpl"}
    {if $pref_mail_method neq constant('Galette\Core\GaletteMail::METHOD_DISABLED') and (!$self_adh and ($login->isAdmin() or $login->isStaff())) and !$disabled.send_mail}
                    <p>
                        <label for="mail_confirm">
        {if $member->id}
                            {_T string="Notify member his account has been modified"}
        {else}
                            {_T string="Notify member his account has been created"}
        {/if}
                        </label>
                        <input type="checkbox" name="mail_confirm" id="mail_confirm" value="1" {if $smarty.post.mail_confirm != ""}checked="checked"{/if}/>
                        <br/><span class="exemple">
        {if $member->id}
                            {_T string="Member will be notified by mail his account has been modified."}
        {else}
                            {_T string="Member will receive his username and password by email, if he has an address."}
        {/if}
                        </span>
                    </p>
    {/if}
        </div>
        <div class="button-container">
            <input type="submit" name="valid" id="btnsave" value="{_T string="Save"}"/>
            <input type="hidden" name="id_adh" value="{$member->id}"/>
        </div>
        </form> 
        <script type="text/javascript">
            $(function() {
                $('#is_company').change(function(){
                    //console.log(this.checked);
                    $('#company_field').toggleClass('hidden');
                });

                _collapsibleFieldsets();

                $('#ddn_adh').datepicker({
                    changeMonth: true,
                    changeYear: true,
                    showOn: 'button',
                    buttonImage: '{$template_subdir}images/calendar.png',
                    buttonImageOnly: true,
                    maxDate: '-0d',
                    yearRange: 'c-100'
                });
                $('#date_crea_adh').datepicker({
                    changeMonth: true,
                    changeYear: true,
                    showOn: 'button',
                    buttonImage: '{$template_subdir}images/calendar.png',
                    buttonImageOnly: true,
                    maxDate: '-0d',
                    yearRange: 'c-10'
                });

                {* Groups popup *}
                $('#btngroups, #btnmanagedgroups').click(function(){
                    var _managed = false;
                    if ( $(this).attr('id') == 'btnmanagedgroups' ) {
                        _managed = true;
                    }
                    var _groups = [];
                    var _form = (_managed) ? 'managed' : 'user';
                    $('#' + _form + 'groups_form input').each(function(){
                        _group = $(this).val().split('|');
                        _groups[_groups.length] = {
                            id: _group[0],
                            name: _group[1]
                        };
                    });
                    $.ajax({
                        url: 'ajax_groups.php',
                        type: "POST",
                        data: {
                            ajax: true,
                            groups: _groups,
                            managed: _managed
                        },
                        {include file="js_loader.tpl"},
                        success: function(res){
                            _groups_dialog(res, _groups, _managed);
                        },
                        error: function() {
                            alert("{_T string="An error occured displaying groups interface :(" escape="js"}");
                        }
                    });
                    return false;
                });

                var _groups_dialog = function(res, _groups, _managed){
                    var _title = '{_T string="Groups selection" escape="js"}';
                    if ( _managed ) {
                        _title = '{_T string="Managed groups selection" escape="js"}';
                    }
                    var _el = $('<div id="ajax_groups_list" title="' + _title + '"> </div>');
                    _el.appendTo('body').dialog({
                        modal: true,
                        hide: 'fold',
                        width: '80%',
                        height: 500,
                        close: function(event, ui){
                            _el.remove();
                        }
                    });
                    _groups_ajax_mapper(res, _groups, _managed);
                }

                var _groups_ajax_mapper = function(res, _groups, _managed){
                    $('#ajax_groups_list').append(res);
                    $('#btnvalid').button().click(function(){
                        //remove actual groups
                        var _form = (_managed) ? 'managed' : 'user';
                        $('#' + _form + 'groups_form').empty();
                        var _groups = new Array();
                        var _groups_str = '';
                        $('li[id^="group_"]').each(function(){
                            //get group values
                            _gid = this.id.substring(6, this.id.length);
                            _gname = $(this).text();
                            _groups[_groups.length] = this.id.substring(6, this.id.length);
                            var _iname = (_managed) ? 'groups_managed_adh' : 'groups_adh';
                            $('#' + _form + 'groups_form').append(
                                '<input type="hidden" value="' +
                                _gid + '|' + _gname + '|' +
                                '" name="' + _iname + '[]">'
                            );
                            if ( _groups_str != '' ) {
                                _groups_str += ', ';
                            }
                            if ( _managed ) {
                                _groups_str += '{_T string="Manager for '%groupname'" escape="js"}'.replace(/%groupname/, _gname);
                            } else {
                                _groups_str += '{_T string="Member of '%groupname'" escape="js"}'.replace(/%groupname/, _gname);
                            }
                        });
                        $('#' + _form + 'groups').html(_groups_str);
                        $('#ajax_groups_list').dialog("close");
                    });
                    //Remap links
                    var _none = $('#none_selected').clone();
                    $('li input[type=checkbox]').click(function(e){
                        e.stopPropagation();
                    });
                    $('li[id^="group_"]').click(function(){
                        $(this).remove();
                        if ( $('#selected_groups ul li').length == 0 ) {
                            $('#selected_groups ul').append(_none);
                        }
                    });
                    $('#listing a').click(function(){
                        var _gid = this.href.substring(this.href.indexOf('?')+10);
                        var _gname = $(this).text();
                        $('#none_selected').remove()
                        if ( $('#group_' + _gid).length == 0 ) {
                            var _li = '<li id="group_' + _gid + '">' + _gname + '</li>';
                            $('#selected_groups ul').append(_li);
                            $('#group_' + _gid).click(function(){
                                $(this).remove();
                                if ( $('#selected_groups ul li').length == 0 ) {
                                    $('#selected_groups ul').append(_none);
                                }
                            });
                        }
                        return false;
                    });

                }

                {include file="photo_dnd.tpl"}
            });
        </script>
{/if}
