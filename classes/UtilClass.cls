/*
 * Class        : UtilClass
 * Developer/Org: Rami Kalayanaraman/Bluewolf
 * Created      : April 27, 2011
 * Objective    : Utility class.
 *
 *  Modification History
 *
 *  Date        Name                Description
 *  ----------  ------------------- ------------------------------------------------------------------------------------
 *  08/08/2018  Terry Post           Added toTitleCase method
 *  08/13/2018  Terry Post          Item-01989 - Change toTitleCase method to remove repeating spaces and to ignore and
 *                                  split portions of the string argument where the length is not > 0.
 *  03/15/2019  Jeff Isom           Added a cast to long for days calculation in Business hours to avoid integer
 *                                  overflow.  Returning default business hours when the named business hours 
 *                                  can't be found. 
 *  ----------  ------------------- ------------------------------------------------------------------------------------
*/
public with sharing class UtilClass {
    public static boolean isFirstTimeRun = true;

/*
 * Method       : generateMessageID
 * Developer/Org: Liz Mangano
 * Created      : January 21, 2014
 * Objective    : Generate unique messageId to be used in JSON paylaod
*/
    public static String generateMessageID()
    {
        Date myDate = Date.today();
        return 'PACE-'+myDate.month()+'-'+myDate.day()+'-'+myDate.Year()+'-'+ Datetime.now().time();

    }

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
/*
    public static String getFileContentType(String fileExtension)
    {
        String contentType = '';
        String ext = '';

        ext = fileExtension;
        if (ext == '')
        {
            ext = 'none';
        }

        // get the content type associated with this extension. If the extension
        // isn't found in custom settings, then default to the 'none' extension.
        FileContentType__c fct = FileContentType__c.getValues(ext);
        if (fct == null)
        {
            fct = FileContentType__c.getValues('none');
        }

        if (fct != null)
        {
            contentType = fct.Content_Type__c;
        }
        //system.debug('$$$$$$: Extension: ' + fileExtension + ' : Content Type: ' + contentType);
        return contentType;

    }
*/
    public static String getFileExtension(String fileName)
    {
        String extension = '';

        Integer i = fileName.lastIndexOf('.');
        if (i > 0) {
            extension = fileName.substring(i);
        }

        return extension;
    }

    /**
     *
     * @author               Terry Post
     * @date                 11/15/2017
     * @param    fileName    String containing the original file name to be truncated
     * @param    length      Integer containing the maximum length of the file name after truncation
     * @description          This method takes a file name string and a max length as parameters. If the file name is
     *                       longer than the allowed length, then it will be truncated to the allowed length. To do so,
     *                       the extension (if it exists) will first be removed and only the file name itself will be
     *                       truncated prior to adding the extension back.
     * @return               the file name truncated (if necessary) to the maximum length keeping the extension in tact
     */
    public static String truncateFileName(String fileName, Integer length) {

        String newFileName = fileName;

        if(length < 0) {
            throw new UtilClassException('Length parameter must be greater than zero');
        }
        // Truncate the file name if needed but make sure to keep the extension in tact
        if(newFileName.length() > length) {

            String ext = getFileExtension(newFileName);

            // If the file name has an extension and the length of the extension is less than the
            // length of the desired truncated length, then temporarily remove the extension so it does not
            // get truncated. If the requested length is less than the length of the extension, then keep
            // the full file name in tact and truncate it.
            if(ext <> '' && length > ext.length()) {
                newFileName = newFileName.replace(ext, '');
            }
            else {
                ext = '';
            }

            // Truncate the file name to the requested length (inclusive of the length of the extension)
            // and then add the extension back to the end of the string.
            newFileName = newFileName.substring(0, length - ext.length());
            newFileName = newFileName + ext;
        }

        return newFileName;
    }

    /**
     * @author Terry Post <terry.post@standard.com>
     * @date 6/21/2018
     * @description This method accepts a generic object parameter, then returns the name of the object type.
     * @param o Generic object
     * @return String Returns the text value of the object's type or zero length string if null
     */
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

    /**
     * @author Terry Post <terry.post@standard.com>
     * @date 8/2/2018
     * @description This method takes a string and converts it to title case where the first letter of most
     * words are capitalized.
     * @param s String value of the text to be changed to title case
     * @return String Returns the string passed in as a parameter converted to title case
     */
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