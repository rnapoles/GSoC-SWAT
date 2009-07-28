<%def name="permission_zone(name, id)">
    <% permissions = [["0", _("None")], ["4", _("Read Only")], ["2", _("Write Only")], ["6", _("Read and Write")]]%>
    <% permissionGroups = [[_("Owner Can"), "owner", 6, 1], [_("Group Members Can"), "group", 4, 1], [_("Everyone Else Can"), "world", 4, 1]] %>
    
    <ul class="permissions-selection">
        % for grp in permissionGroups:
            <li>
                <label for="${id}-${grp[1]}-rw">${grp[0]}:</label>                                
                ${h.select(name + "_" + grp[1] + "_rw", grp[2], permissions, style="float:left;font-size:85%;", id=id + "-" + grp[1] + "-rw")}
    
                <span>
                    ${h.checkbox(name + "_" + grp[1] + '_x', grp[3], True, style="margin-left:15px;", id=id + "-" + grp[1] + '-x')}
                    <label class="checkbox" for="${id}-${grp[1]}-x">${_('Execute?')}</label>
                </span>
            </li>
        % endfor
    </ul>
</%def>
    
<%def name="help(id)">
    <p class="option-help">${c.p.get_value(id, "help")}</p>
</%def>

<%doc>Text</%doc>
<%def name="text(id, value)">
    <label for="${c.p.get_value(id, "id")}" title="${c.p.get_value(id, "title")}">${c.p.get_value(id, "label")}:</label>
    ${h.text(c.p.get_value(id, "name"), value, id=c.p.get_value(id, "id"), class_=c.p.get_value(id, "class"))}
</%def>
    
<%doc>Boolean</%doc>
<%def name="checkbox(id, value)">
    ${h.hidden(c.p.get_value(id, "name"), 'no')}
    ${h.checkbox(c.p.get_value(id, "name"), 'yes', value, id=c.p.get_value(id, "id"), class_=c.p.get_value(id, "class"))}
    <label class="checkbox" for="${c.p.get_value(id, "id")}" title="${c.p.get_value(id, "title")}">${c.p.get_value(id, "label")}</label>                                    
</%def>
    
<%doc>Choose which type to call</%doc>
<%def name="put(id, param_value=None)">
<%
    type = c.p.get_value(id, "type")
    
    param_name = id.replace('-', '')
    param_value = param_value or c.samba_lp.get(param_name, c.share_name)

    help(id)

    if type == "text":    
        text(id, param_value)
    elif type == "checkbox":
        checkbox(id, param_value)
%> 
</%def>

<%def name="write(share='')">
<%

    
    
    

