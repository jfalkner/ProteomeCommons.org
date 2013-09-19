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
package org.proteomecommons.www.data;

import java.sql.ResultSet;
import java.util.List;
import org.proteomecommons.www.reference.Reference;
import org.proteomecommons.www.reference.ReferenceUtil;
import org.proteomecommons.www.user.User;
import org.proteomecommons.www.user.UserUtil;
import org.tranche.gui.Widgets;
import org.tranche.hash.BigHash;

/**
 *
 * @author James "Augie" Hill - augman85@gmail.com
 */
public class Data {

    public int dataID = -1,  userID = -1;
    public long files = 0,  size = 0;
    public String title = null,  description = null,  date_published = null,  date_uploaded = null;
    public BigHash hash = null;
    public boolean encrypted = false,  active = false;
    private List<Integer> referencesFrom = null,  referencesTo = null;

    public Data(ResultSet rs) {
        try {
            this.dataID = rs.getInt("dataID");
            this.userID = rs.getInt("userID");
            this.hash = BigHash.createHashFromString(rs.getString("hash"));
            this.title = rs.getString("title");
            this.description = rs.getString("description");
            this.files = rs.getLong("files");
            this.size = rs.getLong("size");
            this.date_published = rs.getString("date_published");
            this.date_uploaded = rs.getString("date_uploaded");
            this.encrypted = rs.getBoolean("encrypted");
            this.active = rs.getBoolean("active");
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

    private synchronized void reloadReferencesFrom() {
        referencesFrom = ReferenceUtil.getReferenceIDsFrom("data", "dataID", dataID);
    }

    public synchronized List<Reference> getReferencesTo() {
        if (referencesTo == null) {
            reloadReferencesTo();
        }
        return ReferenceUtil.getReferences(referencesTo);
    }

    public synchronized void clearReferencesTo() {
        referencesTo = null;
    }

    public synchronized void reloadReferencesTo() {
        referencesTo = ReferenceUtil.getReferenceIDsTo("data", "dataID", dataID);
    }

    public boolean isSet() {
        return hash != null;
    }

    public User getUser() {
        return UserUtil.getUser(userID);
    }

    public boolean hasNewVersion() {
        try {
            return Widgets.hasNewVersion(hash);
        } catch (Exception e) {
            return false;
        }
    }

    public boolean hasOldVersion() {
        try {
            return Widgets.hasOldVersion(hash);
        } catch (Exception e) {
            return false;
        }
    }
    
    public BigHash getNewVersion() {
        try {
            return Widgets.getNewVersion(hash);
        } catch (Exception e) {
            return null;
        }
    }

    public BigHash getOldVersion() {
        try {
            return Widgets.getOldVersion(hash);
        } catch (Exception e) {
            return null;
        }
    }
}
