@isTest
private class UtilClassTest {

    private static final String CS_NONE_EXT = 'none';
    private static final String CS_NONE_CONTENT_TYPE = 'application/octet-stream';
    private static final String CS_TXT_EXT = '.txt';
    private static final String CS_TXT_CONTENT_TYPE = 'text/plain';

    @testSetup static void setup()
    {
    /*
        List<FileContentType__c> customSettingsList = new List<FileContentType__c>();
        customSettingsList.add(new FileContentType__c(Name = CS_NONE_EXT, Content_Type__c = CS_NONE_CONTENT_TYPE));
        customSettingsList.add(new FileContentType__c(Name = CS_TXT_EXT, Content_Type__c = CS_TXT_CONTENT_TYPE));
        insert customSettingsList;
*/
    }
    private static testMethod void test_getFileExtension_NoExtension()
    {

        String fileName = 'Test File Name';
        String fileExtension = '';

        fileExtension = UtilClass.getFileExtension(fileName);

        system.assertEquals('', fileExtension);
    }

    private static testMethod void test_getFileExtension_NoPeriodsInName()
    {

        String fileName = 'Test File Name' + CS_TXT_EXT;
        String fileExtension = '';

        fileExtension = UtilClass.getFileExtension(fileName);

        system.assertEquals(CS_TXT_EXT, fileExtension);
    }

    private static testMethod void test_getFileExtension_PeriodInName()
    {

        String fileName = 'Test.File Name' + CS_TXT_EXT;
        String fileExtension = '';

        fileExtension = UtilClass.getFileExtension(fileName);

        system.assertEquals(CS_TXT_EXT, fileExtension);
    }

    private static testMethod void test_getFileExtension_MultPeriodsInName()
    {

        String fileName = 'Test.File.Name' + CS_TXT_EXT;
        String fileExtension = '';

        fileExtension = UtilClass.getFileExtension(fileName);

        system.assertEquals(CS_TXT_EXT, fileExtension);
    }
/*
    private static testMethod void test_getFileContentType_KnownFileExt()
    {
        String fileExtension = CS_TXT_EXT;
        String fileContentType = UtilClass.getFileContentType(fileExtension);

        system.assertEquals(CS_TXT_CONTENT_TYPE, fileContentType);

    }

    private static testMethod void test_getFileContentType_UnknownFileExt()
    {
        String fileExtension = '.xyz';
        String fileContentType = UtilClass.getFileContentType(fileExtension);

        system.assertEquals(CS_NONE_CONTENT_TYPE, fileContentType);

    }

    private static testMethod void test_getFileContentType_NoFileExt()
    {
        String fileExtension = '';
        String fileContentType = UtilClass.getFileContentType(fileExtension);

        system.assertEquals(CS_NONE_CONTENT_TYPE, fileContentType);

    }
*/
    private static testMethod void test_truncateFileName_WithFileExt()
    {
        String fileName = 'Test File Name.pdf';
        Integer length = 10;

        system.assertEquals(length, UtilClass.truncateFileName(fileName, length).length());

    }

    private static testMethod void test_truncateFileName_WithoutFileExt()
    {
        String fileName = 'Test File Name';
        Integer length = 10;

        system.assertEquals(length, UtilClass.truncateFileName(fileName, length).length());

    }

    private static testMethod void test_truncateFileName_NoTruncation()
    {
        String fileName = 'Test File Name.pdf';
        Integer length = 20;

        system.assertEquals(fileName.length(), UtilClass.truncateFileName(fileName, length).length());

    }

    private static testMethod void test_truncateFileName_NegativeLength()
    {
        String fileName = 'Test File Name.pdf';
        Integer length = -1;
        String newFileName = '';
        Boolean errorThrown = false;

        try {
            newFileName = UtilClass.truncateFileName(fileName, length);
        }
        catch (Exception ex) {
            system.assertEquals('Length parameter must be greater than zero', ex.getMessage());
            errorThrown = true;
        }

        system.assertEquals('', newFileName);
        system.assertEquals(true, errorThrown);
    }

    private static testMethod void test_fetchBusinessHoursID()
    {
        List<BusinessHours> hoursList = [Select Id, Name From BusinessHours Limit 1];

        if(!hoursList.isEmpty()) {
            system.assertEquals(hoursList[0].Id, UtilClass.fetchBusinessHoursID(hoursList[0].Name));
        }

    }

    private static testMethod void test_fetchBusinessHoursID_negative()
    {

        List<BusinessHours> hoursList = [Select Id, Name From BusinessHours where isDefault = true];

        system.assertEquals(hoursList[0].Id, UtilClass.fetchBusinessHoursID('Test Business Hours'));

    }

    private static testMethod void test_generateMessageID()
    {

        system.assertNotEquals(null, UtilClass.generateMessageID());

    }

    private static testMethod void test_getObjectType()
    {
        system.assertEquals('', UtilClass.getObjectType(null));
        Boolean testBoolean = false;
        system.assertEquals('Boolean', UtilClass.getObjectType(testBoolean));
        Blob testBlob = Blob.valueOf('testBlob');
        system.assertEquals('Blob', UtilClass.getObjectType(testBlob));
        Date testDate = Date.today();
        system.assertEquals('Date', UtilClass.getObjectType(testDate));
        Datetime testDatetime = Datetime.now();
        system.assertEquals('Datetime', UtilClass.getObjectType(testDatetime));
        Decimal testDecimal = Decimal.valueOf(0);
        system.assertEquals('Decimal', UtilClass.getObjectType(testDecimal));
        Double testDouble = Double.valueOf(0);
        system.assertEquals('Decimal', UtilClass.getObjectType(testDouble));
        Integer testInteger = Integer.valueOf('0');
        system.assertEquals('Integer', UtilClass.getObjectType(testInteger));
        List<Object> testList = new List<Object>();
        system.assertEquals('List', UtilClass.getObjectType(testList));
        Long testLong = Long.valueOf('0');
        system.assertEquals('Long', UtilClass.getObjectType(testLong));
        system.assertEquals('Account', UtilClass.getObjectType(new Account()));
        String testString = 'sdfsdf';
        system.assertEquals('String', UtilClass.getObjectType(testString));
        Time testTime = Time.newInstance(9, 1, 1, 1);
        system.assertEquals('Time', UtilClass.getObjectType(testTime));
        Map<String, Object> testMap = new Map<String, Object>();
        system.assertEquals('Object', UtilClass.getObjectType(testMap));

    }

    private static testMethod void test_toTitleCase() {

        system.assertEquals('The Quick Brown Fox', UtilClass.toTitleCase('the quick brown fox'));
        system.assertEquals('The Days of Our Lives', UtilClass.toTitleCase('the days of our lives'));
        system.assertEquals('Oh My God', UtilClass.toTitleCase('OH MY GOD'));
        //Item-01989 - Test string with extra spaces
        system.assertEquals('Too Many Spaces', UtilClass.toTitleCase(' too  many  spaces '));

    }
}