%>

    ${h.form('', method="post", id="share-form", class_="share-configuration")}
        <ol class="tab-list">
	    <li id="tab1" class="active">
		<h3><a title="${_('Basic Share Configuration')}" class="title-icon basic-tab" href="#">${_('Basic')}</a></h3>                           
	    </li>
	    
	    <li id="tab2">
		<h3><a title="${_('Advanced Permissions for this Share')}" class="title-icon permissions-tab" href="#">${_('Permissions')}</a></h3>                       
	    </li>
	    
	    <li id="tab3">
		<h3><a title="${_('Share User Management')}" class="title-icon users-tab" href="#">${_('Users')}</a></h3>
	    </li>
	    
	    <li id="tab4">
		<h3><a title="${_('Share Host Management')}" class="title-icon hosts-tab" href="#">${_('Hosts')}</a></h3>
	    </li>                        
	</ol>
        
        <ul class="tab-list-items"> 
	    <li id="content-tab1" class="active tab">
		<ol class="col-1">
		    <li>${put("name", c.share_name)}</li>
		    
		    <li>
                        <p class="option-help">${_("Sets the path to the directory provided by a file share or used by a printer share. Set automatically in [homes] share to user\'s home directory, otherwise defaults to  /tmp. Honors the %u (user) and %m (machine) variables.")}</p>
                        
			<span class="field-with-ops">
                            <label for="share-path" title="${_('Set the Path to be Shared')}">${_('Path')}:</label>
                            ${h.text("share_path", c.samba_lp.get("path", share), id="share-path", class_='big-text')}
			</span>

			<ol class="field-ops">
			    <li><a href="${h.url_for(controller='share', action='path')}" class="popup-selector" title="${_('Select the Share Location')}"><img src="/default/images/icons/layer-select-point.png" alt="${_('Add User/Group Icon')}" /></a></li>
			</ol>
		    </li>                                                                
		</ol>
		
		<ol class="col-2">
		    <li>${put("guest-ok")}</li>
		    
		    <li>
			<p class="option-help">${_('Allows a share to be announced in browse lists.')}</p>
                        
                        ${h.hidden('share_browsable', 'no')}
                        ${h.checkbox('share_browsable', 'yes', c.samba_lp.get("browsable", share), id='share-browsable', class_='big-margin')}
                        
			<label class="checkbox" for="share-browsable" title="${_('Check to make this share Browsable')}">${_('Browsable?')}</label>
		    </li>
		    
		    <li>
			<p class="option-help">${_('Sets a share to read-only.')}</p>
                        
                        ${h.hidden('share_read_only', 'no')}
                        ${h.checkbox('share_read_only', 'yes', c.samba_lp.get("read only", share), id='share-read-only', class_='big-margin')}
                        
			<label class="checkbox" for="share-read-only" title="${_('Check to make this Share Read Only')}">${_('Read Only?')}</label>
		    </li>
                    
		    <li>
			<p class="option-help">${_('Forces user of a share to do so as the guest account')}</p>
                        
                        ${h.hidden('share_guest_only', 'no')}
                        ${h.checkbox('share_guest_only', 1, c.samba_lp.get("guest only", share), id='share-guest-only', class_='big-margin')}
                        
			<label class="checkbox" for="share-guest-only" title="${_('Check to make this Share Guest Only')}">${_('Guest Only?')}</label>
		    </li>                
		</ol>
		
		<div class="clear-both"></div>
	    </li>
	    
	    <li id="content-tab2">                            
		<ol class="col-1">
		    <li>                                    
			<p class="option-help">${_('Sets the maximum allowable permissions for new files (e.g., 0755). See also directory mask. To require certain permissions to be set, see force create mask/force directory mask.')}</p>
                        <p class="field-title">${_('Create Mask')}</p>
                        
                        ${permission_zone('create_mask', 'create-mask')}
                        ${h.hidden('share_create_mask', '')}
		    </li>
		    
		    <li>                                    
			<p class="option-help">${_('Also called directory mode. Sets the maximum allowable permissions for newly created directories. To require certain permissions be set, see the force create mask and force directory mask options')}</p>
			<p class="field-title">${_('Directory Mask')}</p>
			
                        ${permission_zone('directory_mask', 'directory-mask')}
                        ${h.hidden('share_directory_mask', '')}
		    </li>
		</ol>                            
	    </li>
	    
	    <li id="content-tab3">
		<ol class="col-1">
		    <li>                                    
			<p class="option-help">${_('List of users that are given read-write access to a read-only share.')}</p>
			
			<span class="field-with-ops">
			    <label for="share-insert-writeuser" title="${_('Select Users/Groups that will have Read Access to this Share')}">${_('Read List')}:</label>
                            ${h.text("", "", id="share-insert-read-user", class_='big-text')}
			</span>

			<ol class="field-ops">
			    <li><a title="${_('Add this User/Group')}" href="#" onclick="userGroup.addManual('share-insert-read-user', 'user-list-read');return false;"><img src="/default/images/icons/plus-small.png" alt="${_('Add User/Group Icon')}" /></a></li>
			    <li><a title="${_('Open User/Group Selection Popup')}" href="${h.url_for(controller='share', action='users_groups')}?copyto=user-list-read" class="popup-selector"><img src="/default/images/icons/users.png" alt="${_('Select Users/Groups Icon')}" /></a></li>
			</ol>
			
                        ${h.hidden('share_read_list', c.samba_lp.get("read list", share), id='user-list-read-textbox')}

			<ul id="user-list-read" class="user-list">
			</ul>
			
			<div class="clear-both"></div>
		    </li>                    
                    
		    <li>                                    
			<p class="option-help">${_('Specifies a list of users given read-only access to a writeable share.')}</p>
			
			<span class="field-with-ops">
			    <label for="share-insert-write-user" title="${_('Select Users/Groups that will have Write Access to this Share')}">${_('Write List')}:</label>
                            ${h.text("", "", id="share-insert-write-user", class_='big-text')}
			</span>

			<ol class="field-ops">
			    <li><a title="${_('Add this User/Group')}" href="#" onclick="userGroup.addManual('share-insert-write-user', 'user-list-write');return false;"><img src="/default/images/icons/plus-small.png" alt="${_('Add User/Group Icon')}" /></a></li>
			    <li><a title="${_('Open User/Group Selection Popup')}" href="${h.url_for(controller='share', action='users_groups')}?copyto=user-list-write" class="popup-selector"><img src="/default/images/icons/users.png" alt="${_('Select Users/Groups Icon')}" /></a></li>
			</ol>
			
                        ${h.hidden('share_write_list', c.samba_lp.get("write list", share), id='user-list-write-textbox')}
			
			<ul id="user-list-write" class="user-list">
			</ul>
			
			<div class="clear-both"></div>
		    </li>
		    
                    <li>                                    
			<p class="option-help">${_('List of users who will be granted root permissions on the share by Samba.')}</p>
			
			<span class="field-with-ops">
			    <label for="share-insert-adminuser" title="${_('Select Users/Groups that will have Read Access to this Share')}">${_('Admin List')}:</label>
                            ${h.text("", "", id="share-insert-adminuser", class_='big-text')}
			</span>
			
			<ol class="field-ops">
                            <li><a title="${_('Add this User/Group')}" href="#" onclick="userGroup.addManual('share-insert-adminuser', 'user-list-admin');return false;"><img src="/default/images/icons/plus-small.png" alt="${_('Add User/Group Icon')}" /></a></li>
			    <li><a title="${_('Open User/Group Selection Popup')}" href="${h.url_for(controller='share', action='users_groups')}?copyto=user-list-admin" class="popup-selector"><img src="/default/images/icons/users.png" alt="${_('Select Users/Groups Icon')}" /></a></li>
			</ol>

                        ${h.hidden('share_admin_list', c.samba_lp.get("admin list", share), id='user-list-admin-textbox')}
			
			<ul id="user-list-admin" class="user-list">
			</ul>
			
			<div class="clear-both"></div>
                    </li>
		</ol>                            
	    </li>
	    
	    <li id="content-tab4">
                <ol class="col-1">
                    <li>
			<p class="option-help">${_('A list of machines that can access a share or shares. If NULL (the default) any machine can access the share unless there is a hosts deny option.')}</p>
			
			<span class="field-with-ops">
			    <label for="share-insert-allowed-hosts" title="${_('List of Hostnames that will be able to access this Share')}">${_('Allowed Hosts')}:</label>
                            ${h.text("", "", id="share-insert-allowed-hosts", class_='big-text')}
			</span>
			
			<ol class="field-ops">
                            <li><a title="${_('Add this Host')}" href="#" onclick="userGroup.addManual('share-insert-allowed-hosts', 'allowed-hosts-list');return false;"><img src="/default/images/icons/plus-small.png" alt="${_('Add User/Group Icon')}" /></a></li>
			</ol>
			
                        ${h.hidden('share_hosts_allow', c.samba_lp.get("hosts allow", share), id='allowed-hosts-list-textbox')}
			
			<ul id="allowed-hosts-list" class="user-list">
			</ul>
			
			<div class="clear-both"></div>
                    </li>
                    
                    <li>
			<p class="option-help">${_('A list of machines that cannot connect to a share or shares. ')}</p>
			
			<span class="field-with-ops">
			    <label for="share-insert-deny-hosts" title="${_('List of Hostnames that will not be able to access this Share')}">${_('Denied Hosts')}:</label>
                            ${h.text("", "", id="share-insert-deny-hosts", class_='big-text')}
			</span>
			
			<ol class="field-ops">
                            <li><a title="${_('Add this Host')}" href="#" onclick="userGroup.addManual('share-insert-deny-hosts', 'denied-hosts-list');return false;"><img src="/default/images/icons/plus-small.png" alt="${_('Add User/Group Icon')}" /></a></li>
			</ol>

                        ${h.hidden('share_hosts_deny', c.samba_lp.get("hosts deny", share), id='denied-hosts-list-textbox')}
			
			<ul id="denied-hosts-list" class="user-list">
			</ul>
			
			<div class="clear-both"></div>
                    </li>
                </ol>
	    </li>
	</ul>
	
	<div class="widget share-comment round-2px">
	    <div class="title-bar">
		<h2 class="title-icon" style="background-image:url('/default/images/icons/balloon.png');">${_('Comments')}</h2>
	    </div>
	    <div class="content">
		<textarea cols="80" rows="5" name="share_comment" id="share-comment">${c.samba_lp.get("comment", share)}</textarea>
	    </div>
	</div>
        
        <div>
            ${h.hidden("task", request.environ['pylons.routes_dict']['action'])}
            ${h.hidden("old_name", share)}
        </div>
        
    ${h.end_form()}
</%def>