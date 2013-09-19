package org.proteomecommons.www;

import java.util.LinkedList;
import java.util.List;
import org.proteomecommons.mysql.MySQLDatabaseUtil;

/**
 *
 * @author James A Hill - augman85@gmail.com
 */
public class SearchUtil {

    public static List<String> splitFilter(String filter) {
        List<String> items = new LinkedList<String>();
        String[] splits = filter.split(" ");
        for (String split : splits) {
            // no blanks!
            if (split.trim().equals("")) {
                continue;
            }
            String[] reSplits = split.split(",");
            for (String reSplit : reSplits) {
                // no blanks!
                if (!reSplit.trim().equals("")) {
                    items.add(reSplit);
                }
            }
        }
        return items;
    }

    public static String makeSQLFilter(String filter, String[] fields) {
        String returnText = "";
        
        // dummy check - if no input filter or fields, no output
        if (filter.trim().equals("") || fields.length == 0) {
            return returnText;
        }
        
        List<String> splits = splitFilter(MySQLDatabaseUtil.formatTextForDatabase(filter));

        // maybe return nothing?
        if (splits.isEmpty()) {
            return returnText;
        }

        returnText = "(";
        
        int splitCount = 0;
        for (String split : splits) {
            if (splitCount > 0) {
                returnText = returnText + ") AND (";
            }

            int fieldCount = 0;
            for (String field : fields) {
                if (fieldCount > 0) {
                    returnText = returnText + " OR ";
                }
                returnText = returnText + " " + field + " LIKE '%" + split + "%' ";
                fieldCount++;
            }

            splitCount++;
        }
        
        returnText = returnText + ")";

        return returnText;
    }
}
