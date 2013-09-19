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
package org.proteomecommons.www.publication;

import java.sql.ResultSet;
import java.util.List;
import org.proteomecommons.www.reference.Reference;
import org.proteomecommons.www.reference.ReferenceUtil;
import org.proteomecommons.www.user.User;
import org.proteomecommons.www.user.UserUtil;

/**
 *
 * @author James "Augie" Hill - augman85@gmail.com
 */
public class Publication {

    public int publicationID = -1, userID = -1;
    public String title = null,  description = null,  citation = null, url = null,  date = null;
    public boolean active = false;
    private List<Integer> referencesTo = null, referencesFrom = null;

    public Publication(ResultSet rs) {
        try {
            this.publicationID = rs.getInt("publicationID");
            this.title = rs.getString("title");
            this.description = rs.getString("description");
            this.citation = rs.getString("citation");
            this.url = rs.getString("url");
            this.date = rs.getString("date");
            this.active = rs.getBoolean("active");
            this.userID = rs.getInt("userID");
        } catch (Exception e) {
        }
    }
    
    public synchronized List<Reference> getReferencesFrom() {
        if (referencesFrom == null) {
            reloadReferencesFrom();
        }
        return ReferenceUtil.getReferences(referencesFrom);
    }
    
    public synchronized void clearReferencesFrom() {
        referencesFrom = null;
    }
    
    public synchronized void reloadReferencesFrom() {
        referencesFrom = ReferenceUtil.getReferenceIDsFrom("publication", "publicationID", publicationID);
    }
    
    public List<Reference> getReferencesTo() {
        if (referencesTo == null) {
            reloadReferencesTo();
        }
        return ReferenceUtil.getReferences(referencesTo);
    }
    
    public synchronized void clearReferencesTo() {
        referencesTo = null;
    }
    
    public synchronized void reloadReferencesTo() {
        referencesTo = ReferenceUtil.getReferenceIDsTo("publication", "publicationID", publicationID);
    }
    
    public boolean isSet() {
        return title != null;
    }
    
    public User getUser() {
        return UserUtil.getUser(userID);
    }
    
}
