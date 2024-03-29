    <table id="input-table">
{if $class eq 'Status'}
        <caption>
            {_T string="Note: members with a status priority lower than %priority are staff members." pattern="/%priority/" replace=$non_staff_priority}
        </caption>
{/if}
        <thead>
            <tr>
                <th class="listing id_row">#</th>
                <th class="listing">{_T string="Name"}</th>
{if $class == 'ContributionsTypes'}
                <th class="listing">{_T string="Extends membership?"}</th>
{elseif $class == 'Status'}
                <th class="listing">{_T string="Priority"}</th>
{/if}
                <th class="listing">{_T string="Actions"}</th>
            </tr>
        </thead>
        <tfoot>
            <tr>
                <td class="listing">&nbsp;</td>
                <td class="listing left">
                    <input size="40" type="text" name="{$fields.$class.name}"/>
                </td>
                <td class="listing left">
{if $class == 'ContributionsTypes'}
                    <select name="{$fields.$class.field}">
                        <option value="0" selected="selected">{_T string="No"}</option>
                        <option value="1">{_T string="Yes"}</option>
                    </select>
{elseif $class == 'Status'}
                    <input size="4" type="text" name="{$fields.$class.field}" value="99" />
{/if}
                </td>
                <td class="listing center">
                    <input type="hidden" name="new" value="1" />
                    <input type="hidden" name="class" value="{$class}" />
                    <input type="submit" name="valid" id="btnadd" value="{_T string="Add"}"/>
                </td>
            </tr>
        </tfoot>
        <tbody>
{foreach from=$entries item=entry}
            <tr>
                <td class="listing">{$entry.id}</td>
                <td class="listing left">

                    {if $class == 'Status'}
                        {if $entry.priority < 30}
                            <img src="{$template_subdir}images/icon-staff.png" alt="{_T string="[staff]"}" width="16" height="16"/>
                        {else}
                            <img src="{$template_subdir}images/icon-empty.png" alt="" width="16" height="16"/>
                        {/if}
                    {/if}
                    {$entry.name|escape}
                </td>
                <td class="listing">
    {if $class == 'ContributionsTypes'}
                    {$entry.extends}
    {elseif $class == 'Status'}
                    {$entry.priority}
    {/if}
                </td>
                <td class="listing center actions_row">
                    <a href="gestion_intitules.php?class={$class}&amp;id={$entry.id}">
                        <img src="{$template_subdir}images/icon-edit.png" alt="{_T string="Edit '%s' field" pattern="/%s/" replace=$entry.name}" title="{_T string="Edit '%s' field" pattern="/%s/" replace=$entry.name}" width="16" height="16"/>
                    </a>
                    <a onclick="return confirm('{_T string="Do you really want to delete this entry?"|escape:"javascript"}')" href="gestion_intitules.php?class={$class}&amp;del={$entry.id}">
                        <img src="{$template_subdir}images/icon-trash.png" alt="{_T string="Delete '%s' field" pattern="/%s/" replace=$entry.name}" title="{_T string="Delete '%s' field" pattern="/%s/" replace=$entry.name}" width="16" height="16" />
                    </a>
                </td>
            </tr>
{/foreach}
        </tbody>
    </table>
