package org.proteomecommons.www;

import com.maxmind.geoip.LookupService;
import java.io.File;
import java.text.NumberFormat;

/**
 *
 * @author James A Hill
 */
public class Util {

    private static LookupService lookupService = null;
    private static NumberFormat integerNumberFormat = null;

    public static String formatNumber(long number) {
        if (integerNumberFormat == null) {
            integerNumberFormat = NumberFormat.getIntegerInstance();
        }
        return integerNumberFormat.format(number);
    }
    
    public static String formatNumber(int number) {
        if (integerNumberFormat == null) {
            integerNumberFormat = NumberFormat.getIntegerInstance();
        }
        return integerNumberFormat.format(number);
    }

    public static String getWebSafeString(String string) {
        if (string == null) {
            return "";
        }
        string = string.replace("%", "%25");
        string = string.replace(" ", "%20");
        string = string.replace("!", "%21");
        string = string.replace("\"", "%22");
        string = string.replace("#", "%23");
        string = string.replace("$", "%24");
        string = string.replace("&", "%26");
        string = string.replace("'", "%27");
        string = string.replace("(", "%28");
        string = string.replace(")", "%29");
        string = string.replace("*", "%2a");
        string = string.replace("+", "%2b");
        string = string.replace(",", "%2c");
        string = string.replace("-", "%2d");
        string = string.replace(".", "%2e");
        string = string.replace("/", "%2f");
        string = string.replace(":", "%3a");
        string = string.replace(";", "%3b");
        string = string.replace("<", "%3c");
        string = string.replace("=", "%3d");
        string = string.replace(">", "%3e");
        string = string.replace("?", "%3f");
        string = string.replace("@", "%40");
        return string;
    }

    public static LookupService getLookupService() {
        if (lookupService == null) {
            try {
                lookupService = new LookupService(new File("@baseDir", "GeoLiteCity.dat"));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return lookupService;
    }

    public static String getCountry(String ip) {
        try {
            return getLookupService().getLocation(ip).countryName;
        } catch (Exception e) {
            return "";
        }
    }

    public static String getRegion(String ip) {
        try {
            return getLookupService().getLocation(ip).region;
        } catch (Exception e) {
            return "";
        }
    }
    
    public static String shorten(String string, int length) {
        if (string.length() < length) {
            return string;
        } else {
            return string.substring(0, length) + "...";
        }
    }
}
