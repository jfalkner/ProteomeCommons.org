/*
 *    Copyright 2005 The Regents of the University of Michigan
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.proteomecommons.www.group;

import java.sql.ResultSet;
import org.proteomecommons.www.user.User;
import org.proteomecommons.www.user.UserUtil;

/**
 *
 * @author James "Augie" Hill - augman85@gmail.com
 */
public class GroupMember {

    public int groupID = -1,  userID = -1;
    public String date_created = null;
    // admin permissions
    private boolean can_edit = false,  can_invite_user = false,  can_remove_user = false,  can_modify_permissions = false, can_import_group = false, can_remove_group = false;
    // user permissions
    private boolean can_import_link = false, can_import_news = false, can_import_tool = false, can_import_publication = false, can_import_data = false, can_annotate_data = false;
    // viewer permissions
    private boolean can_see_group = false, can_see_users = false, can_see_data = false, can_see_publications = false, can_see_links = false, can_see_tools = false, can_see_news = false, can_see_subgroups = false;

    public GroupMember(ResultSet rs) {
        try {
            groupID = rs.getInt("groupID");
            userID = rs.getInt("userID");
            can_edit = rs.getBoolean("permission_edit");
            can_invite_user = rs.getBoolean("permission_invite_user");
            can_remove_user = rs.getBoolean("permission_remove_user");
            can_modify_permissions = rs.getBoolean("permission_modify_permissions");
            can_import_group = rs.getBoolean("permission_import_group");
            can_remove_group = rs.getBoolean("permission_remove_group");
            can_import_link = rs.getBoolean("permission_import_link");
            can_import_news = rs.getBoolean("permission_import_news");
            can_import_tool = rs.getBoolean("permission_import_tool");
            can_import_publication = rs.getBoolean("permission_import_publication");
            can_import_data = rs.getBoolean("permission_import_data");
            can_annotate_data = rs.getBoolean("permission_annotate_data");;
            can_see_group = rs.getBoolean("permission_see_group");
            can_see_users = rs.getBoolean("permission_see_users");
            can_see_data = rs.getBoolean("permission_see_data");
            can_see_publications = rs.getBoolean("permission_see_publications");
            can_see_links = rs.getBoolean("permission_see_links");
            can_see_tools = rs.getBoolean("permission_see_tools");
            can_see_news = rs.getBoolean("permission_see_news");
            can_see_subgroups = rs.getBoolean("permission_see_subgroups");;
            date_created = rs.getString("date_created");
        } catch (Exception e) {
        }
    }
    
    public boolean isStrictlyAdmin() {
        return isSet() && can_edit && can_invite_user && can_remove_user && can_modify_permissions && can_import_group && can_remove_group && can_import_link && can_import_news && can_import_tool && can_import_publication && can_import_data && can_annotate_data && can_see_group && can_see_users && can_see_data && can_see_publications && can_see_links && can_see_tools && can_see_news && can_see_subgroups;
    }
    
    public boolean isStrictlyUser() {
        return isSet() && !can_edit && !can_invite_user && !can_remove_user && !can_modify_permissions && !can_import_group && !can_remove_group && can_import_link && can_import_news && can_import_tool && can_import_publication && can_import_data && can_annotate_data && can_see_group && can_see_users && can_see_data && can_see_publications && can_see_links && can_see_tools && can_see_news && can_see_subgroups;
    }
    
    public boolean isStrictlyViewer() {
        return isSet() && !can_edit && !can_invite_user && !can_remove_user && !can_modify_permissions && !can_import_group && !can_remove_group && !can_import_link && !can_import_news && !can_import_tool && !can_import_publication && !can_import_data && !can_annotate_data && can_see_group && can_see_users && can_see_data && can_see_publications && can_see_links && can_see_tools && can_see_news && can_see_subgroups;
    }
    
    public boolean hasNoPermissions() {
        return !isSet() || (!can_edit && !can_invite_user && !can_remove_user && !can_modify_permissions && !can_import_group && !can_remove_group && !can_import_link && !can_import_news && !can_import_tool && !can_import_publication && !can_import_data && !can_annotate_data && !can_see_group && !can_see_users && !can_see_data && !can_see_publications && !can_see_links && !can_see_tools && !can_see_news && !can_see_subgroups);
    }
    
    public boolean isCustom() {
        return !isStrictlyAdmin() && !isStrictlyUser() && !isStrictlyViewer() && !hasNoPermissions();
    }
    
    public boolean canEditGroup() {
        return isSet() && can_edit;
    }
    
    public boolean canInviteUser() {
        return isSet() && can_invite_user;
    }
    
    public boolean canRemoveUser() {
        return isSet() && can_remove_user;
    }
    
    public boolean canModifyPermissions() {
        return isSet() && can_modify_permissions;
    }
    
    public boolean canImportGroup() {
        return isSet() && can_import_group;
    }
    
    public boolean canRemoveGroup() {
        return isSet() && can_remove_group;
    }
    
    public boolean canImportLink() {
        return isSet() && can_import_link;
    }
    
    public boolean canImportNews() {
        return isSet() && can_import_news;
    }
    
    public boolean canImportTool() {
        return isSet() && can_import_tool;
    }
    
    public boolean canImportPublication() {
        return isSet() && can_import_publication;
    }
    
    public boolean canImportData() {
        return isSet() && can_import_data;
    }
    
    public boolean canAnnotateData() {
        return isSet() && can_annotate_data;
    }
    
    public boolean canSeeGroup() {
        return isSet() && can_see_group;
    }
    
    public boolean canSeeUsers() {
        return isSet() && can_see_users;
    }
    
    public boolean canSeeData() {
        return isSet() && can_see_data;
    }
    
    public boolean canSeePublications() {
        return isSet() && can_see_publications;
    }
    
    public boolean canSeeLinks() {
        return isSet() && can_see_links;
    }
    
    public boolean canSeeTools() {
        return isSet() && can_see_tools;
    }
    
    public boolean canSeeNews() {
        return isSet() && can_see_news;
    }
    
    public boolean canSeeSubgroups() {
        return isSet() && can_see_subgroups;
    }

    public boolean isSet() {
        return date_created != null;
    }
    
    public User getUser() {
        return UserUtil.getUser(userID);
    }
}
