public with sharing class UtilClass {
    public static boolean isFirstTimeRun = true;


    public static ID fetchBusinessHoursID(String businessHourName)
    {
        //TODO: Comment about what this is doing.  Check if it will allow two to be default
        Id bhId = null;
        List<businesshours> bsHrsList =  [select id, name from businessHours where name = :businessHourName or isDefault = true];
        if(bsHrsList.size() == 1) {
            bhId = bsHrsList[0].id;
        } else {
            for (businesshours bh : bsHrsList) {
                if (bh.name == businessHourName) {
                    bhId = bh.id;
                }
            }
        }

        return bhId;
    }

    public static DateTime dateBusinessHour(ID businessHrID , DateTime dt, Integer noOfDays)
    {

        long interval = (long)noOfDays*24*60*60*1000;

        return BusinessHours.add(businessHrID, dt, interval );
    }


    public static String getFileExtension(String fileName)
    {
        String extension = '';

        Integer i = fileName.lastIndexOf('.');
        if (i > 0) {
            extension = fileName.substring(i);
        }

        return extension;
    }

    public static String getObjectType(Object o) {

        if(o == null) return '';
        if(o instanceof SObject)            return ((SObject)o).getSObjectType().getDescribe().getName();
        if(o instanceof Boolean)            return 'Boolean';
        //if(o instanceof Id)                 return 'Id';
        if(o instanceof String)             return 'String';
        if(o instanceof Blob)               return 'Blob';
        if(o instanceof Date)               return 'Date';
        if(o instanceof Datetime)           return 'Datetime';
        if(o instanceof Time)               return 'Time';
        if(o instanceof Integer)            return 'Integer';
        if(o instanceof Long)               return 'Long';
        if(o instanceof Decimal)            return 'Decimal';  // we can't distinguish between decimal and double
        if(o instanceof Double)             return 'Double';   // we can't distinguish between decimal and double
        if(o instanceof List<object>)       return 'List';
        return 'Object';                    // actually we can't detect maps and sets

    }

    public class UtilClassException extends Exception {

    }

    public static String toTitleCase(String phrase){
        String titlePhrase = '';
        //a set of words that should always (or at least, almost always) be in lower case when in Title Case
        //eg The Day of the Jackal.  First and last word of a phrase should always be Capped though.
        Set<String> forceLower = new Set<String>{'of', 'the', 'for', 'and', 'a', 'to', 'at' ,'an', 'but', 'if', 'or', 'nor'};

        if(phrase != null && phrase.length() > 0){
            String[] splitPhrase = phrase.normalizeSpace().trim().split(' ');

            for(integer i = 0; i < splitPhrase.size(); i++){
                if(splitPhrase[i].length() > 0) {
                    if (!forceLower.contains(splitPhrase[i].toLowerCase()) || i == 0 || i == (splitPhrase.size() - 1)) {
                        titlePhrase += (splitPhrase[i].substring(0, 1).toUpperCase()) + (splitPhrase[i].substring(1).toLowerCase()) + ' ';
                    } else {
                        titlePhrase += splitPhrase[i].toLowerCase() + ' ';
                    }
                }
            }
        }
        return titlePhrase.trim();
    }
}