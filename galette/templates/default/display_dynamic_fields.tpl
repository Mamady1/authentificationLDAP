{if !empty($dynamic_fields)}
<table class="details">
    <caption class="ui-state-active ui-corner-top">{_T string="Additionnal fields:"}</caption>
    {foreach from=$dynamic_fields item=field}
        {if $field.field_perm ne 1 || $login->isAdmin() || $login->isStaff()}
            {if $field.field_type eq 0}
    <tr>
        <th class="separator" colspan="2">{$field.field_name|escape}</th>
    </tr>
            {else}
    <tr>
        <th>{$field.field_name|escape}</th>
        <td>
                {section name="fieldLoop" start=1 loop=$field.field_repeat+1}
            {if GaletteMail::isValidEmail($data.dyn[$field.field_id][$smarty.section.fieldLoop.index])}
                {if $smarty.section.fieldLoop.index_prev > 0}<br />{/if}
                <a href="mailto:{$data.dyn[$field.field_id][$smarty.section.fieldLoop.index]}">{$data.dyn[$field.field_id][$smarty.section.fieldLoop.index]}</a>
            {else if GaletteMail::isUrl($data.dyn[$field.field_id][$smarty.section.fieldLoop.index])}
                {if $smarty.section.fieldLoop.index_prev > 0}<br />{/if}
                <a href="{$data.dyn[$field.field_id][$smarty.section.fieldLoop.index]}" target="_blank" title="{_T string="Open '%s' in a new window" replace=$data.dyn[$field.field_id][$smarty.section.fieldLoop.index] pattern="/%s/"}">{$data.dyn[$field.field_id][$smarty.section.fieldLoop.index]}</a>
            {else}
            {$data.dyn[$field.field_id][$smarty.section.fieldLoop.index]|nl2br|default:"&nbsp;"}<br/>
            {/if}
                {/section}
        </td>
    </tr>
            {/if}
        {/if}
    {/foreach}
</table>
{/if}
